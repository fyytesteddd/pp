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
local function SetupTabs()
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
end
local function InfoTab()
    if not Info then return end
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
end

local function PlayerTab2()
    if not PlayerTab then return end
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
end

local function AutoTab()
    if not Auto then return end
local instantSection=Auto:AddSection("Instant Fishing")
local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players").LocalPlayer
local REE=RS.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]
local RFC=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]
local RFS=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]
local REF=RS.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]
local RFK=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/CancelFishingInputs"]
local d=1.3
local run=false
local eq=false
local aid="rbxassetid://114959536562596"
local at,hum=nil,nil
local function sF(r,a)if not r then return false end return pcall(function()if a~=nil then r:FireServer(a)else r:FireServer()end end)end
local function sI(r,a,b)if not r then return nil end local ok,res=pcall(function()if a~=nil and b~=nil then return r:InvokeServer(a,b)elseif a~=nil then return r:InvokeServer(a)else return r:InvokeServer()end end)return ok and res end
local function play()if not P.Character then return end hum=P.Character:FindFirstChildOfClass("Humanoid")if not hum then return end local an=Instance.new("Animation")an.AnimationId=aid at=hum:LoadAnimation(an)if at then at:Play()end end
local function stop()if at then at:Stop()at=nil end hum=nil end
local function equip()while run do if not eq then sF(REE,1)eq=true end task.wait(2)end eq=false end
local function cycle()while run do sI(RFK)local t=os.time()+os.clock()pcall(function()RFC:InvokeServer(t)end)sI(RFS,-139.630452165,0.99647927980797)task.wait(d)if not run then break end sF(REF)task.wait(.4)if not run then break end end end
local function start()play()task.spawn(equip)task.wait(.05)task.spawn(cycle)end
local autoFishingToggle=instantSection:AddToggle("autoFishing",{Title="Instant Fishing",Default=false})
autoFishingToggle:OnChanged(function(s)run=s if run then task.spawn(start)else sI(RFK)stop()eq=false end end)
local fishingDelaySlider=instantSection:AddSlider("fishingDelay",{Title="Completed Delay",Min=0.1,Max=5,Default=1.3,Rounding=1})
fishingDelaySlider:OnChanged(function(v)d=v end)
P.CharacterAdded:Connect(function()if run then task.wait(1)play()end end)
game:GetService("UserInputService").WindowFocused:Connect(function()if not run and at then stop()end end)

local blatantSection1=Auto:AddSection("Blatant V1")
local run=false
local loopT,eqT=nil,nil
local cDelay=3.1
local kDelay=.3
local interval=1.8
local loopIntervalInput=blatantSection1:AddInput("loopInterval",{Title="Recast Delay",Default=tostring(interval),Placeholder="1.8"})
loopIntervalInput:OnChanged(function(v)local n=tonumber(v)if n and n>=0 then interval=n end end)
local completeDelayInput=blatantSection1:AddInput("completeDelay",{Title="Complete Delay",Default=tostring(cDelay),Placeholder="3.1"})
completeDelayInput:OnChanged(function(v)local n=tonumber(v)if n and n>0 then cDelay=n end end)
local RS=game:GetService("ReplicatedStorage")
local R={"Packages","_Index","sleitnick_net@0.2.0","net"}
local function GR(n)local c=RS for _,p in ipairs(R)do c=c:WaitForChild(p,2)end return c and c:FindFirstChild(n)end
local RFC=GR("RF/ChargeFishingRod")
local RFS=GR("RF/RequestFishingMinigameStarted")
local REF=GR("RE/FishingCompleted")
local RFK=GR("RF/CancelFishingInputs")
local REE=GR("RE/EquipToolFromHotbar")
local function cast()if not run then return end task.spawn(function()local st=os.clock()local ts=os.time()+os.clock()pcall(function()RFC:InvokeServer(ts)end)task.wait(.05)pcall(function()RFS:InvokeServer(-139.6379699707,0.99647927980797)end)local w=cDelay-(os.clock()-st)if w>0 then task.wait(w)end pcall(function()REF:FireServer()end)task.wait(kDelay)pcall(function()RFK:InvokeServer()end)end)end
local blatantModeToggle=blatantSection1:AddToggle("blatantMode",{Title="Enable Blatant Mode",Default=false})
blatantModeToggle:OnChanged(function(s)run=s if s then if loopT then task.cancel(loopT)end loopT=task.spawn(function()while run do cast()task.wait(interval)end end)if eqT then task.cancel(eqT)end eqT=task.spawn(function()while run do pcall(function()REE:FireServer(1)end)task.wait(1)end end)else if loopT then task.cancel(loopT)loopT=nil end if eqT then task.cancel(eqT)eqT=nil end pcall(function()REE:FireServer(0)end)end end)

local blatantSection2=Auto:AddSection("Blatant V2")
local RS=game:GetService("ReplicatedStorage")
local net=RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RFC=net:WaitForChild("RF/ChargeFishingRod")
local RFS=net:WaitForChild("RF/RequestFishingMinigameStarted")
local RFK=net:WaitForChild("RF/CancelFishingInputs")
local RFU=net:WaitForChild("RF/UpdateAutoFishingState")
local REF=net:WaitForChild("RE/FishingCompleted")
local REM=net:WaitForChild("RE/FishingMinigameChanged")
local Equip=net:WaitForChild("RE/EquipToolFromHotbar")
local Unequip=net:WaitForChild("RE/UnequipToolFromHotbar")
local active=false
local fishingThread=nil
local equipThread=nil
local casts=0
local start=0
local CD=.002
local FD=.7
local KD=.3
local function safe(f)task.spawn(function()pcall(f)end)end
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local function fishingLoop()while active do local t=tick()safe(function()RFC:InvokeServer({[1]=t})end)task.wait(CD)local r=tick()safe(function()RFS:InvokeServer(1,0,r)end)casts+=1 task.wait(FD)safe(function()REF:FireServer()end)task.wait(KD)safe(function()RFK:InvokeServer()end)end end
local function equipLoop()while active do safe(function()Equip:FireServer(1)end)task.wait(1)end safe(function()Unequip:FireServer()end)end
REM.OnClientEvent:Connect(function()if not active then return end task.spawn(function()task.wait(FD)safe(function()REF:FireServer()end)task.wait(KD)safe(function()RFK:InvokeServer()end)end)end)
local blatantV2CompleteDelayInput=blatantSection2:AddInput("blatantV2_completeDelay",{Title="Complete Delay",Default=tostring(FD),Placeholder=tostring(FD)})
blatantV2CompleteDelayInput:OnChanged(function(v)local n=tonumber(v)if n and n>=0 then FD=n end end)
local blatantV2CancelDelayInput=blatantSection2:AddInput("blatantV2_cancelDelay",{Title="Cancel Delay",Default=tostring(KD),Placeholder=tostring(KD)})
blatantV2CancelDelayInput:OnChanged(function(v)local n=tonumber(v)if n and n>=0 then KD=n end end)
local blatantV2Toggle=blatantSection2:AddToggle("blatantV2_toggle",{Title="Enable Blatant V2",Default=false})
blatantV2Toggle:OnChanged(function(s)active=s if s then casts=0 start=tick()pcall(function()LocalPlayer:SetAttribute("InCutscene",true)end)safe(function()RFU:InvokeServer(true)end)fishingThread=task.spawn(fishingLoop)equipThread=task.spawn(equipLoop)else if fishingThread then task.cancel(fishingThread)fishingThread=nil end if equipThread then task.cancel(equipThread)equipThread=nil end safe(function()RFU:InvokeServer(false)end)safe(function()Unequip:FireServer()end)task.wait(.2)safe(function()RFK:InvokeServer()end)end end)

local blatantSection3=Auto:AddSection("Blatant V3 (BETA)")
local RS=game:GetService("ReplicatedStorage")
local net=RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RFC=net:WaitForChild("RF/ChargeFishingRod")
local RFS=net:WaitForChild("RF/RequestFishingMinigameStarted")
local RFK=net:WaitForChild("RF/CancelFishingInputs")
local RFU=net:WaitForChild("RF/UpdateAutoFishingState")
local REF=net:WaitForChild("RE/FishingCompleted")
local REM=net:WaitForChild("RE/FishingMinigameChanged")
local Equip=net:WaitForChild("RE/EquipToolFromHotbar")
local Unequip=net:WaitForChild("RE/UnequipToolFromHotbar")
local active=false
local fishingThread=nil
local equipThread=nil
local casts=0
local start=0
local CD=.001
local FD=.68
local KD=.299
local function safe(f)task.spawn(function()pcall(f)end)end
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local function fishingLoop()while active do local t=tick()safe(function()RFC:InvokeServer({[1]=t})end)task.wait(CD)local r=tick()safe(function()RFS:InvokeServer(1,0,r)end)casts+=1 local t2=tick()safe(function()RFC:InvokeServer({[1]=t2})end)task.wait(CD)local r2=tick()safe(function()RFS:InvokeServer(1,0,r2)end)casts+=1 task.wait(FD)safe(function()REF:FireServer()end)safe(function()REF:FireServer()end)task.wait(KD)safe(function()RFK:InvokeServer()end)task.wait(0.001)end end
local function equipLoop()while active do safe(function()Equip:FireServer(1)end)task.wait(100)end safe(function()Unequip:FireServer()end)end
REM.OnClientEvent:Connect(function()if not active then return end task.spawn(function()task.wait(FD)safe(function()REF:FireServer()end)task.wait(KD)safe(function()RFK:InvokeServer()end)end)end)
local blatantV3CastDelayInput=blatantSection3:AddInput("blatantV3_castDelay",{Title="Cast Delay",Default=tostring(CD),Placeholder=tostring(CD)})
blatantV3CastDelayInput:OnChanged(function(v)local n=tonumber(v)if n and n>=0 then CD=n end end)
local blatantV3CompleteDelayInput=blatantSection3:AddInput("blatantV3_completeDelay",{Title="Complete Delay",Default=tostring(FD),Placeholder=tostring(FD)})
blatantV3CompleteDelayInput:OnChanged(function(v)local n=tonumber(v)if n and n>=0 then FD=n end end)
local blatantV3CancelDelayInput=blatantSection3:AddInput("blatantV3_cancelDelay",{Title="Cancel Delay",Default=tostring(KD),Placeholder=tostring(KD)})
blatantV3CancelDelayInput:OnChanged(function(v)local n=tonumber(v)if n and n>=0 then KD=n end end)
local blatantV3Toggle=blatantSection3:AddToggle("blatantV3_toggle",{Title="Enable Blatant V3",Default=false})
blatantV3Toggle:OnChanged(function(s)active=s if s then casts=0 start=tick()pcall(function()LocalPlayer:SetAttribute("InCutscene",true)end)safe(function()RFU:InvokeServer(true)end)fishingThread=task.spawn(fishingLoop)equipThread=task.spawn(equipLoop)else if fishingThread then task.cancel(fishingThread)fishingThread=nil end if equipThread then task.cancel(equipThread)equipThread=nil end safe(function()RFU:InvokeServer(false)end)safe(function()Unequip:FireServer()end)task.wait(.2)safe(function()RFK:InvokeServer()end)end end)


local Autosell=Auto:AddSection(" [ Auto Sell Feature ] ")

local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players").LocalPlayer

local pkg=RS:WaitForChild("Packages"):WaitForChild("_Index")
local net=nil
if pkg:FindFirstChild("sleitnick_net@0.2.0")then
 net=pkg["sleitnick_net@0.2.0"]:WaitForChild("net")
elseif pkg:FindFirstChild("cemstone_net@0.2.1")then
 net=pkg["cemstone_net@0.2.1"]:WaitForChild("net")
end

local RF=net["RF/SellAllItems"]
local RE=net["RE/ObtainedNewFishNotification"]

local on=false
local mode="Delay"
local val=50
local loop=nil
local cnt=0
local conn=nil

local function sell()
 if not RF then return false end
 return pcall(function()RF:InvokeServer()end)
end

local function listen()
 if not RE then return false end
 if conn then conn:Disconnect()conn=nil end
 conn=RE.OnClientEvent:Connect(function()
  cnt+=1
  if mode=="Count"and on and cnt>=val then
   if sell()then cnt=0 end
  end
 end)
 return true
end

local function start()
 if loop then task.cancel(loop)end
 loop=task.spawn(function()
  while on do
   if mode=="Delay"then
    sell()
    for _=1,val do if not on then break end task.wait(1)end
   else task.wait(1)end
  end
 end)
end

local sellModeDropdown=Autosell:AddDropdown("sellMode",{
 Title="Sell Mode",
 Values={"Delay","Count"},
 Default="Delay"
})
sellModeDropdown:OnChanged(function(v)
 mode=v cnt=0
 if on then
  if v=="Count"then listen()else start()end
 end
end)

local sellValueInput=Autosell:AddInput("sellValue",{
 Title="Value",
 Default="50",
 Placeholder="50"
})
sellValueInput:OnChanged(function(t)
 local n=tonumber(t)
 if n and n>0 then val=n end
end)

local autoSellToggle=Autosell:AddToggle("autoSell",{
 Title="Enable Auto Sell",
 Default=false
})
autoSellToggle:OnChanged(function(s)
 on=s
 if s then
  if mode=="Count"then
   listen()
  else
   start()
  end
 else
  if conn then conn:Disconnect()conn=nil end
  cnt=0
  if loop then task.cancel(loop)loop=nil end
 end
end)

Autosell:AddButton({
 Title="Sell Now",
 Callback=function()sell()end
})



local favoriteSection = Auto:AddSection("Auto Favorite Feature")

local RS = game:GetService("ReplicatedStorage")
local net = RS.Packages._Index["sleitnick_net@0.2.0"].net
local REF = net["RE/FavoriteItem"]
local REN = net["RE/ObtainedNewFishNotification"]
local Items = RS:FindFirstChild("Items")

local AutoFav = {
    Connection = nil,
    Tiers = {},
    Muts = {},
    FishData = {},
    ItemNames = {},
    Enabled = false
}

local function loadFishData()
    if not Items or not Items:IsA("ModuleScript") then return false end
    
    local success, data = pcall(require, Items)
    if not success or not data then return false end
    
    local tierMap = {
        [1] = "Common",
        [2] = "Uncommon",
        [3] = "Rare",
        [4] = "Epic",
        [5] = "Legendary",
        [6] = "Mythic",
        [7] = "SECRET"
    }
    
    for _, name in ipairs({"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"}) do
        AutoFav.FishData[name] = {}
    end
    
    for _, fishData in pairs(data) do
        if type(fishData) == "table" and fishData.Data and fishData.Data.Type == "Fish" then
            local tier = tierMap[fishData.Data.Tier or 1] or "Common"
            if AutoFav.FishData[tier] then
                table.insert(AutoFav.FishData[tier], fishData.Data.Id)
            end
        end
    end
    
    for tierName, fishList in pairs(AutoFav.FishData) do
        table.sort(fishList)
    end
    
    return true
end

loadFishData()

local ItemUtility = require(RS:WaitForChild("Shared"):WaitForChild("ItemUtility"))
task.spawn(function()
    local ItemsFolder = RS:FindFirstChild("Items")
    if ItemsFolder then
        for _, itemScript in pairs(ItemsFolder:GetDescendants()) do
            if not string.find(itemScript:GetFullName(), "!!!") and itemScript:IsA("ModuleScript") then
                local success, itemData = pcall(function()
                    return require(itemScript)
                end)
                if success and itemData then
                    local data = itemData.Data or itemData
                    if data and data.Id and data.Name and data.Type ~= "Fishing Rods" then
                        table.insert(AutoFav.ItemNames, data.Name)
                    end
                end
            end
        end
        table.sort(AutoFav.ItemNames)
    end
end)

local function convertFluentTableToArray(fluentTable)
    local array = {}
    if not fluentTable then return array end
    
    for value, isSelected in pairs(fluentTable) do
        if isSelected then
            table.insert(array, value)
        end
    end
    return array
end

local function autoFavorite(id, worldFish, inventoryItem)
    local mutation = (worldFish and worldFish.VariantId) or 
                     (inventoryItem and inventoryItem.InventoryItem and 
                      inventoryItem.InventoryItem.Metadata and 
                      inventoryItem.InventoryItem.Metadata.VariantId)
    
    local uuid = nil
    if inventoryItem and inventoryItem.InventoryItem and inventoryItem.InventoryItem.UUID then
        uuid = inventoryItem.InventoryItem.UUID
    else
        uuid = id
    end
    
   
    if inventoryItem and inventoryItem.InventoryItem then
        local itemData = ItemUtility:GetItemData(inventoryItem.InventoryItem.Id)
        if itemData and itemData.Data and itemData.Data.Name then
            local itemName = itemData.Data.Name
            for _, selectedName in ipairs(AutoFav.SelectedNames or {}) do
                if itemName == selectedName then
                    if REF then
                        task.spawn(function()
                            pcall(function()
                                REF:FireServer(uuid)
                            end)
                        end)
                    end
                    return
                end
            end
        end
    end
    
    
    for _, tier in ipairs(AutoFav.Tiers) do
        if AutoFav.FishData[tier] and table.find(AutoFav.FishData[tier], id) then
            if REF then
                task.spawn(function()
                    pcall(function()
                        REF:FireServer(uuid)
                    end)
                end)
            end
            return
        end
    end
    

    if mutation then
        for _, mut in ipairs(AutoFav.Muts) do
            if mutation == mut then
                if REF then
                    task.spawn(function()
                        pcall(function()
                            REF:FireServer(uuid)
                        end)
                    end)
                end
                return
            end
        end
    end
end

local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"}
local mutations = {
    "Shiny", "Albino", "Sandy", "Noob", "Moon Fragment", "Festive", "Disco", "1x1x1x1",
    "Bloodmoon", "Color Burn", "Corrupt", "Fairy Dust", "Frozen", "Galaxy", "Gemstone",
    "Ghost", "Gold", "Holographic", "Lightning", "Midnight", "Radioactive", "Stone",
    "Leviathan's Rage"
}


local rarityDropdown = favoriteSection:AddDropdown("FavRarity", {
    Title = "Rarity",
    Values = rarities,
    Multi = true,
    Default = {"Legendary", "Mythic", "SECRET"}
})

rarityDropdown:OnChanged(function(selectedTable)
    AutoFav.Tiers = convertFluentTableToArray(selectedTable)
end)

local mutationDropdown = favoriteSection:AddDropdown("FavMutation", {
    Title = "Mutation",
    Values = mutations,
    Multi = true,
    Default = {}
})

mutationDropdown:OnChanged(function(selectedTable)
    AutoFav.Muts = convertFluentTableToArray(selectedTable)
end)

local favoriteByNameDropdown = favoriteSection:AddDropdown("FavByName", {
    Title = "Favorite by Name",
    Values = AutoFav.ItemNames,
    Multi = true,
    AllowNone = true,
    SearchBarEnabled = true,
    ScrollBarEnabled = true,
    Default = {}
})

favoriteByNameDropdown:OnChanged(function(selectedTable)
    AutoFav.SelectedNames = convertFluentTableToArray(selectedTable)
end)

local autoToggle = favoriteSection:AddToggle("AutoFavorite", {
    Title = "Enable Auto Favorite",
    Default = false
})

autoToggle:OnChanged(function(state)
    AutoFav.Enabled = state
    
    if state then
        if AutoFav.Connection then
            AutoFav.Connection:Disconnect()
            AutoFav.Connection = nil
        end
        
        if REN then
            local function safeAutoFavorite(...)
                if AutoFav.Enabled then
                    autoFavorite(...)
                end
            end
            
            AutoFav.Connection = REN.OnClientEvent:Connect(safeAutoFavorite)
        end
    else
        if AutoFav.Connection then
            AutoFav.Connection:Disconnect()
            AutoFav.Connection = nil
        end
    end
end)
end

local function ShopTab()
    if not Shop then return end
local ShopFeature = Shop:AddSection("Purchase Fishing Rods")

local RS = game:GetService("ReplicatedStorage")
local rodPurchaseRF = RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

local rods = {
    ["Starter Rod (50$)"] = 1,
    ["Luck Rod (350$)"] = 79,
    ["Carbon Rod (900$)"] = 76,
    ["Grass Rod (1500$)"] = 85,
    ["Desmascus Rod (3000$)"] = 77,
    ["Ice Rod (5000$)"] = 78,
    ["Lucky Rod (15000$)"] = 4,
    ["Midnight Rod (50000$)"] = 80,
    ["SteamPunk Rod (215000$)"] = 6,
    ["Chrome Rod (437000$)"] = 7,
    ["Fluorescent Rod (715000$)"] = 255,
    ["Astral Rod (1M$)"] = 5,
    ["Ares Rod (3M$)"] = 126,
    ["Angler Rod (8M$)"] = 168,
    ["Bambo Rod (12M$)"] = 258
}

local rodValues = {
    "Starter Rod (50$)", "Luck Rod (350$)", "Carbon Rod (900$)", "Grass Rod (1500$)",
    "Desmascus Rod (3000$)", "Ice Rod (5000$)", "Lucky Rod (15000$)", "Midnight Rod (50000$)",
    "SteamPunk Rod (215000$)", "Chrome Rod (437000$)", "Fluorescent Rod (715000$)",
    "Astral Rod (1M$)", "Ares Rod (3M$)", "Angler Rod (8M$)", "Bambo Rod (12M$)"
}

local rodDropdown = ShopFeature:AddDropdown("RodDropdown", {
    Title = "Select Fishing Rod",
    Values = rodValues,
    Default = rodValues[1]
})

local currentRod = rodValues[1]

rodDropdown:OnChanged(function(value)
    currentRod = value
end)

ShopFeature:AddButton({
    Title = "Purchase Fishing Rod",
    Callback = function()
        local id = rods[currentRod]
        if id and rodPurchaseRF then
            pcall(function()
                rodPurchaseRF:InvokeServer(id)
            end)
        end
    end
})

local bobers = Shop:AddSection("Purchase Bobbers")
local baitPurchaseRF = RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]

local baits = {
    ["TopWater Bait (100$)"] = 10,
    ["Luck Bait (1000$)"] = 2,
    ["Midnight Bait (3000$)"] = 3,
    ["Nature Bait (83500$)"] = 17,
    ["Chroma Bait (290000$)"] = 6,
    ["Dark Matter Bait (630000$)"] = 8,
    ["Corrupt Bait (1.15M$)"] = 15,
    ["Aether Bait (3.70M$)"] = 16,
    ["Floral Bait (4M$)"] = 20
}

local baitValues = {
    "TopWater Bait (100$)", "Luck Bait (1000$)", "Midnight Bait (3000$)",
    "Nature Bait (83500$)", "Chroma Bait (290000$)", "Dark Matter Bait (630000$)",
    "Corrupt Bait (1.15M$)", "Aether Bait (3.70M$)", "Floral Bait (4M$)"
}

local baitDropdown = bobers:AddDropdown("BaitDropdown", {
    Title = "Select Bobbers",
    Values = baitValues,
    Default = baitValues[1]
})

local currentBait = baitValues[1]

baitDropdown:OnChanged(function(value)
    currentBait = value
end)

bobers:AddButton({
    Title = "Purchase Bobbers",
    Callback = function()
        local id = baits[currentBait]
        if id and baitPurchaseRF then
            pcall(function()
                baitPurchaseRF:InvokeServer(id)
            end)
        end
    end
})

local weatherShop=Shop:AddSection("Purchase Weather")
local sel={"Wind (10000)","Cloudy (20000)","Storm (35000)"}
local on=false
local loop=nil
local selectWeatherDropdown=weatherShop:AddDropdown("weatherSelect",{
 Title="Select Weather",
 Values={"Wind (10000)","Cloudy (20000)","Snow (15000)","Storm (35000)","Radiant (50000)","Shark Hunt (300000)"},
 Default={"Wind (10000)","Cloudy (20000)","Storm (35000)"},
 Multi=true
})
selectWeatherDropdown:OnChanged(function(v)sel=v end)
local RS=game:GetService("ReplicatedStorage")
local RF=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]
local map={
 ["Wind (10000)"]="Wind",
 ["Cloudy (20000)"]="Cloudy",
 ["Snow (15000)"]="Snow",
 ["Storm (35000)"]="Storm",
 ["Radiant (50000)"]="Radiant",
 ["Shark Hunt (300000)"]="Shark Hunt"
}
local function buy(n)
 local w=map[n]
 if w then RF:InvokeServer(w)end
end
weatherShop:AddButton({
 Title="Purchase Weather",
 Callback=function()
  for _,w in pairs(sel)do buy(w)end
 end
})
local autoBuyWeatherToggle=weatherShop:AddToggle("autoBuyWeather",{
 Title="Auto Buy Weather",
 Default=false
})
autoBuyWeatherToggle:OnChanged(function(s)
 on=s
 if s then
  loop=game:GetService("RunService").Heartbeat:Connect(function()
   task.wait(2)
   if on then
    for _,w in pairs(sel)do buy(w)end
   end
  end)
 else
  if loop then loop:Disconnect()loop=nil end
 end
end)
end

local function TeleportTab()
    if not Teleport then return end
local Teleport1=Teleport:AddSection("Teleport Players")

local PS = game:GetService("Players")
local LP = PS.LocalPlayer
local selectedPlayer = ""

local function getPlayerList()
    local players = {}
    for _, player in pairs(PS:GetPlayers()) do
        if player ~= LP then
            table.insert(players, player.Name)
        end
    end
    return players
end

local playerDropdown = Teleport1:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = getPlayerList(),
    Default = ""
})

playerDropdown:OnChanged(function(value)
    if value and value ~= "" then
        selectedPlayer = value
    end
end)

Teleport1:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        local players = getPlayerList()
        playerDropdown:SetValues(players)
    end
})

Teleport1:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        if selectedPlayer ~= "" then
            local targetPlayer = PS:FindFirstChild(selectedPlayer)
            if targetPlayer then
                local targetChar = targetPlayer.Character
                local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                local localChar = LP.Character
                local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
                
                if targetHRP and localHRP then
                    localHRP.CFrame = targetHRP.CFrame
                end
            end
        end
    end
})

task.spawn(function()
    task.wait(2)
    local players = getPlayerList()
    playerDropdown:SetValues(players)
end)

local Teleport2=Teleport:AddSection("Teleport Location")

local T = {
    ["Fisherman Island"] = CFrame.new(77, 9, 2706),
    ["Kohana Volcano"] = CFrame.new(-628.758911, 35.710186, 104.373764, 0.482912123, 1.81591773e-08, 0.875668824, 3.01732896e-08, 1, -3.73774007e-08, -0.875668824, 4.44718076e-08, 0.482912123),
    ["Kohana"] = CFrame.new(-725.013306, 3.03549194, 800.079651, -0.999999285, -5.38041718e-08, -0.00118542486, -5.379977e-08, 1, -3.74458198e-09, 0.00118542486, -3.68080366e-09, -0.999999285),
    ["Esotric Islands"] = CFrame.new(2113, 10, 1229),
    ["Coral Reefs"] = CFrame.new(-3063.54248, 4.04500151, 2325.85278, 0.999428809, 2.02288568e-08, 0.033794228, -1.96206607e-08, 1, -1.83286453e-08, -0.033794228, 1.76551112e-08, 0.999428809),
    ["Crater Island"] = CFrame.new(984.003296, 2.87008905, 5144.92627, 0.999932885, 1.19231975e-08, 0.0115857301, -1.04685522e-08, 1, -1.25615529e-07, -0.0115857301, 1.25485812e-07, 0.999932885),
    ["Sisyphus Statue"] = CFrame.new(-3737, -136, -881),
    ["Treasure Room"] = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, -2.75628675e-08, -0.989015162, -1.74189818e-08, 1, -2.52656349e-08, 0.989015162, 1.34930183e-08, -0.147814155),
    ["Lost Isle"] = CFrame.new(-3649.0813, 5.42584181, -1052.88745, 0.986230493, 3.9997154e-08, -0.165376455, -3.81513914e-08, 1, 1.43375187e-08, 0.165376455, -7.83075649e-09, 0.986230493),
    ["Tropical Grove"] = CFrame.new(-2151.29248, 15.8166971, 3628.10669, -0.997403979, 4.56146232e-09, -0.0720091537, 4.62302685e-09, 1, -6.88285429e-10, 0.0720091537, -1.0193989e-09, -0.997403979),
    ["Weater Machine"] = CFrame.new(-1518.05042, 2.87499976, 1909.78125, -0.995625556, -1.82757487e-09, -0.0934334621, 2.24076646e-09, 1, -4.34377512e-08, 0.0934334621, -4.34570957e-08, -0.995625556),
    ["Enchant Room"] = CFrame.new(3180.14502, -1302.85486, 1387.9563, 0.338028163, 9.92235272e-08, -0.941136003, 1.90291747e-08, 1, 1.12264253e-07, 0.941136003, -5.58575195e-08, 0.338028163),
    ["Seconds Enchant"] = CFrame.new(1487, 128, -590),
    ["Ancient Jungle"] = CFrame.new(1519.33215, 2.08891273, -307.090668, 0.632470906, -1.48247699e-08, 0.774584115, -2.24899335e-08, 1, 3.75027014e-08, -0.774584115, -4.11397139e-08, 0.632470906),
    ["Sacred Temple"] = CFrame.new(1413.84277, 4.375, -587.298279, 0.261966974, 5.50031594e-08, -0.965076864, -8.19077872e-09, 1, 5.47701973e-08, 0.965076864, -6.44325127e-09, 0.261966974),
    ["Underground Cellar"] = CFrame.new(2103.14673, -91.1976471, -717.124939, -0.226165071, -1.71397723e-08, -0.974088967, -2.1650266e-09, 1, -1.70930168e-08, 0.974088967, -1.75691484e-09, -0.226165071),
    ["Arrow Artifact"] = CFrame.new(883.135437, 6.62499952, -350.10025, -0.480593145, 2.676836e-08, 0.876943707, -4.66245069e-08, 1, -5.6076324e-08, -0.876943707, -6.78369645e-08, -0.480593145),
    ["Crescent Artifact"] = CFrame.new(1409.40747, 6.62499952, 115.430603, -0.967555583, -5.63477229e-08, 0.252658188, -7.82660337e-08, 1, -7.67005233e-08, -0.252658188, -9.39865714e-08, -0.967555583),
    ["Hourglass Diamond Artifact"] = CFrame.new(1480.98645, 6.27569771, -847.142029, -0.967326343, -5.985531e-08, 0.253534466, -6.16077926e-08, 1, 1.02735098e-09, -0.253534466, -1.46259147e-08, -0.967326343),
    ["Diamond Artifact"] = CFrame.new(1836.31604, 6.34277105, -298.546265, 0.545851529, -2.36059989e-08, -0.837881923, -4.70848498e-08, 1, -5.8847597e-08, 0.837881923, 7.15735951e-08, 0.545851529),
    ["Ancient Ruin"] = CFrame.new(6087, -586, 4701),
    ["Pirate Island"] = CFrame.new(3263, 5, 3686),
    ["Pirate Treasure Room"] = CFrame.new(3333, -299, 3093)
}

local selectedIsland = ""

local islandValues = {
    "Fisherman Island", "Kohana Volcano", "Kohana", "Esotric Islands", "Coral Reefs",
    "Crater Island", "Sisyphus Statue", "Treasure Room", "Lost Isle", "Tropical Grove",
    "Weater Machine", "Enchant Room", "Seconds Enchant", "Ancient Jungle", "Sacred Temple",
    "Underground Cellar", "Arrow Artifact", "Crescent Artifact", "Hourglass Diamond Artifact",
    "Diamond Artifact", "Ancient Ruin", "Pirate Island", "Pirate Treasure Room"
}

local islandDropdown = Teleport2:AddDropdown("IslandDropdown", {
    Title = "Teleport To Island",
    Values = islandValues,
    Default = ""
})

islandDropdown:OnChanged(function(value)
    if value and value ~= "" then
        selectedIsland = value
    end
end)

Teleport2:AddButton({
    Title = "Teleport to Island",
    Callback = function()
        if selectedIsland ~= "" and T[selectedIsland] then
            local character = LP.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = T[selectedIsland]
            end
        end
    end
})


local Teleport3=Teleport:AddSection("Teleport To Game Event")

local P = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

local currentEvent = "Megalodon Hunt"
local teleporting = false
local lastPosition = nil
local bodyVelocity = nil
local connection = nil
local frozen = false
local done = false

local EventSettings = {
    isTeleporting = false,
    currentLocation = "Megalodon Hunt"
}

teleporting = EventSettings.isTeleporting
currentEvent = EventSettings.currentLocation

local function findEvent(eventName)
    if eventName == "Worm Fish" then
        for _, v in ipairs(workspace:GetChildren()) do
            local model = v:FindFirstChild("Model")
            if model then
                local part = model:GetChildren()[3]
                if part and part:IsA("BasePart") then
                    return part
                end
            end
        end
    else
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == eventName then
                if v:IsA("Model") then
                    return v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true)
                elseif v:IsA("BasePart") then
                    return v
                end
            end
        end
    end
    return nil
end

local function freeze(position)
    local character = P.Character
    if not character or character:GetAttribute("Dead") then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = humanoidRootPart
    
    local success = pcall(function()
        humanoidRootPart.CFrame = CFrame.new(position)
    end)
    
    if not success then
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        return
    end
    
    frozen = true
    done = true
end

local function unfreeze()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    frozen = false
    done = false
end

local function savePosition()
    for _ = 1, 5 do
        local character = P.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            lastPosition = humanoidRootPart.Position
            return true
        end
        task.wait(0.2)
    end
    return false
end

local function teleportToEvent(eventPart)
    if not eventPart then return end
    local position = eventPart.Position
    freeze(Vector3.new(
        position.X + math.random(-10, 10),
        position.Y + 80,
        position.Z + math.random(-10, 10)
    ))
end

local function returnToLastPosition()
    if not lastPosition then return end
    unfreeze()
    local humanoidRootPart = P.Character and P.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(lastPosition)
    end
end

local function stopTeleporting()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    if frozen then
        returnToLastPosition()
    end
end

local function startTeleporting()
    if connection then
        connection:Disconnect()
    end
    
    if not savePosition() then return end
    
    connection = RS.Heartbeat:Connect(function()
        if not teleporting then
            if frozen then
                returnToLastPosition()
            end
            return
        end
        
        local character = P.Character
        if not character or character:GetAttribute("Dead") then
            if frozen then
                unfreeze()
            end
            return
        end
        
        if done then return end
        
        local eventPart = nil
        for _ = 1, 3 do
            eventPart = findEvent(currentEvent)
            if eventPart then break end
            task.wait(0.1)
        end
        
        if eventPart then
            if not frozen then
                teleportToEvent(eventPart)
            end
        elseif frozen then
            returnToLastPosition()
        end
    end)
end

local eventDropdown = Teleport3:AddDropdown("EventDropdown", {
    Title = "Hunt Location",
    Values = {"Megalodon Hunt", "Ghost Shark Hunt", "Shark Hunt", "Worm Fish"},
    Default = currentEvent
})

eventDropdown:OnChanged(function(value)
    currentEvent = value
    EventSettings.currentLocation = value
    
    if teleporting then
        unfreeze()
        task.wait(0.1)
        startTeleporting()
    end
end)

local eventToggle = Teleport3:AddToggle("EventTeleport", {
    Title = "Teleport To Game Event",
    Default = teleporting
})

eventToggle:OnChanged(function(state)
    teleporting = state
    EventSettings.isTeleporting = state
    
    if state then
        task.wait(0.5)
        startTeleporting()
    else
        stopTeleporting()
    end
end)

P.CharacterAdded:Connect(function()
    task.wait(2)
    if teleporting then
        task.wait(1)
        startTeleporting()
    end
end)

local Teleport4=Teleport:AddSection("Teleport To NPC")

local npcLocations = {
    ["Alex"] = CFrame.new(49, 17, 2880),
    ["Alien Merchant"] = CFrame.new(-134, 2, 2762),
    ["Aura Kid"] = CFrame.new(71, 17, 2830),
    ["Billy Bob"] = CFrame.new(80, 17, 2876),
    ["Boat Expert"] = CFrame.new(33, 10, 2783),
    ["Joe"] = CFrame.new(144, 20, 2862),
    ["Ron"] = CFrame.new(-52, 17, 2859),
    ["Scientist"] = CFrame.new(-7, 18, 2886),
    ["Scott"] = CFrame.new(-17, 10, 2703),
    ["Seth"] = CFrame.new(111, 17, 2877),
    ["Silly Fisherman"] = CFrame.new(102, 10, 2690)
}

local selectedNPC = ""

local npcValues = {
    "Alex", "Alien Merchant", "Aura Kid", "Billy Bob", "Boat Expert",
    "Joe", "Ron", "Scientist", "Scott", "Seth", "Silly Fisherman"
}

local npcDropdown = Teleport4:AddDropdown("NPCDropdown", {
    Title = "Teleport to NPC",
    Values = npcValues,
    Default = ""
})

npcDropdown:OnChanged(function(value)
    if value and value ~= "" then
        selectedNPC = value
    end
end)

Teleport4:AddButton({
    Title = "Teleport to NPC",
    Callback = function()
        if selectedNPC and selectedNPC ~= "" and npcLocations[selectedNPC] then
            local character = P.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = npcLocations[selectedNPC]
            end
        end
    end
})
end


local function TotemTab()
    if not Totem then return end
    
    local Totemtot = Totem:AddSection("Totem Features")
    
    local statusParagraph = Totemtot:AddParagraph({
        Title = "Status",
        Content = "Waiting...",
        Icon = "clock"
    })
    
    local RS = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    
    local TOTEM_DATA = {
        ["Luck Totem"] = {Id = 1, Duration = 3601},
        ["Mutation Totem"] = {Id = 2, Duration = 3601},
        ["Shiny Totem"] = {Id = 3, Duration = 3601}
    }
    
    local TOTEM_NAMES = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
    local selectedTotemName = "Luck Totem"
    local currentTotemExpiry = 0
    local AUTO_TOTEM_ACTIVE = false
    local AUTO_TOTEM_THREAD = nil
    
    -- Cari Replion helper
    local PlayerDataReplion = nil
    local function GetPlayerData()
        if PlayerDataReplion then return PlayerDataReplion end
        local success, result = pcall(function()
            local Replion = RS:WaitForChild("Packages", 10):WaitForChild("Replion", 10)
            return require(Replion).Client:WaitReplion("Data", 5)
        end)
        if success and result then
            PlayerDataReplion = result
            return result
        end
        return nil
    end
    
    -- Cari remote
    local function GetRemoteSmart(name)
        local packages = RS:WaitForChild("Packages", 10)
        local index = packages and packages:WaitForChild("_Index", 10)
        if index then 
            for _, child in ipairs(index:GetChildren()) do 
                if child.Name:find("net@") then 
                    local net = child:FindFirstChild("net")
                    if net then 
                        local remote = net:FindFirstChild(name)
                        if remote then return remote end
                    end
                end
            end
        end
        return nil
    end

    local RE_SpawnTotem = nil
    local RE_EquipToolFromHotbar = nil

    task.spawn(function()
        while not RE_SpawnTotem do
            RE_SpawnTotem = GetRemoteSmart("RE/SpawnTotem")
            if not RE_SpawnTotem then task.wait(1) end
        end
    end)

    task.spawn(function()
        while not RE_EquipToolFromHotbar do
            RE_EquipToolFromHotbar = GetRemoteSmart("RE/EquipToolFromHotbar")
            if not RE_EquipToolFromHotbar then task.wait(1) end
        end
    end)
    
    local function GetTotemUUID(name)
        local replion = GetPlayerData()
        if not replion then return nil end
        
        local success, data = pcall(function()
            return replion:GetExpect("Inventory")
        end)
        
        if success and data and data.Totems then
            for _, item in ipairs(data.Totems) do
                if tonumber(item.Id) == TOTEM_DATA[name].Id and (item.Count or 1) >= 1 then
                    return item.UUID
                end
            end
        end
        return nil
    end
    
    local function RunAutoTotemLoop()
        if AUTO_TOTEM_THREAD then
            task.cancel(AUTO_TOTEM_THREAD)
        end
        
        AUTO_TOTEM_THREAD = task.spawn(function()
            while AUTO_TOTEM_ACTIVE and task.wait(1) do
                local timeLeft = currentTotemExpiry - os.time()
                
                if timeLeft > 0 then
                    local minutes = math.floor((timeLeft % 3600) / 60)
                    local seconds = timeLeft % 60
                    statusParagraph:SetDesc(string.format("Next: %02d:%02d", minutes, seconds))
                else
                    statusParagraph:SetDesc("Spawning...")
                    
                    if not GetPlayerData() then
                        statusParagraph:SetDesc("Waiting for data...")
                        continue
                    end
                    
                    if not RE_SpawnTotem then
                        statusParagraph:SetDesc("Waiting for RE_SpawnTotem...")
                        -- Try manual fetch just in case
                        RE_SpawnTotem = GetRemoteSmart("RE/SpawnTotem")
                        continue
                    end
                    
                    local uuid = GetTotemUUID(selectedTotemName)
                    
                    if uuid then
                        local success, err = pcall(function()
                            RE_SpawnTotem:FireServer(uuid)
                        end)
                        
                        if success then
                            currentTotemExpiry = os.time() + TOTEM_DATA[selectedTotemName].Duration
                            statusParagraph:SetDesc("Spawned!")
                            
                            -- Equip rod
                            if RE_EquipToolFromHotbar then
                                for i = 1, 3 do
                                    task.wait(0.2)
                                    pcall(function()
                                        RE_EquipToolFromHotbar:FireServer(1)
                                    end)
                                end
                            end
                        else
                            statusParagraph:SetDesc("Error: " .. tostring(err))
                        end
                    else
                        statusParagraph:SetDesc("No " .. selectedTotemName .. " found")
                    end
                end
            end
        end)
    end
    
    local totemDropdown = Totemtot:AddDropdown("TotemType", {
        Title = "Pilih Totem",
        Values = TOTEM_NAMES,
        Default = selectedTotemName
    })
    
    totemDropdown:OnChanged(function(value)
        selectedTotemName = value
        currentTotemExpiry = 0
        statusParagraph:SetDesc("Changed to: " .. value)
    end)
    
    local totemToggle = Totemtot:AddToggle("AutoTotemSingle", {
        Title = "Auto Totem (Single)",
        Default = false
    })
    
    totemToggle:OnChanged(function(state)
        AUTO_TOTEM_ACTIVE = state
        
        if state then
            statusParagraph:SetDesc("Starting...")
            RunAutoTotemLoop()
        else
            if AUTO_TOTEM_THREAD then
                task.cancel(AUTO_TOTEM_THREAD)
                AUTO_TOTEM_THREAD = nil
            end
            statusParagraph:SetDesc("Stopped")
        end
    end)
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
menuCreated=true
task.spawn(function()
 while true do
  task.wait(3)
  if menuCreated then
   SetupTabs()
   InfoTab()
   PlayerTab2()
   Window:SelectTab(2) 
   AutoTab()
   ShopTab()
   TeleportTab()
    TotemTab()
   break
  end
 end
end)
--// Anti AFK
local VIM=game:GetService("VirtualInputManager")
task.spawn(function()
 while true do
  task.wait(math.random(600,700))
  local k={{Enum.KeyCode.LeftShift,Enum.KeyCode.E},{Enum.KeyCode.LeftControl,Enum.KeyCode.F},{Enum.KeyCode.LeftShift,Enum.KeyCode.Q},{Enum.KeyCode.E,Enum.KeyCode.F}}
  local c=k[math.random(#k)]
  pcall(function()
   for _,x in pairs(c)do VIM:SendKeyEvent(true,x,false,nil)end
   task.wait(.1)
   for _,x in pairs(c)do VIM:SendKeyEvent(false,x,false,nil)end
  end)
 end
end)
print("[ ANTI AFK ON BY FYY ]")

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
Window:SelectTab(1)
Fluent:Notify({
Title="Fyy X Fish IT",
Content="Script loaded. Please authenticate first.",
Duration=5
})
SaveManager:LoadAutoloadConfig()
local UIS=game:GetService("UserInputService")
local PG=game.Players.LocalPlayer:WaitForChild("PlayerGui")
local uisConn=nil 
local dragging=false 
local dragInput,dragStart,startPos
local function C()
local o=PG:FindFirstChild("CustomFloatingIcon_FyyHub")
if o then o:Destroy()end 
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
return g,f 
end
local function S(g,f)
if uisConn then 
uisConn:Disconnect()
uisConn=nil 
end 
local function u(i)local d=i.Position-dragStart f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)end
f.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
dragging=true 
dragStart=i.Position 
startPos=f.Position 
local m=false 
local c1,c2 
c1=i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then 
dragging=false 
c1:Disconnect()
if not m then 
if Window then
Window:Minimize()
end
end 
end 
end)
c2=i.Changed:Connect(function()
if dragging and(i.Position-dragStart).Magnitude>5 then 
m=true 
c2:Disconnect()
end 
end)
end 
end)
f.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
uisConn=UIS.InputChanged:Connect(function(i)if i==dragInput and dragging then u(i)end end)
if Window then
local function updateIcon()g.Enabled=not Window.Visible end
local conn
if Window.OnVisibilityChanged then
conn=Window:OnVisibilityChanged(function(v)g.Enabled=not v end)
else
task.spawn(function()while g and g.Parent do updateIcon()task.wait(0.3)end if conn then conn:Disconnect()end end)
end
g.Enabled=not Window.Visible
end
end
local function I()
if not game.Players.LocalPlayer.Character then 
game.Players.LocalPlayer.CharacterAdded:Wait()
end 
local g,f=C()
if g and f then 
S(g,f)
end 
end
game.Players.LocalPlayer.CharacterAdded:Connect(function()task.wait(1)I()end)I()
