Fluent, SaveManager, InterfaceManager = loadstring(Game:HttpGet("https://raw.githubusercontent.com/fyytesteddd/pp/refs/heads/main/lib.lua"))()

local Window=Fluent:CreateWindow({Title="Fyy X Fish IT | 1.1.2",SubTitle="by Fyy Community",TabWidth=150,Size=UDim2.fromOffset(530, 300),Acrylic=true,Theme="Arctic",MinimizeKey=Enum.KeyCode.G,BackgroundImage="rbxassetid://78893380921225",BackgroundTransparency=0.4})
local Tabs={Auth=Window:AddTab({Title="Authentication",Icon="key"})}
local Options=Fluent.Options

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
local Info,Premium,PlayerTab,Auto,Shop,Teleport,Totem,Quest,Event,Trade,Enchant,Animation,Discord,SettingTab,MiscTab
local function SetupTabs()
-- Setup SaveManager dan InterfaceManager setelah authentication
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FyyScriptHub")
SaveManager:SetFolder("FyyScriptHub/FishIT")
-- Buat semua tabs
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
Discord=Window:AddTab({Title="Webhook",Icon="megaphone"})
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
local PlayerSection=PlayerTab:AddSection(" [ Player Feature ] ")
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

PlayerSection:AddSpace({ Height = 20 }) -- Contoh penggunaan Space: Memberikan jarak 20px

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
local GuiSection=PlayerTab:AddSection(" [ Gui External ] ")
GuiSection:AddButton({Title="Fly GUI",Description="Load Fly GUI",Callback=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
Fluent:Notify({Title="Fly",Content="Fly GUI berhasil dijalankan",Duration=3})
end})
local SG,SL=nil,nil
local statsOverlayToggle=GuiSection:AddToggle("StatsOverlay",{Title="Show Stats Overlay",Description="Menampilkan FPS, CPU(ms), Ping, RAM. (Draggable)",Default=false})
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
f.Active=true
f.Selectable=true
Instance.new("UICorner",f).CornerRadius=UDim.new(1,0)
local s=Instance.new("UIStroke",f)
s.Color=Color3.fromHex("8B5CF6")
s.Thickness=2
s.Transparency=.1
s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

-- Drag Bar (below stats frame)
local dragBar=Instance.new("Frame")
dragBar.Name="DragBar"
dragBar.Size=UDim2.new(0.6,0,0,6)
dragBar.Position=UDim2.new(0.2,0,1,8)
dragBar.BackgroundColor3=Color3.fromRGB(45,45,50)
dragBar.BorderSizePixel=0
dragBar.Active=true
dragBar.Selectable=true
dragBar.Parent=f

local dragCorner=Instance.new("UICorner")
dragCorner.CornerRadius=UDim.new(1,0)
dragCorner.Parent=dragBar

local dragStroke=Instance.new("UIStroke")
dragStroke.Color=Color3.fromHex("8B5CF6")
dragStroke.Thickness=1
dragStroke.Parent=dragBar

dragBar.MouseEnter:Connect(function()
dragBar.BackgroundColor3=Color3.fromRGB(60,60,65)
end)
dragBar.MouseLeave:Connect(function()
dragBar.BackgroundColor3=Color3.fromRGB(45,45,50)
end)

-- Stats Content Container (to prevent layout affecting drag bar)
local container=Instance.new("Frame")
container.Name="StatsContainer"
container.Size=UDim2.new(1,0,1,0)
container.BackgroundTransparency=1
container.Parent=f

-- UIListLayout in container, not in main frame
local l=Instance.new("UIListLayout",container)
l.FillDirection=Enum.FillDirection.Horizontal
l.Padding=UDim.new(0,12)
l.HorizontalAlignment=Enum.HorizontalAlignment.Center
l.VerticalAlignment=Enum.VerticalAlignment.Center

local function L()
local t=Instance.new("TextLabel",container)
t.AutomaticSize=Enum.AutomaticSize.X
t.Size=UDim2.new(0,0,1,0)
t.BackgroundTransparency=1
t.Font=Enum.Font.GothamBold
t.TextSize=13
t.TextColor3=Color3.fromRGB(255,255,255)
t.Text="..."
return t
end

-- Drag Functionality
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local dragging=false
local dragInput,dragStart,startPos
local dragActionName="StatsDragBlocker"

local function update(input)
local delta=input.Position-dragStart
f.Position=UDim2.new(
startPos.X.Scale,
startPos.X.Offset+delta.X,
startPos.Y.Scale,
startPos.Y.Offset+delta.Y
)
end

local function startDrag(input)
dragging=true
dragStart=input.Position
startPos=f.Position

-- Block Camera Movement
CAS:BindActionAtPriority(dragActionName, function()
return Enum.ContextActionResult.Sink
end, false, Enum.ContextActionPriority.High.Value+50, Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseMovement)

input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
dragging=false
CAS:UnbindAction(dragActionName)
end
end)
end

local function connectDragArea(guiObject)
guiObject.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or 
   input.UserInputType==Enum.UserInputType.Touch then
startDrag(input)
end
end)

guiObject.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or
   input.UserInputType==Enum.UserInputType.Touch then
dragInput=input
end
end)
end

connectDragArea(f)
connectDragArea(dragBar)

UIS.InputChanged:Connect(function(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or 
                 input.UserInputType==Enum.UserInputType.Touch) then
update(input)
end
end)

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
local instantSection=Auto:AddSection(" [ Instant Fishing ] ")
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

local blatantSection1=Auto:AddSection(" [ Blatant V1 ] ")
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

local blatantSection2=Auto:AddSection(" [ Blatant V2 ] ")
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

local blatantSection3=Auto:AddSection(" [ Blatant V3 (BETA) ] ")
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
local function fishingLoop()while active do local t=tick()safe(function()RFC:InvokeServer({[1]=t})end)task.wait(CD)local r=tick()safe(function()RFS:InvokeServer(1,0,r)end)casts+=1 local t2=tick()safe(function()RFC:InvokeServer({[1]=t2})end)task.wait(CD)local r2=tick()safe(function()RFS:InvokeServer(1,0,r2)end)casts+=1 task.wait(FD)safe(function()REF:FireServer()end)task.wait(KD)safe(function()RFK:InvokeServer()end)task.wait(0.001)end end
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



local favoriteSection = Auto:AddSection(" [ Auto Favorite Feature ] ")

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
local ShopFeature = Shop:AddSection(" [ Purchase Fishing Rods ] ")

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

local bobers = Shop:AddSection(" [ Purchase Bobbers ] ")
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

local weatherShop=Shop:AddSection(" [ Purchase Weather ] ")
local sel={}
local on=false
local loop=nil

-- Helper function for Fluent Multi Dropdown
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

local weatherOptions = {"Wind (10000)","Cloudy (20000)","Snow (15000)","Storm (35000)","Radiant (50000)","Shark Hunt (300000)"}
local defaultSelection = {"Wind (10000)","Cloudy (20000)","Storm (35000)"}

local selectWeatherDropdown=weatherShop:AddDropdown("weatherSelect",{
 Title="Select Weather",
 Values=weatherOptions,
 Default=defaultSelection, 
 Multi=true
})

-- Initialize sel with default array
sel = defaultSelection

selectWeatherDropdown:OnChanged(function(v)
    sel = convertFluentTableToArray(v)
end)

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
 if w then 
    pcall(function() RF:InvokeServer(w) end)
 end
end

local function processPurchase()
    for _, name in ipairs(sel) do
        buy(name)
    end
end

weatherShop:AddButton({
 Title="Purchase Weather",
 Callback=function()
  processPurchase()
 end
})

local autoBuyWeatherToggle=weatherShop:AddToggle("autoBuyWeather",{
 Title="Auto Buy Weather",
 Default=false
})

autoBuyWeatherToggle:OnChanged(function(s)
 on=s
 if s then
  if loop then task.cancel(loop) end
  loop=task.spawn(function()
   while on do
    processPurchase()
    task.wait(2)
   end
  end)
 else
  if loop then task.cancel(loop) loop=nil end
 end
end)
end

local function TeleportTab()
    if not Teleport then return end
local Teleport1=Teleport:AddSection(" [ Teleport Players ] ")

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

local Teleport2=Teleport:AddSection(" [ Teleport Location ] ")

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
    ["Pirate Cove"] = CFrame.new(3471, -282, 3470),
    ["Crystal Depths"] = CFrame.new(5682, -890, 15430),
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
    "Diamond Artifact", "Pirate Cove", "Crystal Cove", "Ancient Ruin", "Pirate Island", "Pirate Treasure Room"
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


local Teleport3=Teleport:AddSection(" [ Teleport To Game Event ] ")

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

local Teleport4=Teleport:AddSection(" [ Teleport To NPC ] ")

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
    
    local Totemtot = Totem:AddSection(" [ Totem Features ] ")
    
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


--// Auto Quest


local function QuestTab()
    if not Quest then return end
    
    local deepsea = Quest:AddSection(" [ Deep Sea Event ] ")
    local DeepSeaParagraph = deepsea:AddParagraph({Title="Deep Sea Monitor", Content="Initializing...", Icon="waves"})
    
    local runningDeepSea = false
    local deepSeaThread = nil
    
    local TREASURE_ROOM_CF = CFrame.new(-3650.4873, -269.269318, -1652.68323, -0.147814155, 0, -0.989015162, 0, 1, 0, 0.989015162, 0, -0.147814155)
    local SISYPHUS_CF = CFrame.new(-3737, -136, -881)
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Replion=require(ReplicatedStorage.Packages.Replion)
local ClientData = nil
task.spawn(function()
    ClientData = Replion.Client:WaitReplion("Data")
end)

local function GetDeepSeaStatus()
    if not ClientData then return {QuestCompleted=false,QuestActive=false,Progress=nil,HasGhostfinRod=false} end
    local result = {QuestCompleted=false,QuestActive=false,Progress=nil,HasGhostfinRod=false}
local completedQuests=ClientData:Get({"CompletedQuests"})or{}
for _,questName in ipairs(completedQuests)do
if questName=="Deep Sea Quest"then result.QuestCompleted=true end
end
local inventory=ClientData:Get({"Inventory"})
if inventory and inventory["Fishing Rods"]then
for _,rod in ipairs(inventory["Fishing Rods"])do
if rod.Id==169 then result.HasGhostfinRod=true break end
end
end
if not result.QuestCompleted then
local questData=ClientData:Get({"Quests","Mainline","Deep Sea Quest"})
if questData then
result.QuestActive=true
result.Progress={Q1={Progress=0,Done=false},Q2={Progress=0,Done=false},Q3={Progress=0,Done=false},Q4={Progress=0,Done=false},TotalPercent=0,AllDone=false}
for objId,objData in pairs(questData.Objectives)do
local numId=tonumber(objId)
local progress=objData.Progress or 0
if numId==1 then
result.Progress.Q1.Progress=progress
result.Progress.Q1.Done=progress>=300
elseif numId==2 then
result.Progress.Q2.Progress=progress
result.Progress.Q2.Done=progress>=3
elseif numId==3 then
result.Progress.Q3.Progress=progress
result.Progress.Q3.Done=progress>=1
elseif numId==4 then
result.Progress.Q4.Progress=progress
result.Progress.Q4.Done=progress>=1000000
end
end
local completedCount=0
local totalObjectives=4
if result.Progress.Q1.Done then completedCount=completedCount+1 end
if result.Progress.Q2.Done then completedCount=completedCount+1 end
if result.Progress.Q3.Done then completedCount=completedCount+1 end
if result.Progress.Q4.Done then completedCount=completedCount+1 end
result.Progress.AllDone=(completedCount==totalObjectives)
result.Progress.TotalPercent=math.floor((completedCount/totalObjectives)*100)
end
end
return result
end
local function TeleportTo(cf)
local p=game.Players.LocalPlayer
local c=p.Character
local h=c and c:FindFirstChild("HumanoidRootPart")
if h then
task.wait(0.1)
h.CFrame=cf
task.wait(0.3)
end
end
local function IsFar(cf,dist)
local c=game.Players.LocalPlayer.Character
local h=c and c:FindFirstChild("HumanoidRootPart")
return not h or(h.Position-cf.Position).Magnitude>dist
end
local function RunDeepSea()
if deepSeaThread then task.cancel(deepSeaThread)end
deepSeaThread=task.spawn(function()
local lastDisplayUpdate=0
while runningDeepSea do
local status=GetDeepSeaStatus()
if tick()-lastDisplayUpdate>1 then
if status.QuestCompleted then
DeepSeaParagraph:SetTitle("DEEP SEA COMPLETED")
if status.HasGhostfinRod then
DeepSeaParagraph:SetDesc("Quest selesai! Ghostfin Rod sudah didapat.")
else
DeepSeaParagraph:SetDesc("Quest selesai! Ambil Ghostfin Rod di altar.")
end
elseif status.QuestActive then
DeepSeaParagraph:SetTitle(string.format("Deep Sea Quest [%d%%]",status.Progress.TotalPercent))
local displayText=""
displayText = displayText .. (status.Progress.Q1.Done and "Done " or "Not Done ") .. string.format("| Rare/Epic: %d/300", status.Progress.Q1.Progress) .. "\n"
displayText = displayText .. (status.Progress.Q2.Done and "Done " or "Not Done ") .. string.format("| Mythic: %d/3", status.Progress.Q2.Progress) .. "\n"
displayText = displayText .. (status.Progress.Q3.Done and "Done " or "Not Done ") .. string.format("| Secret: %d/1", status.Progress.Q3.Progress) .. "\n"
displayText = displayText .. (status.Progress.Q4.Done and "Done " or "Not Done ") .. string.format("| Coins: %s/1M", tostring(status.Progress.Q4.Progress))
DeepSeaParagraph:SetDesc(displayText)
else
DeepSeaParagraph:SetTitle("DEEP SEA NOT STARTED")
DeepSeaParagraph:SetDesc("Quest belum pernah dimulai. Pergi ke Deep Sea area untuk memulai.")
end
lastDisplayUpdate=tick()
end
if status.QuestCompleted then
DeepSeaParagraph:SetTitle("QUEST COMPLETED")
DeepSeaParagraph:SetDesc("Deep Sea Quest sudah selesai! Toggle dimatikan.")
runningDeepSea=false
if DeepSeaToggle then DeepSeaToggle:Set(false)end
break
elseif not status.QuestActive then
DeepSeaParagraph:SetTitle("QUEST NOT STARTED")
DeepSeaParagraph:SetDesc("Pergi ke area Deep Sea untuk memulai quest.")
elseif status.QuestActive and status.Progress.AllDone then
DeepSeaParagraph:SetTitle("QUEST OBJECTIVES DONE!")
DeepSeaParagraph:SetDesc("Semua objective selesai! Kembali ke altar untuk claim.")
runningDeepSea=false
if DeepSeaToggle then DeepSeaToggle:Set(false)end
break
end
if status.QuestActive then
local targetCF=nil
if not status.Progress.Q1.Done then
targetCF=TREASURE_ROOM_CF
elseif not status.Progress.Q2.Done or not status.Progress.Q3.Done then
targetCF=SISYPHUS_CF
elseif not status.Progress.Q4.Done then
targetCF=SISYPHUS_CF
end
if targetCF and IsFar(targetCF,20)then
TeleportTo(targetCF)
task.wait(1.5)
end
end
task.wait(1)
end
if not runningDeepSea then DeepSeaParagraph:SetDesc("Stopped")end
deepSeaThread=nil
end)
end
    local DeepSeaToggle = deepsea:AddToggle("autoDeepSea", {
        Title = "Auto Complete Deep Sea",
        Description = "One-time quest: Farm Ghostfin Rod",
        Default = false
    })
    
    DeepSeaToggle:OnChanged(function(s)
        runningDeepSea = s
        if s then
            DeepSeaParagraph:SetDesc("Checking Deep Sea status...")
            task.wait(0.5)
            local status = GetDeepSeaStatus()
            
            if status.QuestCompleted then
                DeepSeaParagraph:SetTitle("QUEST ALREADY COMPLETED")
                DeepSeaParagraph:SetDesc("Deep Sea Quest sudah selesai. Toggle dimatikan.")
                runningDeepSea = false
                if DeepSeaToggle.Value then DeepSeaToggle:SetValue(false) end
                return
            elseif not status.QuestActive then
                DeepSeaParagraph:SetTitle("QUEST NOT STARTED")
                DeepSeaParagraph:SetDesc("Pergi ke area Deep Sea untuk memulai quest.")
                DeepSeaParagraph:SetDesc("Starting automation...")
                RunDeepSea()
            elseif status.QuestActive and status.Progress.AllDone then
                DeepSeaParagraph:SetTitle("READY TO CLAIM")
                DeepSeaParagraph:SetDesc("Semua objective selesai! Kembali ke altar.")
                runningDeepSea = false
                if DeepSeaToggle.Value then DeepSeaToggle:SetValue(false) end
                return
            else
                DeepSeaParagraph:SetDesc("Starting automation...")
                RunDeepSea()
            end
        else
            if deepSeaThread then task.cancel(deepSeaThread) deepSeaThread = nil end
            DeepSeaParagraph:SetDesc("Stopped")
        end
    end)
    
    local element = Quest:AddSection(" [ Element Quest Beta ] ")
    local ElementParagraph = element:AddParagraph({Title="Element Quest Monitor", Content="Initializing...", Icon="swords"})
local runningElement=false
local elementThread=nil
local ALTAR_CF=CFrame.new(1479.587,128.295,-604.224)
local JUNGLE_CF=CFrame.new(1535.639,3.159,-193.352,0.505,-0.000,0.863,0.000,1.000,0.000,-0.863,0.000,0.505)
local TEMPLE_CF=CFrame.new(1461.815,-22.125,-670.234,-0.990,-0.000,0.143,0.000,1.000,0.000,-0.143,0.000,-0.990)
local function GetElementQuestStatus()
    if not ClientData then return {QuestCompleted=false, QuestActive=false, DeepSeaCompleted=false, HasGhostfinRod=false, Progress=nil, CanStartElement=false} end
    local result = {QuestCompleted=false, QuestActive=false, DeepSeaCompleted=false, HasGhostfinRod=false, Progress=nil, CanStartElement=false}
local completedQuests=ClientData:Get({"CompletedQuests"})or{}
for _,questName in ipairs(completedQuests)do
if questName=="Deep Sea Quest"then result.DeepSeaCompleted=true end
if questName=="Element Quest"then result.QuestCompleted=true end
end
local inventory=ClientData:Get({"Inventory"})
if inventory and inventory["Fishing Rods"]then
for _,rod in ipairs(inventory["Fishing Rods"])do
if rod.Id==169 then result.HasGhostfinRod=true break end
end
end
result.CanStartElement=result.DeepSeaCompleted or result.HasGhostfinRod
if not result.QuestCompleted then
local questData=ClientData:Get({"Quests","Mainline","Element Quest"})
if questData then
result.QuestActive=true
    result.Progress = {
        Q1 = {Done=true, Text="Ghostfin Rod: Done"},
        Q2 = {Progress=0, Done=false, Text="Jungle Secret: Not Done"},
        Q3 = {Progress=0, Done=false, Text="Temple Secret: Not Done"},
        Q4 = {Progress=0, Done=false, Text="Transcended Stones: 0/3"},
        TotalPercent = 0, 
        AllDone = false
    }
    for objId, objData in pairs(questData.Objectives) do
        local numId = tonumber(objId)
        local progress = objData.Progress or 0
        if numId == 2 then
            result.Progress.Q2.Progress = progress
            result.Progress.Q2.Done = progress >= 1
            result.Progress.Q2.Text = result.Progress.Q2.Done and "Jungle Secret: Done" or "Jungle Secret: Not Done"
        elseif numId == 3 then
            result.Progress.Q3.Progress = progress
            result.Progress.Q3.Done = progress >= 1
            result.Progress.Q3.Text = result.Progress.Q3.Done and "Temple Secret: Done" or "Temple Secret: Not Done"
        elseif numId == 4 then
            result.Progress.Q4.Progress = progress
            result.Progress.Q4.Done = progress >= 3
            result.Progress.Q4.Text = string.format("Transcended Stones: %d/3", progress)
        end
    end
    result.Progress.Q1.Done = result.CanStartElement
    result.Progress.Q1.Text = result.CanStartElement and "Ghostfin Rod: Done" or "Ghostfin Rod: Not Done"
local completedCount=0
if result.Progress.Q1.Done then completedCount=completedCount+1 end
if result.Progress.Q2.Done then completedCount=completedCount+1 end
if result.Progress.Q3.Done then completedCount=completedCount+1 end
if result.Progress.Q4.Done then completedCount=completedCount+1 end
result.Progress.AllDone=(completedCount==4)
result.Progress.TotalPercent=math.floor((completedCount/4)*100)
end
end
return result
end
local function RunElementQuest()
if elementThread then task.cancel(elementThread)end
elementThread=task.spawn(function()
local lastDisplayUpdate=0
while runningElement do
local status=GetElementQuestStatus()
if tick()-lastDisplayUpdate>1 then
if status.QuestCompleted then
ElementParagraph:SetTitle("ELEMENT QUEST COMPLETE")
ElementParagraph:SetDesc("Quest sudah selesai! Element Rod sudah didapat.")
elseif not status.CanStartElement then
ElementParagraph:SetTitle("CAN'T START ELEMENT QUEST")
ElementParagraph:SetDesc("Butuh: Deep Sea Quest selesai ATAU punya Ghostfin Rod")
elseif status.QuestActive then
ElementParagraph:SetTitle(string.format("Element Quest [%d%%]",status.Progress.TotalPercent))
local displayText=""
displayText=displayText..status.Progress.Q1.Text.."\n"
displayText=displayText..status.Progress.Q2.Text.."\n"
displayText=displayText..status.Progress.Q3.Text.."\n"
displayText=displayText..status.Progress.Q4.Text
ElementParagraph:SetDesc(displayText)
else
ElementParagraph:SetTitle("READY TO START")
if status.DeepSeaCompleted then
    ElementParagraph:SetDesc("Deep Sea Quest selesai | Pergi ke altar untuk mulai Element Quest")
elseif status.HasGhostfinRod then
    ElementParagraph:SetDesc("Sudah punya Ghostfin Rod | Pergi ke altar untuk mulai Element Quest")
end
end
lastDisplayUpdate=tick()
end
if status.QuestCompleted then
ElementParagraph:SetTitle("QUEST COMPLETED")
ElementParagraph:SetDesc("Element Quest sudah selesai! Toggle dimatikan otomatis.")
runningElement=false
if ElementToggle then ElementToggle:Set(false)end
break
elseif not status.CanStartElement then
ElementParagraph:SetTitle("CAN'T START ELEMENT")
ElementParagraph:SetDesc("Selesaikan Deep Sea Quest dulu atau dapatkan Ghostfin Rod")
runningElement=false
if ElementToggle then ElementToggle:Set(false)end
break
elseif not status.QuestActive then
ElementParagraph:SetTitle("GO TO ALTAR")
ElementParagraph:SetDesc("Teleporting to altar to start Element Quest...")
if IsFar(ALTAR_CF,20)then
TeleportTo(ALTAR_CF)
task.wait(2)
end
task.wait(2)
continue
elseif status.QuestActive and status.Progress.AllDone then
ElementParagraph:SetTitle("ELEMENT QUEST DONE!")
ElementParagraph:SetDesc("Semua objective selesai! Kembali ke altar untuk claim Element Rod.")
runningElement=false
if ElementToggle then ElementToggle:Set(false)end
break
end
if status.QuestActive then
local targetCF=nil
if not status.Progress.Q2.Done then
targetCF=JUNGLE_CF
elseif not status.Progress.Q3.Done then
targetCF=TEMPLE_CF
elseif not status.Progress.Q4.Done then
targetCF=ALTAR_CF
end
if targetCF and IsFar(targetCF,20)then
TeleportTo(targetCF)
task.wait(1.5)
end
end
task.wait(2)
end
if not runningElement then ElementParagraph:SetDesc("Stopped") end
elementThread=nil
end)
end
    local ElementToggle = element:AddToggle("autoElement", {
        Title = "Auto Track Element Quest",
        Description = "Requires: Deep Sea completed OR Ghostfin Rod",
        Default = false
    })
    
    ElementToggle:OnChanged(function(s)
        runningElement = s
        if s then
            ElementParagraph:SetDesc("Checking Element Quest status...")
            task.wait(0.5)
            local status = GetElementQuestStatus()
            
            if status.QuestCompleted then
                ElementParagraph:SetTitle("QUEST ALREADY COMPLETED")
                ElementParagraph:SetDesc("Element Quest sudah selesai sebelumnya. Toggle dimatikan otomatis.")
                runningElement = false
                if ElementToggle.Value then ElementToggle:SetValue(false) end
                return
            elseif not status.CanStartElement then
                ElementParagraph:SetTitle("CAN'T START ELEMENT QUEST")
                ElementParagraph:SetDesc(string.format("Butuh:\n- Deep Sea Quest selesai: %s\n- Punya Ghostfin Rod: %s", status.DeepSeaCompleted and "Yes" or "No", status.HasGhostfinRod and "Yes" or "No"))
                runningElement = false
                if ElementToggle.Value then ElementToggle:SetValue(false) end
                return
            elseif not status.QuestActive then
                ElementParagraph:SetTitle("READY TO START")
                if status.DeepSeaCompleted then
                    ElementParagraph:SetDesc("Deep Sea Quest selesai | Pergi ke altar untuk mulai")
                elseif status.HasGhostfinRod then
                    ElementParagraph:SetDesc("Sudah punya Ghostfin Rod | Pergi ke altar untuk mulai")
                end
            elseif status.QuestActive and status.Progress.AllDone then
                ElementParagraph:SetTitle("READY TO CLAIM")
                ElementParagraph:SetDesc("Semua objective selesai! Kembali ke altar untuk claim Element Rod.")
                runningElement = false
                if ElementToggle.Value then ElementToggle:SetValue(false) end
                return
            end
            ElementParagraph:SetDesc("Starting automation...")
            RunElementQuest()
        else
            if elementThread then task.cancel(elementThread) elementThread = nil end
            ElementParagraph:SetDesc("Stopped")
        end
    end)
    
    local diamond = Quest:AddSection(" [ Diamond Quest Beta ] ")
    local DiamondParagraph = diamond:AddParagraph({Title="Diamond Quest Monitor", Content="Initializing...", Icon="gem"})
local runningDiamond=false
local diamondThread=nil
local CORAL_REEFS_CF=CFrame.new(-3020,3,2260)
local TROPICAL_GROVE_CF=CFrame.new(-2150,53,3672)
local RUBY_FARM_CF=CFrame.new(-3595,-279,-1589)
local LOCHNESS_FARM_CF=CFrame.new(-712,6,707)
local DIAMOND_ROD_ID=559
local ELEMENT_ROD_ID=257
local RUBY_ID=243
local LOCHNESS_ID=228
local ItemUtility=require(ReplicatedStorage.Shared.ItemUtility)

local function GetDiamondQuestStatus()
    if not ClientData then return {HasElementRod=false, HasDiamondRod=false, HasDiamondKey=false, InventoryCheck={HasRuby=false, HasLochness=false}, Progress={}} end
    local result = {HasElementRod=false, HasDiamondRod=false, HasDiamondKey=false, InventoryCheck={HasRuby=false, HasLochness=false}, Progress={}}
local inventory=ClientData:Get({"Inventory"})or{}
if inventory["Fishing Rods"]then
for _,rod in ipairs(inventory["Fishing Rods"])do
if tonumber(rod.Id)==ELEMENT_ROD_ID then result.HasElementRod=true end
if tonumber(rod.Id)==DIAMOND_ROD_ID then result.HasDiamondRod=true end
end
end
if inventory.Items then
for _,item in ipairs(inventory.Items)do
local itemData=ItemUtility:GetItemData(item.Id)
if itemData and itemData.Data then
if itemData.Data.Name=="Diamond Key"then result.HasDiamondKey=true end
end
if tonumber(item.Id)==RUBY_ID then
local metadata=item.Metadata or{}
if metadata.VariantId==3 then result.InventoryCheck.HasRuby=true end
elseif tonumber(item.Id)==LOCHNESS_ID then
result.InventoryCheck.HasLochness=true
end
end
end
local questData=ClientData:Get({"Quests","Mainline","Diamond Rod Quest"})
result.Progress.Q1 = {Done=result.HasElementRod, Text=result.HasElementRod and "Element Rod: Done" or "Element Rod: Not Done"}
result.Progress.Q2 = {Progress=0, Done=false, Text="Coral Secret: Not Done"}
result.Progress.Q3 = {Progress=0, Done=false, Text="Tropical Secret: Not Done"}
result.Progress.Q4 = {Done=result.InventoryCheck.HasLochness, Text=result.InventoryCheck.HasLochness and "Lochness Monster: Done" or "Lochness Monster: Not Done"}
result.Progress.Q5 = {Done=result.InventoryCheck.HasRuby, Text=result.InventoryCheck.HasRuby and "Mutated Ruby: Done" or "Mutated Ruby: Not Done"}
result.Progress.Q6={Progress=0,Done=false,Text="Perfect Throws: 0/1000"}
result.Progress.AllDone=false
result.Progress.TotalPercent=0
if questData then
for objId,objData in pairs(questData.Objectives)do
local numId=tonumber(objId)
local progress=objData.Progress or 0
    if numId == 2 then
        result.Progress.Q2.Progress = progress
        result.Progress.Q2.Done = progress >= 1
        result.Progress.Q2.Text = result.Progress.Q2.Done and "Coral Secret: Done" or string.format("Coral Secret: %d/1", progress)
    elseif numId == 3 then
        result.Progress.Q3.Progress = progress
        result.Progress.Q3.Done = progress >= 1
        result.Progress.Q3.Text = result.Progress.Q3.Done and "Tropical Secret: Done" or string.format("Tropical Secret: %d/1", progress)
elseif numId==6 then
result.Progress.Q6.Progress=progress
result.Progress.Q6.Done=progress>=1000
result.Progress.Q6.Text=string.format("Perfect Throws: %d/1000",progress)
end
end
end
local completedCount=0
if result.Progress.Q1.Done then completedCount=completedCount+1 end
if result.Progress.Q2.Done then completedCount=completedCount+1 end
if result.Progress.Q3.Done then completedCount=completedCount+1 end
if result.Progress.Q4.Done then completedCount=completedCount+1 end
if result.Progress.Q5.Done then completedCount=completedCount+1 end
if result.Progress.Q6.Done then completedCount=completedCount+1 end
result.Progress.AllDone=(completedCount==6)
result.Progress.TotalPercent=math.floor((completedCount/6)*100)
return result
end

local function GetClaimRemote()
local packages=game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local index=packages:WaitForChild("_Index")
for _,child in pairs(index:GetChildren())do
if child.Name:find("net@")then
local net=child:FindFirstChild("net")
if net then
local remote=net:FindFirstChild("RF/ClaimItem")
if remote then return remote end
end
end
end
return nil
end

local function ClaimDiamondRod()
local claimRemote=GetClaimRemote()
if claimRemote then
local success,result=pcall(function()return claimRemote:InvokeServer("Diamond Rod")end)
if success then
task.wait(1)
return true, "Successfully claimed Diamond Rod!"
else
return false, "Failed to claim Diamond Rod: " .. tostring(result)
end
end
return false, "Claim remote not found"
end

local function RunDiamondQuest()
if diamondThread then task.cancel(diamondThread)end
diamondThread=task.spawn(function()
local lastDisplayUpdate=0
while runningDiamond do
local status=GetDiamondQuestStatus()
if tick()-lastDisplayUpdate>1 then
if status.HasDiamondRod then
DiamondParagraph:SetTitle("DIAMOND ROD OBTAINED")
DiamondParagraph:SetDesc("Diamond Rod sudah didapat! Quest fully completed.")
elseif status.Progress.AllDone and status.HasDiamondKey then
DiamondParagraph:SetTitle("CLAIM DIAMOND ROD")
DiamondParagraph:SetDesc("Semua objective selesai & punya Diamond Key! Auto claim...")
elseif status.Progress.AllDone and not status.HasDiamondKey then
DiamondParagraph:SetTitle("GET DIAMOND KEY")
DiamondParagraph:SetDesc("Semua objective selesai! Pergi ke Lary untuk dapat Diamond Key.")
elseif not status.HasElementRod then
DiamondParagraph:SetTitle("NEED ELEMENT ROD")
DiamondParagraph:SetDesc("Butuh Element Rod untuk mulai Diamond Quest.")
else
DiamondParagraph:SetTitle(string.format("Diamond Quest [%d%%]",status.Progress.TotalPercent))
local displayText=""
displayText=displayText..status.Progress.Q1.Text.."\n"
displayText=displayText..status.Progress.Q2.Text.."\n"
displayText=displayText..status.Progress.Q3.Text.."\n"
displayText=displayText..status.Progress.Q4.Text.."\n"
displayText=displayText..status.Progress.Q5.Text.."\n"
displayText=displayText..status.Progress.Q6.Text
DiamondParagraph:SetDesc(displayText)
end
lastDisplayUpdate=tick()
end

if status.HasDiamondRod then
DiamondParagraph:SetTitle("DIAMOND ROD OBTAINED")
DiamondParagraph:SetDesc("Diamond Rod sudah didapat! Toggle dimatikan otomatis.")
runningDiamond=false
if DiamondToggle then DiamondToggle:Set(false)end
break
end

if status.Progress.AllDone and status.HasDiamondKey then
DiamondParagraph:SetTitle("CLAIMING DIAMOND ROD...")
DiamondParagraph:SetDesc("Claiming Diamond Rod via remote...")
local success,message=ClaimDiamondRod()
if success then
DiamondParagraph:SetTitle("DIAMOND ROD CLAIMED")
DiamondParagraph:SetDesc(message)
task.wait(2)
continue
else
DiamondParagraph:SetTitle("CLAIM FAILED")
DiamondParagraph:SetDesc(message)
task.wait(3)
end
end

if not status.HasElementRod then
DiamondParagraph:SetTitle("NEED ELEMENT ROD FIRST")
DiamondParagraph:SetDesc("Selesaikan Element Quest dulu! Toggle dimatikan otomatis.")
runningDiamond=false
if DiamondToggle then DiamondToggle:Set(false)end
break
end

if status.Progress.AllDone and not status.HasDiamondKey then
DiamondParagraph:SetTitle("GO TO LARY FOR KEY")
DiamondParagraph:SetDesc("Semua objective selesai! Pergi ke Lary untuk claim Diamond Key.")
task.wait(3)
continue
end

local targetCF=nil
if not status.Progress.Q2.Done then
targetCF=CORAL_REEFS_CF
elseif not status.Progress.Q3.Done then
targetCF=TROPICAL_GROVE_CF
elseif not status.Progress.Q4.Done and not status.InventoryCheck.HasLochness then
targetCF=LOCHNESS_FARM_CF
elseif not status.Progress.Q5.Done and not status.InventoryCheck.HasRuby then
targetCF=RUBY_FARM_CF
elseif not status.Progress.Q6.Done then
targetCF=TROPICAL_GROVE_CF
end

if targetCF and IsFar(targetCF,20)then
TeleportTo(targetCF)
task.wait(1.5)
end

task.wait(2)
end

if not runningDiamond then DiamondParagraph:SetDesc("Stopped") end
diamondThread=nil
end)
end

    local DiamondToggle = diamond:AddToggle("autoDiamond", {
        Title = "Auto Complete Diamond Quest",
        Description = "Farm → Get Diamond Key → Claim Diamond Rod",
        Default = false
    })
    
    DiamondToggle:OnChanged(function(s)
        runningDiamond = s
        if s then
            DiamondParagraph:SetDesc("Checking Diamond Quest status...")
            task.wait(0.5)
            local status = GetDiamondQuestStatus()
            
            if status.HasDiamondRod then
                DiamondParagraph:SetTitle("ALREADY HAVE DIAMOND ROD")
                DiamondParagraph:SetDesc("Sudah punya Diamond Rod")
                runningDiamond = false
                if DiamondToggle.Value then DiamondToggle:SetValue(false) end
                return
            elseif status.Progress.AllDone and status.HasDiamondKey then
                DiamondParagraph:SetTitle("READY TO CLAIM")
                DiamondParagraph:SetDesc("Semua objective selesai & punya Diamond Key! Script akan auto claim.")
            elseif not status.HasElementRod then
                DiamondParagraph:SetTitle("NEED ELEMENT ROD FIRST")
                DiamondParagraph:SetDesc("Butuh Element Rod (ID: 257) dulu! Toggle dimatikan otomatis.")
                runningDiamond = false
                if DiamondToggle.Value then DiamondToggle:SetValue(false) end
                return
            elseif status.Progress.AllDone and not status.HasDiamondKey then
                DiamondParagraph:SetTitle("GET DIAMOND KEY")
                DiamondParagraph:SetDesc("Semua objective selesai! Pergi ke Lary untuk claim Diamond Key.")
            else
                DiamondParagraph:SetTitle(string.format("Diamond Quest [%d%%]", status.Progress.TotalPercent))
                local displayText = ""
                displayText = displayText .. status.Progress.Q1.Text .. "\n"
                displayText = displayText .. status.Progress.Q2.Text .. "\n"
                displayText = displayText .. status.Progress.Q3.Text .. "\n"
                displayText = displayText .. status.Progress.Q4.Text .. "\n"
                displayText = displayText .. status.Progress.Q5.Text .. "\n"
                displayText = displayText .. status.Progress.Q6.Text
                DiamondParagraph:SetDesc(displayText)
            end
            DiamondParagraph:SetDesc("Starting automation...")
            RunDiamondQuest()
        else
            if diamondThread then task.cancel(diamondThread) diamondThread = nil end
            DiamondParagraph:SetDesc("Stopped")
        end
    end)
    
    --// AUTO DORIAN
    local dorian = Quest:AddSection(" [ Auto Quest Dorian ] ")
    local dorianRunning = false
    local dorianThread = nil
    
    local DorianToggle = dorian:AddToggle("autoDorian", {
        Title = "Auto Dorian Quest (Coral)",
        Description = "Start Quest -> Collect 30 Coral -> Finish Quest",
        Default = false
    })
    
    DorianToggle:OnChanged(function(s)
        dorianRunning = s
        if s then
            dorianThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Net = ReplicatedStorage:WaitForChild("Packages", 10)
                if Net then Net = Net:WaitForChild("_Index", 5) end
                if Net then Net = Net:WaitForChild("sleitnick_net@0.2.0", 5) end
                if Net then Net = Net:WaitForChild("net", 5) end
                
                if not Net then
                     Fluent:Notify({Title="Error", Content="Net remote folder not found!", Duration=5})
                     DorianToggle:SetValue(false)
                     return
                end

                local RE_DialogueEnded = Net:FindFirstChild("RE/DialogueEnded")
                local RE_SearchItemPickedUp = Net:FindFirstChild("RE/SearchItemPickedUp")
                
                if not RE_DialogueEnded or not RE_SearchItemPickedUp then
                     Fluent:Notify({Title="Error", Content="Required remotes not found!", Duration=5})
                     DorianToggle:SetValue(false)
                     return
                end
                
                Fluent:Notify({Title="Dorian Quest", Content="Starting Quest...", Duration=3})
                
                -- Step 1: Start Dialogue
                pcall(function() RE_DialogueEnded:FireServer("Dorian", 1, 1) end)
                task.wait(1)
                
                -- Step 2: Collect Coral 33x
                if dorianRunning then
                    Fluent:Notify({Title="Dorian Quest", Content="Collecting 30 Coral...", Duration=3})
                    for i = 1, 33 do
                        if not dorianRunning then break end
                        pcall(function() RE_SearchItemPickedUp:FireServer("Coral") end)
                    end
                end
                
                task.wait(1)
                
                -- Step 3: Finish Dialogue
                if dorianRunning then
                    Fluent:Notify({Title="Dorian Quest", Content="Finishing Quest...", Duration=3})
                    pcall(function() RE_DialogueEnded:FireServer("Dorian", 1, 2) end)
                end
                
                if dorianRunning then
                     Fluent:Notify({Title="Dorian Quest", Content="Completed! Script Finished.", Duration=3})
                end
                
                -- Auto Turn Off
                dorianRunning = false
                DorianToggle:SetValue(false)
            end)
        else
            if dorianThread then task.cancel(dorianThread) dorianThread = nil end
            dorianRunning = false
        end
    end)
    
    --// AUTO QUEST HANK
    local hankSection = Quest:AddSection(" [ Auto Quest Hank (Pickaxe) ] ")
    local HankStatus = hankSection:AddParagraph({Title="Status", Content="Idle", Icon="book-open"})
    local hankRunning = false
    local hankThread = nil
    
    local function HasHanksDiary()
        local r = ClientData 
        if not r then return false end 
        local s, i = pcall(function() return r:GetExpect("Inventory") end)
        if not s or not i or not i.Items then return false end 
        
        for _, it in ipairs(i.Items) do 
            -- ID 20222 based on user decompiled code, checking name too just in case
            if it.Id == 20222 or (it.Name and string.find(it.Name, "Hank's Diary")) then 
                return true 
            end 
        end 
        return false 
    end

    local HankToggle = hankSection:AddToggle("autoHank", {
        Title = "Auto Complete Hank Quest",
        Description = "Claim Quest → Fish Diary (Crystal Depths) → Turn In",
        Default = false
    })
    
    HankToggle:OnChanged(function(s)
        hankRunning = s
        if s then
            hankThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
                local RE_DialogueEnded = Net:WaitForChild("RE/DialogueEnded")
                local RE_Obtained = Net:FindFirstChild("RE/ObtainedNewFishNotification")
                
                -- Instant Fish Remotes
                local RFC = Net:WaitForChild("RF/ChargeFishingRod")
                local RFS = Net:WaitForChild("RF/RequestFishingMinigameStarted")
                local REF = Net:WaitForChild("RE/FishingCompleted")
                local RFK = Net:WaitForChild("RF/CancelFishingInputs")
                local RE_Equip = Net:WaitForChild("RE/EquipToolFromHotbar")

                -- Listen for Diary Catch
                local catchListener
                if RE_Obtained then
                    catchListener = RE_Obtained.OnClientEvent:Connect(function(uiData)
                        if uiData and (uiData.Name == "Hank's Diary" or string.find(tostring(uiData.Name), "Diary")) then
                            HankStatus:SetDesc("Diary Caught! Stopping fishing...")
                        end
                    end)
                end

                -- Equip Rod Initially
                HankStatus:SetDesc("Equipping Rod...")
                RE_Equip:FireServer(1) 
                task.wait(0.5)

                -- Blatant V3 Logic Setup
                local CD, FD, KD = 0.45, 0.7, 0.3
                local function safe(f) task.spawn(function() pcall(f) end) end

                -- Equip/Unequip Remotes
                local RE_UnequipItem = Net:WaitForChild("RE/UnequipItem")
                local RE_EquipItem = Net:WaitForChild("RE/EquipItem")

                -- Helper: Unequip All
                local function UnequipAll()
                    local s, e = pcall(function() return ClientData:GetExpect("EquippedItems") end)
                    if s and e then
                        for _, u in ipairs(e) do
                            pcall(function() RE_UnequipItem:FireServer(u) end)
                            task.wait(0.05)
                        end
                    end
                end

                -- Helper: Get Diary UUID
                local function GetDiaryUUID()
                    local r = ClientData
                    if not r then return nil end
                    local s, i = pcall(function() return r:GetExpect("Inventory") end)
                    if s and i and i.Items then
                        for _, it in ipairs(i.Items) do 
                            if tonumber(it.Id) == 20222 and it.UUID then
                                return it.UUID 
                            end 
                        end
                    end
                    return nil
                end

                while hankRunning do
                    -- 1. Check if we already have the Diary
                    if HasHanksDiary() then
                        HankStatus:SetDesc("Diary Found! Preparing Turn-in...")
                        
                        -- Unequip All
                        UnequipAll()
                        task.wait(0.5)
                        
                        -- Equip Diary
                        local dUUID = GetDiaryUUID()
                        if dUUID then
                            HankStatus:SetDesc("Equipping Diary...")
                            pcall(function() RE_EquipItem:FireServer(dUUID, "Gears") end)
                            task.wait(0.5)
                        end
                        
                        -- Unequip Tool Hotbar (Stabilization)
                        local RE_UnequipHotbar = Net:FindFirstChild("RE/UnequipToolFromHotbar")
                        if RE_UnequipHotbar then 
                            pcall(function() RE_UnequipHotbar:FireServer() end) 
                            task.wait(0.5)
                        end
                        
                        -- Equip Slot 2
                        pcall(function() RE_Equip:FireServer(2) end)
                        task.wait(0.5)
                        
                        HankStatus:SetDesc("Turning in to Hank...")
                        RE_DialogueEnded:FireServer("Hank", 1, 3)
                        task.wait(0.5)
                        RE_DialogueEnded:FireServer("Hank", 1, 3) 
                        
                        if catchListener then catchListener:Disconnect() end
                        HankStatus:SetDesc("Quest Completed! Pickaxe Received.")
                        break
                    end
                    
                    -- Start Quest just in case
                    pcall(function() RE_DialogueEnded:FireServer("Hank", 1, 2) end)
                    
                    -- Teleport Check
                    local targetPos = CFrame.new(5682, -890, 15430)
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        if (char.HumanoidRootPart.Position - targetPos.Position).Magnitude > 20 then
                            HankStatus:SetDesc("Teleporting to Crystal Depths...")
                            char.HumanoidRootPart.CFrame = targetPos
                            task.wait(1)
                            RE_Equip:FireServer(1) -- Re-equip if teleported (just in case)
                            task.wait(0.5)
                        end
                    end
                    
                    if not hankRunning then break end

                    -- Blatant V3 Cycle (100% Match)
                    HankStatus:SetDesc("Fishing (Blatant V3 Async)...")
                    
                    local t = tick()
                    safe(function() RFC:InvokeServer({[1]=t}) end)
                    task.wait(CD)
                    local r = tick()
                    safe(function() RFS:InvokeServer(1,0,r) end)
                    
                    local t2 = tick()
                    safe(function() RFC:InvokeServer({[1]=t2}) end)
                    task.wait(CD)
                    local r2 = tick()
                    safe(function() RFS:InvokeServer(1,0,r2) end)
                    
                    task.wait(FD) 
                    if not hankRunning then break end
                    
                    safe(function() REF:FireServer() end)
                    safe(function() REF:FireServer() end)
                    
                    task.wait(KD)
                    safe(function() RFK:InvokeServer() end)
                    task.wait(0.001)
                end
                
                if catchListener then catchListener:Disconnect() end
                hankRunning = false
                HankToggle:SetValue(false)
            end)
        else
            if hankThread then task.cancel(hankThread) hankThread = nil end
            hankRunning = false
            HankStatus:SetDesc("Stopped")
        end
    end)

    --// AUTO QUEST ARCHAEOLOGIST
    local archSection = Quest:AddSection(" [ Auto Quest Archaeologist ] ")
    local ArchStatus = archSection:AddParagraph({Title="Status", Content="Idle", Icon="scroll"})
    local archRunning = false
    local archThread = nil

    local function IsArchQuestActive()
        local r = ClientData
        if not r then return false end
        local s, q = pcall(function() return r:GetExpect("ActiveQuests") end)
        if s and q then
            for _, v in pairs(q) do
                -- Broader check
                local n = tostring(v.Name or "")
                local d = tostring(v.Description or "")
                if string.find(n, "Leviathan's Scale") or string.find(d, "Leviathan's Scale") or v.NPC == "Archaeologist" then
                    return true
                end
            end
        end
        return false
    end

    local ArchToggle = archSection:AddToggle("autoArch", {
        Title = "Auto Archaeologist (Leviathan Scale)",
        Description = "Start Quest → Farm Objectives (Magma/Ocean/Essence + 200 Fish)",
        Default = false
    })

    ArchToggle:OnChanged(function(s)
        archRunning = s
        if s then
            archThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
                local RE_DialogueEnded = Net:WaitForChild("RE/DialogueEnded")
                local RE_Obtained = Net:FindFirstChild("RE/ObtainedNewFishNotification")
                
                -- Instant Fish Remotes
                local RFC = Net:WaitForChild("RF/ChargeFishingRod")
                local RFS = Net:WaitForChild("RF/RequestFishingMinigameStarted")
                local REF = Net:WaitForChild("RE/FishingCompleted")
                local RFK = Net:WaitForChild("RF/CancelFishingInputs")
                local RE_Equip = Net:WaitForChild("RE/EquipToolFromHotbar")

                -- Listen for Quest Items
                local catchListener
                if RE_Obtained then
                    catchListener = RE_Obtained.OnClientEvent:Connect(function(uiData)
                        local n = tostring(uiData.Name)
                        if n == "Magma Core" or n == "Leviathan Essence" or n == "Ocean Core" then
                            ArchStatus:SetDesc("Caught Quest Item: " .. n)
                        end
                    end)
                end

                -- 1. Try Start Quest
                ArchStatus:SetDesc("Starting Quest (Archaeologist)...")
                RE_DialogueEnded:FireServer("Archaeologist", 1, 3)
                
                -- Wait for Quest to Appear (Max 5s) with Retry
                local questActive = false
                for i = 1, 10 do
                    if IsArchQuestActive() then
                        questActive = true
                        break
                    end
                    task.wait(0.5)
                end

                -- 2. Validate Quest Started (Warning Only)
                if not questActive then
                     ArchStatus:SetDesc("Warning: Quest Status Unknown (Continuing...)")
                     Fluent:Notify({Title="Archaeologist", Content="Quest tidak terdeteksi list, tapi lanjut farming.", Duration=5})
                     -- Continue anyway
                end
                
                ArchStatus:SetDesc("Quest Active! Moving to Farm Spot...")

                -- Equip Rod Initially
                RE_Equip:FireServer(1) 
                task.wait(0.5)

                -- Blatant V3 Logic Setup
                local CD, FD, KD = 0.45, 0.7, 0.3
                local function safe(f) task.spawn(function() pcall(f) end) end

                -- Gate Remotes
                local RF_Consume = Net:WaitForChild("RF/ConsumeItem")
                local RE_ClaimRelic = Net:WaitForChild("RE/ClaimRelic")
                local RE_PlaceRelic = Net:WaitForChild("RE/PlaceLeviathanPressureItem")
                
                -- Detect Scale UUID
                local function GetLeviathanScaleUUID()
                    local r = ClientData
                    if not r then return nil end
                    local s, i = pcall(function() return r:GetExpect("Inventory") end)
                    if s and i and i.Items then
                        for _, it in ipairs(i.Items) do
                            if tonumber(it.Id) == 576 and it.UUID then return it.UUID end
                        end
                    end
                    return nil
                end
                
                -- Detect Relic UUID (Name + ID Fallback)
                local function GetRelicUUID(n, id)
                    local s, i = pcall(function() return ClientData:GetExpect("Inventory") end)
                    if s and i and i.Items then
                        for _, it in ipairs(i.Items) do
                            if (it.Name == n or tonumber(it.Id) == id) and it.UUID then return it.UUID end
                        end
                    end
                    return nil
                end

                while archRunning do
                    -- Check Completion (Reward Obtained)
                    local scaleUUID = GetLeviathanScaleUUID()
                    if scaleUUID then
                        ArchStatus:SetDesc("Leviathan Scale Found! Starting Gate Sequence...")
                        
                        -- 1. Consume Scale
                        ArchStatus:SetDesc("Consuming Leviathan Scale...")
                        pcall(function() RF_Consume:InvokeServer(scaleUUID) end)
                        task.wait(1.5)
                        
                        -- 2. Claim Relics
                        ArchStatus:SetDesc("Claiming Relics...")
                        RE_ClaimRelic:FireServer("Sunken Eye Relic")
                        RE_ClaimRelic:FireServer("Burntflame Relic")
                        RE_ClaimRelic:FireServer("Blacktide Relic")
                        task.wait(2)
                        
                        -- 3. Teleport to Gate
                        ArchStatus:SetDesc("Teleporting to Gate...")
                        local gatePos = CFrame.new(3445, -288, 3402)
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                             char.HumanoidRootPart.CFrame = gatePos
                        end
                        task.wait(1)
                        
                        -- 4. Place Relics
                        ArchStatus:SetDesc("Placing Relics...")
                        local r1 = GetRelicUUID("Sunken Eye Relic", 578)
                        local r2 = GetRelicUUID("Burntflame Relic", 579)
                        local r3 = GetRelicUUID("Blacktide Relic", 577)
                        
                        if r1 then pcall(function() RE_PlaceRelic:FireServer(r1, 1) end) end
                        task.wait(0.2)
                        if r2 then pcall(function() RE_PlaceRelic:FireServer(r2, 2) end) end
                        task.wait(0.2)
                        if r3 then pcall(function() RE_PlaceRelic:FireServer(r3, 3) end) end
                        task.wait(1)
                        
                        -- 5. Wait for Door
                        ArchStatus:SetDesc("Waiting for Door to Open...")
                        local door = workspace:FindFirstChild("LeviathanEvent")
                        if door and door:FindFirstChild("Door") then
                             local lDoor = door.Door:FindFirstChild("Left") and door.Door.Left:FindFirstChild("L_Door")
                             for i=1, 60 do 
                                 if not archRunning then break end
                                 if not lDoor or lDoor.Transparency > 0.5 or not lDoor.CanCollide then
                                     ArchStatus:SetDesc("Door Open! Entering...")
                                     break
                                 end
                                 task.wait(1)
                             end
                        end
                        
                        -- 6. Enter
                        local enterPos = CFrame.new(3471, -282, 3470)
                        if char and char:FindFirstChild("HumanoidRootPart") then
                             char.HumanoidRootPart.CFrame = enterPos
                        end
                        
                        -- 7. Monitor Event Logic
                        ArchStatus:SetDesc("Monitoring Leviathan Event...")
                        while archRunning do
                            task.wait(2)
                            local d = workspace:FindFirstChild("LeviathanEvent")
                            local ld = d and d:FindFirstChild("Door") and d.Door:FindFirstChild("Left") and d.Door.Left:FindFirstChild("L_Door")
                            
                            -- If Door Closed (Transparency ~0) or Event Gone
                            if not ld or ld.Transparency < 0.1 then
                                ArchStatus:SetDesc("Event Ended. Returning...")
                                break
                            end
                        end
                        
                        -- Return to Start Position
                        if startPos and char and char:FindFirstChild("HumanoidRootPart") then
                             char.HumanoidRootPart.CFrame = startPos
                        end
                        
                        archRunning = false
                        ArchToggle:SetValue(false)
                        break
                    end
                    
                    -- Teleport Check
                    local targetPos = CFrame.new(-645, 30, 113)
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        if (char.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                            ArchStatus:SetDesc("Teleporting to Farming Spot...")
                            char.HumanoidRootPart.CFrame = targetPos
                            task.wait(1)
                            RE_Equip:FireServer(1) 
                            task.wait(0.5)
                        end
                    end
                    
                    -- Removed Quest Active Check to prevent auto-stop
                    -- Script will run until manually stopped or objective items found logic added later if needed
                    
                    if not archRunning then break end

                    -- Blatant V3 Cycle
                    ArchStatus:SetDesc("Farming Objectives (Blatant V3)...")
                    
                    local t = tick()
                    safe(function() RFC:InvokeServer({[1]=t}) end)
                    task.wait(CD)
                    local r = tick()
                    safe(function() RFS:InvokeServer(1,0,r) end)
                    
                    local t2 = tick()
                    safe(function() RFC:InvokeServer({[1]=t2}) end)
                    task.wait(CD)
                    local r2 = tick()
                    safe(function() RFS:InvokeServer(1,0,r2) end)
                    
                    task.wait(FD) 
                    if not archRunning then break end
                    
                    safe(function() REF:FireServer() end)
                    safe(function() REF:FireServer() end)
                    
                    task.wait(KD)
                    safe(function() RFK:InvokeServer() end)
                    task.wait(0.001)
                end
                
                if catchListener then catchListener:Disconnect() end
                archRunning = false
                ArchToggle:SetValue(false)
            end)
        else
            if archThread then task.cancel(archThread) archThread = nil end
            archRunning = false
            ArchStatus:SetDesc("Stopped")
        end
    end)

    --// AUTO LEVER
    local leverxixi = Quest:AddSection(" [ Auto Lever ] ")
local AUTO_LEVER_THREAD=nil
local AUTO_LEVER_EQUIP_THREAD=nil
local LEVER_FARMING_MODE=false
local AUTO_LEVER_ACTIVE=false
local LEVER_INSTANT_DELAY=1.7
local ARTIFACT_IDS={["Arrow Artifact"]=265,["Crescent Artifact"]=266,["Diamond Artifact"]=267,["Hourglass Diamond Artifact"]=271}
local function GetRemote(p,n,t)local c=game:GetService("ReplicatedStorage")for _,k in ipairs(p)do c=c:WaitForChild(k,t or 0.5)if not c then return nil end end return c:FindFirstChild(n)end
local RPath={"Packages","_Index","sleitnick_net@0.2.0","net"}
local RE_EquipToolFromHotbar=GetRemote(RPath,"RE/EquipToolFromHotbar")
local RF_PlaceLeverItem=GetRemote(RPath,"RE/PlaceLeverItem")
local RE_UnequipItem=GetRemote(RPath,"RE/UnequipItem")
local RE_EquipItem=GetRemote(RPath,"RE/EquipItem")
local RF_ChargeFishingRod=GetRemote(RPath,"RF/ChargeFishingRod")
local RF_RequestFishingMinigameStarted=GetRemote(RPath,"RF/RequestFishingMinigameStarted")
local RE_FishingCompleted=GetRemote(RPath,"RE/FishingCompleted")
local RF_CancelFishingInputs=GetRemote(RPath,"RF/CancelFishingInputs")
local ArtifactData={
["Hourglass Diamond Artifact"]={ItemName="Hourglass Diamond Artifact",LeverName="Hourglass Diamond Lever",ChildReference=6,CrystalPathSuffix="Crystal",UnlockColor=Color3.fromRGB(255,248,49),FishingPos={Pos=Vector3.new(1490.144,3.312,-843.171),Look=Vector3.new(0.115,0,0.993)}},
["Diamond Artifact"]={ItemName="Diamond Artifact",LeverName="Diamond Lever",ChildReference="TempleLever",CrystalPathSuffix="Crystal",UnlockColor=Color3.fromRGB(219,38,255),FishingPos={Pos=Vector3.new(1844.159,2.53,-288.755),Look=Vector3.new(0.981,0,-0.193)}},
["Arrow Artifact"]={ItemName="Arrow Artifact",LeverName="Arrow Lever",ChildReference=5,CrystalPathSuffix="Crystal",UnlockColor=Color3.fromRGB(255,47,47),FishingPos={Pos=Vector3.new(874.365,2.53,-358.484),Look=Vector3.new(-0.99,0,0.144)}},
["Crescent Artifact"]={ItemName="Crescent Artifact",LeverName="Crescent Lever",ChildReference=4,CrystalPathSuffix="Crystal",UnlockColor=Color3.fromRGB(112,255,69),FishingPos={Pos=Vector3.new(1401.07,6.489,116.738),Look=Vector3.new(-0.5,0,0.866)}}
}
local ArtifactOrder={"Hourglass Diamond Artifact","Diamond Artifact","Arrow Artifact","Crescent Artifact"}
local function TeleportToLookAt(p,l)local c=game.Players.LocalPlayer.Character local h=c and c:FindFirstChild("HumanoidRootPart")if h then h.CFrame=CFrame.new(p,p+l)end end
local function IsLeverUnlocked(a)local J=workspace:FindFirstChild("JUNGLE INTERACTIONS")if not J then return false end local d=ArtifactData[a]if not d then return false end local f=nil if type(d.ChildReference)=="string"then f=J:FindFirstChild(d.ChildReference)end if not f and type(d.ChildReference)=="number"then local c=J:GetChildren()f=c[d.ChildReference]end if not f then return false end local cr=f:FindFirstChild(d.CrystalPathSuffix)if not cr or not cr:IsA("BasePart")then return false end local cC,tC=cr.Color,d.UnlockColor return math.abs(cC.R*255-tC.R*255)<1.1 and math.abs(cC.G*255-tC.G*255)<1.1 and math.abs(cC.B*255-tC.B*255)<1.1 end
local function HasArtifactItem(a)local r=ClientData if not r then return false end local s,i=pcall(function()return r:GetExpect("Inventory")end)if not s or not i or not i.Items then return false end local id=ARTIFACT_IDS[a]if not id then return false end for _,it in ipairs(i.Items)do if tonumber(it.Id)==id then return true end end return false end
local function RunQuestInstantFish(d)if not(RE_EquipToolFromHotbar and RF_ChargeFishingRod and RF_RequestFishingMinigameStarted and RE_FishingCompleted and RF_CancelFishingInputs)then return end local ts=os.time()+os.clock()pcall(function()RF_ChargeFishingRod:InvokeServer(ts)end)pcall(function()RF_RequestFishingMinigameStarted:InvokeServer(-139.630452165,0.99647927980797)end)task.wait(d and d>0 and d or LEVER_INSTANT_DELAY)pcall(function()RE_FishingCompleted:FireServer()end)task.wait(0.3)pcall(function()RF_CancelFishingInputs:InvokeServer()end)end
local function EquipBestRod()if RE_EquipToolFromHotbar then pcall(function()RE_EquipToolFromHotbar:FireServer(1)end)end end
    local leverStatus = leverxixi:AddParagraph({Title="Lever Status", Content="Status: Inactive\nWaiting for activation...", Icon="wand-2"})
    local delaySlider = leverxixi:AddSlider("LeverFishingDelay", {
        Title = "Fishing Delay",
        Description = "Delay untuk farming lever (seconds)",
        Min = 0.5,
        Max = 4.0,
        Default = 1.7,
        Rounding = 1
    })
    
    delaySlider:OnChanged(function(v)
        LEVER_INSTANT_DELAY = tonumber(v) or 1.7 
    end)
local function RunAutoLeverLoop()
if AUTO_LEVER_THREAD then task.cancel(AUTO_LEVER_THREAD)end
if AUTO_LEVER_EQUIP_THREAD then task.cancel(AUTO_LEVER_EQUIP_THREAD)end
AUTO_LEVER_EQUIP_THREAD=task.spawn(function()local t=0 while AUTO_LEVER_ACTIVE do if LEVER_FARMING_MODE and RE_EquipToolFromHotbar then pcall(function()RE_EquipToolFromHotbar:FireServer(1)end)if t%20==0 then EquipBestRod()end t+=1 end task.wait(0.5)end end)
AUTO_LEVER_THREAD=task.spawn(function()
local c=game.Players.LocalPlayer.Character
local h=c and c:FindFirstChild("HumanoidRootPart")
while AUTO_LEVER_ACTIVE do
local all=true
local target=nil
local s="Current Status:\n"
for _,a in ipairs(ArtifactOrder)do local d=ArtifactData[a]if d then local u=IsLeverUnlocked(a)s=s..d.LeverName..": "..(u and"Done"or"Locked").."\n"if not u and not target then target=a end if not u then all=false end end end
leverStatus:SetDesc(s)
if all then leverStatus:SetTitle("ALL LEVERS UNLOCKED") leverStatus:SetDesc("All temple levers have been unlocked!\nAuto Lever will stop.") break
elseif target then
local d=ArtifactData[target]
if HasArtifactItem(target)then
LEVER_FARMING_MODE=false
leverStatus:SetTitle("Placing: "..d.ItemName)
if h then TeleportToLookAt(d.FishingPos.Pos,d.FishingPos.Look)h.Anchored=true end
task.wait(0.5)
if RE_UnequipItem then pcall(function()RE_UnequipItem:FireServer("all")end)end
task.wait(0.2)
if RF_PlaceLeverItem then pcall(function()RF_PlaceLeverItem:FireServer(target)end)end
task.wait(2)
if h then h.Anchored=false end
task.wait(1)
else
LEVER_FARMING_MODE=true
leverStatus:SetTitle("Farming: "..d.ItemName)
if h and(h.Position-d.FishingPos.Pos).Magnitude>10 then TeleportToLookAt(d.FishingPos.Pos,d.FishingPos.Look)task.wait(0.5)
else RunQuestInstantFish(LEVER_INSTANT_DELAY)task.wait(0.1)end
end
end
task.wait(0.1)
end
AUTO_LEVER_ACTIVE=false
LEVER_FARMING_MODE=false
if AUTO_LEVER_EQUIP_THREAD then task.cancel(AUTO_LEVER_EQUIP_THREAD)AUTO_LEVER_EQUIP_THREAD=nil end
if RE_EquipToolFromHotbar then pcall(function()RE_EquipToolFromHotbar:FireServer(0)end)end
end)
end
    local autoLeverToggle = leverxixi:AddToggle("autoLever", {
        Title = "Enable Auto Lever",
        Default = false
    })
    
    autoLeverToggle:OnChanged(function(s)
        AUTO_LEVER_ACTIVE = s
        if s then 
            leverStatus:SetTitle("Lever Status - ACTIVE")
            leverStatus:SetDesc("Starting Auto Lever system...")
            RunAutoLeverLoop()
        else
            leverStatus:SetTitle("Lever Status - INACTIVE")
            leverStatus:SetDesc("Status: Inactive\nToggle to enable Auto Lever")
            if AUTO_LEVER_THREAD then task.cancel(AUTO_LEVER_THREAD) AUTO_LEVER_THREAD = nil end
            if AUTO_LEVER_EQUIP_THREAD then task.cancel(AUTO_LEVER_EQUIP_THREAD) AUTO_LEVER_EQUIP_THREAD = nil end
            LEVER_FARMING_MODE = false
            local c = game.Players.LocalPlayer.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if h then h.Anchored = false end
            if RE_EquipToolFromHotbar then pcall(function() RE_EquipToolFromHotbar:FireServer(0) end) end
        end
    end)
end

local function EventTab()
    if not Event then return end

    local Replion = require(game:GetService("ReplicatedStorage").Packages.Replion)
    local ItemUtility = require(game:GetService("ReplicatedStorage").Shared.ItemUtility)
    local TierUtility = require(game:GetService("ReplicatedStorage").Shared.TierUtility)
    
    local function GetPlayerDataReplion()
        return Replion.Client:WaitReplion("Data", 5)
    end
    
    local function GetRemote(p, n)
        local c = game:GetService("ReplicatedStorage")
        for _, v in ipairs(p) do c = c:WaitForChild(v, 0.5) if not c then return end end
        return c:FindFirstChild(n)
    end
    local RUIN_DOOR_REMOTE = GetRemote({"Packages", "_Index", "sleitnick_net@0.2.0", "net"}, "RE/PlacePressureItem")
    
    local function GetHRP() local c = game.Players.LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end
    local function TeleportToLookAt(p, l) local c = game.Players.LocalPlayer.Character local h = c and c:FindFirstChild("HumanoidRootPart") if h then h.CFrame = CFrame.new(p, p + l) end end

    -- // ANCIENT LOCHNESS EVENT //
    local loknes = Event:AddSection(" [ Ancient Lochness Event ] ")
    local CountdownParagraph = loknes:AddParagraph({Title="Event Countdown: Waiting...", Content="Status: Trying to sync event...", Icon="clock"})
    local StatsParagraph = loknes:AddParagraph({Title="Event Stats: N/A", Content="Timer: N/A\nCaught: N/A\nChance: N/A", Icon="trending-up"})
    
    local LOCHNESS_POS, LOCHNESS_LOOK = Vector3.new(6063.347, -585.925, 4713.696), Vector3.new(-0.376, 0, -0.927)
    local lastPositionBeforeEvent = nil
    
    local function GetEventGUI()
        local ok, g = pcall(function()
            local i = workspace:WaitForChild("!!! DEPENDENCIES", 5):WaitForChild("Event Tracker", 5).Main.Gui.Content.Items
            local s = i.Stats
            return {Countdown=i.Countdown.Label, Timer=s.Timer.Label, Quantity=s.Quantity, Odds=s.Odds}
        end)
        return ok and g or nil
    end

    local function UpdateEventStats()
        local g = GetEventGUI()
        if not g then
            CountdownParagraph:SetTitle("Event Countdown: GUI Not Found ❌")
            CountdownParagraph:SetDesc("Make sure 'Event Tracker' is loaded in workspace.")
            StatsParagraph:SetTitle("Event Stats: N/A")
            StatsParagraph:SetDesc("Timer: N/A\nCaught: N/A\nChance: N/A")
            return false
        end
        local c = g.Countdown and (g.Countdown.ContentText or g.Countdown.Text) or "N/A"
        local t = g.Timer and (g.Timer.ContentText or g.Timer.Text) or "N/A"
        local q = g.Quantity and (g.Quantity.ContentText or g.Quantity.Text) or "N/A"
        local o = g.Odds and (g.Odds.ContentText or g.Odds.Text) or "N/A"
        CountdownParagraph:SetTitle("Ancient Lochness Start In:") CountdownParagraph:SetDesc(c)
        StatsParagraph:SetTitle("Ancient Lochness Stats")
        StatsParagraph:SetDesc(string.format("- Timer: %s\n- Caught: %s\n- Chance: %s", t, q, o))
        return tostring(t):find("M") and tostring(t):find("S") and not tostring(t):match("^0M 0S")
    end
    
    local EventSyncThread = nil
    local autoJoinEventActive = false
    local function RunEventSyncLoop()
        if EventSyncThread then task.cancel(EventSyncThread) end
        EventSyncThread = task.spawn(function()
            local tp = false
            while true do
                local a = UpdateEventStats()
                if autoJoinEventActive then
                    if a and not tp then
                        if not lastPositionBeforeEvent then
                            local h = GetHRP()
                            if h then lastPositionBeforeEvent = {Pos=h.Position, Look=h.CFrame.LookVector} end
                        end
                        TeleportToLookAt(LOCHNESS_POS, LOCHNESS_LOOK) tp = true
                    elseif tp and not a and lastPositionBeforeEvent then
                        task.wait(15)
                        TeleportToLookAt(lastPositionBeforeEvent.Pos, lastPositionBeforeEvent.Look)
                        lastPositionBeforeEvent, tp = nil, false
                    end
                end
                task.wait(0.5)
            end
        end)
    end
    RunEventSyncLoop()
    
    local LochnessToggle = loknes:AddToggle("AutoJoinLochness", {
        Title = "Auto Join Ancient Lochness Event",
        Description = "Auto teleport to event when active",
        Default = false
    })
    LochnessToggle:OnChanged(function(s)
        autoJoinEventActive = s
        if s then
            CountdownParagraph:SetTitle("Event Countdown: Monitoring...")
            CountdownParagraph:SetDesc("Watching for Lochness event...")
        else
            CountdownParagraph:SetTitle("Event Countdown: Stopped")
            CountdownParagraph:SetDesc("Event monitoring stopped")
        end
    end)
    
    -- // AUTO OPEN RUIN DOOR //
    local ruinDoorSection = Event:AddSection(" [ Auto Open Ruin Door ] ")
    local ruinDoorStatus = ruinDoorSection:AddParagraph({Title="Ruin Door Status: Checking...", Content="Toggle ON to start checking", Icon="door-open"})
    
    local AUTO_UNLOCK_STATE, AUTO_UNLOCK_THREAD, AUTO_UNLOCK_ATTEMPT_THREAD = false, nil, nil
    local ITEM_FISH_NAMES = {"Freshwater Piranha", "Goliath Tiger", "Sacred Guardian Squid", "Crocodile"}
    local SACRED_TEMPLE_POS, SACRED_TEMPLE_LOOK = Vector3.new(1461.815, -22.125, -670.234), Vector3.new(-0.99, 0, 0.143)
    
    local function GetFishNameAndRarity(it)
        if not it or not it.ItemId then return "Unknown", "Common" end
        local d = ItemUtility:GetItemData(it.ItemId) if not d then return "Unknown", "Common" end
        local t = TierUtility:GetTierData(it.Tier or 1)
        return d.Data.Name or "Unknown", (t and t.Name) or "Common"
    end

    local function IsItemAvailable(n)
        local r = GetPlayerDataReplion() if not r then return false end
        local ok, i = pcall(function() return r:GetExpect("Inventory") end)
        if not ok or not i or not i.Items then return false end
        for _, v in ipairs(i.Items) do
            if v.Identifier == n then return true end
            local name = GetFishNameAndRarity(v)
            if name == n and (v.Count or 1) >= 1 then return true end
        end
        return false
    end
    
    local function GetMissingItem() for _, n in ipairs(ITEM_FISH_NAMES) do if not IsItemAvailable(n) then return n end end end

    local function GetRuinDoorStatus()
        local ri = workspace:FindFirstChild("RUIN INTERACTIONS")
        local d = ri and ri:FindFirstChild("Door")
        local s = "LOCKED 🔒"
        if d and d:FindFirstChild("RuinDoor") then
            local l = d.RuinDoor:FindFirstChild("LDoor")
            if l then
                local x
                if l:IsA("BasePart") then x = l.Position.X
                elseif l:IsA("Model") then local ok, p = pcall(function() return l:GetPivot() end) if ok and p then x = p.Position.X end end
                if x and x > 6075 then s = "UNLOCKED ✅" end
            end
        end
        return s
    end
    
    local function RunRuinDoorUnlockAttemptLoop()
        if AUTO_UNLOCK_ATTEMPT_THREAD then task.cancel(AUTO_UNLOCK_ATTEMPT_THREAD) end
        if not RUIN_DOOR_REMOTE then return end
        AUTO_UNLOCK_ATTEMPT_THREAD = task.spawn(function()
            while AUTO_UNLOCK_STATE and GetRuinDoorStatus() == "LOCKED 🔒" do
                for _, n in ipairs(ITEM_FISH_NAMES) do task.wait(7) pcall(function() RUIN_DOOR_REMOTE:FireServer(n) end) end
                task.wait(5)
            end
        end)
    end
    
    local function RunAutoUnlockLoop()
        if AUTO_UNLOCK_THREAD then task.cancel(AUTO_UNLOCK_THREAD) end
        if AUTO_UNLOCK_ATTEMPT_THREAD then task.cancel(AUTO_UNLOCK_ATTEMPT_THREAD) end
        AUTO_UNLOCK_THREAD = task.spawn(function()
            local farm, last = false, nil
            RunRuinDoorUnlockAttemptLoop()
            while AUTO_UNLOCK_STATE do
                local st, miss = GetRuinDoorStatus(), GetMissingItem()
                if st == "LOCKED 🔒" then
                    if miss then
                        if not farm then
                            local h = GetHRP()
                            if h then last = {Pos=h.Position, Look=h.CFrame.LookVector} end
                            TeleportToLookAt(SACRED_TEMPLE_POS, SACRED_TEMPLE_LOOK)
                            task.wait(1.5) farm = true
                        end
                         ruinDoorStatus:SetDesc("Farming: " .. miss .. "\nMake sure Auto Fishing is ON!")
                    else
                        if farm then
                            if last then TeleportToLookAt(last.Pos, last.Look) last = nil end
                            farm = false
                        end
                        ruinDoorStatus:SetDesc("All items collected!\nAttempting unlock...")
                    end
                    task.wait(5)
                elseif st == "UNLOCKED ✅" then
                    if farm and last then TeleportToLookAt(last.Pos, last.Look) end
                    ruinDoorStatus:SetDesc("Door successfully unlocked!") break
                else
                    task.wait(5)
                end
            end
            AUTO_UNLOCK_STATE = false
            if AUTO_UNLOCK_ATTEMPT_THREAD then task.cancel(AUTO_UNLOCK_ATTEMPT_THREAD) AUTO_UNLOCK_ATTEMPT_THREAD = nil end
        end)
    end
    
    local autoUnlockToggle = ruinDoorSection:AddToggle("AutoUnlockRuin", {
        Title = "Auto Unlock Ruin Door",
        Description = "Auto teleport to Sacred Temple and farm items",
        Default = false,
        Callback = function(s)
            AUTO_UNLOCK_STATE = s
            if s then
                task.spawn(function()
                    local success, err = pcall(function()
                        local st, miss = GetRuinDoorStatus(), GetMissingItem()
                        ruinDoorStatus:SetTitle("Ruin Door Status: " .. st)
                        
                        if st == "UNLOCKED ✅" then 
                            Fluent:Notify({Title="Already Unlocked", Content="The door is already unlocked!", Duration=3})
                            if autoUnlockToggle.SetValue then autoUnlockToggle:SetValue(false) end
                            return 
                        end
                        
                        ruinDoorStatus:SetDesc(miss and ("Missing: " .. miss .. "\nTeleporting to Sacred Temple...") or "All items collected!\nStarting unlock attempts...")
                        RunAutoUnlockLoop()
                    end)
                    
                    if not success then
                        warn("Auto Unlock Error: " .. tostring(err))
                        Fluent:Notify({Title="System Error", Content="Check console (F9). Error: " .. tostring(err), Duration=5})
                        if autoUnlockToggle.SetValue then autoUnlockToggle:SetValue(false) end
                    end
                end)
            else
                ruinDoorStatus:SetTitle("Ruin Door Status: Stopped")
                ruinDoorStatus:SetDesc("Auto unlock stopped")
                if AUTO_UNLOCK_THREAD then task.cancel(AUTO_UNLOCK_THREAD) AUTO_UNLOCK_THREAD = nil end
                if AUTO_UNLOCK_ATTEMPT_THREAD then task.cancel(AUTO_UNLOCK_ATTEMPT_THREAD) AUTO_UNLOCK_ATTEMPT_THREAD = nil end
            end
        end
    })


    -- // PIRATE EVENT REWARDS //
    local sectionclassic = Event:AddSection(" [ Pirate Event Rewards ] ")
    local autoClaimClassicState, autoClaimClassicThread = false, nil
    local RE_ClaimEventReward = nil
    pcall(function() RE_ClaimEventReward = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 10):WaitForChild("_Index", 10):WaitForChild("sleitnick_net@0.2.0", 10):WaitForChild("net", 10):WaitForChild("RE/ClaimEventReward", 10) end)
    
    local pirateRewardToggle = sectionclassic:AddToggle("AutoClaimPirate", {
        Title = "Auto Claim Pirate Event Rewards",
        Default = false
    })
    pirateRewardToggle:OnChanged(function(s)
        autoClaimClassicState = s
        if s then
            if not RE_ClaimEventReward then RE_ClaimEventReward = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net:FindFirstChild("RE/ClaimEventReward") end
            if not RE_ClaimEventReward then Fluent:Notify({Title="Error", Content="Remote Claim Reward tidak ditemukan.", Duration=3}) return false end
            Fluent:Notify({Title="Auto Claim ON", Content="Collecting pirate rewards...", Duration=3})
            if autoClaimClassicThread then task.cancel(autoClaimClassicThread) end
            autoClaimClassicThread = task.spawn(function()
                while autoClaimClassicState do
                    for i = 1, 15 do 
                        if not autoClaimClassicState then break end 
                        pcall(function() RE_ClaimEventReward:FireServer(i) end) 
                        task.wait(0.1) 
                    end
                    task.wait(60)
                end
            end)
        else
            if autoClaimClassicThread then task.cancel(autoClaimClassicThread) autoClaimClassicThread = nil end
            Fluent:Notify({Title="Auto Claim OFF", Content="Stopped collecting rewards.", Duration=2})
        end
    end)
    
    -- // PIRATE TREASURE //
    local sectionTreasure = Event:AddSection(" [ Pirate Treasure ] ")
    local autoClaimTreasureState = false
    local autoClaimTreasureThread = nil
    local STORAGE = workspace:WaitForChild("PirateChestStorage", 5)
    local START_CFRAME = CFrame.new(3263, 5, 3686)
    local LOOP_DELAY = 1
    local triedChests = {}
    
    local function getInteractable(obj)
        local p = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if p and p.Enabled then return p end
        local c = obj:FindFirstChildWhichIsA("ClickDetector", true)
        if c then return c end
    end
    
    local function interactOnce(obj)
        local i = getInteractable(obj)
        if not i then return false end
        if i:IsA("ProximityPrompt") then
            if fireproximityprompt then fireproximityprompt(i, 1) end
        else
            if fireclickdetector then fireclickdetector(i) end
        end
        return true
    end
    
    local function getRandomChest()
        if not STORAGE then return end
        local valid = {}
        for _, v in ipairs(STORAGE:GetChildren()) do
            if not triedChests[v] and getInteractable(v) then table.insert(valid, v) end
        end
        if #valid == 0 then return end
        return valid[math.random(#valid)]
    end
    
    local treasureToggle = sectionTreasure:AddToggle("AutoClaimTreasure", {
        Title = "Auto Claim Treasure Chest",
        Default = false
    })
    treasureToggle:OnChanged(function(state)
        autoClaimTreasureState = state
        if state then
            if not STORAGE then Fluent:Notify({Title="Error", Content="PirateChestStorage not found", Duration=3}) return end
            Fluent:Notify({Title="Auto Claim ON", Content="Collecting treasure chests...", Duration=2})
            triedChests = {}
            if autoClaimTreasureThread then task.cancel(autoClaimTreasureThread) autoClaimTreasureThread = nil end
            autoClaimTreasureThread = task.spawn(function()
                local c = game.Players.LocalPlayer.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if h then h.AssemblyLinearVelocity = Vector3.zero h.CFrame = START_CFRAME + Vector3.new(0, 3, 0) end
                task.wait(0.6)
                
                while autoClaimTreasureState do
                    local chest = getRandomChest()
                    if not chest then
                        autoClaimTreasureState = false
                        Fluent:Notify({Title="Treasure Empty", Content="Semua treasure sudah di-claim.", Duration=3})
                        if treasureToggle.Value then treasureToggle:SetValue(false) end
                        break
                    end
                    triedChests[chest] = true
                    local part = chest:IsA("Model") and (chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")) or chest
                    if part then
                         local c2 = game.Players.LocalPlayer.Character
                         local h2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                         if h2 then h2.AssemblyLinearVelocity = Vector3.zero h2.CFrame = part.CFrame + Vector3.new(0, 3, 0) end
                         task.wait(0.4)
                         interactOnce(chest)
                    end
                    task.wait(LOOP_DELAY)
                end
            end)
        else
             if autoClaimTreasureThread then task.cancel(autoClaimTreasureThread) autoClaimTreasureThread = nil end
             Fluent:Notify({Title="Auto Claim OFF", Content="Stopped collecting treasure.", Duration=2})
        end
    end)
end


local function TradeTab()
    if not Trade then return end
    
    -- Services
    local RepStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HttpService = game:GetService("HttpService")
    local ItemUtility = require(RepStorage:WaitForChild("Shared"):WaitForChild("ItemUtility"))
    local ReplionClient = require(RepStorage:WaitForChild("Packages"):WaitForChild("Replion")).Client
    
    -- Remote Setup
    local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
    local function GetRemote(p, n)
        local c = RepStorage
        for _, k in ipairs(p) do
            c = c:WaitForChild(k, 5)
            if not c then return nil end
        end
        return c:FindFirstChild(n)
    end
    local RF_InitiateTrade = GetRemote(RPath, "RF/InitiateTrade")
    
    -- State Variables
    local autoTradeState = false
    local autoTradeThread = nil
    local tradeHoldFavorite = false
    local autoAcceptState = false
    local hideFavoriteInDropdown = false
    local groupMutationsInDropdown = false
    local selectedTradeTargetId = nil
    local selectedTradeItemName = nil
    local selectedTradeRarity = nil
    local tradeDelay = 1
    local tradeAmount = 0
    local tradeStopAtCoins = 0
    local isTradeByCoinActive = false
    local tradeQuantity = 1
    local selectedMutation = ""
    local allMutations = {"Shiny","Albino","Sandy","Noob","Moon Fragment","Festive","Disco","1x1x1x1","Bloodmoon","Color Burn","Corrupt","Fairy Dust","Frozen","Galaxy","Gemstone","Ghost","Gold","Holographic","Lightning","Midnight","Radioactive","Stone"}
    local GlobalItemCache = {}
    
    -- Cache Items
    task.spawn(function()
        local items = RepStorage:WaitForChild("Items"):GetChildren()
        for _, v in ipairs(items) do
            if v.Name:sub(1, 3) ~= "!!!" then
                table.insert(GlobalItemCache, v.Name)
            end
        end
        table.sort(GlobalItemCache)
    end)
    
    -- Auto Accept Hook
    task.spawn(function()
        local PromptController, Promise
        pcall(function()
            PromptController = require(RepStorage:WaitForChild("Controllers").PromptController)
            Promise = require(RepStorage:WaitForChild("Packages").Promise)
        end)
        if PromptController and PromptController.FirePrompt then
            local old = PromptController.FirePrompt
            PromptController.FirePrompt = function(self, t, ...)
                if autoAcceptState and type(t) == "string" and t:find("Accept") and t:find("from:") then
                    return Promise.new(function(r) task.wait(2) r(true) end)
                end
                return old(self, t, ...)
            end
        end
    end)
    
    -- Helper Functions
    local function GetFishNameAndRarity(item)
        local name = item.Identifier or "Unknown"
        local rarity = item.Metadata and item.Metadata.Rarity or "COMMON"
        if ItemUtility then
            local d = ItemUtility:GetItemData(item.Id)
            if d and d.Data and d.Data.Name then name = d.Data.Name end
        end
        return name, rarity
    end
    
    local function GetMutationName(item)
        if not item.Metadata or not item.Metadata.VariantId then return "No Mutation" end
        local mutations = {
            Shiny = "Shiny",
            Albino = "Albino",
            Sandy = "Sandy",
            Noob = "Noob",
            ["Moon Fragment"] = "Moon Fragment",
            Festive = "Festive",
            Disco = "Disco",
            ["1x1x1x1"] = "1x1x1x1",
            Bloodmoon = "Bloodmoon",
            ["Color Burn"] = "Color Burn",
            Corrupt = "Corrupt",
            ["Fairy Dust"] = "Fairy Dust",
            Frozen = "Frozen",
            Galaxy = "Galaxy",
            Gemstone = "Gemstone",
            Ghost = "Ghost",
            Gold = "Gold",
            Holographic = "Holographic",
            Lightning = "Lightning",
            Midnight = "Midnight",
            Radioactive = "Radioactive",
            Stone = "Stone"
        }
        return mutations[item.Metadata.VariantId] or item.Metadata.VariantId
    end
    
    local function GetPlayerDataReplion()
        local s, r = pcall(function() return ReplionClient:WaitReplion("Data") end)
        return s and r or nil
    end
    
    local function GetItemsToTrade()
        local r = GetPlayerDataReplion()
        if not r then return {} end
        local s, i = pcall(function() return r:GetExpect("Inventory") end)
        if not s or not i or not i.Items then return {} end
        
        local out = {}
        for _, item in ipairs(i.Items) do
            local fav = item.IsFavorite or item.Favorited
            if tradeHoldFavorite and fav then continue end
            if typeof(item.UUID) ~= "string" or #item.UUID < 10 then continue end
            
            local name, rar = GetFishNameAndRarity(item)
            local ir = (rar and rar:upper() ~= "COMMON") and rar or "Default"
            local pr = not selectedTradeRarity or ir:upper() == selectedTradeRarity:upper()
            local pn = not selectedTradeItemName or name == selectedTradeItemName
            local mutation = GetMutationName(item)
            local pm = not selectedMutation or selectedMutation == "" or mutation == selectedMutation
            
            if pr and pn and pm then
                table.insert(out, {UUID=item.UUID, Name=name, Id=item.Id, Metadata=item.Metadata or {}, IsFavorite=fav, Mutation=mutation})
            end
        end
        return out
    end
    
    local function GetInventoryForScan()
        local r = GetPlayerDataReplion()
        if not r then return {} end
        local s, i = pcall(function() return r:GetExpect("Inventory") end)
        if not s or not i or not i.Items then return {} end
        
        local out = {}
        for _, item in ipairs(i.Items) do
            local fav = item.IsFavorite or item.Favorited
            if hideFavoriteInDropdown and fav then continue end
            if typeof(item.UUID) ~= "string" or #item.UUID < 10 then continue end
            
            local name, rar = GetFishNameAndRarity(item)
            local ir = (rar and rar:upper() ~= "COMMON") and rar or "Default"
            local pr = not selectedTradeRarity or ir:upper() == selectedTradeRarity:upper()
            local mutation = GetMutationName(item)
            local pm = not selectedMutation or selectedMutation == "" or mutation == selectedMutation
            
            if pr and pm then
                table.insert(out, {UUID=item.UUID, Name=name, Id=item.Id, Metadata=item.Metadata or {}, IsFavorite=fav, Mutation=mutation})
            end
        end
        return out
    end
    
    local function IsItemStillInInventory(u)
        local r = GetPlayerDataReplion()
        local s, i = pcall(function() return r:GetExpect("Inventory") end)
        if s and i.Items then
            for _, it in ipairs(i.Items) do
                if it.UUID == u then return true end
            end
        end
        return false
    end
    
    local function TeleportToPlayer(id)
        local tp = Players:GetPlayerByUserId(id)
        if tp and tp.Character then
            local th = tp.Character:FindFirstChild("HumanoidRootPart")
            local mh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if th and mh then
                mh.CFrame = th.CFrame * CFrame.new(0, 5, 0)
                return true
            end
        end
        return false
    end
    
    local function RunAutoTradeLoop()
        if autoTradeThread then task.cancel(autoTradeThread) end
        autoTradeThread = task.spawn(function()
            local tradeCount = 0
            local acc = 0
            
            if not selectedTradeTargetId then
                Fluent:Notify({Title="Error", Content="Pilih target player dulu.", Duration=3})
                return
            end
            
            Fluent:Notify({Title="Auto Trade Started", Content="Mencari item...", Duration=2})
            local targetQuantity = tradeQuantity > 0 and tradeQuantity or 99999
            local tradedCount = 0
            
            while autoTradeState and tradedCount < targetQuantity do
                -- Check Limits
                if isTradeByCoinActive and tradeStopAtCoins > 0 and acc >= tradeStopAtCoins then
                    Fluent:Notify({Title="Target Value Tercapai", Content="Total: "..acc, Duration=5})
                    break
                end
                if tradeAmount > 0 and tradeCount >= tradeAmount then
                    Fluent:Notify({Title="Limit Tercapai", Content="Jumlah trade terpenuhi.", Duration=5})
                    break
                end
                
                -- Teleport to Target
                if not TeleportToPlayer(selectedTradeTargetId) then
                    Fluent:Notify({Title="Target Hilang", Content="Player keluar / tidak ditemukan.", Duration=3})
                    break
                end
                
                -- Get & Trade Items
                local items = GetItemsToTrade()
                if #items > 0 then
                    local item = items[1]
                    local base = 0
                    if ItemUtility then
                        local d = ItemUtility:GetItemData(item.Id)
                        if d then base = d.SellPrice or 0 end
                    end
                    local mult = item.Metadata.SellMultiplier or 1
                    local val = math.floor(base * mult)
                    
                    local ok = pcall(function() RF_InitiateTrade:InvokeServer(selectedTradeTargetId, item.UUID) end)
                    if ok then
                        local st = os.clock()
                        local traded = false
                        repeat
                            task.wait(0.5)
                            if not IsItemStillInInventory(item.UUID) then traded = true end
                        until traded or os.clock() - st > 5
                        
                        if traded then
                            tradeCount += 1
                            tradedCount += 1
                            acc += val
                            Fluent:Notify({Title="Trade Sent", Content=string.format("%s (%d$)\nProgress: %d/%d", item.Name, val, tradedCount, targetQuantity), Duration=2})
                            task.wait(tradeDelay)
                        else
                            Fluent:Notify({Title="Lag/Failed", Content="Item tidak terkirim.", Duration=1})
                            task.wait(1)
                        end
                    else
                        task.wait(1)
                    end
                else
                    Fluent:Notify({Title="Stok Habis", Content="Tidak ada item sesuai filter.", Duration=5})
                    break
                end
                task.wait(0.1)
            end
            
            autoTradeState = false
            Fluent:Notify({Title="Auto Trade Stopped", Content="Stopped by user.", Duration=3})
        end)
    end
    
    -- UI Setup
    Trade:AddSection(" [ Auto Trade System ] ")
    
    -- Auto Accept Toggle
    Trade:AddToggle("AutoAcceptTrade", {
        Title = "Auto Accept Trade",
        Description = "Otomatis menerima semua trade masuk.",
        Default = false
    }):OnChanged(function(s)
        autoAcceptState = s
        Fluent:Notify({Title=s and "Auto Accept ON" or "Auto Accept OFF", Content=s and "Siap menerima trade." or nil, Duration=3})
    end)
    
    -- Player Selection Section
    Trade:AddSection(" [ Player Selection ] ")
    
    local PlayerDropdown = Trade:AddDropdown("PlayerSelect", {
        Title = "Select Target Player",
        Values = {},
        Multi = false,
        Default = 1
    })
    PlayerDropdown:OnChanged(function(n)
        local p = Players:FindFirstChild(n)
        if p then
            selectedTradeTargetId = p.UserId
            Fluent:Notify({Title="Target Set", Content=p.Name, Duration=2})
        else
            selectedTradeTargetId = nil
        end
    end)
    
    -- Refresh Button
    Trade:AddButton({
        Title = "Refresh Players",
        Description = "Update list players",
        Callback = function()
            local l = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(l, p.Name) end
            end
            PlayerDropdown:SetValues(l)
            Fluent:Notify({Title="List Updated", Content=#l.." players found.", Duration=2})
        end
    })
    
    -- Filters Section
    Trade:AddSection(" [ Item Filters ] ")
    
    Trade:AddDropdown("RarityFilter", {
        Title = "Filter Rarity (Optional)",
        Values = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","SECRET","Trophy","Collectible","DEV"},
        Multi = false,
        Default = nil
    }):OnChanged(function(r) selectedTradeRarity = r end)
    
    local mutationDropdown = Trade:AddDropdown("MutationFilter", {
        Title = "Filter Mutation (Optional)",
        Values = {"All Mutations","No Mutation","Shiny","Albino","Sandy","Noob","Moon Fragment","Festive","Disco","1x1x1x1","Bloodmoon","Color Burn","Corrupt","Fairy Dust","Frozen","Galaxy","Gemstone","Ghost","Gold","Holographic","Lightning","Midnight","Radioactive","Stone"},
        Multi = false,
        Default = nil
    })
    mutationDropdown:OnChanged(function(m)
        if m == "All Mutations" or m == "No Mutation" then
            selectedMutation = ""
        else
            selectedMutation = m
        end
    end)
    
    -- Options
    Trade:AddToggle("HoldFavorite", {
        Title = "Hold Favorite Items",
        Description = "Jangan trade item yang di-Favorite.",
        Default = false
    }):OnChanged(function(s) tradeHoldFavorite = s end)
    
    Trade:AddToggle("HideFavDropdown", {
        Title = "Hide Favorited in Dropdown",
        Description = "Sembunyikan item favorit saat scan.",
        Default = false
    }):OnChanged(function(s) hideFavoriteInDropdown = s end)
    
    Trade:AddToggle("GroupMutations", {
        Title = "Group Mutations",
        Description = "Gabung semua mutasi dalam satu item.",
        Default = false
    }):OnChanged(function(s) groupMutationsInDropdown = s end)
    
    -- Item Selector Section
    Trade:AddSection(" [ Item Selector ] ")
    
    -- Scan System
    local tradeDropdown
    local function ScanBackpackItems()
        local items = GetInventoryForScan()
        
        if groupMutationsInDropdown then
            local itemTotals = {}
            local favTotals = {}
            for _, item in ipairs(items) do
                local name = item.Name
                local isFav = item.IsFavorite
                itemTotals[name] = (itemTotals[name] or 0) + 1
                if isFav then favTotals[name] = (favTotals[name] or 0) + 1 end
            end
            
            local itemList = {}
            for itemName, total in pairs(itemTotals) do
                local favCount = favTotals[itemName] or 0
                local displayName = itemName.." (x"..total
                if favCount > 0 then
                    displayName = displayName.." ⭐"
                end
                displayName = displayName..")"
                table.insert(itemList, displayName)
            end
            table.sort(itemList)
            return itemList
        else
            local itemDetails = {}
            for _, item in ipairs(items) do
                local name = item.Name
                local mutation = item.Mutation
                local isFav = item.IsFavorite
                if not itemDetails[name] then itemDetails[name] = {} end
                if not itemDetails[name][mutation] then itemDetails[name][mutation] = {total=0, fav=0} end
                itemDetails[name][mutation].total = itemDetails[name][mutation].total + 1
                if isFav then itemDetails[name][mutation].fav = itemDetails[name][mutation].fav + 1 end
            end
            
            local itemList = {}
            for itemName, mutations in pairs(itemDetails) do
                for mutName, data in pairs(mutations) do
                    local displayName = itemName
                    if mutName ~= "No Mutation" then
                        displayName = displayName.." ("..mutName.." x"..data.total
                    else
                        displayName = displayName.." (x"..data.total
                    end
                    if data.fav > 0 then
                        displayName = displayName.." ⭐"
                    end
                    displayName = displayName..")"
                    table.insert(itemList, displayName)
                end
            end
            table.sort(itemList)
            return itemList
        end
    end
    
    -- Scan Button
    Trade:AddButton({
        Title = "Scan Backpack",
        Description = "Scan inventory for items",
        Callback = function()
            local scanned = ScanBackpackItems()
            if #scanned > 0 then
                tradeDropdown:SetValues(scanned)
                Fluent:Notify({Title="Scan Complete", Content=#scanned.." item variations found", Duration=2})
            else
                tradeDropdown:SetValues({"No items found"})
                Fluent:Notify({Title="Empty", Content="No items matching filters", Duration=2})
            end
        end
    })
    
    -- Item Dropdown
    tradeDropdown = Trade:AddDropdown("ItemSelect", {
        Title = "Select Item from Backpack",
        Values = {"Click Scan Backpack first"},
        Multi = false,
        Default = nil
    })
    tradeDropdown:OnChanged(function(n)
        if n and n ~= "" then
            local itemNameOnly = n:match("^(.+) %(")
            if itemNameOnly then
                itemNameOnly = itemNameOnly:gsub(" %s+$", "")
                selectedTradeItemName = itemNameOnly
            end
        end
    end)
    
    -- Trade Settings Section
    Trade:AddSection(" [ Trade Settings ] ")
    
    Trade:AddInput("TradeQuantity", {
        Title = "Quantity to Trade",
        Default = "1",
        Numeric = true,
        Finished = true,
        Callback = function(v) tradeQuantity = tonumber(v) or 1 end
    })
    
    Trade:AddInput("StopAtCoins", {
        Title = "Stop at Coin Value",
        Default = "0",
        Numeric = true,
        Finished = true,
        Callback = function(v)
            tradeStopAtCoins = tonumber(v) or 0
            isTradeByCoinActive = tradeStopAtCoins > 0
        end
    })
    
    Trade:AddSlider("TradeDelay", {
        Title = "Trade Delay",
        Min = 0.5,
        Max = 5,
        Default = 1,
        Rounding = 1
    }):OnChanged(function(v) tradeDelay = tonumber(v) end)
    
    -- Start Section
    Trade:AddSection(" [ Start Trade ] ")
    
    -- Start Toggle
    Trade:AddToggle("EnableAutoTrade", {
        Title = "Enable Auto Trade",
        Default = false
    }):OnChanged(function(s)
        autoTradeState = s
        if s then
            if not selectedTradeTargetId then
                Fluent:Notify({Title="Error", Content="Target Player belum dipilih!", Duration=3})
                return false
            end
            RunAutoTradeLoop()
        else
            if autoTradeThread then task.cancel(autoTradeThread) end
            Fluent:Notify({Title="Stopped", Content="Auto Trade stopped.", Duration=2})
        end
    end)
end


local function EnchantTab()
    if not Enchant then return end
    
    -- Services
    local RepStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplionClient = require(RepStorage:WaitForChild("Packages"):WaitForChild("Replion")).Client
    local ItemUtility = require(RepStorage:WaitForChild("Shared"):WaitForChild("ItemUtility"))
    local RunService = game:GetService("RunService")
    
    -- Remote Setup
    local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
    local function GetRemote(p, n)
        local c = RepStorage
        for _, k in ipairs(p) do
            c = c:WaitForChild(k, 5)
            if not c then return nil end
        end
        return c:FindFirstChild(n)
    end
    local RE_EquipItem = GetRemote(RPath, "RE/EquipItem")
    local RE_UnequipItem = GetRemote(RPath, "RE/UnequipItem")
    local RE_EquipToolFromHotbar = GetRemote(RPath, "RE/EquipToolFromHotbar")
    local RE_ActivateEnchantingAltar = GetRemote(RPath, "RE/ActivateEnchantingAltar")
    
    -- Constants
    local ENCHANT_ALTAR_POS = Vector3.new(3236.441, -1302.855, 1397.91)
    local ENCHANT_ALTAR_LOOK = Vector3.new(-0.954, 0, 0.299)
    local ENCHANT_STONE_ID = 10
    local EVOLVED_ENCHANT_STONE_ID = 558
    local ENCHANT_MAPPING = {
        ["Glistening I"] = 1,
        ["Reeler I"] = 2,
        ["Reeler II"] = 21,
        ["Big Hunter I"] = 3,
        ["Gold Digger I"] = 4,
        ["Leprechaun I"] = 5,
        ["Leprechaun II"] = 6,
        ["Mutation Hunter I"] = 7,
        ["Mutation Hunter II"] = 14,
        ["Mutation Hunter III"] = 22,
        ["Stargazer I"] = 8,
        ["Stargazer II"] = 17,
        ["Empowered I"] = 9,
        ["XPerienced"] = 10,
        ["Stormhunter I"] = 11,
        ["Stormhunter II"] = 19,
        ["Cursed I"] = 12,
        ["Prismatic I"] = 13,
        ["Perfection"] = 15,
        ["SECRET Hunter"] = 16,
        ["Fairy Hunter"] = 18,
        ["Shark Hunter"] = 20
    }
    local ENCHANT_ROD_LIST = {
        {Name="Luck Rod", ID=79},
        {Name="Carbon Rod", ID=76},
        {Name="Grass Rod", ID=85},
        {Name="Demascus Rod", ID=77},
        {Name="Ice Rod", ID=78},
        {Name="Lucky Rod", ID=4},
        {Name="Midnight Rod", ID=80},
        {Name="Steampunk Rod", ID=6},
        {Name="Chrome Rod", ID=7},
        {Name="Flourescent Rod", ID=255},
        {Name="Astral Rod", ID=5},
        {Name="Ares Rod", ID=126},
        {Name="Angler Rod", ID=168},
        {Name="Ghostfin Rod", ID=169},
        {Name="Element Rod", ID=257},
        {Name="Hazmat Rod", ID=256},
        {Name="Bamboo Rod", ID=258},
        {Name="Diamond Rod", ID=559}
    }
    
    -- State Variables
    local autoEnchantState = false
    local autoEnchantThread = nil
    local selectedRodUUID = nil
    local selectedEnchantNames = {}
    local selectedStoneType = "Enchant Stone"
    
    -- Helper Functions
    local function TeleportToLookAt(p, l)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if h then
            h.CFrame = CFrame.new(p, p + l) * CFrame.new(0, 0.5, 0)
        end
    end
    
    local function GetEnchantNamesList()
        local t = {}
        for n in pairs(ENCHANT_MAPPING) do
            table.insert(t, n)
        end
        table.sort(t)
        return t
    end
    
    local function GetHardcodedRodNames()
        local t = {}
        for _, v in ipairs(ENCHANT_ROD_LIST) do
            table.insert(t, v.Name)
        end
        return t
    end
    
    local function GetPlayerDataReplion()
        local s, r = pcall(function() return ReplionClient:WaitReplion("Data") end)
        return s and r or nil
    end
    
    local function GetUUIDByRodID(id)
        local r = GetPlayerDataReplion()
        if not r then return nil end
        local s, i = pcall(function() return r:GetExpect("Inventory") end)
        if not s or not i or not i["Fishing Rods"] then return nil end
        for _, rod in ipairs(i["Fishing Rods"]) do
            if tonumber(rod.Id) == id then return rod.UUID end
        end
        return nil
    end
    
    local function GetStoneUUID(stoneType)
        local targetId = stoneType == "Evolved Enchant Stone" and EVOLVED_ENCHANT_STONE_ID or ENCHANT_STONE_ID
        local r = GetPlayerDataReplion()
        if not r then return nil end
        local s, i = pcall(function() return r:GetExpect("Inventory") end)
        if s and i.Items then
            for _, it in ipairs(i.Items) do
                if tonumber(it.Id) == targetId and it.UUID then
                    local itemData = ItemUtility:GetItemData(it.Id)
                    if itemData and itemData.Data then
                        local typeName = itemData.Data.Type
                        if typeName then return it.UUID, typeName end
                    end
                    return it.UUID, "Enchant Stones"
                end
            end
        end
        return nil
    end
    
    local function CheckIfEnchantReached(uuid)
        local r = GetPlayerDataReplion()
        local rods = r:GetExpect("Inventory")["Fishing Rods"] or {}
        local trg = nil
        for _, rod in ipairs(rods) do
            if rod.UUID == uuid then trg = rod break end
        end
        if not trg then return true end
        local eid = trg.Metadata and trg.Metadata.EnchantId
        if not eid then return false end
        -- Robust iteration for Map (Fluent) or Array (WindUI)
        for k, v in pairs(selectedEnchantNames) do
            local name = (type(k) == "number") and v or k
            if ENCHANT_MAPPING[name] == eid then return true end
        end
        return false
    end
    
    local function UnequipAllEquippedItems()
        local r = GetPlayerDataReplion()
        local e = r:GetExpect("EquippedItems") or {}
        for _, u in ipairs(e) do
            pcall(function() RE_UnequipItem:FireServer(u) end)
            task.wait(0.05)
        end
    end
    
    local function RunAutoEnchantLoop(uuid, stoneType)
        if autoEnchantThread then task.cancel(autoEnchantThread) end
        autoEnchantThread = task.spawn(function()
            UnequipAllEquippedItems()
            task.wait(0.5)
            TeleportToLookAt(ENCHANT_ALTAR_POS, ENCHANT_ALTAR_LOOK)
            task.wait(1.5)
            Fluent:Notify({Title="Enchant Started", Content="Mulai rolling dengan "..stoneType.."...", Duration=2})
            
            while autoEnchantState do
                if CheckIfEnchantReached(uuid) then
                    Fluent:Notify({Title="Success!", Content="Target Enchant didapatkan.", Duration=5})
                    break
                end
                
                local stone, stoneCategory = GetStoneUUID(stoneType)
                if not stone then
                    Fluent:Notify({Title="Stone Habis!", Content=stoneType.." sudah habis.", Duration=5})
                    break
                end
                
                pcall(function() RE_EquipItem:FireServer(uuid, "Fishing Rods") end)
                task.wait(0.2)
                pcall(function() RE_EquipItem:FireServer(stone, stoneCategory or "Enchant Stones") end)
                task.wait(0.2)
                pcall(function() RE_EquipToolFromHotbar:FireServer(2) end)
                task.wait(0.3)
                pcall(function() RE_ActivateEnchantingAltar:FireServer() end)
                task.wait(1.5)
                pcall(function() RE_EquipToolFromHotbar:FireServer(0) end)
                task.wait(0.5)
            end
            
            autoEnchantState = false
            Fluent:Notify({Title="Auto Enchant Stopped", Content="Process halted.", Duration=3})
        end)
    end
    
    -- UI Setup
    Enchant:AddSection(" [ Auto Enchant ] ")
    
    -- Rod Selection
    local RodDropdown = Enchant:AddDropdown("RodSelect", {
        Title = "Select Rod to Enchant",
        Description = "Pilih Rod yang ada di inventory kamu.",
        Values = GetHardcodedRodNames(),
        Multi = false,
        Default = nil
    })
    RodDropdown:OnChanged(function(n)
        selectedRodUUID = nil
        for _, v in ipairs(ENCHANT_ROD_LIST) do
            if v.Name == n then
                local u = GetUUIDByRodID(v.ID)
                if u then
                    selectedRodUUID = u
                    Fluent:Notify({Title="Rod Selected", Content="UUID: "..u:sub(1,8).."...", Duration=2})
                else
                    Fluent:Notify({Title="Missing", Content=n.." tidak ditemukan di tas.", Duration=3})
                end
                break
            end
        end
    end)
    
    -- Stone Type Selection
    Enchant:AddDropdown("StoneType", {
        Title = "Select Stone Type",
        Description = "Pilih jenis stone untuk enchant.",
        Values = {"Enchant Stone", "Evolved Enchant Stone"},
        Multi = false,
        Default = 1
    }):OnChanged(function(v) selectedStoneType = v end)
    
    -- Re-check Button
    Enchant:AddButton({
        Title = "Re-Check Rod UUID",
        Description = "Klik ini jika kamu baru beli rod tapi dropdown error.",
        Callback = function()
            local n = RodDropdown.Value
            if n then
                for _, v in ipairs(ENCHANT_ROD_LIST) do
                    if v.Name == n then
                        local u = GetUUIDByRodID(v.ID)
                        if u then
                            selectedRodUUID = u
                            Fluent:Notify({Title="Updated", Content="UUID Rod diperbarui.", Duration=2})
                        else
                            selectedRodUUID = nil
                            Fluent:Notify({Title="Error", Content="Rod hilang dari inventory.", Duration=3})
                        end
                        break
                    end
                end
            else
                Fluent:Notify({Title="Info", Content="Pilih Rod di dropdown dulu.", Duration=2})
            end
        end
    })
    
    -- Target Enchants
    Enchant:AddDropdown("TargetEnchants", {
        Title = "Target Enchants",
        Description = "Berhenti jika mendapatkan salah satu dari ini.",
        Values = GetEnchantNamesList(),
        Multi = true,
        Default = {}
    }):OnChanged(function(n) selectedEnchantNames = n or {} end)
    
    -- Enable Toggle
    Enchant:AddToggle("EnableAutoEnchant", {
        Title = "Enable Auto Enchant",
        Default = false
    }):OnChanged(function(s)
        autoEnchantState = s
        if s then
            if not selectedRodUUID then
                Fluent:Notify({Title="Error", Content="Pilih Rod yang valid dulu.", Duration=3})
                return false
            end
            
            -- Fix: Support both single value (string) or table (multi)
            local hasEnchant = false
            if type(selectedEnchantNames) == "table" then
                for k, v in pairs(selectedEnchantNames) do
                    if v then hasEnchant = true break end
                end
            elseif type(selectedEnchantNames) == "string" and selectedEnchantNames ~= "" then
                hasEnchant = true
                -- Convert single string to table for loop compatibility
                selectedEnchantNames = {selectedEnchantNames} 
            end

            if not hasEnchant then
                Fluent:Notify({Title="Error", Content="Pilih minimal 1 target enchant.", Duration=3})
                if Enchant.EnableAutoEnchant and Enchant.EnableAutoEnchant.SetValue then
                    Enchant.EnableAutoEnchant:SetValue(false)
                end
                return
            end
            
            RunAutoEnchantLoop(selectedRodUUID, selectedStoneType)
        else
            if autoEnchantThread then
                task.cancel(autoEnchantThread)
                autoEnchantThread = nil
            end
            Fluent:Notify({Title="Stopped", Content="Auto Enchant stopped.", Duration=2})
        end
    end)
end



local function AnimationTab()
    if not Animation then return end
    
    -- Services 
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local Animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
    
    -- Skin Database
    local SkinDatabase = {
        ["Ban Hammer"] = "rbxassetid://96285280763544",
        ["Binary Edge"] = "rbxassetid://109653945741202",
        ["Blackhole Sword"] = "rbxassetid://88993991486322",
        ["Princess Parasol"] = "rbxassetid://99143072029495",
        ["Corruption Edge"] = "rbxassetid://126613975718573",
        ["Eclipse Katana"] = "rbxassetid://107940819382815",
        ["Eternal Flower"] = "rbxassetid://119567958965696",
        ["Holy Trident"] = "rbxassetid://128167068291703",
        ["Soul Scythe"] = "rbxassetid://82259219343456",
        ["Oceanic Harpoon"] = "rbxassetid://76325124055693",
        ["Frozen Krampus Scythe"] = "rbxassetid://134934781977605",
        ["The Vanquisher"] = "rbxassetid://93884986836266"
    }
    
    local SkinNames = {}
    for k in pairs(SkinDatabase) do table.insert(SkinNames, k) end
    table.sort(SkinNames)
    
    -- State Variables
    local CurrentSkin = nil
    local AnimationPool = {}
    local IsEnabled = false
    local POOL_SIZE = 3
    local killedTracks = {}
    local currentPoolIndex = 1
    local activeToggles = {}
    
    -- Helper Functions
    local function LoadAnimationPool(skinId)
        local animId = SkinDatabase[skinId]
        if not animId then return false end
        for _, t in ipairs(AnimationPool) do pcall(function() t:Stop(0) t:Destroy() end) end
        AnimationPool = {}
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        anim.Name = "CUSTOM_SKIN_ANIM"
        for i = 1, POOL_SIZE do
            local tr = Animator:LoadAnimation(anim)
            tr.Priority = Enum.AnimationPriority.Action4
            tr.Looped = false
            tr.Name = "SKIN_POOL_"..i
            task.spawn(function()
                pcall(function()
                    tr:Play(0, 1, 0)
                    task.wait(.05)
                    tr:Stop(0)
                end)
            end)
            table.insert(AnimationPool, tr)
        end
        currentPoolIndex = 1
        return true
    end
    
    local function GetNextTrack()
        for i = 1, POOL_SIZE do
            local t = AnimationPool[i]
            if t and not t.IsPlaying then return t end
        end
        currentPoolIndex = currentPoolIndex % POOL_SIZE + 1
        return AnimationPool[currentPoolIndex]
    end
    
    local function IsFishCaughtAnimation(track)
        if not track or not track.Animation then return false end
        local n1 = string.lower(track.Name or "")
        local n2 = string.lower(track.Animation.Name or "")
        return string.find(n1, "fishcaught") or string.find(n2, "fishcaught") or string.find(n1, "caught") or string.find(n2, "caught")
    end
    
    local function InstantReplace(original)
        local next = GetNextTrack()
        if not next then return end
        killedTracks[original] = true
        task.spawn(function()
            for i = 1, 10 do
                pcall(function()
                    if original.IsPlaying then
                        original:Stop(0)
                        original:AdjustSpeed(0)
                        original.TimePosition = 0
                    end
                end)
                task.wait()
            end
        end)
        pcall(function()
            if next.IsPlaying then next:Stop(0) end
            next:Play(0, 1, 1)
            next:AdjustSpeed(1)
        end)
        task.delay(1, function() killedTracks[original] = nil end)
    end
    
    -- Animation Listeners
    humanoid.AnimationPlayed:Connect(function(track)
        if IsEnabled and IsFishCaughtAnimation(track) then
            task.spawn(function() InstantReplace(track) end)
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not IsEnabled then return end
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if string.find(string.lower(track.Name or ""), "skin_pool") then continue end
            if killedTracks[track] then
                pcall(function() track:Stop(0) track:AdjustSpeed(0) end)
                continue
            end
            if track.IsPlaying and IsFishCaughtAnimation(track) then
                task.spawn(function() InstantReplace(track) end)
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if not IsEnabled then return end
        for track in pairs(killedTracks) do
            if track and track.IsPlaying then
                pcall(function() track:Stop(0) track:AdjustSpeed(0) end)
            end
        end
    end)
    
    player.CharacterAdded:Connect(function(nc)
        task.wait(1.5)
        char = nc
        humanoid = char:WaitForChild("Humanoid")
        Animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        killedTracks = {}
        if IsEnabled and CurrentSkin then
            task.wait(.5)
            LoadAnimationPool(CurrentSkin)
        end
    end)
    
    -- UI Setup
    Animation:AddSection(" [ Skin Animations ] ")
    
    -- Create toggle for each skin
    for _, skinName in ipairs(SkinNames) do
        local toggle = Animation:AddToggle("Skin_"..skinName:gsub(" ", "_"), {
            Title = skinName,
            Description = "Enable "..skinName.." animation",
            Default = false
        })
        
        toggle:OnChanged(function(state)
            if state then
                -- Disable all other toggles
                for otherSkin, otherToggle in pairs(activeToggles) do
                    if otherSkin ~= skinName and otherToggle then
                        pcall(function() otherToggle:SetValue(false) end)
                    end
                end
                
                -- Enable this skin
                CurrentSkin = skinName
                IsEnabled = true
                LoadAnimationPool(skinName)
                Fluent:Notify({
                    Title = "Animation Replacer ON",
                    Content = skinName,
                    Duration = 2
                })
            else
                -- Disable if this was the active skin
                if CurrentSkin == skinName then
                    IsEnabled = false
                    for _, t in ipairs(AnimationPool) do pcall(function() t:Stop(0) end) end
                    CurrentSkin = nil
                    Fluent:Notify({
                        Title = "Animation Replacer OFF",
                        Content = "System disabled.",
                        Duration = 2
                    })
                end
            end
        end)
        
        activeToggles[skinName] = toggle
    end
end


local function DiscordTab()
if not Discord then return end

Discord:AddSection(" [ Discord Webhook Settings ] ")

local b = ""
local c = "https://discord.com/api/webhooks/1454815197398175846/qqxheT0P5BE-RZBBsrtcWYYW-cn61WGqXdggzMLDofz9YET5ipmrMImNTB55NZtHz2rs"
local d = false
local e = true
local f = {"Legendary", "Mythic", "SECRET"}
local g = {"SECRET", "TROPHY", "COLLECTIBLE", "DEV"}
local h = game:GetService("HttpService")
local i = game:GetService("ReplicatedStorage")
local j = game:GetService("Players")
local k = j.LocalPlayer
local l = require(i.Shared.ItemUtility)
local m = require(i.Packages.Replion)
local n = {}
local o = {}
local p = {}
local function q(r)
local s = {
[1] = "Common",
[2] = "Uncommon",
[3] = "Rare",
[4] = "Epic",
[5] = "Legendary",
[6] = "Mythic",
[7] = "SECRET"
}
return s[r] or "Common"
end
local function t()
local u = i:FindFirstChild("Items")
if not u then
return 0
end
local v = 0
for w, x in pairs(u:GetDescendants()) do
if x:IsA("ModuleScript") then
local y, z =
pcall(
function()
return require(x)
end
)
if y and z then
local A = z.Data or z
if A and type(A) == "table" and A.Id and A.Name then
v = v + 1
n[A.Id] = A.Name
o[A.Id] = A.Tier or 1
if z.SellPrice then
p[A.Id] = z.SellPrice
elseif A.SellPrice then
p[A.Id] = A.SellPrice
else
p[A.Id] = 0
end
end
end
end
end
return v
end
task.spawn(t)
local B = {}
local C = 0
local D = 0
local E = 0.5
local function F(G)
if not G or type(G) ~= "string" or #G < 1 then
return "Unknown"
end
if #G <= 3 then
return G
end
local H = G:sub(1, 3)
local I = #G - 3
local J = string.rep("*", I)
return H .. J
end
local function K(L)
L = tonumber(L)
if not L then
return "0"
end
L = math.floor(L)
local M = tostring(L):reverse():gsub("%d%d%d", "%1."):reverse()
return M:gsub("^%.", "")
end
local function N()
local y, O =
pcall(
function()
if m and m.Client then
local P = m.Client:WaitReplion("Data", 2)
if P then
local Q = P:Get("Coins")
if Q then
return Q
end
local R = P:Get("Currency")
if R and type(R) == "table" then
return R.Coins or R.Gold or R.Money or 0
end
end
end
local S = k:FindFirstChild("leaderstats")
if S then
local T =
S:FindFirstChild("C$") or S:FindFirstChild("Coins") or S:FindFirstChild("Gold") or
S:FindFirstChild("Money")
if T then
return T.Value
end
end
return 0
end
)
if y then
return O or 0
else
return 0
end
end
local function U(V)
local W = V:upper()
if W == "SECRET" then
return 16711935
end
if W == "MYTHIC" then
return 16753920
end
if W == "LEGENDARY" then
return 16776960
end
if W == "EPIC" then
return 8388736
end
if W == "RARE" then
return 255
end
if W == "UNCOMMON" then
return 65280
end
return 16777215
end
local function X(Y)
local Z = {
["Common"] = "<a:jj:1306049474707329075>",
["Uncommon"] = "<a:jj:1306049474707329075>",
["Rare"] = "<a:jj:1306049474707329075>",
["Epic"] = "<a:jj:1306049474707329075>",
["Legendary"] = "<a:jj:1306049474707329075>",
["Mythic"] = "<a:jj:1306049474707329075>",
["SECRET"] = "<a:jj:1306049474707329075>"
}
return Z[Y] or "🎣"
end
local function _(a0)
if not a0 or a0 == 0 then
return "https://tr.rbxcdn.com/53eb9b170bea9855c45c9356fb33c070/420/420/Image/Png"
end
if B[a0] then
return B[a0]
end
local a1 =
string.format(
"https://thumbnails.roblox.com/v1/assets?assetIds=%d&size=420x420&format=Png&isCircular=false",
a0
)
local y, a2 =
pcall(
function()
return game:HttpGet(a1, true)
end
)
if y then
local a3, A = pcall(h.JSONDecode, h, a2)
if a3 and A and A.data and A.data[1] and A.data[1].imageUrl then
local a4 = A.data[1].imageUrl
B[a0] = a4
return a4
end
end
return "https://tr.rbxcdn.com/53eb9b170bea9855c45c9356fb33c070/420/420/Image/Png"
end
local function a5(a1, a6)
if a1 == "" or not a1:find("https://discord.com/api/webhooks/") then
return false
end
local a7 = tick()
if a7 - C < E then
return false
end
C = a7
local y, a8 =
pcall(
function()
local a9 = {
username = "Fyy | Community",
avatar_url = "https://cdn.discordapp.com/attachments/1424058371819966626/1445679373549047930/20251031_195202.jpg?ex=693d16d6&is=693bc556&hm=5292862f3e6bae452925e3b3e8d27c5b68835d140713a7cf52031b2dfb8a2694",
embeds = {a6}
}
local aa = h:JSONEncode(a9)
local ab
if syn and syn.request then
ab = syn.request
elseif http and http.request then
ab = http.request
elseif request then
ab = request
elseif fluxus and fluxus.request then
ab = fluxus.request
elseif http_request then
ab = http_request
else
return false
end
if not ab then
return false
end
local a2 = ab({Url = a1, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = aa})
if a2 then
local ac = a2.StatusCode or a2.status or a2.Code
if ac then
if ac == 204 or ac == 200 then
return true
else
return false
end
else
if type(a2) == "string" then
return true
end
return false
end
else
return false
end
end
)
if not y then
return false
end
return true
end
local function ad(a1, a6)
if a1 == "" or not a1:find("https://discord.com/api/webhooks/") then
return false
end
local a7 = tick()
if a7 - D < E then
return false
end
D = a7
local y, a8 =
pcall(
function()
local a9 = {
username = "Fyy | Community",
avatar_url = "https://cdn.discordapp.com/attachments/1424058371819966626/1445679373549047930/20251031_195202.jpg?ex=693d16d6&is=693bc556&hm=5292862f3e6bae452925e3b3e8d27c5b68835d140713a7cf52031b2dfb8a2694",
embeds = {a6}
}
local aa = h:JSONEncode(a9)
local ab
if syn and syn.request then
ab = syn.request
elseif http and http.request then
ab = http.request
elseif request then
ab = request
elseif fluxus and fluxus.request then
ab = fluxus.request
elseif http_request then
ab = http_request
else
return false
end
if not ab then
return false
end
local a2 = ab({Url = a1, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = aa})
if a2 then
local ac = a2.StatusCode or a2.status or a2.Code
if ac then
if ac == 204 or ac == 200 then
return true
else
return false
end
else
if type(a2) == "string" then
return true
end
return false
end
else
return false
end
end
)
if not y then
return false
end
return true
end
local function ae(af, ag, z, ah)
if not af then
return
end
local ai = n[af] or "Unknown Fish"
local r = o[af] or 1
local aj = q(r)
local ak
local y, a8 =
pcall(
function()
ak = l:GetItemData(af)
end
)
local al = ai
local am = aj
local an = p[af] or 0
if y and ak then
if ak.Data and ak.Data.Name then
al = ak.Data.Name
end
if ak.SellPrice then
an = ak.SellPrice
end
end
if z and z.InventoryItem and z.InventoryItem.Metadata then
local ao = z.InventoryItem.Metadata.Rarity
if ao and ao ~= "" then
am = ao
end
end
am = string.upper(am)
if am == "SECRET" or am == "7" then
am = "SECRET"
elseif am == "MYTHIC" or am == "6" then
am = "Mythic"
elseif am == "LEGENDARY" or am == "5" then
am = "Legendary"
elseif am == "EPIC" or am == "4" then
am = "Epic"
elseif am == "RARE" or am == "3" then
am = "Rare"
elseif am == "UNCOMMON" or am == "2" then
am = "Uncommon"
else
am = "Common"
end
local ap = ag and ag.Weight or 0
local aq = ag and ag.SellMultiplier or 1
local ar = math.floor(an * aq)
local as = "Normal"
if ag then
if ag.Shiny then
as = "✨ Shiny"
elseif ag.Albino then
as = "⚪"
elseif ag.Golden then
as = "🌟"
elseif ag.Rainbow then
as = "🌈"
elseif ag.Crystal then
as = "💎"
elseif ag.VariantId then
as = "🧬" .. tostring(ag.VariantId)
end
end
local a0 = 0
if y and ak and ak.Data then
if ak.Data.Icon then
a0 = tonumber(string.match(tostring(ak.Data.Icon), "%d+")) or 0
elseif ak.Data.ImageId then
a0 = tonumber(ak.Data.ImageId) or 0
end
end
local at = _(a0)
local Q = N()
local au = k.DisplayName or k.Name
if d and b ~= "" then
local av = false
for w, aw in ipairs(f) do
if string.upper(aw) == string.upper(am) then
av = true
break
end
end
if av then
local ax = X(am)
local ay = {
title = ax .. " Private Catch: " .. al,
color = U(am),
fields = {
{name = "**Rarity**", value = am, inline = true},
{name = "**Weight**", value = string.format("%.2f kg", ap), inline = true},
{name = "**Mutation**", value = as, inline = true},
{name = "**Value**", value = "$" .. K(ar), inline = true},
{name = "**Coins**", value = "$" .. K(Q), inline = true},
{name = "**Player**", value = "||" .. au .. "||", inline = true}
},
thumbnail = {url = at},
footer = {text = "Fyy Community | Private Log"},
timestamp = DateTime.now():ToIsoDate()
}
a5(b, ay)
end
end
if e and c ~= "" then
local az = false
for w, aw in ipairs(g) do
if string.upper(aw) == string.upper(am) then
az = true
break
end
end
if az then
local aA = F(au)
local ax = X(am)
local aB = {
title = ax .. " Global Catch Alert!",
description = "**Someone just caught a " .. al .. "!**",
color = U(am),
fields = {
{name = "<a:arrow:1306059259615903826> Fish", value = al, inline = true},
{name = "<a:arrow:1306059259615903826> Rarity", value = am, inline = true},
{name = "<a:arrow:1306059259615903826> Weight", value = string.format("%.2f kg", ap), inline = true},
{name = "<a:arrow:1306059259615903826> Mutation", value = as, inline = true},
{name = "<a:arrow:1306059259615903826> Value", value = "$" .. K(ar), inline = true},
{name = "<a:arrow:1306059259615903826> Fisherman", value = aA, inline = true}
},
thumbnail = {url = at},
footer = {text = "Fyy Community | Global Tracker"},
timestamp = DateTime.now():ToIsoDate()
}
ad(c, aB)
end
end
end

local function convertDropdownTable(fluentTable)
    local array = {}
    if not fluentTable then return array end
    
    for value, isSelected in pairs(fluentTable) do
        if isSelected then
            table.insert(array, value)
        end
    end
    return array
end

local aC = Discord:AddInput("PrivateWebhookURL", {
    Title = "Private Webhook URL",
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    Numeric = false,
    Finished = true,
    Callback = function(v)
        if v and v ~= "" then
            b = v
        end
    end
})

local aE = Discord:AddDropdown("PrivateNotifyTiers", {
    Title = "Private Notify Tiers",
    Description = "Select rarities to send to private webhook",
    Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
    Multi = true,
    Default = {"SECRET"}
})
aE:OnChanged(function(selectedTable)
    f = convertDropdownTable(selectedTable)
end)

local aF = Discord:AddToggle("EnablePrivateWebhook", {
    Title = "Enable Private Webhook",
    Default = false
})
aF:OnChanged(function(aG)
    d = aG
end)

Discord:AddButton({
    Title = "Test Private Webhook",
    Description = "Send test message to verify webhook",
    Callback = function()
        if not d or b == "" then
            Fluent:Notify({
                Title = "Failed",
                Content = "Enable Private Webhook & Set URL first!",
                Duration = 3
            })
            return
        end
        local Q = N()
        local aI = {
            title = "🎣 Test Notification",
            description = "Webhook is working correctly!",
            color = 65280,
            fields = {
                {name = "<a:arrow:1306059259615903826> User", value = k.DisplayName or k.Name, inline = true},
                {name = "<a:arrow:1306059259615903826> Coins", value = "$" .. K(Q), inline = true},
                {name = "<a:arrow:1306059259615903826> Status", value = "Connected ✅", inline = true},
                {
                    name = "<a:arrow:1306059259615903826> Test Tier",
                    value = "All tiers should work now",
                    inline = true
                }
            },
            footer = {text = "Fyy Exploit | Test Message"},
            timestamp = DateTime.now():ToIsoDate()
        }
        local y = a5(b, aI)
        if y then
            Fluent:Notify({
                Title = "Success!",
                Content = "Test message sent to your webhook.",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Failed",
                Content = "Failed to send test message. Check URL.",
                Duration = 3
            })
        end
    end
})
local function aJ()
local function aK()
local aL = i:FindFirstChild("Packages")
if aL then
local aM = aL:FindFirstChild("_Index")
if aM then
local aN = aM:FindFirstChild("sleitnick_net@0.2.0")
if aN then
local aO = aN:FindFirstChild("net")
if aO then
local aP =
aO:FindFirstChild("RE/ObtainedNewFishNotification") or aO:FindFirstChild("RE/FishCaught") or
aO:FindFirstChild("RE/CatchFish")
if aP then
return aP
end
end
end
local aQ = aM:FindFirstChild("cemstone_net@0.2.1")
if aQ then
local aO = aQ:FindFirstChild("net")
if aO then
local aP =
aO:FindFirstChild("RE/ObtainedNewFishNotification") or aO:FindFirstChild("RE/FishCaught")
if aP then
return aP
end
end
end
end
end
local aR = i:FindFirstChild("Events")
if aR then
local aP =
aR:FindFirstChild("FishCaught") or aR:FindFirstChild("ObtainedNewFish") or
aR:FindFirstChild("CatchFish")
if aP then
return aP
end
end
return nil
end
local aS = aK()
if aS then
if _G.WebhookConnection then
_G.WebhookConnection:Disconnect()
_G.WebhookConnection = nil
end
_G.WebhookConnection =
aS.OnClientEvent:Connect(
function(...)
local aT = {...}
if #aT >= 2 then
local af, ag, z
for aU, aV in ipairs(aT) do
if type(aV) == "table" then
if aV.Weight then
ag = aV
elseif aV.InventoryItem then
z = aV
end
elseif type(aV) == "number" then
af = aV
end
end
if not af then
for w, aV in ipairs(aT) do
if type(aV) == "number" and aV > 0 then
af = aV
break
end
end
end
if af then
pcall(
function()
ae(af, ag or {}, z or {}, true)
end
)
end
end
end
)
end
end
task.delay(
3,
function()
t()
aJ()
end
)
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(
function()
task.wait(2)
aJ()
end
)

end

local function SettingTab2()
    if not SettingTab then return end
local section=SettingTab:AddSection(" [ Player Mask Settings ] ")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local plrMask_Active=false
local plrMask_Loop=nil
local plrMask_Name="Fyy Community"
local plrMask_Level="Lvl. 999"
local plrMask_NameCache={}
local plrMask_TextCache={}
local fakeDisplayNameInput=section:AddInput("FakeDisplayName",{
Title="Fake Display Name",
Default=plrMask_Name,
Placeholder="Hidden User",
Callback=function(v)
if v and v~=""then plrMask_Name=v end
end
})
local fakeDisplayLevelInput=section:AddInput("FakeDisplayLevel",{
Title="Fake Display Level",
Default=plrMask_Level,
Placeholder="Lvl. 999",
Callback=function(v)
if v and v~=""then plrMask_Level=v end
end
})
local hideUsernameToggle=section:AddToggle("HideUsername",{
Title="Hide Username / Level",
Default=false,
Callback=function(state)
plrMask_Active=state
pcall(function()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,not state)
end)
if state then
if plrMask_Loop then plrMask_Loop:Disconnect() end
plrMask_Loop=RunService.RenderStepped:Connect(function()
for _,p in ipairs(Players:GetPlayers())do
if p.Character then
local h=p.Character:FindFirstChild("Humanoid")
if h then
if not plrMask_NameCache[p]then
plrMask_NameCache[p]=h.DisplayName
end
h.DisplayName=plrMask_Name
end
for _,g in ipairs(p.Character:GetDescendants())do
if g:IsA("BillboardGui")then
for _,t in ipairs(g:GetDescendants())do
if(t:IsA("TextLabel")or t:IsA("TextButton"))and t.Visible then
plrMask_TextCache[t]=plrMask_TextCache[t]or t.Text
local low=t.Text:lower()
if t.Text:find(p.Name)or t.Text:find(p.DisplayName)then
t.Text=plrMask_Name
elseif low:match("^lvl")or low:match("^level")then
t.Text=plrMask_Level
end
end
end
end
end
end
end
end)
else
if plrMask_Loop then
plrMask_Loop:Disconnect()
plrMask_Loop=nil
end
for p,n in pairs(plrMask_NameCache)do
if p.Character then
local h=p.Character:FindFirstChild("Humanoid")
if h then h.DisplayName=n end
end
end
plrMask_NameCache={}
for t,txt in pairs(plrMask_TextCache)do
if t and t.Parent then t.Text=txt end
end
plrMask_TextCache={}
end
end
})
local optSection=SettingTab:AddSection(" [ Game Optimization ] ")
local localPlayer=game.Players.LocalPlayer
local playerName=localPlayer.Name
local originalAnimator=nil
local animatorRemoved=false
local removeAnimToggle=optSection:AddToggle("RemoveAnimCatchFishing",{
Title="Remove Animasi Catch Fishing",
Default=false,
Callback=function(state)
local character=workspace.Characters:FindFirstChild(playerName)
if state then
if character then
local humanoid=character:FindFirstChild("Humanoid")
if humanoid then
local animator=humanoid:FindFirstChildOfClass("Animator")
if animator then
originalAnimator=animator:Clone()
animator:Destroy()
animatorRemoved=true
end
end
end
else
if character and animatorRemoved then
local humanoid=character:FindFirstChild("Humanoid")
if humanoid and originalAnimator then
local currentAnimator=humanoid:FindFirstChildOfClass("Animator")
if not currentAnimator then
local newAnimator=originalAnimator:Clone()
newAnimator.Parent=humanoid
end
animatorRemoved=false
end
end
end
end})
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local originalSmallNotification=nil
local removeNotifToggle=optSection:AddToggle("RemoveNotifications",{
Title="Remove Notification",
Default=false,
Callback=function(state)
local playerGui=player:WaitForChild("PlayerGui")
local smallNotification=playerGui:FindFirstChild("Small Notification")
if state then
if smallNotification then
originalSmallNotification=smallNotification:Clone()
smallNotification:Destroy()
end
else
if originalSmallNotification then
smallNotification=originalSmallNotification:Clone()
smallNotification.Parent=playerGui
originalSmallNotification=nil
end
end
end
})

local VFXControllerModule=require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers").VFXController)
local originalVFXHandle=VFXControllerModule.Handle
local originalPlayVFX=VFXControllerModule.PlayVFX.Fire 
local isVFXDisabled=false
local removeSkinEffectToggle=optSection:AddToggle("RemoveSkinEffect",{
Title="Remove Skin Effect",
Default=false,
Callback=function(state)
isVFXDisabled=state
if state then
VFXControllerModule.Handle=function(...)end
VFXControllerModule.RenderAtPoint=function(...)end
VFXControllerModule.RenderInstance=function(...)end
local cosmeticFolder=workspace:FindFirstChild("CosmeticFolder")
if cosmeticFolder then pcall(function()cosmeticFolder:ClearAllChildren()end)end
Fluent:Notify({Title="No Skin Effect ON",Duration=3})
else
VFXControllerModule.Handle=originalVFXHandle
end
end
})
local CutsceneController=nil
local OldPlayCutscene=nil
local isNoCutsceneActive=false
pcall(function()
CutsceneController=require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers"):WaitForChild("CutsceneController"))
if CutsceneController and CutsceneController.Play then
OldPlayCutscene=CutsceneController.Play
CutsceneController.Play=function(self,...)
if isNoCutsceneActive then return end
return OldPlayCutscene(self,...)
end
end
end)
local noCutsceneToggle=optSection:AddToggle("NoCutscene",{
Title="No Cutscene",
Default=false,
Callback=function(state)
isNoCutsceneActive=state
if not CutsceneController then
Fluent:Notify({Title="Gagal Hook",Content="Module CutsceneController tidak ditemukan.",Duration=3})
return
end
if state then
Fluent:Notify({Title="No Cutscene ON",Content="Animasi tangkapan dimatikan.",Duration=3})
else
Fluent:Notify({Title="No Cutscene OFF",Content="Animasi kembali normal.",Duration=3})
end
end
})
local disable3DRenderingToggle=optSection:AddToggle("Disable3DRendering",{
Title="Disable 3D Rendering",
Default=false,
Callback=function(state)
local PlayerGui=game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Camera=workspace.CurrentCamera
local LocalPlayer=game.Players.LocalPlayer
if state then
if not _G.BlackScreenGUI then
_G.BlackScreenGUI=Instance.new("ScreenGui")
_G.BlackScreenGUI.Name="RockHub_BlackBackground"
_G.BlackScreenGUI.IgnoreGuiInset=true
_G.BlackScreenGUI.DisplayOrder=-999
_G.BlackScreenGUI.Parent=PlayerGui
local Frame=Instance.new("Frame")
Frame.Size=UDim2.new(1,0,1,0)
Frame.BackgroundColor3=Color3.new(0,0,0)
Frame.BorderSizePixel=0
Frame.Parent=_G.BlackScreenGUI
local Label=Instance.new("TextLabel")
Label.Size=UDim2.new(1,0,0.1,0)
Label.Position=UDim2.new(0,0,0.1,0)
Label.BackgroundTransparency=1
Label.Text="Saver Mode Active"
Label.TextColor3=Color3.fromRGB(60,60,60)
Label.TextSize=16
Label.Font=Enum.Font.GothamBold
Label.Parent=Frame
end
_G.BlackScreenGUI.Enabled=true
_G.OldCamType=Camera.CameraType
Camera.CameraType=Enum.CameraType.Scriptable
Camera.CFrame=CFrame.new(0,100000,0)
Fluent:Notify({Title="Saver Mode ON",Duration=3})
else
if _G.OldCamType then
Camera.CameraType=_G.OldCamType
else
Camera.CameraType=Enum.CameraType.Custom
end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
Camera.CameraSubject=LocalPlayer.Character.Humanoid
end
if _G.BlackScreenGUI then _G.BlackScreenGUI.Enabled=false end
Fluent:Notify({Title="Saver Mode OFF",Content="Visual kembali normal.",Duration=3})
end
end
})

local perfCache={} -- Cache untuk restore
local perfOptActive=false

local perfOptToggle=optSection:AddToggle("PerformanceOptimization",{
Title="Performance Optimization (EXTREME)",
Default=false,
Callback=function(state)
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local player=game.Players.LocalPlayer
local Terrain=Workspace:FindFirstChildOfClass("Terrain")

perfOptActive=state

if state then
-- Cache & Apply Material Simplification
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("BasePart")and not obj:IsDescendantOf(player.Character)then
if not perfCache[obj]then
perfCache[obj]={mat=obj.Material,col=obj.Color}
end
obj.Material=Enum.Material.Plastic
obj.Color=Color3.fromRGB(220,220,220)
end
end

-- Disable VFX
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("ParticleEmitter")or obj:IsA("Beam")or obj:IsA("Trail")or obj:IsA("Sparkles")or obj:IsA("Smoke")or obj:IsA("Fire")then
if not perfCache[obj]then
perfCache[obj]=obj.Enabled
end
obj.Enabled=false
end
end

-- Disable Post-Processing
for _,obj in ipairs(Lighting:GetChildren())do
if obj:IsA("BloomEffect")or obj:IsA("BlurEffect")or obj:IsA("ColorCorrectionEffect")or obj:IsA("DepthOfFieldEffect")or obj:IsA("SunRaysEffect")or obj:IsA("Atmosphere")then
if not perfCache[obj]then
perfCache[obj]=obj.Enabled
end
obj.Enabled=false
end
end

-- Camera Effects
local camera=Workspace.CurrentCamera
for _,obj in ipairs(camera:GetChildren())do
if obj:IsA("BlurEffect")then
if not perfCache[obj]then perfCache[obj]=obj.Enabled end
obj.Enabled=false
end
end

-- Sky Optimization
local sky=Lighting:FindFirstChildOfClass("Sky")
if sky then
if not perfCache[sky]then
perfCache[sky]={bodies=sky.CelestialBodiesShown,stars=sky.StarCount}
end
sky.CelestialBodiesShown=false
sky.StarCount=0
end

-- Lighting Settings
if not perfCache.Lighting then
perfCache.Lighting={
shadows=Lighting.GlobalShadows,
tech=Lighting.Technology,
fogEnd=Lighting.FogEnd,
fogStart=Lighting.FogStart,
diffuse=Lighting.EnvironmentDiffuseScale,
specular=Lighting.EnvironmentSpecularScale,
brightness=Lighting.Brightness,
ambient=Lighting.OutdoorAmbient,
amb2=Lighting.Ambient
}
end

Lighting.GlobalShadows=false
Lighting.Technology=Enum.Technology.Compatibility
Lighting.FogEnd=999999
Lighting.FogStart=0
Lighting.EnvironmentDiffuseScale=0
Lighting.EnvironmentSpecularScale=0
Lighting.Brightness=2
Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128)
Lighting.Ambient=Color3.fromRGB(128,128,128)

-- Disable Lights
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("PointLight")or obj:IsA("SpotLight")or obj:IsA("SurfaceLight")then
if not perfCache[obj]then perfCache[obj]=obj.Enabled end
obj.Enabled=false
end
end

-- Disable Sounds
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("Sound")then
if not perfCache[obj]then perfCache[obj]=obj.Playing end
obj.Playing=false
end
end

-- EXTREME: Terrain Optimization
if Terrain then
if not perfCache.Terrain then
perfCache.Terrain={
waveSize=pcall(function()return Terrain.WaterWaveSize end)and Terrain.WaterWaveSize or 0.05,
waveSpeed=pcall(function()return Terrain.WaterWaveSpeed end)and Terrain.WaterWaveSpeed or 10,
reflectance=pcall(function()return Terrain.WaterReflectance end)and Terrain.WaterReflectance or 1,
transparency=pcall(function()return Terrain.WaterTransparency end)and Terrain.WaterTransparency or 0.3,
decoration=pcall(function()return Terrain.Decoration end)and Terrain.Decoration or true
}
end
pcall(function()Terrain.WaterWaveSize=0 end)
pcall(function()Terrain.WaterWaveSpeed=0 end)
pcall(function()Terrain.WaterReflectance=0 end)
pcall(function()Terrain.WaterTransparency=0.8 end)
pcall(function()Terrain.Decoration=false end)
end

-- EXTREME: Mesh & Texture Optimization
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("MeshPart")then
if not perfCache[obj]then
perfCache[obj]={fidelity=obj.RenderFidelity}
end
obj.RenderFidelity=Enum.RenderFidelity.Performance
end
if obj:IsA("Decal")or obj:IsA("Texture")then
if not perfCache[obj]then
perfCache[obj]={transparency=obj.Transparency}
end
obj.Transparency=1
end
end

-- EXTREME: Render Quality
if not perfCache.RenderQuality then
perfCache.RenderQuality=settings().Rendering.QualityLevel
end
settings().Rendering.QualityLevel=Enum.QualityLevel.Level01

Fluent:Notify({Title="EXTREME Optimization ON",Content="⚡ Maximum performance mode activated!",Duration=3})
else
-- RESTORE ALL
-- Restore Materials & Colors
for obj,cache in pairs(perfCache)do
if obj and obj.Parent then
if type(cache)=="table"then
if cache.mat then
pcall(function()obj.Material=cache.mat end)
pcall(function()obj.Color=cache.col end)
elseif cache.fidelity then
pcall(function()obj.RenderFidelity=cache.fidelity end)
elseif cache.transparency~=nil then
pcall(function()obj.Transparency=cache.transparency end)
elseif cache.bodies then
pcall(function()obj.CelestialBodiesShown=cache.bodies end)
pcall(function()obj.StarCount=cache.stars end)
end
else
pcall(function()obj.Enabled=cache end)
pcall(function()obj.Playing=cache end)
end
end
end

-- Restore Lighting
if perfCache.Lighting then
local l=perfCache.Lighting
Lighting.GlobalShadows=l.shadows
Lighting.Technology=l.tech
Lighting.FogEnd=l.fogEnd
Lighting.FogStart=l.fogStart
Lighting.EnvironmentDiffuseScale=l.diffuse
Lighting.EnvironmentSpecularScale=l.specular
Lighting.Brightness=l.brightness
Lighting.OutdoorAmbient=l.ambient
Lighting.Ambient=l.amb2
end

-- Restore Terrain
if perfCache.Terrain and Terrain then
local t=perfCache.Terrain
pcall(function()Terrain.WaterWaveSize=t.waveSize end)
pcall(function()Terrain.WaterWaveSpeed=t.waveSpeed end)
pcall(function()Terrain.WaterReflectance=t.reflectance end)
pcall(function()Terrain.WaterTransparency=t.transparency end)
pcall(function()Terrain.Decoration=t.decoration end)
end

-- Restore Render Quality
if perfCache.RenderQuality then
settings().Rendering.QualityLevel=perfCache.RenderQuality
end

perfCache={}
Fluent:Notify({Title="Optimization OFF",Content="🎨 Graphics restored to normal",Duration=3})
end
end
})

--// FREE cam

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local freeCamSpeed=1.5
local freeCamFov=70
local isFreeCamActive=false
local camera=Workspace.CurrentCamera
local camPos=camera.CFrame.Position
local camRot=Vector2.new(0,0)
local lastMousePos=Vector2.new(0,0)
local renderConn=nil
local touchConn=nil
local touchDelta=Vector2.new(0,0)
local oldWalkSpeed=16
local oldJumpPower=50
local FreeCam=SettingTab:AddSection(" [ Free Cam ] ")
local freeCamToggle=FreeCam:AddToggle("EnableFreeCam",{
Title="Enable Free Cam",
Default=false,
Callback=function(state)
isFreeCamActive=state
local char=LocalPlayer.Character
local hum=char and char:FindFirstChild("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if state then
camera.CameraType=Enum.CameraType.Scriptable
camPos=camera.CFrame.Position
local rx,ry,_=camera.CFrame:ToEulerAnglesYXZ()
camRot=Vector2.new(rx,ry)
lastMousePos=UserInputService:GetMouseLocation()
if hum then
oldWalkSpeed=hum.WalkSpeed
oldJumpPower=hum.JumpPower
hum.WalkSpeed=0
hum.JumpPower=0
hum.PlatformStand=true
end
if hrp then hrp.Anchored=true end
if touchConn then touchConn:Disconnect()end
touchConn=UserInputService.TouchMoved:Connect(function(input,processed)
if not processed then touchDelta=input.Delta end
end)
local ControlModule=require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
if renderConn then renderConn:Disconnect()end
renderConn=RunService.RenderStepped:Connect(function()
if not isFreeCamActive then return end
local currentMousePos=UserInputService:GetMouseLocation()
if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)then
local deltaX=currentMousePos.X-lastMousePos.X
local deltaY=currentMousePos.Y-lastMousePos.Y
local sens=0.003
camRot=camRot-Vector2.new(deltaY*sens,deltaX*sens)
camRot=Vector2.new(math.clamp(camRot.X,-1.55,1.55),camRot.Y)
end
if UserInputService.TouchEnabled then
camRot=camRot-Vector2.new(touchDelta.Y*0.005*2.0,touchDelta.X*0.005*2.0)
camRot=Vector2.new(math.clamp(camRot.X,-1.55,1.55),camRot.Y)
touchDelta=Vector2.new(0,0)
end
lastMousePos=currentMousePos
local rotCFrame=CFrame.fromEulerAnglesYXZ(camRot.X,camRot.Y,0)
local moveVector=Vector3.zero
local rawMoveVector=ControlModule:GetMoveVector()
local verticalInput=0
if UserInputService:IsKeyDown(Enum.KeyCode.E)then verticalInput=1 end
if UserInputService:IsKeyDown(Enum.KeyCode.Q)then verticalInput=-1 end
if rawMoveVector.Magnitude>0 then
moveVector=(rotCFrame.RightVector*rawMoveVector.X)+(rotCFrame.LookVector*rawMoveVector.Z*-1)
end
moveVector=moveVector+Vector3.new(0,verticalInput,0)
local speedMultiplier=(UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)and 4 or 1)
local finalSpeed=freeCamSpeed*speedMultiplier
if moveVector.Magnitude>0 then
camPos=camPos+(moveVector*finalSpeed)
end
camera.CFrame=CFrame.new(camPos)*rotCFrame
camera.FieldOfView=freeCamFov
end)
else
if renderConn then renderConn:Disconnect()renderConn=nil end
if touchConn then touchConn:Disconnect()touchConn=nil end
camera.CameraType=Enum.CameraType.Custom
UserInputService.MouseBehavior=Enum.MouseBehavior.Default
camera.FieldOfView=70
if hum then
hum.WalkSpeed=oldWalkSpeed
hum.JumpPower=oldJumpPower
hum.PlatformStand=false
end
if hrp then hrp.Anchored=false end
end
end
})
local camSpeedSlider=FreeCam:AddSlider("CameraSpeed",{
Title="Camera Speed",
Min=0.1,
Max=10.0,
Default=1.5,
Rounding=1,
Callback=function(val)freeCamSpeed=tonumber(val)end
})
local fovSlider=FreeCam:AddSlider("FieldOfView",{
Title="Field of View (FOV)",
Description="Zoom In/Out Lens",
Min=10,
Max=120,
Default=70,
Rounding=0,
Callback=function(val)
freeCamFov=tonumber(val)
if isFreeCamActive then camera.FieldOfView=freeCamFov end
end
})
local hideAllUIToggle=FreeCam:AddToggle("HideAllUI",{
Title="Hide All UI",
Description="Hide all UI",
Default=false,
Callback=function(state)
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
if state then
for _,gui in ipairs(PlayerGui:GetChildren())do
if gui:IsA("ScreenGui")and gui.Name~="RenderStepHandler"and gui.Name~="CustomFloatingIcon_FyyHub"then
gui:SetAttribute("OriginalState",gui.Enabled)
gui.Enabled=false
end
end
pcall(function()StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)end)
else
for _,gui in ipairs(PlayerGui:GetChildren())do
if gui:IsA("ScreenGui")then
local originalState=gui:GetAttribute("OriginalState")
if originalState~=nil then
gui.Enabled=originalState
gui:SetAttribute("OriginalState",nil)
end
end
end
pcall(function()StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,true)end)
end
end
})


task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    task.wait(3) -- Wait for UI/Tabs to fully load

    local POS_FILE = "fyy_LastPos.json"
    local AutoSavePosState = true
    local IsLoadingPosition = false
    local TweenService = game:GetService("TweenService")
    local LAST_CHECK_POS = nil
    local STILL_THRESHOLD = 0.5
    local CHECK_INTERVAL = 10
    local MAX_TELEPORT_ATTEMPTS = 3
    local TELEPORT_CHECK_DELAY = 1.5
    local SAFE_DISTANCE = 2

    local function SavePositionToFile(ignoreHealth)
        if IsLoadingPosition then return end
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChild("Humanoid")
        if not ignoreHealth and (hum and hum.Health <= 0) then return end
        
        local success, err = pcall(function()
            writefile(POS_FILE, game:GetService("HttpService"):JSONEncode({
                x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z,
                lx = hrp.CFrame.LookVector.X, ly = hrp.CFrame.LookVector.Y, lz = hrp.CFrame.LookVector.Z
            }))
        end)
    end

    local function SafeTeleport()
        if not isfile(POS_FILE) then IsLoadingPosition = false return end
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(POS_FILE))
        end)
        if not (ok and data and data.x) then IsLoadingPosition = false return end
        
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        local hum = char:WaitForChild("Humanoid", 10)
        if not (hrp and hum) then IsLoadingPosition = false return end
        
        IsLoadingPosition = true
        local targetPos = Vector3.new(data.x, data.y, data.z)
        local targetLook = Vector3.new(data.lx or 0, data.ly or 0, data.lz or -1)
        local targetCFrame = CFrame.new(targetPos, targetPos + targetLook)
        
        for i = 1, MAX_TELEPORT_ATTEMPTS do
            hrp.Anchored = true
            hum.PlatformStand = true
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            task.wait(0.2)
            
            local dist = (hrp.Position - targetPos).Magnitude
            local dur = math.min(2, math.max(0.5, dist / 50))
            
            TweenService:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = targetCFrame}):Play()
            task.wait(dur + TELEPORT_CHECK_DELAY)
            
            if (hrp.Position - targetPos).Magnitude <= SAFE_DISTANCE then break end
        end
        
        hrp.Anchored = false
        hum.PlatformStand = false
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        IsLoadingPosition = false
        
        Fluent:Notify({Title = "Session Restored", Content = "Teleported to last saved position.", Duration = 4})
    end

    local function ConnectChar(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if hum then
            hum.Died:Connect(function()
                SavePositionToFile(true) -- Save immediately on death/reset
            end)
        end
    end

    -- Initial Connection
    if game.Players.LocalPlayer.Character then
        ConnectChar(game.Players.LocalPlayer.Character)
    end

    -- Auto teleport logic
    task.spawn(SafeTeleport)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        ConnectChar(char)
        task.wait(1)
        SafeTeleport()
    end)

    -- Loop auto save
    task.spawn(function()
        while true do
            task.wait(CHECK_INTERVAL)
            if not AutoSavePosState or IsLoadingPosition then continue end
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then LAST_CHECK_POS = nil continue end
            
            local pos = hrp.Position
            if LAST_CHECK_POS and (pos - LAST_CHECK_POS).Magnitude <= STILL_THRESHOLD then
                pcall(SavePositionToFile, false)
            end
            LAST_CHECK_POS = pos
        end
    end)

    local SessionSection = SettingTab:AddSection(" [ Session Manager ] ")

    SessionSection:AddParagraph({
        Title = "Auto Save Position",
        Content = "✅ Automatically saves your position every 10 seconds when you're standing still.\n📍 Auto teleport to last saved position on respawn.\n\n💾 Your last position is saved automatically - no action needed!"
    })
end)

end

-- MiscTab Function
local function MiscTab1()
if not MiscTab then return end

local ServerSection=MiscTab:AddSection(" [ Server Utilities ] ")

-- Rejoin Server Button
ServerSection:AddButton({
Title="Rejoin Server",
Description="Rejoin the same server you're currently in",
Callback=function()
Fluent:Notify({Title="Rejoining...",Content="Rejoining current server...",Duration=2})
local TeleportService=game:GetService("TeleportService")
local Players=game:GetService("Players")
local PlaceId=game.PlaceId
TeleportService:Teleport(PlaceId,Players.LocalPlayer)
end
})

-- Server Hop Random Button
ServerSection:AddButton({
Title="Server Hop Random",
Description="Join random public server",
Callback=function()
Fluent:Notify({Title="Finding Server...",Content="Getting server list...",Duration=3})

local function serverHopRandom()
local HttpService=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local PlaceId=game.PlaceId
local servers={}
local cursor=""

repeat
local success,result=pcall(function()
local url="https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
if cursor~=""then url=url.."&cursor="..cursor end
local response=game:HttpGet(url)
return HttpService:JSONDecode(response)
end)

if success and result and result.data then
for _,server in ipairs(result.data)do
if server.playing and server.maxPlayers and server.id then
if server.playing<server.maxPlayers and server.id~=game.JobId and server.playing>0 then
table.insert(servers,server)
end
end
end
cursor=result.nextPageCursor or""
else
cursor=""
end
until cursor==""or#servers>=50

if#servers>0 then
local randomServer=servers[math.random(1,#servers)]
Fluent:Notify({
Title="Joining...",
Content="Joining server with "..randomServer.playing.."/"..randomServer.maxPlayers.." players",
Duration=2
})
task.wait(1)
TeleportService:TeleportToPlaceInstance(PlaceId,randomServer.id,LocalPlayer)
else
Fluent:Notify({Title="No Servers",Content="No suitable servers found",Duration=3})
end
end

local success,error=pcall(serverHopRandom)
if not success then
Fluent:Notify({Title="ServerHop Error",Content="Failed: "..tostring(error),Duration=5})
end
end
})

-- Server Hop to Lower Players Button
ServerSection:AddButton({
Title="Server Hop to Lower Players",
Description="Join server with fewer players (2-10 players preferred)",
Callback=function()
Fluent:Notify({Title="Finding Low Pop...",Content="Searching for low population server...",Duration=3})

local function serverHopLowPop()
local HttpService=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local PlaceId=game.PlaceId
local servers={}
local cursor=""

repeat
local success,result=pcall(function()
local url="https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
if cursor~=""then url=url.."&cursor="..cursor end
local response=game:HttpGet(url)
return HttpService:JSONDecode(response)
end)

if success and result and result.data then
for _,server in ipairs(result.data)do
if server.playing and server.maxPlayers and server.id then
if server.playing<server.maxPlayers and server.id~=game.JobId and server.playing>0 then
table.insert(servers,server)
end
end
end
cursor=result.nextPageCursor or""
else
cursor=""
end
until cursor==""or#servers>=50

if#servers>0 then
-- Sort servers by player count (lowest first)
table.sort(servers,function(a,b)return a.playing<b.playing end)

-- Try to find server with 2-10 players
local targetServer=nil
for _,server in ipairs(servers)do
if server.playing>=2 and server.playing<=10 then
targetServer=server
break
end
end

-- If no server in range, pick the lowest
if not targetServer then targetServer=servers[1]end

if targetServer then
Fluent:Notify({
Title="Joining...",
Content="Joining server with "..targetServer.playing.."/"..targetServer.maxPlayers.." players",
Duration=2
})
task.wait(1)
TeleportService:TeleportToPlaceInstance(PlaceId,targetServer.id,LocalPlayer)
else
Fluent:Notify({Title="No Servers",Content="No suitable servers found",Duration=3})
end
else
Fluent:Notify({Title="Error",Content="Failed to get server list",Duration=3})
end
end

local success,error=pcall(serverHopLowPop)
if not success then
Fluent:Notify({Title="ServerHop Error",Content="Failed: "..tostring(error),Duration=5})
end
end
})

end

local function PremiumTab()
    if not Premium then return end
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
        Fluent:Notify({Title = "Kaitun Started", Content = "Full auto farming started.", Duration = 3})
        RunKaitunLogic()
    else
        if KAITUN_THREAD then task.cancel(KAITUN_THREAD) end
        if KAITUN_AUTOSELL_THREAD then task.cancel(KAITUN_AUTOSELL_THREAD) end
        if KAITUN_EQUIP_THREAD then task.cancel(KAITUN_EQUIP_THREAD) end
        if KAITUN_OVERLAY then KAITUN_OVERLAY:Destroy() end
        pcall(function() RE_EquipToolFromHotbar:FireServer(0) end)
        Fluent:Notify({Title = "Kaitun Stopped", Content = "Auto farming paused.", Duration = 2})
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
   task.wait(0.5)
   InfoTab()
   PlayerTab2()
   Window:SelectTab(2) 
   task.wait(0.5)
   AutoTab()
   task.wait(0.5)
   ShopTab()
   task.wait(0.5)
   TeleportTab()
   task.wait(0.5)
    TotemTab()
    task.wait(0.5)
    QuestTab()
    task.wait(0.5)
    EventTab()
    task.wait(0.5)
    TradeTab()
    task.wait(0.5)
    EnchantTab()
    task.wait(0.5)
    AnimationTab()
    task.wait(0.5)
    DiscordTab()
  task.wait(0.5)
    SettingTab2()
    task.wait(0.5)
   MiscTab1()
   task.wait(1)
    PremiumTab()
   task.wait(1) 
   SaveManager:LoadAutoloadConfig()
   Fluent:Notify({
    Title="All Tabs Loaded!",
    Content="Script ready to use. Enjoy!",
    Duration=5
   })
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
local CAS=game:GetService("ContextActionService")
local dragActionName="IconDragBlocker"
local function u(i)local d=i.Position-dragStart f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)end
f.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
dragging=true 
dragStart=i.Position 
startPos=f.Position 

-- Block Camera
CAS:BindActionAtPriority(dragActionName, function()
return Enum.ContextActionResult.Sink
end, false, Enum.ContextActionPriority.High.Value+50, Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseMovement)

local m=false 
local c1,c2 
c1=i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then 
dragging=false 
c1:Disconnect()
CAS:UnbindAction(dragActionName)
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
