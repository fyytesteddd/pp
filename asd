local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fyywannafly-sudo/FyyCommunity/refs/heads/main/lib_fyy"))()

WindUI:AddTheme({
    Name = "Fyy Community",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#18181b"), Transparency = 0 },
    }),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})

local Window = WindUI:CreateWindow({
    Title = "Fyy Community",
    Icon = "rbxassetid://106899268176689",
    Author = "Fyy X Fish IT",
    Folder = "FyyConfig",
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    Background = "rbxassetid://78893380921225", 
})

Window:SetToggleKey(Enum.KeyCode.G)

Window:EditOpenButton({
    Title = "Fyy Community",
    Icon = "rbxassetid://106899268176689",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("AA00FF")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:SetIconSize(35) 
Window:Tag({
    Title = "1.1.0",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13, 
})

local Player = Window:Tab({
    Title = "Tab Title",
    Icon = "bird", -- optional
    Locked = false,
})
local Auto = Window:Tab({
    Title = "Tab Title",
    Icon = "bird", -- optional
    Locked = false,
})
--// CONFIG SYSTEM

local Fyy=Window.ConfigManager:CreateConfig("FyyCommunityConfig")
local ElementRegistry={}
local function Reg(id,element)
Fyy:Register(id,element)
ElementRegistry[id]=element
return element
end
local HttpService=game:GetService("HttpService")
local BaseFolder="WindUI/"..(Window.Folder or"FyyCommunity").."/config/"
local function SmartLoadConfig(configName)
local path=BaseFolder..configName..".json"
if not isfile(path)then
WindUI:Notify({Title="Gagal Load",Content="File tidak ditemukan: "..configName,Duration=3,Icon="x"})
return end
local content=readfile(path)
local success,decodedData=pcall(function()return HttpService:JSONDecode(content)end)
if not success or not decodedData then
WindUI:Notify({Title="Gagal Load",Content="File JSON rusak/kosong.",Duration=3,Icon="alert-triangle"})
return end
local realData=decodedData
if decodedData["__elements"]then realData=decodedData["__elements"]end
local changeCount=0
local foundCount=0
for _ in pairs(ElementRegistry)do foundCount=foundCount+1 end
for id,itemData in pairs(realData)do
local element=ElementRegistry[id]
if element then
local finalValue=itemData
if type(itemData)=="table"and itemData.value~=nil then finalValue=itemData.value end
local currentVal=element.Value
local isDifferent=false
if type(finalValue)=="table"then isDifferent=true
elseif currentVal~=finalValue then isDifferent=true end
if isDifferent then
pcall(function()element:Set(finalValue)end)
changeCount=changeCount+1
if changeCount%10==0 then task.wait()end
end
end
end
WindUI:Notify({Title="Config Loaded",Content=string.format("Updated: %d settings",changeCount),Duration=3,Icon="check"})
end
--// TAB


--// END OF INFO TAB

local PS=Player:Section({Title="Player Feature"})
local WS=Reg("walkSpeed",Player:Input({Title="Set WalkSpeed",Placeholder="Enter number (e.g. 50)",Callback=function(v)WS.Value=tonumber(v)or 16 end}))
local WST=Reg("walkSpeedToggle",Player:Toggle({Title="WalkSpeed",Default=false,Callback=function(s)
 local p=game.Players.LocalPlayer
 local c=p.Character or p.CharacterAdded:Wait()
 local h=c:WaitForChild("Humanoid")
 h.WalkSpeed=s and(WS.Value or 16)or 16
end}))
Player:Divider()

local IJC
local infJumpToggle = Reg("infJump", Player:Toggle({Title="Infinite Jump",Default=false,Callback=function(s)
 local UIS=game:GetService("UserInputService")
 if s then
  IJC=UIS.JumpRequest:Connect(function()
   local c=game.Players.LocalPlayer.Character
   if c and c:FindFirstChild("Humanoid")then
    c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
  end)
 elseif IJC then IJC:Disconnect()IJC=nil end
end}))

local NCC
local NCLIP Reg("noClip",Player:Toggle({Title="NoClip",Default=false,Callback=function(s)
 local p=game.Players.LocalPlayer
 if s then
  NCC=game:GetService("RunService").Stepped:Connect(function()
   local c=p.Character
   if c then
    for _,pt in ipairs(c:GetChildren())do
     if pt:IsA("BasePart")then pt.CanCollide=false end
    end
   end
  end)
 elseif NCC then
  NCC:Disconnect()NCC=nil
  local c=p.Character
  if c then
   for _,pt in ipairs(c:GetChildren())do
    if pt:IsA("BasePart")then pt.CanCollide=true end
   end
  end
 end
end}))

local wow=false
local wp
local wallWalkToggle = Reg("wallWalk", Player:Toggle({Title="Walk On Water",Default=false,Callback=function(s)
 wow=s
 local p=game.Players.LocalPlayer
 local c=p.Character
 if s and c then
  local hrp=c:FindFirstChild("HumanoidRootPart")
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
end}))

game:GetService("RunService").Heartbeat:Connect(function()
 if wow and wp then
  local c=game.Players.LocalPlayer.Character
  if c and c:FindFirstChild("HumanoidRootPart")then
   local p=c.HumanoidRootPart.Position
   wp.Position=Vector3.new(p.X,0,p.Z)
  end
 end
end)

local RS=game:GetService("ReplicatedStorage")
local RF_E=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/EquipOxygenTank"]
local RF_U=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/UnequipOxygenTank"]
local ox=false
local infOxygenToggle = Reg("infOxygen", Player:Toggle({Title="Equip Oxygen Tank",Default=false,Callback=function(s)
 ox=s
 if ox then RF_E:InvokeServer(105)else RF_U:InvokeServer()end
end}))

local RF_R=RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/UpdateFishingRadar"]
local espRadarToggle = Reg("espRadar", Player:Toggle({Title="Bypass Fishing Radar",Default=false,Callback=function(s)
RF_R:InvokeServer(s and true or false)
end}))

local pl=game:GetService("Players").LocalPlayer
local saveCF=nil
pl.CharacterAdded:Connect(function(c)
 if not saveCF then return end
 local hrp=c:WaitForChild("HumanoidRootPart",5)
 if hrp then task.wait(.3)hrp.CFrame=saveCF end
end)

Player:Button({Title="Respawn at Current Position",Callback=function()
 local c=pl.Character if not c then return end
 local hrp=c:FindFirstChild("HumanoidRootPart")
 local h=c:FindFirstChild("Humanoid")
 if hrp and h then saveCF=hrp.CFrame h.Health=0 end
end})

Player:Space()
Player:Divider()

Player:Section({Title="Gui External",Opened=true})
Player:Button({Title="Fly GUI",Callback=function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
 WindUI:Notify({Title="Fly",Content="Fly GUI berhasil dijalankan ✅",Duration=3,Icon="bell"})
end})

local SG,SL=nil,nil
local function CS()
 if SG then SG:Destroy()end
 local g=Instance.new("ScreenGui",game.CoreGui)
 g.Name="RockHub_Stats" g.IgnoreGuiInset=true
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
l.HorizontalAlignment = Enum.HorizontalAlignment.Center
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
 return g,L(),L(),L(),L()
end

local statsOverlayToggle = Reg("t_stats_top_v2", Player:Toggle({Title="Show Stats Overlay",Desc="Menampilkan FPS, CPU(ms), Ping, RAM.",Value=false,Icon="activity",Callback=function(st)
if st then
  local fps,cpu,ping,ram
  SG,fps,cpu,ping,ram=CS()
  local RSv=game:GetService("RunService")
  local ST=game:GetService("Stats")
  SL=RSv.RenderStepped:Connect(function(dt)
   if not SG then return end
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
 else
  if SL then SL:Disconnect()SL=nil end
  if SG then SG:Destroy()SG=nil end
 end
end}))


--// END OF PLAYER 

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

--- ANTI [Fyy Anti-AFK] ON

Auto:Section({Title="Instant Fishing"})
local AFR=false
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

local function sF(r,a)
 if not r then return false end
 return pcall(function()if a~=nil then r:FireServer(a)else r:FireServer()end end)
end

local function sI(r,a,b)
 if not r then return nil end
 local ok,res=pcall(function()
  if a~=nil and b~=nil then return r:InvokeServer(a,b)
  elseif a~=nil then return r:InvokeServer(a)
  else return r:InvokeServer()end
 end)
 return ok and res
end

local function play()
 if not P.Character then return end
 hum=P.Character:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 local an=Instance.new("Animation")
 an.AnimationId=aid
 at=hum:LoadAnimation(an)
 if at then at:Play()end
end

local function stop()
 if at then at:Stop()at=nil end
 hum=nil
end

local function equip()
 while run do
  if not eq then sF(REE,1)eq=true end
  task.wait(2)
 end
 eq=false
end

local function cycle()
 while run do
  sI(RFK)
  local t=os.time()+os.clock()
  pcall(function()RFC:InvokeServer(t)end)
  sI(RFS,-139.630452165,0.99647927980797)
  task.wait(d)
  if not run then break end
  sF(REF)
  task.wait(.4)
  if not run then break end
 end
end

local function start()
 play()
 task.spawn(equip)
 task.wait(.05)
 task.spawn(cycle)
end

local autoFishingToggle = Reg("autoFishing", Auto:Toggle({Title="Instant Fishing",Default=false,Callback=function(s) run=s AFR=s
 if run then task.spawn(start)
 else sI(RFK)stop()eq=false end
end}))

local fishingDelaySlider = Reg("fishingDelay", Auto:Slider({Title="Completed Delay",Step=.1,Value={Min=.1,Max=5,Default=1.3},Callback=function(v)d=v end}))

P.CharacterAdded:Connect(function()
 if run then task.wait(1)play()end
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
 if not run and at then stop()end
end)

Auto:Space()Auto:Divider()

--// Instant Fishing

Auto:Section({Title="Blatant Mode"})

local run=false
local loopT,eqT=nil,nil
local cDelay=3.1
local kDelay=.3
local interval=1.8

local loopIntervalInput=Reg("loopInterval",Auto:Input({Title="Recast Delay",Value=tostring(interval),Placeholder="1.8",Callback=function(v)local n=tonumber(v)if n and n>=0 then interval=n end end}))
local completeDelayInput=Reg("completeDelay",Auto:Input({Title="Complete Delay",Value=tostring(cDelay),Placeholder="3.1",Callback=function(v)local n=tonumber(v)if n and n>0 then cDelay=n end end}))

local RS=game:GetService("ReplicatedStorage")
local R={"Packages","_Index","sleitnick_net@0.2.0","net"}
local function GR(n)
 local c=RS
 for _,p in ipairs(R)do c=c:WaitForChild(p,2)end
 return c and c:FindFirstChild(n)
end

local RFC=GR("RF/ChargeFishingRod")
local RFS=GR("RF/RequestFishingMinigameStarted")
local REF=GR("RE/FishingCompleted")
local RFK=GR("RF/CancelFishingInputs")
local REE=GR("RE/EquipToolFromHotbar")

local function cast()
 if not run then return end
 task.spawn(function()
  local st=os.clock()
  local ts=os.time()+os.clock()
  pcall(function()RFC:InvokeServer(ts)end)
  task.wait(.05)
  pcall(function()RFS:InvokeServer(-139.6379699707,0.99647927980797)end)
  local w=cDelay-(os.clock()-st)
  if w>0 then task.wait(w)end
  pcall(function()REF:FireServer()end)
  task.wait(kDelay)
  pcall(function()RFK:InvokeServer()end)
 end)
end

local blatantModeToggle = Reg("blatantMode",Auto:Toggle({
 Title="Enable Blatant Mode",
 Value=false,
 Callback=function(s)
  run=s
  if s then
   if loopT then task.cancel(loopT)end
   loopT=task.spawn(function()
    while run do cast()task.wait(interval)end
   end)
   if eqT then task.cancel(eqT)end
   eqT=task.spawn(function()
    while run do pcall(function()REE:FireServer(1)end)task.wait(1)end
   end)
  else
   if loopT then task.cancel(loopT)loopT=nil end
   if eqT then task.cancel(eqT)eqT=nil end
   pcall(function()REE:FireServer(0)end)
  end
 end
}))

local RS = game:GetService("ReplicatedStorage")
local net = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RFC = net:WaitForChild("RF/ChargeFishingRod")
local RFS = net:WaitForChild("RF/RequestFishingMinigameStarted")
local RFK = net:WaitForChild("RF/CancelFishingInputs")
local RFU = net:WaitForChild("RF/UpdateAutoFishingState")
local REF = net:WaitForChild("RE/FishingCompleted")
local REM = net:WaitForChild("RE/FishingMinigameChanged")
local Equip = net:WaitForChild("RE/EquipToolFromHotbar")

local active = false
local fishingThread = nil
local equipThread = nil
local resetThread = nil
local casts = 0
local start = 0

local CD = .002
local FD = .7
local KD = .3

local function safe(f)
    task.spawn(function()
        pcall(f)
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function fishingLoop()
    while active do
        local t = tick()
        safe(function() RFC:InvokeServer({[1] = t}) end)
        task.wait(CD)
        local r = tick()
        safe(function() RFS:InvokeServer(1, 0, r) end)
        casts += 1
        
        local t2 = tick()
        safe(function() RFC:InvokeServer({[1] = t2}) end)
        task.wait(CD)
        local r2 = tick()
        safe(function() RFS:InvokeServer(1, 0, r2) end)
        casts += 1
        
        task.wait(FD)
        safe(function() REF:FireServer() end)
        safe(function() REF:FireServer() end)
        
        task.wait(KD)
        safe(function() RFK:InvokeServer() end)
        task.wait(0.001)
    end
end

local function equipLoop()
    while active do
        safe(function() Equip:FireServer(1) end)
        task.wait(100)
    end
end

local function resetCycleLoop()
    while active do
        task.wait(15)
        if active then
            if fishingThread then 
                task.cancel(fishingThread)
                fishingThread = nil
            end
            
            safe(function() RFK:InvokeServer() end)
            task.wait(1)
            
            if active then
                fishingThread = task.spawn(fishingLoop)
            end
        end
    end
end

REM.OnClientEvent:Connect(function()
    if not active then return end
    task.spawn(function()
        task.wait(FD)
        safe(function() REF:FireServer() end)
        task.wait(KD)
        safe(function() RFK:InvokeServer() end)
    end)
end)

Auto:Section({Title = "Blatant V2"})

local blatantV2CastDelayInput = Reg("blatantV2_castDelay", Auto:Input({
    Title = "Cast Delay",
    Placeholder = tostring(CD),
    Value = tostring(CD),
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0 then
            CD = n
        end
    end
}))

local blatantV2CompleteDelayInput = Reg("blatantV2_completeDelay", Auto:Input({
    Title = "Complete Delay",
    Placeholder = tostring(FD),
    Value = tostring(FD),
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0 then
            FD = n
        end
    end
}))

local blatantV2CancelDelayInput = Reg("blatantV2_cancelDelay", Auto:Input({
    Title = "Cancel Delay",
    Placeholder = tostring(KD),
    Value = tostring(KD),
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0 then
            KD = n
        end
    end
}))

local blatantV2Toggle = Reg("blatantV2_toggle", Auto:Toggle({
    Title = "Enable Blatant V2",
    Desc = "Ultra fast",
    Default = false,
    Callback = function(s)
        active = s
        if s then 
            casts = 0
            start = tick()
            pcall(function() LocalPlayer:SetAttribute("InCutscene", true) end)
            safe(function() RFU:InvokeServer(true) end)
            
            fishingThread = task.spawn(fishingLoop)
            equipThread = task.spawn(equipLoop)
            resetThread = task.spawn(resetCycleLoop)
        else 
            if fishingThread then 
                task.cancel(fishingThread)
                fishingThread = nil 
            end
            if equipThread then 
                task.cancel(equipThread)
                equipThread = nil 
            end
            if resetThread then 
                task.cancel(resetThread)
                resetThread = nil 
            end
            
            safe(function() RFU:InvokeServer(false) end)
            task.wait(.2)
            safe(function() RFK:InvokeServer() end)
        end
    end
}))



--// ASD
Auto:Section({Title="Teleport Feature"})

local P=game:GetService("Players").LocalPlayer
local RS=game:GetService("RunService")

local T={
 ["Fisherman Island"]=CFrame.new(77,9,2706),
 ["Kohana Volcano"]=CFrame.new(-628.758911,35.710186,104.373764,0.482912123,1.81591773e-08,0.875668824,3.01732896e-08,1,-3.73774007e-08,-0.875668824,4.44718076e-08,0.482912123),
 ["Kohana"]=CFrame.new(-725.013306,3.03549194,800.079651,-0.999999285,-5.38041718e-08,-0.00118542486,-5.379977e-08,1,-3.74458198e-09,0.00118542486,-3.68080366e-09,-0.999999285),
 ["Esotric Islands"]=CFrame.new(2113,10,1229),
 ["Coral Reefs"]=CFrame.new(-3063.54248,4.04500151,2325.85278,0.999428809,2.02288568e-08,0.033794228,-1.96206607e-08,1,-1.83286453e-08,-0.033794228,1.76551112e-08,0.999428809),
 ["Crater Island"]=CFrame.new(984.003296,2.87008905,5144.92627,0.999932885,1.19231975e-08,0.0115857301,-1.04685522e-08,1,-1.25615529e-07,-0.0115857301,1.25485812e-07,0.999932885),
 ["Sisyphus Statue"]=CFrame.new(-3737,-136,-881),
 ["Treasure Room"]=CFrame.new(-3650.4873,-269.269318,-1652.68323,-0.147814155,-2.75628675e-08,-0.989015162,-1.74189818e-08,1,-2.52656349e-08,0.989015162,1.34930183e-08,-0.147814155),
 ["Lost Isle"]=CFrame.new(-3649.0813,5.42584181,-1052.88745,0.986230493,3.9997154e-08,-0.165376455,-3.81513914e-08,1,1.43375187e-08,0.165376455,-7.83075649e-09,0.986230493),
 ["Tropical Grove"]=CFrame.new(-2151.29248,15.8166971,3628.10669,-0.997403979,4.56146232e-09,-0.0720091537,4.62302685e-09,1,-6.88285429e-10,0.0720091537,-1.0193989e-09,-0.997403979),
 ["Weater Machine"]=CFrame.new(-1518.05042,2.87499976,1909.78125,-0.995625556,-1.82757487e-09,-0.0934334621,2.24076646e-09,1,-4.34377512e-08,0.0934334621,-4.34570957e-08,-0.995625556),
 ["Enchant Room"]=CFrame.new(3180.14502,-1302.85486,1387.9563,0.338028163,9.92235272e-08,-0.941136003,1.90291747e-08,1,1.12264253e-07,0.941136003,-5.58575195e-08,0.338028163),
 ["Seconds Enchant"]=CFrame.new(1487,128,-590),
 ["Ancient Jungle"]=CFrame.new(1519.33215,2.08891273,-307.090668,0.632470906,-1.48247699e-08,0.774584115,-2.24899335e-08,1,3.75027014e-08,-0.774584115,-4.11397139e-08,0.632470906),
 ["Sacred Temple"]=CFrame.new(1413.84277,4.375,-587.298279,0.261966974,5.50031594e-08,-0.965076864,-8.19077872e-09,1,5.47701973e-08,0.965076864,-6.44325127e-09,0.261966974),
 ["Underground Cellar"]=CFrame.new(2103.14673,-91.1976471,-717.124939,-0.226165071,-1.71397723e-08,-0.974088967,-2.1650266e-09,1,-1.70930168e-08,0.974088967,-1.75691484e-09,-0.226165071),
 ["Arrow Artifact"]=CFrame.new(883.135437,6.62499952,-350.10025,-0.480593145,2.676836e-08,0.876943707,-4.66245069e-08,1,-5.6076324e-08,-0.876943707,-6.78369645e-08,-0.480593145),
 ["Crescent Artifact"]=CFrame.new(1409.40747,6.62499952,115.430603,-0.967555583,-5.63477229e-08,0.252658188,-7.82660337e-08,1,-7.67005233e-08,-0.252658188,-9.39865714e-08,-0.967555583),
 ["Hourglass Diamond Artifact"]=CFrame.new(1480.98645,6.27569771,-847.142029,-0.967326343,-5.985531e-08,0.253534466,-6.16077926e-08,1,1.02735098e-09,-0.253534466,-1.46259147e-08,-0.967326343),
 ["Diamond Artifact"]=CFrame.new(1836.31604,6.34277105,-298.546265,0.545851529,-2.36059989e-08,-0.837881923,-4.70848498e-08,1,-5.8847597e-08,0.837881923,7.15735951e-08,0.545851529),
 ["Ancient Ruin"]=CFrame.new(6087,-586,4701),
 ["Pirate Island"]=CFrame.new(3263, 5, 3686),
 ["Pirate Treasure Room"]=CFrame.new(3333, -299, 3093)

}

local sel=""
local loop=nil
local last=nil

local function start()
 if loop then return end
 local c=P.Character
 if c and c:FindFirstChild("HumanoidRootPart")then
  last=c.HumanoidRootPart.CFrame
 end
 loop=RS.Heartbeat:Connect(function()
  local c=P.Character
  local hrp=c and c:FindFirstChild("HumanoidRootPart")
  local cf=T[sel]
  if hrp and cf and(last==nil or(hrp.Position-last.Position).Magnitude>.1)then
   hrp.CFrame=cf
   last=cf
  end
 end)
end

local function stop()
 if loop then loop:Disconnect()loop=nil last=nil end
end

local teleportLocationDropdown = Reg("teleportLocation",Auto:Dropdown({
 Title="Teleport Location",
 Values={"Fisherman Island","Kohana Volcano","Kohana","Esotric Islands","Coral Reefs","Crater Island","Sisyphus Statue","Treasure Room","Lost Isle","Tropical Grove","Weater Machine","Enchant Room","Seconds Enchant","Ancient Jungle","Sacred Temple","Underground Cellar","Arrow Artifact","Crescent Artifact","Hourglass Diamond Artifact","Diamond Artifact","Ancient Ruin","Pirate Island","Pirate Treasure Room"},
 AllowNone = true,
 Callback=function(o)if o and o~=""then sel=o end end
}))

local autoTeleportToggle = Reg("autoTeleport",Auto:Toggle({
 Title="Teleport & Freeze to Position",
 Default=false,
 Callback=function(s)
  if s then
   local c=P.Character
   local hrp=c and c:FindFirstChild("HumanoidRootPart")
   local cf=T[sel]
   if hrp and cf then hrp.CFrame=cf task.wait(.1)start()end
  else stop()end
 end
}))

