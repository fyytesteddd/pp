local Fluent,SaveManager,InterfaceManager=loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua"))()
local Window=Fluent:CreateWindow({Title="Fyy X Fish IT | 1.1.1",SubTitle="by Fyy Community",TabWidth=150,Size=UDim2.fromOffset(530,300),Acrylic=true,Theme="Darker",MinimizeKey=Enum.KeyCode.LeftControl})
local Tabs={Auth=Window:AddTab({Title="Authentication",Icon="key"})}
local Options=Fluent.Options
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FyyScriptHub")
SaveManager:SetFolder("FyyScriptHub/FishIT")
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local FILE_CONFIG={folder="FyyVerifyyy",subfolder="auth",filename="token.dat"}
local API_CONFIG={base_url="http://151.240.0.25:3000",validate_endpoint="check"}
local function getHWID()
local hwid
local success=pcall(function()
hwid=game:GetService("RbxAnalyticsService"):GetClientId()
end)
if success and hwid and hwid~=""then return hwid end
pcall(function()
hwid=HttpService:GenerateGUID(false)
end)
return hwid or("HWID-"..tostring(tick()))
end
local MAX_RETRIES=3
local RETRY_DELAY=1
local function secureHttpGet(url)
for _=1,MAX_RETRIES do
local success,response=pcall(function()
return game:HttpGet(url,true)
end)
if success and response and response~=""then return response end
task.wait(RETRY_DELAY)
end
return nil
end
local function getAuthFilePath()
return FILE_CONFIG.folder.."/"..FILE_CONFIG.subfolder.."/"..FILE_CONFIG.filename
end
local function saveToken(token)
pcall(function()
if not isfolder(FILE_CONFIG.folder)then
makefolder(FILE_CONFIG.folder)
end
local sub=FILE_CONFIG.folder.."/"..FILE_CONFIG.subfolder
if not isfolder(sub)then
makefolder(sub)
end
writefile(getAuthFilePath(),tostring(token))
end)
end
local function loadToken()
if not isfile(getAuthFilePath())then return nil end
local token=readfile(getAuthFilePath())
token=tostring(token):upper():gsub("%s+","")
return token~=""and token or nil
end
local function deleteToken()
pcall(function()
if isfile(getAuthFilePath())then
delfile(getAuthFilePath())
end
end)
end
local function ValidateKey(key)
if not key or(not string.match(key,"^FYY%-.+")and not string.match(key,"^TRIAL%-.+"))then
return false,"Format key salah"
end
local encKey=HttpService:UrlEncode(tostring(key))
local encHWID=HttpService:UrlEncode(tostring(getHWID()))
local encUserId=HttpService:UrlEncode(tostring(LocalPlayer.UserId))
local encPlaceId=HttpService:UrlEncode(tostring(game.PlaceId))
local username=LocalPlayer.Name
local url=string.format(
"%s/%s?key=%s&hwid=%s&robloxId=%s&placeId=%s&username=%s",
API_CONFIG.base_url,
API_CONFIG.validate_endpoint,
encKey,
encHWID,
encUserId,
encPlaceId,
HttpService:UrlEncode(username)
)
local response=secureHttpGet(url)
if not response then return false,"Server tidak merespon"end
local decoded
local ok=pcall(function()
decoded=HttpService:JSONDecode(response)
end)
if not ok or type(decoded)~="table"then
return false,"Response server tidak valid"
end
if decoded.status=="ok"then
if decoded.isTrial then
saveToken(key)
return true,"TRIAL_OK"
end
if decoded.code=="OK"or decoded.code=="FIRST_BIND"then
saveToken(key)
return true,decoded.code
end
end
if decoded.code=="HWID_BLACKLISTED"then
return false,"HWID kamu di-blacklist"
elseif decoded.code=="USERNAME_NOT_FOUND"then
return false,"Username tidak terdaftar di key ini"
elseif decoded.code=="INVALID_KEY"then
return false,"Key tidak valid"
elseif decoded.code=="BLACKLISTED"then
return false,"Key di-blacklist"
elseif decoded.code=="EXPIRED"then
return false,"Key sudah expired"
elseif decoded.code=="MISSING_PARAMS"then
return false,"Parameter tidak lengkap"
end
return false,decoded.code or"AUTH_FAILED"
end
local I="77nEeYeFRp"
local U="https://discord.com/api/v10/invites/"..I.."?with_counts=true&with_expiration=true"
local R,E
xpcall(function()
R=game:GetService("HttpService"):JSONDecode(game:HttpGet(U,true))
end,function(e)
warn("err fetching discord info:"..tostring(e))
E=tostring(e)
R=nil
end)
if R and R.guild then
Tabs.Auth:AddParagraph({
Title=R.guild.name,
Content='• Member Count: '..tostring(R.approximate_member_count)..'\n• Online Count: '..tostring(R.approximate_presence_count)
})
else
Tabs.Auth:AddParagraph({
Title="Error fetching Discord server info",
Content=E or"Unknown error occurred"
})
end
local Info,Premium,PlayerTab,Auto,Shop,Teleport,Totem,Quest,Event,Trade,Enchant,Animation,DiscordTab,SettingTab,MiscTab
local function SetupTabsAfterAuth()
Info=Window:AddTab({Title="Info",Icon="info"})
Premium=Window:AddTab({Title="Kaitun VIP",Icon="crown"})
PlayerTab=Window:AddTab({Title="Player",Icon="user"})
Auto=Window:AddTab({Title="Main",Icon="play"})
Shop=Window:AddTab({Title="Shop",Icon="shopping-cart"})
Teleport=Window:AddTab({Title="Teleport",Icon="map-pin"})
Totem=Window:AddTab({Title="Totem",Icon="hexagon"})
Quest=Window:AddTab({Title="Quest",Icon="loader"})
Event=Window:AddTab({Title="Event",Icon="gift"})
Trade=Window:AddTab({Title="Trade",Icon="repeat"})
Enchant=Window:AddTab({Title="Enchants",Icon="star"})
Animation=Window:AddTab({Title="Animation",Icon="gem"})
DiscordTab=Window:AddTab({Title="Webhook",Icon="megaphone"})
SettingTab=Window:AddTab({Title="Settings",Icon="settings"})
MiscTab=Window:AddTab({Title="Misc",Icon="globe"})
local ConfigTab=Window:AddTab({Title="Config",Icon="folder"})
InterfaceManager:BuildInterfaceSection(ConfigTab)
SaveManager:BuildConfigSection(ConfigTab)
Info:AddParagraph({
Title="Welcome!",
Content="Authentication successful!\nScript loaded successfully."
})
Info:AddParagraph({
Title="IMPORTANT!",
Content="Have Problem / Need Help? Join Server Now."
})
Info:AddButton({
Title="Copy Discord Link",
Description="Click to copy Discord invite link",
Callback=function()
local success=pcall(function()
setclipboard("https://discord.gg/77nEeYeFRp")
end)
if success then
Fluent:Notify({
Title="Success",
Content="Discord link copied to clipboard!\nhttps://discord.gg/77nEeYeFRp",
Duration=5
})
else
Fluent:Notify({
Title="Error",
Content="Failed to copy link to clipboard",
Duration=3
})
end
end
})
local PlayerSection=PlayerTab:AddSection("Player Feature")
local walkSpeedValue=16
local walkSpeedToggle=PlayerSection:AddToggle("WalkSpeedToggle",{Title="WalkSpeed",Default=false})
local walkSpeedInput=PlayerSection:AddInput("WalkSpeedInput",{Title="Set WalkSpeed",Default="16",Placeholder="Enter number (e.g. 50)",Numeric=true,Finished=false,Callback=function(v)
walkSpeedValue=tonumber(v)or 16
if Options.WalkSpeedToggle.Value then
local char=LocalPlayer.Character
if char and char:FindFirstChild("Humanoid")then
char.Humanoid.WalkSpeed=walkSpeedValue
end
end
end})
walkSpeedToggle:OnChanged(function(e)
local char=LocalPlayer.Character
if char and char:FindFirstChild("Humanoid")then
char.Humanoid.WalkSpeed=e and walkSpeedValue or 16
end
end)
local IJC
local infJumpToggle=PlayerSection:AddToggle("InfiniteJump",{Title="Infinite Jump",Default=false})
infJumpToggle:OnChanged(function(e)
local UIS=game:GetService("UserInputService")
if e then
IJC=UIS.JumpRequest:Connect(function()
local char=LocalPlayer.Character
if char and char:FindFirstChild("Humanoid")then
char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end)
elseif IJC then IJC:Disconnect()IJC=nil end
end)
local NCC
local noClipToggle=PlayerSection:AddToggle("NoClip",{Title="NoClip",Default=false})
noClipToggle:OnChanged(function(e)
if e then
NCC=game:GetService("RunService").Stepped:Connect(function()
local char=LocalPlayer.Character
if char then
for _,p in ipairs(char:GetChildren())do
if p:IsA("BasePart")then p.CanCollide=false end
end
end
end)
elseif NCC then
NCC:Disconnect()NCC=nil
local char=LocalPlayer.Character
if char then
for _,p in ipairs(char:GetChildren())do
if p:IsA("BasePart")then p.CanCollide=true end
end
end
end
end)
local wow=false
local wp
local wallWalkToggle=PlayerSection:AddToggle("WalkOnWater",{Title="Walk On Water",Default=false})
wallWalkToggle:OnChanged(function(e)
wow=e
local char=LocalPlayer.Character
if e and char then
local hrp=char:FindFirstChild("HumanoidRootPart")
if hrp then
if wp then wp:Destroy()end
wp=Instance.new("Part")
wp.Anchored=true
wp.CanCollide=true
wp.Size=Vector3.new(20,1,20)
wp.Transparency=1
wp.Position=Vector3.new(hrp.Position.X,0,hrp.Position.Z)
wp.Parent=workspace
end
elseif wp then wp:Destroy()wp=nil end
end)
game:GetService("RunService").Heartbeat:Connect(function()
if wow and wp then
local char=LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart")then
local p=char.HumanoidRootPart.Position
wp.Position=Vector3.new(p.X,0,p.Z)
end
end
end)
local RS=game:GetService("ReplicatedStorage")
local net=RS.Packages._Index["sleitnick_net@0.2.0"].net
local RF_E=net["RF/EquipOxygenTank"]
local RF_U=net["RF/UnequipOxygenTank"]
local ox=false
local infOxygenToggle=PlayerSection:AddToggle("EquipOxygenTank",{Title="Equip Oxygen Tank",Default=false})
infOxygenToggle:OnChanged(function(e)
ox=e
if ox then RF_E:InvokeServer(105)else RF_U:InvokeServer()end
end)
local RF_R=net["RF/UpdateFishingRadar"]
local espRadarToggle=PlayerSection:AddToggle("BypassFishingRadar",{Title="Bypass Fishing Radar",Default=false})
espRadarToggle:OnChanged(function(e)
RF_R:InvokeServer(e and true or false)
end)
local saveCF=nil
LocalPlayer.CharacterAdded:Connect(function(char)
if not saveCF then return end
local hrp=char:WaitForChild("HumanoidRootPart",5)
if hrp then task.wait(.3)hrp.CFrame=saveCF end
end)
PlayerSection:AddButton({Title="Respawn at Current Position",Description="Respawn at your current location",Callback=function()
local char=LocalPlayer.Character
if not char then return end
local hrp=char:FindFirstChild("HumanoidRootPart")
local hum=char:FindFirstChild("Humanoid")
if hrp and hum then saveCF=hrp.CFrame hum.Health=0 end
end})
local GuiSection=PlayerTab:AddSection("Gui External")
GuiSection:AddButton({Title="Fly GUI",Description="Load Fly GUI",Callback=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
Fluent:Notify({Title="Fly",Content="Fly GUI berhasil dijalankan ✅",Duration=3})
end})
local SG,SL=nil,nil
local statsOverlayToggle=GuiSection:AddToggle("StatsOverlay",{Title="Show Stats Overlay",Description="Menampilkan FPS, CPU(ms), Ping, RAM.",Default=false})
statsOverlayToggle:OnChanged(function(e)
if e then
if SG then SG:Destroy()end
local g=Instance.new("ScreenGui",game.CoreGui)
g.Name="RockHub_Stats"g.IgnoreGuiInset=true
local f=Instance.new("Frame",g)
f.Size=UDim2.fromOffset(360,40)
f.AnchorPoint=Vector2.new(.5,0)
f.Position=UDim2.new(.5,0,.06,0)
f.BackgroundColor3=Color3.fromRGB(20,20,20)
f.BackgroundTransparency=.2
f.BorderSizePixel=0
Instance.new("UICorner",f).CornerRadius=UDim.new(1,0)
local s=Instance.new("UIStroke",f)
s.Color=Color3.fromHex("8B5CF6")
s.Thickness=2
s.Transparency=.1
s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
local l=Instance.new("UIListLayout",f)
l.FillDirection=Enum.FillDirection.Horizontal
l.Padding=UDim.new(0,12)
l.HorizontalAlignment=Enum.HorizontalAlignment.Center
l.VerticalAlignment=Enum.VerticalAlignment.Center
local function L()
local t=Instance.new("TextLabel",f)
t.AutomaticSize=Enum.AutomaticSize.X
t.Size=UDim2.new(0,0,1,0)
t.BackgroundTransparency=1
t.Font=Enum.Font.GothamBold
t.TextSize=13
t.TextColor3=Color3.fromRGB(255,255,255)
t.Text="..."
return t
end
local fps,cpu,ping,ram=L(),L(),L(),L()
local RSv=game:GetService("RunService")
local ST=game:GetService("Stats")
SL=RSv.RenderStepped:Connect(function(dt)
if not g then return end
local f=math.floor(workspace:GetRealPhysicsFPS())
local c=math.floor(dt*1000)
local p=math.floor(ST.Network.ServerStatsItem["Data Ping"]:GetValue())
local m=math.floor(ST:GetTotalMemoryUsageMb())
fps.Text="FPS: "..f
fps.TextColor3=f>=50 and Color3.fromRGB(0,255,127)or Color3.fromRGB(255,65,65)
cpu.Text="CPU: "..c.."ms"
cpu.TextColor3=c<=20 and Color3.fromRGB(0,255,127)or(c<=50 and Color3.fromRGB(255,215,0)or Color3.fromRGB(255,65,65))
ping.Text="Ping: "..p.."ms"
ping.TextColor3=p<100 and Color3.fromRGB(0,255,127)or Color3.fromRGB(255,65,65)
ram.Text="Mem: "..m.."MB"
end)
SG=g
else
if SL then SL:Disconnect()SL=nil end
if SG then SG:Destroy()SG=nil end
end
end)

-- // KAITUN VIP TAB START
local function ParseProgressUI(textLabel)
if not textLabel or not textLabel:IsA("TextLabel")then return"0/0",false end
local text=textLabel.Text
local currentStr,maxStr=text:match("([^/]+)/([^/]+)")
if currentStr and maxStr then
local cleanCurrent=currentStr:gsub("%D","")
local cleanMax=maxStr:gsub("%D","")
local currentNum=tonumber(cleanCurrent)
local maxNum=tonumber(cleanMax)
if currentNum and maxNum then return text,currentNum>=maxNum end
end
return text,false
end

local KaitunSection=Premium:AddSection("Kaitun")

local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Replion=require(ReplicatedStorage.Packages.Replion)
local ItemUtility=require(ReplicatedStorage.Shared.ItemUtility)

local function GetRemoteSmart(name)
local packages=ReplicatedStorage:WaitForChild("Packages",5)
local index=packages and packages:WaitForChild("_Index",5)
if index then 
for _,child in ipairs(index:GetChildren())do 
if child.Name:find("net@")then 
local net=child:FindFirstChild("net")
if net then 
local remote=net:FindFirstChild(name)
if remote then return remote end
end
end
end
end
return nil
end

local RE_EquipToolFromHotbar=GetRemoteSmart("RE/EquipToolFromHotbar")
local RE_EquipItem=GetRemoteSmart("RE/EquipItem")
local RE_EquipBait=GetRemoteSmart("RE/EquipBait")
local RE_UnequipItem=GetRemoteSmart("RE/UnequipItem")
local RF_PurchaseFishingRod=GetRemoteSmart("RF/PurchaseFishingRod")
local RF_PurchaseBait=GetRemoteSmart("RF/PurchaseBait")
local RF_SellAllItems=GetRemoteSmart("RF/SellAllItems")
local RF_ChargeFishingRod=GetRemoteSmart("RF/ChargeFishingRod")
local RF_RequestFishingMinigameStarted=GetRemoteSmart("RF/RequestFishingMinigameStarted")
local RE_FishingCompleted=GetRemoteSmart("RE/FishingCompleted")
local RF_CancelFishingInputs=GetRemoteSmart("RF/CancelFishingInputs")
local RE_ObtainedNewFishNotification=GetRemoteSmart("RE/ObtainedNewFishNotification")
local RF_PlaceLeverItem=GetRemoteSmart("RE/PlaceLeverItem")
local RE_SpawnTotem=GetRemoteSmart("RE/SpawnTotem")
local RF_CreateTranscendedStone=GetRemoteSmart("RF/CreateTranscendedStone")
local RF_UpdateAutoFishingState=GetRemoteSmart("RF/UpdateAutoFishingState")
local RF_ClaimItem=GetRemoteSmart("RF/ClaimItem")

local ENCHANT_ROOM_POS=Vector3.new(3255.670,-1301.530,1371.790)
local ENCHANT_ROOM_LOOK=Vector3.new(-0.000,-0.000,-1.000)
local TREASURE_ROOM_POS=Vector3.new(-3598.440,-281.274,-1645.855)
local TREASURE_ROOM_LOOK=Vector3.new(-0.065,0.000,-0.998)
local SISYPHUS_POS=Vector3.new(-3743.745,-135.074,-1007.554)
local SISYPHUS_LOOK=Vector3.new(0.310,0.000,0.951)
local ANCIENT_JUNGLE_POS=Vector3.new(1535.639,3.159,-193.352)
local ANCIENT_JUNGLE_LOOK=Vector3.new(0.505,-0.000,0.863)
local SACRED_TEMPLE_POS=Vector3.new(1461.815,-22.125,-670.234)
local SACRED_TEMPLE_LOOK=Vector3.new(-0.990,-0.000,0.143)
local SECOND_ALTAR_POS=Vector3.new(1479.587,128.295,-604.224)
local SECOND_ALTAR_LOOK=Vector3.new(-0.298,0.000,-0.955)
local CORAL_REEFS_POS=Vector3.new(-3020,3,2260)
local CORAL_REEFS_LOOK=Vector3.new(0,0,-1)
local TROPICAL_GROVE_POS=Vector3.new(-2150,53,3672)
local TROPICAL_GROVE_LOOK=Vector3.new(0,0,-1)
local RUBY_FARM_POS=Vector3.new(-3595,-279,-1589)
local RUBY_FARM_LOOK=Vector3.new(0,0,-1)
local LOCHNESS_FARM_POS=Vector3.new(-712,6,707)
local LOCHNESS_FARM_LOOK=Vector3.new(0,0,-1)

local KAITUN_ACTIVE=false
local KAITUN_THREAD=nil
local KAITUN_AUTOSELL_THREAD=nil
local KAITUN_EQUIP_THREAD=nil
local KAITUN_OVERLAY=nil
local KAITUN_CATCH_CONN=nil
local PlayerDataReplion=nil

local function GetPlayerDataReplion()
if PlayerDataReplion then return PlayerDataReplion end
local ReplionClient=require(ReplicatedStorage.Packages.Replion).Client
PlayerDataReplion=ReplionClient:WaitReplion("Data",5)
return PlayerDataReplion
end

local ARTIFACT_IDS={["Arrow Artifact"]=265,["Crescent Artifact"]=266,["Diamond Artifact"]=267,["Hourglass Diamond Artifact"]=271}

local function HasArtifactItem(artifactName)
local replion=GetPlayerDataReplion()
if not replion then return false end
local success,inventoryData=pcall(function() return replion:GetExpect("Inventory") end)
if not success or not inventoryData or not inventoryData.Items then return false end
local targetId=ARTIFACT_IDS[artifactName]
if not targetId then return false end
for _,item in ipairs(inventoryData.Items) do
if tonumber(item.Id)==targetId then return true end
end
return false
end

local ArtifactData={
["Hourglass Diamond Artifact"]={ItemName="Hourglass Diamond Artifact",LeverName="Hourglass Diamond Lever",ChildReference=6,CrystalPathSuffix="Crystal",
UnlockColor=Color3.fromRGB(255,248,49),
FishingPos={Pos=Vector3.new(1490.144,3.312,-843.171),Look=Vector3.new(0.115,0.000,0.993)}},
["Diamond Artifact"]={ItemName="Diamond Artifact",LeverName="Diamond Lever",ChildReference="TempleLever",CrystalPathSuffix="Crystal",
UnlockColor=Color3.fromRGB(219,38,255),
FishingPos={Pos=Vector3.new(1844.159,2.530,-288.755),Look=Vector3.new(0.981,0.000,-0.193)}},
["Arrow Artifact"]={ItemName="Arrow Artifact",LeverName="Arrow Lever",ChildReference=5,CrystalPathSuffix="Crystal",
UnlockColor=Color3.fromRGB(255,47,47),
FishingPos={Pos=Vector3.new(874.365,2.530,-358.484),Look=Vector3.new(-0.990,0.000,0.144)}},
["Crescent Artifact"]={ItemName="Crescent Artifact",LeverName="Crescent Lever",ChildReference=4,CrystalPathSuffix="Crystal",
UnlockColor=Color3.fromRGB(112,255,69),
FishingPos={Pos=Vector3.new(1401.070,6.489,116.738),Look=Vector3.new(-0.500,-0.000,0.866)}}
}

local ArtifactOrder={"Hourglass Diamond Artifact","Diamond Artifact","Arrow Artifact","Crescent Artifact"}

local ShopItems={
["Rods"]={
{Name="Luck Rod",ID=79,Price=325},{Name="Carbon Rod",ID=76,Price=750},{Name="Grass Rod",ID=85,Price=1500},{Name="Demascus Rod",ID=77,Price=3000},
{Name="Ice Rod",ID=78,Price=5000},{Name="Lucky Rod",ID=4,Price=15000},{Name="Midnight Rod",ID=80,Price=50000},{Name="Steampunk Rod",ID=6,Price=215000},
{Name="Chrome Rod",ID=7,Price=437000},{Name="Flourescent Rod",ID=255,Price=715000},{Name="Astral Rod",ID=5,Price=1000000},
{Name="Ares Rod",ID=126,Price=3000000},{Name="Angler Rod",ID=168,Price=8000000},{Name="Hazmat Rod",ID=256,Price=1380000},{Name="Bamboo Rod",ID=258,Price=12000000}
},
["Bobbers"]={
{Name="Starter Bait",ID=1,Price=0},{Name="Luck Bait",ID=2,Price=1000},{Name="Midnight Bait",ID=3,Price=3000},{Name="Royal Bait",ID=4,Price=425000},
{Name="Chroma Bait",ID=6,Price=290000},{Name="Dark Matter Bait",ID=8,Price=630000},{Name="Topwater Bait",ID=10,Price=100},{Name="Corrupt Bait",ID=15,Price=1148484},
{Name="Aether Bait",ID=16,Price=3700000},{Name="Nature Bait",ID=17,Price=83500},{Name="Floral Bait",ID=20,Price=4000000},{Name="Singularity Bait",ID=18,Price=8200000}
}
}

local ROD_DELAYS={
[79]=4.6,[76]=4.35,[85]=4.2,[77]=4.35,[78]=3.85,[4]=3.5,[80]=2.7,
[6]=2.3,[7]=2.2,[255]=2.2,[256]=1.9,[5]=1.85,[126]=1.7,[168]=1.6,[169]=1.3,[257]=1,[559]=0.8
}

local DEFAULT_ROD_DELAY=3.85
local CURRENT_KAITUN_DELAY=DEFAULT_ROD_DELAY

local function TeleportToLookAt(position,lookAt)
if not KAITUN_ACTIVE then return end
local character=game.Players.LocalPlayer.Character
if character then
local hrp=character:FindFirstChild("HumanoidRootPart")
if hrp then hrp.CFrame=CFrame.new(position,position+lookAt) end
end
end

local function ForceResetAndTeleport(targetPos,targetLook)
if not KAITUN_ACTIVE then return end
local plr=game.Players.LocalPlayer
pcall(function() RF_UpdateAutoFishingState:InvokeServer(false) end)
pcall(function() RF_CancelFishingInputs:InvokeServer() end)
if plr.Character and plr.Character:FindFirstChild("Humanoid") then plr.Character.Humanoid.Health=0 end
plr.CharacterAdded:Wait()
local newChar=plr.Character or plr.CharacterAdded:Wait()
local hrp=newChar:WaitForChild("HumanoidRootPart",10)
task.wait(1)
if hrp and targetPos then TeleportToLookAt(targetPos,targetLook or Vector3.new(0,0,-1)) end
task.wait(0.5)
pcall(function() RE_EquipToolFromHotbar:FireServer(1) end)
end

local function GetRodPriceByID(id)
for _,item in ipairs(ShopItems["Rods"]) do if item.ID==tonumber(id) then return item.Price end end
return 0
end

local function GetBaitInfo(id)
id=tonumber(id)
for _,item in ipairs(ShopItems["Bobbers"]) do if item.ID==id then return item.Name,item.Price end end
return "Unknown Bait (ID:"..id..")",0
end

local function HasItemByID(targetId,category)
local replion=GetPlayerDataReplion()
if not replion then return false end
local success,inventoryData=pcall(function() return replion:GetExpect("Inventory") end)
if success and inventoryData then
local list=inventoryData[category] or (category=="Bait" and inventoryData["Baits"])
if list then for _,item in ipairs(list) do if tonumber(item.Id)==tonumber(targetId) then return true end end end
end
return false
end

local function EquipBestGear()
if not KAITUN_ACTIVE then return DEFAULT_ROD_DELAY end
local replion=GetPlayerDataReplion()
if not replion then return DEFAULT_ROD_DELAY end
local s,d=pcall(function() return replion:GetExpect("Inventory") end)
if not s or not d then return DEFAULT_ROD_DELAY end
local bestRodUUID,bestRodPrice,bestRodId=nil,-1,nil
if d["Fishing Rods"] then
for _,r in ipairs(d["Fishing Rods"]) do
local p=GetRodPriceByID(r.Id)
if tonumber(r.Id)==169 then p=99999999 end
if tonumber(r.Id)==257 then p=999999999 end
if tonumber(r.Id)==559 then p=9999999999 end
if p>bestRodPrice then bestRodPrice=p;bestRodUUID=r.UUID;bestRodId=tonumber(r.Id) end
end
end
local bestBaitId,bestBaitPrice=nil,-1
local baitList=d["Bait"] or d["Baits"]
if baitList then
for _,b in ipairs(baitList) do
local bName,bPrice=GetBaitInfo(b.Id)
if bPrice>=bestBaitPrice then bestBaitPrice=bPrice;bestBaitId=tonumber(b.Id) end
end
end
if bestRodUUID then pcall(function() RE_EquipItem:FireServer(bestRodUUID,"Fishing Rods") end) end
if bestBaitId then pcall(function() RE_EquipBait:FireServer(bestBaitId) end) end
pcall(function() RE_EquipToolFromHotbar:FireServer(1) end)
CURRENT_KAITUN_DELAY=(bestRodId and ROD_DELAYS[bestRodId]) and ROD_DELAYS[bestRodId] or DEFAULT_ROD_DELAY
return CURRENT_KAITUN_DELAY
end

local function GetCurrentBestGear()
local replion=GetPlayerDataReplion()
if not replion then return "Loading...","Loading...",0 end
local s,d=pcall(function() return replion:GetExpect("Inventory") end)
local bR,hRP="None",-1
if d["Fishing Rods"] then
for _,r in ipairs(d["Fishing Rods"]) do
local p=GetRodPriceByID(r.Id)
if tonumber(r.Id)==169 then p=99999999 end
if tonumber(r.Id)==257 then p=999999999 end
if tonumber(r.Id)==559 then p=9999999999 end
if p>hRP then
hRP=p
local data=ItemUtility:GetItemData(r.Id)
bR=data and data.Data.Name or "Unknown"
end
end
end
local bB,hBP="None",-1
local bList=d["Bait"] or d["Baits"]
if bList then for _,b in ipairs(bList) do local bName,bPrice=GetBaitInfo(b.Id);if bPrice>=hBP then hBP=bPrice;bB=bName end end end
return bR,bB,hRP
end

local function ManageBaitPurchases(currentCoins,currentStep)
if not RF_PurchaseBait or not KAITUN_ACTIVE then return end
local hasLuck=HasItemByID(2,"Bait")
local hasMidnight=HasItemByID(3,"Bait")
if not hasLuck and not hasMidnight and currentCoins>=1000 then pcall(function() RF_PurchaseBait:InvokeServer(2) end) return
elseif not hasMidnight and currentCoins>=3000 then pcall(function() RF_PurchaseBait:InvokeServer(3) end) return end
if currentStep==5 then
local hasCorrupt=HasItemByID(15,"Bait")
local hasAether=HasItemByID(16,"Bait")
if not hasCorrupt then
if currentCoins>=1148484 then pcall(function() RF_PurchaseBait:InvokeServer(15) end) Fluent:Notify({Title="Upgrade Bait",Content="Membeli Corrupt Bait.",Duration=3}) end
elseif not hasAether then if currentCoins>=3700000 then pcall(function() RF_PurchaseBait:InvokeServer(16) end) Fluent:Notify({Title="Upgrade Bait",Content="Membeli Aether Bait.",Duration=3}) end end
elseif currentStep==6 then
local hasFloral=HasItemByID(20,"Bait")
if not hasFloral and currentCoins>=4000000 then pcall(function() RF_PurchaseBait:InvokeServer(20) end) Fluent:Notify({Title="Upgrade Bait",Content="Membeli Floral Bait.",Duration=3}) end
end
end

local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Replion=require(ReplicatedStorage.Packages.Replion)
local ClientData=Replion.Client:WaitReplion("Data")

local function GetMainlineData(questName)
local data=ClientData.Data
if not data then return nil end
if data.Quests and data.Quests.Mainline and data.Quests.Mainline[questName] then return data.Quests.Mainline[questName] end
return nil
end

local function GetGhostfinProgress()
local result={
Q1={Text="Rare/Epic: 0/300",Done=false},
Q2={Text="Mythic: 0/3",Done=false},
Q3={Text="Secret: 0/1",Done=false},
Q4={Text="Coins: 0/1M",Done=false},
AllDone=false,
HasGhostfin=HasItemByID(169,"Fishing Rods")
}
if result.HasGhostfin then
result.AllDone=true
result.Q1.Done=true;result.Q2.Done=true;result.Q3.Done=true;result.Q4.Done=true
result.Q1.Text="Rare/Epic: 300/300";result.Q2.Text="Mythic: 3/3";result.Q3.Text="Secret: 1/1";result.Q4.Text="Coins: 1M/1M"
return result
end
local qData=GetMainlineData("Deep Sea Quest")
if qData and qData.Objectives then
for id,objData in pairs(qData.Objectives) do
local prog=objData.Progress or 0
local numId=tonumber(id)
if numId==1 then result.Q1.Text=string.format("Rare/Epic: %d/300",prog);result.Q1.Done=prog>=300
elseif numId==2 then result.Q2.Text=string.format("Mythic: %d/3",prog);result.Q2.Done=prog>=3
elseif numId==3 then result.Q3.Text=string.format("Secret: %d/1",prog);result.Q3.Done=prog>=1
elseif numId==4 then result.Q4.Text=string.format("Coins: %s/1M",tostring(prog));result.Q4.Done=prog>=1000000 end
end
end
result.AllDone=result.Q1.Done and result.Q2.Done and result.Q3.Done and result.Q4.Done
return result
end

local function GetElementProgress()
local result={
Q1={Text="Ghostfin Rod: 0/1",Done=false},
Q2={Text="Jungle Secret: 0/1",Done=false},
Q3={Text="Temple Secret: 0/1",Done=false},
Q4={Text="Stones: 0/3",Done=false},
AllDone=false,
HasElement=HasItemByID(257,"Fishing Rods")
}
if result.HasElement then
result.AllDone=true
result.Q1.Done=true;result.Q2.Done=true;result.Q3.Done=true;result.Q4.Done=true
result.Q1.Text="Ghostfin Rod: 1/1";result.Q4.Text="Stones: 3/3"
return result
end
result.Q1.Done=HasItemByID(169,"Fishing Rods")
result.Q1.Text=result.Q1.Done and "Ghostfin Rod: 1/1" or "Ghostfin Rod: 0/1"
if not result.Q1.Done then
result.AllDone=false
return result
end
local qData=GetMainlineData("Element Quest")
if qData and qData.Objectives then
for id,objData in pairs(qData.Objectives) do
local prog=objData.Progress or 0
local numId=tonumber(id)
if numId==2 then result.Q2.Text=string.format("Jungle Secret: %d/1",prog);result.Q2.Done=prog>=1
elseif numId==3 then result.Q3.Text=string.format("Temple Secret: %d/1",prog);result.Q3.Done=prog>=1
elseif numId==4 then result.Q4.Text=string.format("Stones: %d/3",prog);result.Q4.Done=prog>=3 end
end
end
result.AllDone=result.Q1.Done and result.Q2.Done and result.Q3.Done and result.Q4.Done
return result
end

local function GetDiamondProgress()
local result={
Q1={Text="Element Rod: 0/1",Done=false},
Q2={Text="Coral Secret: 0/1",Done=false},
Q3={Text="Tropical Secret: 0/1",Done=false},
Q4={Text="Mutated Ruby: 0/1",Done=false},
Q5={Text="Lochness Monster: 0/1",Done=false},
Q6={Text="Perfect Throws: 0/1000",Done=false},
AllDone=false,
HasDiamond=HasItemByID(559,"Fishing Rods")
}
if result.HasDiamond then
result.AllDone=true
for i=1,6 do result["Q"..i].Done=true end
result.Q1.Text="Element Rod: 1/1";result.Q2.Text="Coral Secret: 1/1";result.Q3.Text="Tropical Secret: 1/1"
result.Q4.Text="Mutated Ruby: 1/1";result.Q5.Text="Lochness Monster: 1/1";result.Q6.Text="Perfect Throws: 1000/1000"
return result
end
result.Q1.Done=HasItemByID(257,"Fishing Rods")
result.Q1.Text=result.Q1.Done and "Element Rod: 1/1" or "Element Rod: 0/1"
if not result.Q1.Done then
result.AllDone=false
return result
end
local inventory=ClientData:Get({"Inventory"}) or {}
local hasRuby=false
local hasLochness=false
if inventory.Items then
for _,item in ipairs(inventory.Items) do
if tonumber(item.Id)==243 then
local metadata=item.Metadata or {}
if metadata.VariantId==3 then hasRuby=true end
elseif tonumber(item.Id)==228 then
hasLochness=true
end
end
end
result.Q4.Done=hasLochness
result.Q5.Done=hasRuby
result.Q4.Text=hasLochness and "Mutated Ruby: 1/1" or "Mutated Ruby: 0/1"
result.Q5.Text=hasRuby and "Lochness Monster: 1/1" or "Lochness Monster: 0/1"
local qData=GetMainlineData("Diamond Rod Quest")
if qData and qData.Objectives then
for id,objData in pairs(qData.Objectives) do
local prog=objData.Progress or 0
local numId=tonumber(id)
if numId==2 then result.Q2.Text=string.format("Coral Secret: %d/1",prog);result.Q2.Done=prog>=1
elseif numId==3 then result.Q3.Text=string.format("Tropical Secret: %d/1",prog);result.Q3.Done=prog>=1
elseif numId==6 then result.Q6.Text=string.format("Perfect Throws: %d/1000",prog);result.Q6.Done=prog>=1000 end
end
end
result.AllDone=result.Q1.Done and result.Q2.Done and result.Q3.Done and result.Q4.Done and result.Q5.Done and result.Q6.Done
return result
end

local function IsLeverUnlocked(artifactName)
local JUNGLE=workspace:FindFirstChild("JUNGLE INTERACTIONS")
if not JUNGLE then return false end
local data=ArtifactData[artifactName]
if not data then return false end
local folder=nil
if type(data.ChildReference)=="string" then folder=JUNGLE:FindFirstChild(data.ChildReference) end
if not folder and type(data.ChildReference)=="number" then local c=JUNGLE:GetChildren() folder=c[data.ChildReference] end
if not folder then return false end
local crystal=folder:FindFirstChild(data.CrystalPathSuffix)
if not crystal or not crystal:IsA("BasePart") then return false end
local cC,tC=crystal.Color,data.UnlockColor
return (math.abs(cC.R*255-tC.R*255)<1.1 and math.abs(cC.G*255-tC.G*255)<1.1 and math.abs(cC.B*255-tC.B*255)<1.1)
end

local function GetLowestWeightSecrets(limit)
local secrets={}
local r=GetPlayerDataReplion() if not r then return {} end
local s,d=pcall(function() return r:GetExpect("Inventory") end)
if s and d.Items then
for _,item in ipairs(d.Items) do
local r=item.Metadata and item.Metadata.Rarity or "Unknown"
if r:upper()=="SECRET" and item.Metadata and item.Metadata.Weight then
if not (item.IsFavorite or item.Favorited or item.Locked) then table.insert(secrets,{UUID=item.UUID,Weight=item.Metadata.Weight}) end
end
end
end
table.sort(secrets,function(a,b) return a.Weight<b.Weight end)
local result={}
for i=1,math.min(limit,#secrets) do table.insert(result,secrets[i].UUID) end
return result
end

local TierCounts={Common=0,Uncommon=0,Rare=0,Epic=0,Legendary=0,Mythic=0,Secret=0}

local function CreateKaitunUI()
local old=game.CoreGui:FindFirstChild("Fyy")
if old then old:Destroy() end
local sg=Instance.new("ScreenGui")
sg.Name="Fyy"
sg.Parent=game.CoreGui
sg.IgnoreGuiInset=true
sg.DisplayOrder=-50
local mf=Instance.new("Frame")
mf.Name="MainFrame"
mf.Size=UDim2.new(1,0,1,0)
mf.Position=UDim2.new(0,0,0,0)
mf.BackgroundColor3=Color3.fromRGB(0,0,0)
mf.BackgroundTransparency=0.25
mf.BorderSizePixel=0
mf.Parent=sg
local layout=Instance.new("UIListLayout")
layout.Parent=mf
layout.SortOrder=Enum.SortOrder.LayoutOrder
layout.Padding=UDim.new(0,5)
layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
layout.VerticalAlignment=Enum.VerticalAlignment.Center
local function makeLabel(text,color,order,font,size)
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,0,0,0)
l.AutomaticSize=Enum.AutomaticSize.Y
l.BackgroundTransparency=1
l.Text=text
l.TextColor3=color or Color3.fromRGB(255,255,255)
l.Font=font or Enum.Font.GothamBold
l.TextSize=size or 16
l.LayoutOrder=order
l.TextWrapped=true
l.Parent=mf
return l
end
makeLabel("Fyy Kaitun Status",Color3.fromRGB(255,255,255),1,Enum.Font.GothamBlack,18)
local lStats1=makeLabel("Loading...",Color3.fromRGB(255,255,255),2,Enum.Font.GothamSemibold,11)
local lStats2=makeLabel("Loading...",Color3.fromRGB(255,255,255),3,Enum.Font.GothamSemibold,11)
makeLabel("",nil,4,nil,4)
makeLabel("Progress Quest Ghostfinn",Color3.fromRGB(255,100,100),5,Enum.Font.GothamBold,14)
local lGhost1=makeLabel("Loading...",Color3.fromRGB(180,180,180),6,Enum.Font.Gotham,11)
local lGhost2=makeLabel("Loading...",Color3.fromRGB(180,180,180),7,Enum.Font.Gotham,11)
local lGhost3=makeLabel("Loading...",Color3.fromRGB(180,180,180),8,Enum.Font.Gotham,11)
local lGhost4=makeLabel("Loading...",Color3.fromRGB(180,180,180),9,Enum.Font.Gotham,11)
makeLabel("",nil,10,nil,4)
makeLabel("Progress Quest Element Rod",Color3.fromRGB(100,100,255),11,Enum.Font.GothamBold,14)
local lElem1=makeLabel("Loading...",Color3.fromRGB(180,180,180),12,Enum.Font.Gotham,11)
local lElem2=makeLabel("Loading...",Color3.fromRGB(180,180,180),13,Enum.Font.Gotham,11)
local lElem3=makeLabel("Loading...",Color3.fromRGB(180,180,180),14,Enum.Font.Gotham,11)
local lElem4=makeLabel("Loading...",Color3.fromRGB(180,180,180),15,Enum.Font.Gotham,11)
makeLabel("Progress Quest Diamond Rod",Color3.fromRGB(255,215,0),16,Enum.Font.GothamBold,14)
local lDiamond1=makeLabel("Loading...",Color3.fromRGB(180,180,180),17,Enum.Font.Gotham,11)
local lDiamond2=makeLabel("Loading...",Color3.fromRGB(180,180,180),18,Enum.Font.Gotham,11)
local lDiamond3=makeLabel("Loading...",Color3.fromRGB(180,180,180),19,Enum.Font.Gotham,11)
local lDiamond4=makeLabel("Loading...",Color3.fromRGB(180,180,180),20,Enum.Font.Gotham,11)
local lDiamond5=makeLabel("Loading...",Color3.fromRGB(180,180,180),21,Enum.Font.Gotham,11)
local lDiamond6=makeLabel("Loading...",Color3.fromRGB(180,180,180),22,Enum.Font.Gotham,11)
makeLabel("----------------------------------------------------------------------------------------------------",Color3.fromRGB(100,100,100),23,nil,8)
makeLabel("CURRENT ACTIVITY",Color3.fromRGB(255,215,0),24,Enum.Font.GothamBold,13)
local lStatus=makeLabel("Idle",Color3.fromRGB(0,255,127),25,Enum.Font.GothamBlack,16)
return {Gui=sg,Labels={Stats1=lStats1,Stats2=lStats2,Ghost={lGhost1,lGhost2,lGhost3,lGhost4},Elem={lElem1,lElem2,lElem3,lElem4},Diamond={lDiamond1,lDiamond2,lDiamond3,lDiamond4,lDiamond5,lDiamond6},Status=lStatus}}
end

local function RunQuestInstantFish(dynamicDelay)
if not KAITUN_ACTIVE then return end
if not (RE_EquipToolFromHotbar and RF_ChargeFishingRod and RF_RequestFishingMinigameStarted) then
Fluent:Notify({Title="Remote Error",Content="Restart Game! Remote not found.",Duration=5})
return
end
pcall(function() RE_EquipToolFromHotbar:FireServer(1) end)
task.wait(0.2)
local ts=os.time()+os.clock()
pcall(function() RF_ChargeFishingRod:InvokeServer(ts) end)
task.wait(0.1)
pcall(function() RF_RequestFishingMinigameStarted:InvokeServer(-139.630452165,0.99647927980797) end)
task.wait(dynamicDelay)
pcall(function() RE_FishingCompleted:FireServer() end)
task.wait(0.3)
pcall(function() RF_CancelFishingInputs:InvokeServer() end)
end

local function RunKaitunLogic()
if KAITUN_THREAD then task.cancel(KAITUN_THREAD) end
if KAITUN_AUTOSELL_THREAD then task.cancel(KAITUN_AUTOSELL_THREAD) end
if KAITUN_EQUIP_THREAD then task.cancel(KAITUN_EQUIP_THREAD) end
if KAITUN_CATCH_CONN then KAITUN_CATCH_CONN:Disconnect() end
TierCounts={Common=0,Uncommon=0,Rare=0,Epic=0,Legendary=0,Mythic=0,Secret=0}
local uiData=CreateKaitunUI()
KAITUN_OVERLAY=uiData.Gui
if RE_ObtainedNewFishNotification then
KAITUN_CATCH_CONN=RE_ObtainedNewFishNotification.OnClientEvent:Connect(function(id,meta)
if ItemUtility then
local d=ItemUtility:GetItemData(id)
if d and d.Probability and d.Probability.Chance then
local rarity=meta.Rarity or "Common"
local rKey=rarity:gsub("^%l",string.upper)
if rKey=="Legend" then rKey="Legendary" end
if TierCounts[rKey] then TierCounts[rKey]=TierCounts[rKey]+1 end
end
end
end)
end
KAITUN_AUTOSELL_THREAD=task.spawn(function()
while KAITUN_ACTIVE do pcall(function() RF_SellAllItems:InvokeServer() end) task.wait(30) end
end)
KAITUN_EQUIP_THREAD=task.spawn(function()
local lc=0
CURRENT_KAITUN_DELAY=EquipBestGear()
while KAITUN_ACTIVE do
pcall(function() RE_EquipToolFromHotbar:FireServer(1) end)
if lc%20==0 then CURRENT_KAITUN_DELAY=EquipBestGear() end
lc=lc+1
task.wait(0.1)
end
end)
KAITUN_THREAD=task.spawn(function()
local luckPrice=325
local midPrice=50000
local steamPrice=215000
local astralPrice=1000000
local ghostfinPrice=99999999
local elementPrice=999999999
local diamondPrice=9999999999
while KAITUN_ACTIVE do
local r=GetPlayerDataReplion()
local coins=0
if r then
coins=r:Get("Coins") or 0
if coins==0 then
local s,c=pcall(function() return require(game:GetService("ReplicatedStorage").Modules.CurrencyUtility.Currency) end)
if s and c then coins=r:Get(c["Coins"].Path) or 0 end
end
end
local bRod,bBait,bRodPrice=GetCurrentBestGear()
local pGhost=GetGhostfinProgress()
local pElem=GetElementProgress()
local pDiamond=GetDiamondProgress()
uiData.Labels.Stats1.Text=string.format("Best Rod: %s | Coins: %s | Uncommon: %d | Epic: %d | Mythic: %d",bRod,coins,TierCounts.Uncommon,TierCounts.Epic,TierCounts.Mythic)
uiData.Labels.Stats2.Text=string.format("Best Bait: %s | Common: %d | Rare: %d | Legendary: %d | Secret: %d",bBait,TierCounts.Common,TierCounts.Rare,TierCounts.Legendary,TierCounts.Secret)
uiData.Labels.Ghost[1].Text=pGhost.Q1.Text;uiData.Labels.Ghost[1].TextColor3=pGhost.Q1.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Ghost[2].Text=pGhost.Q2.Text;uiData.Labels.Ghost[2].TextColor3=pGhost.Q2.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Ghost[3].Text=pGhost.Q3.Text;uiData.Labels.Ghost[3].TextColor3=pGhost.Q3.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Ghost[4].Text=pGhost.Q4.Text;uiData.Labels.Ghost[4].TextColor3=pGhost.Q4.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Elem[1].Text=pElem.Q1.Text;uiData.Labels.Elem[1].TextColor3=pElem.Q1.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Elem[2].Text=pElem.Q2.Text;uiData.Labels.Elem[2].TextColor3=pElem.Q2.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Elem[3].Text=pElem.Q3.Text;uiData.Labels.Elem[3].TextColor3=pElem.Q3.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Elem[4].Text=pElem.Q4.Text;uiData.Labels.Elem[4].TextColor3=pElem.Q4.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Diamond[1].Text=pDiamond.Q1.Text;uiData.Labels.Diamond[1].TextColor3=pDiamond.Q1.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Diamond[2].Text=pDiamond.Q2.Text;uiData.Labels.Diamond[2].TextColor3=pDiamond.Q2.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Diamond[3].Text=pDiamond.Q3.Text;uiData.Labels.Diamond[3].TextColor3=pDiamond.Q3.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Diamond[4].Text=pDiamond.Q4.Text;uiData.Labels.Diamond[4].TextColor3=pDiamond.Q4.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Diamond[5].Text=pDiamond.Q5.Text;uiData.Labels.Diamond[5].TextColor3=pDiamond.Q5.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
uiData.Labels.Diamond[6].Text=pDiamond.Q6.Text;uiData.Labels.Diamond[6].TextColor3=pDiamond.Q6.Done and Color3.new(0,1,0) or Color3.new(0.7,0.7,0.7)
local step=0
local targetPrice=0
local currentActivityText="Idle"
if bRodPrice<luckPrice then step=1;targetPrice=luckPrice
elseif bRodPrice<midPrice then step=2;targetPrice=midPrice
elseif bRodPrice<steamPrice then step=3;targetPrice=steamPrice
elseif bRodPrice<astralPrice then step=4;targetPrice=astralPrice
elseif bRodPrice<ghostfinPrice then step=5
elseif bRodPrice<elementPrice then step=6
elseif bRodPrice<diamondPrice then step=7
else step=8 end
ManageBaitPurchases(coins,step)
if step<=4 then
local tName,tId="Unknown",0
if step==1 then tName="Luck Rod";tId=79 elseif step==2 then tName="Midnight Rod";tId=80 elseif step==3 then tName="Steampunk Rod";tId=6 elseif step==4 then tName="Astral Rod";tId=5 end
if coins>=targetPrice then
currentActivityText="Buying "..tName
ForceResetAndTeleport(nil,nil)
pcall(function() RF_PurchaseFishingRod:InvokeServer(tId) end)
task.wait(1.5)
EquipBestGear()
else
currentActivityText=string.format("Farming Coins for %s... (%s/%s)",tName,coins,targetPrice)
local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp and (hrp.Position-ENCHANT_ROOM_POS).Magnitude>10 then TeleportToLookAt(ENCHANT_ROOM_POS,ENCHANT_ROOM_LOOK) task.wait(0.5) end
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
end
elseif step==5 then
if pGhost.AllDone then
currentActivityText="Ghostfin Quest Done! Farming for Ares..."
if HasItemByID(126,"Fishing Rods") then
currentActivityText="Already have Ares Rod! Moving to next step..."
else
if coins>=3000000 then
ForceResetAndTeleport(nil,nil)
pcall(function() RF_PurchaseFishingRod:InvokeServer(126) end)
task.wait(1.5)
EquipBestGear()
else
currentActivityText=string.format("Farming Coins for Ares Rod... (%s/3M)",coins)
local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if (hrp.Position-TREASURE_ROOM_POS).Magnitude>15 then TeleportToLookAt(TREASURE_ROOM_POS,TREASURE_ROOM_LOOK) task.wait(0.5) end
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
end
end
else
if not pGhost.Q1.Done then
currentActivityText="Farming 300 Rare/Epic (Treasure Room)"
local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if (hrp.Position-TREASURE_ROOM_POS).Magnitude>15 then TeleportToLookAt(TREASURE_ROOM_POS,TREASURE_ROOM_LOOK) task.wait(0.5) end
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
else
currentActivityText="Farming Mythic/Secret (Sisyphus)"
local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if (hrp.Position-SISYPHUS_POS).Magnitude>15 then TeleportToLookAt(SISYPHUS_POS,SISYPHUS_LOOK) task.wait(0.5) end
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
end
end
elseif step==6 then
if pElem.AllDone then
currentActivityText="Element Quest Done! Farming for Diamond..."
if HasItemByID(257,"Fishing Rods") then
currentActivityText="Already have Element Rod! Moving to Diamond..."
EquipBestGear()
else
currentActivityText="Element objectives done but no rod? Teleporting to Altar..."
TeleportToLookAt(SECOND_ALTAR_POS,SECOND_ALTAR_LOOK)
task.wait(2)
end
else
local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not pElem.Q2.Done then
currentActivityText="Farming Secret Fish (Jungle)"
if (hrp.Position-ANCIENT_JUNGLE_POS).Magnitude>15 then TeleportToLookAt(ANCIENT_JUNGLE_POS,ANCIENT_JUNGLE_LOOK) task.wait(0.5) end
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
elseif not pElem.Q3.Done then
currentActivityText="Farming Temple Secret"
local currentLeverIndex=(math.floor(os.clock()/5)%#ArtifactOrder)+1
local leverName=ArtifactOrder[currentLeverIndex]
pcall(function() RF_PlaceLeverItem:FireServer(leverName) end)
local missingLever=nil
for _,n in ipairs(ArtifactOrder) do 
if not IsLeverUnlocked(n) then 
missingLever=n 
break 
end 
end
if missingLever then
if HasItemByID(ArtifactData[missingLever].ItemName,"Items") then
TeleportToLookAt(ArtifactData[missingLever].FishingPos.Pos,ArtifactData[missingLever].FishingPos.Look)
task.wait(0.5)
pcall(function() RF_PlaceLeverItem:FireServer(missingLever) end)
task.wait(2.0)
else
if (hrp.Position-ArtifactData[missingLever].FishingPos.Pos).Magnitude>10 then
TeleportToLookAt(ArtifactData[missingLever].FishingPos.Pos,ArtifactData[missingLever].FishingPos.Look)
task.wait(0.5)
else RunQuestInstantFish(CURRENT_KAITUN_DELAY) end
end
else
TeleportToLookAt(SACRED_TEMPLE_POS,SACRED_TEMPLE_LOOK)
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
end
elseif not pElem.Q4.Done then
currentActivityText="Creating Transcended Stones..."
local trash=GetLowestWeightSecrets(1)
if #trash>0 then
TeleportToLookAt(SECOND_ALTAR_POS,SECOND_ALTAR_LOOK)
pcall(function() if RE_UnequipItem then RE_UnequipItem:FireServer("all") end end)
task.wait(0.5)
pcall(function() RE_EquipItem:FireServer(trash[1],"Fish") end)
task.wait(0.3)
pcall(function() RE_EquipToolFromHotbar:FireServer(2) end)
task.wait(0.5)
pcall(function() RF_CreateTranscendedStone:InvokeServer() end)
task.wait(2)
else
TeleportToLookAt(SECOND_ALTAR_POS,SECOND_ALTAR_LOOK)
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
end
end
end
elseif step==7 then
if pDiamond.AllDone then
currentActivityText="Diamond Quest Done! Claiming..."
local inventory=ClientData:Get({"Inventory"}) or {}
local hasDiamondKey=false
if inventory.Items then
for _,item in ipairs(inventory.Items) do
local itemData=ItemUtility:GetItemData(item.Id)
if itemData and itemData.Data and itemData.Data.Name=="Diamond Key" then
hasDiamondKey=true
break
end
end
end
if hasDiamondKey and RF_ClaimItem then
currentActivityText="Claiming Diamond Rod..."
pcall(function() RF_ClaimItem:InvokeServer("Diamond Rod") end)
task.wait(2)
else
currentActivityText="Need Diamond Key from Lary"
TeleportToLookAt(SISYPHUS_POS,SISYPHUS_LOOK)
task.wait(3)
end
else
local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local tasksToDo={}
if not pDiamond.Q2.Done then table.insert(tasksToDo,{name="Coral Secret",pos=CORAL_REEFS_POS,look=CORAL_REEFS_LOOK}) end
if not pDiamond.Q3.Done then table.insert(tasksToDo,{name="Tropical Secret",pos=TROPICAL_GROVE_POS,look=TROPICAL_GROVE_LOOK}) end
if not pDiamond.Q4.Done then table.insert(tasksToDo,{name="Lochness Monster",pos=LOCHNESS_FARM_POS,look=LOCHNESS_FARM_LOOK}) end
if not pDiamond.Q5.Done then table.insert(tasksToDo,{name="Mutated Ruby",pos=RUBY_FARM_POS,look=RUBY_FARM_LOOK}) end
if not pDiamond.Q6.Done then table.insert(tasksToDo,{name="Perfect Throws",pos=TROPICAL_GROVE_POS,look=TROPICAL_GROVE_LOOK}) end
if #tasksToDo>0 then
local currentTask=tasksToDo[1]
currentActivityText="Farming "..currentTask.name.."..."
if (hrp.Position-currentTask.pos).Magnitude>15 then 
TeleportToLookAt(currentTask.pos,currentTask.look) 
task.wait(0.5) 
end
RunQuestInstantFish(CURRENT_KAITUN_DELAY)
else
currentActivityText="Diamond objectives done, waiting..."
task.wait(1)
end
end
elseif step==8 then
currentActivityText="KAITUN COMPLETED! DIAMOND ROD OBTAINED."
task.wait(3)
if KAITUN_ACTIVE then
KAITUN_ACTIVE=false
Fluent:Notify({Title="Kaitun Selesai",Content="Diamond Rod Acquired!",Duration=5})
Options.KaitunToggle:SetValue(false)
end
end
uiData.Labels.Status.Text=currentActivityText
task.wait(0.1)
end
end)
end

-- TOGGLE KAITUN (FLUENT VERSION)
local kaitunToggle = KaitunSection:AddToggle("KaitunToggle", {
    Title = "Start Auto Kaitun (Full AFK)",
    Description = "Auto Farm -> Buy Rods -> Auto Buy Bait -> Auto Quests.",
    Default = false
})

kaitunToggle:OnChanged(function(state)
    KAITUN_ACTIVE = state
    if state then
        Fluent:Notify({Title = "Kaitun Started", Duration = 3})
        RunKaitunLogic()
    else
        if KAITUN_THREAD then task.cancel(KAITUN_THREAD) end
        if KAITUN_AUTOSELL_THREAD then task.cancel(KAITUN_AUTOSELL_THREAD) end
        if KAITUN_EQUIP_THREAD then task.cancel(KAITUN_EQUIP_THREAD) end
        if KAITUN_OVERLAY then KAITUN_OVERLAY:Destroy() end
        pcall(function() RE_EquipToolFromHotbar:FireServer(0) end)
        Fluent:Notify({Title = "Kaitun Stopped", Duration = 2})
    end
end)

Window:Auth(1) 
end
local enteredKey=""
local isAuthenticating=false
local menuCreated=false
local function DoAuth(key,isAuto)
if isAuthenticating or menuCreated then return end
if not key or key==""then return end
isAuthenticating=true
Fluent:Notify({
Title=isAuto and"Auto Login"or"Validating",
Content=isAuto and"Mencoba login..."or"Memverifikasi key...",
Duration=2
})
local valid,codeOrErr=ValidateKey(key)
isAuthenticating=false
if valid then
saveToken(key)
getgenv().AuthComplete=true
getgenv().UserData=codeOrErr
SetupTabsAfterAuth()
menuCreated=true
Window:Auth(1) 
Fluent:Notify({
Title="Success",
Content=isAuto and("Auto login berhasil ("..tostring(codeOrErr)..")")or"Authentication berhasil",
Duration=3
})
else
if isAuto then
deleteToken()
end
Fluent:Notify({
Title="Failed",
Content=tostring(codeOrErr),
Duration=4
})
end
end
local KeyInput=Tabs.Auth:AddInput("KeyInput",{
Title="License Key",
Default="",
Placeholder="FYY-000-000-000",
Numeric=false,
Finished=false,
Callback=function(Value)
enteredKey=tostring(Value or""):upper():gsub("%s+","")
end
})
Tabs.Auth:AddButton({
Title="Verify Key",
Description="Click to verify your license key",
Callback=function()
DoAuth(enteredKey,false)
end
})
Tabs.Auth:AddParagraph({
Title="How to Use",
Content="1. Enter your license key\n2. Click Verify Key\n3. If valid, other tabs will appear"
})
task.spawn(function()
task.wait(2)
local saved=loadToken()
if saved and not menuCreated then
DoAuth(saved,true)
end
end)
Window:Auth(1) 
Fluent:Notify({
Title="Fyy X Fish IT",
Content="Script loaded. Please authenticate first.",
Duration=5
})
SaveManager:LoadAutoloadConfig()
local UIS=game:GetService("UserInputService")
local PG=LocalPlayer:WaitForChild("PlayerGui")
local function CreateFloatingIcon()
local existing=PG:FindFirstChild("CustomFloatingIcon_FyyHub")
if existing then existing:Destroy()end
local g=Instance.new("ScreenGui")
g.Name="CustomFloatingIcon_FyyHub"
g.DisplayOrder=999
g.ResetOnSpawn=false
local f=Instance.new("Frame")
f.Size=UDim2.fromOffset(45,45)
f.Position=UDim2.new(0,50,0.4,0)
f.AnchorPoint=Vector2.new(.5,.5)
f.BackgroundColor3=Color3.fromRGB(20,20,20)
f.BorderSizePixel=0
f.Parent=g
local s=Instance.new("UIStroke")
s.Color=Color3.fromRGB(138,43,226)
s.Thickness=2
s.Parent=f
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
local i=Instance.new("ImageLabel")
i.Image="rbxassetid://106899268176689"
i.BackgroundTransparency=1
i.Size=UDim2.new(1,-4,1,-4)
i.Position=UDim2.fromScale(.5,.5)
i.AnchorPoint=Vector2.new(.5,.5)
i.Parent=f
Instance.new("UICorner",i).CornerRadius=UDim.new(0,10)
g.Parent=PG
local dragging=false
local dragInput,dragStart,startPos
f.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=true
dragStart=input.Position
startPos=f.Position
end
end)
f.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
dragInput=input
end
end)
UIS.InputChanged:Connect(function(input)
if dragging and input==dragInput then
local delta=input.Position-dragStart
f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end
end)
f.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=false
if(input.Position-dragStart).Magnitude<5 then
if Window.Visible then
Window:Hide()
else
Window:Show()
end
end
end
end)
Window:OnShow(function()
g.Enabled=false
end)
Window:OnHide(function()
g.Enabled=true
end)
g.Enabled=not Window.Visible
return g
end
if LocalPlayer.Character then
CreateFloatingIcon()
end
LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
CreateFloatingIcon()
end)
