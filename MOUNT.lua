local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fyywannafly-sudo/FyyCommunity/refs/heads/main/lib_fyy"))()

WindUI:AddTheme({
    Name = "Fyy Community", 
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },        
        ["100"]   = { Color = Color3.fromHex("#18181b"), Transparency = 0 },    
    }, {                                                                        
        Rotation = 0,                                                           
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
    Title = "Fyy Community | Mount",
    Icon = "rbxassetid://106899268176689", 
    Author = "Fyy X Mount",
    Folder = "FyyConfig",
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    Background = "rbxassetid://78893380921225", 
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
    Title = "FyyLoader",
    Content = "Press G To Open/Close Menu!",
    Duration = 4, 
    Icon = "slack",
})

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
    Title = "1.1.1",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13, 
})

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
    local function u(i)
        local d=i.Position-dragStart 
        f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
    
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
                    if not m and Window and Window.Toggle then 
                        Window:Toggle()
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
    
    f.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then 
            dragInput=i 
        end 
    end)
    
    uisConn=UIS.InputChanged:Connect(function(i)
        if i==dragInput and dragging then 
            u(i)
        end 
    end)
    
    if Window then 
        Window:OnOpen(function()
            g.Enabled=false 
        end)
        Window:OnClose(function()
            g.Enabled=true 
        end)
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

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    I()
end)
I()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FILE_CONFIG = {
    folder = "FyyVerifyyy",
    subfolder = "auth",
    filename = "token.dat"
}

local API_CONFIG = {
    base_url = "http://151.240.0.25:3001",
    validate_endpoint = "check"
}

local function getHWID()
    local hwid
    local success = pcall(function()
        hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if success and hwid and hwid ~= "" then
        return hwid
    end
    pcall(function()
        hwid = HttpService:GenerateGUID(false)
    end)
    return hwid or ("HWID-" .. tostring(tick()))
end

local MAX_RETRIES = 3
local RETRY_DELAY = 1

local function secureHttpGet(url)
    for _ = 1, MAX_RETRIES do
        local success, response = pcall(function()
            return game:HttpGet(url, true)
        end)
        if success and response and response ~= "" then
            return response
        end
        task.wait(RETRY_DELAY)
    end
    return nil
end

local function getAuthFilePath()
    return FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder .. "/" .. FILE_CONFIG.filename
end

local function saveToken(token)
    pcall(function()
        if not isfolder(FILE_CONFIG.folder) then
            makefolder(FILE_CONFIG.folder)
        end
        local sub = FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder
        if not isfolder(sub) then
            makefolder(sub)
        end
        writefile(getAuthFilePath(), tostring(token))
    end)
end

local function loadToken()
    if not isfile(getAuthFilePath()) then
        return nil
    end
    local token = readfile(getAuthFilePath())
    token = tostring(token):upper():gsub("%s+", "")
    return token ~= "" and token or nil
end

local function deleteToken()
    pcall(function()
        if isfile(getAuthFilePath()) then
            delfile(getAuthFilePath())
        end
    end)
end

local function ValidateKey(key)
    if not key or (not string.match(key, "^FYY%-.+") and not string.match(key, "^TRIAL%-.+")) then
        return false, "Format key salah"
    end

    local encKey     = HttpService:UrlEncode(tostring(key))
    local encHWID    = HttpService:UrlEncode(tostring(getHWID()))
    local encUserId  = HttpService:UrlEncode(tostring(LocalPlayer.UserId))
    local encPlaceId = HttpService:UrlEncode(tostring(game.PlaceId))
    local username   = LocalPlayer.Name

    local url = string.format(
        "%s/%s?key=%s&hwid=%s&robloxId=%s&placeId=%s&username=%s",
        API_CONFIG.base_url,
        API_CONFIG.validate_endpoint, 
        encKey,
        encHWID,
        encUserId,
        encPlaceId,
        HttpService:UrlEncode(username)
    )

    local response = secureHttpGet(url)
    if not response then
        return false, "Server tidak merespon"
    end

    local decoded
    local ok = pcall(function()
        decoded = HttpService:JSONDecode(response)
    end)
    if not ok or type(decoded) ~= "table" then
        return false, "Response server tidak valid"
    end

    if decoded.status == "ok" then
        if decoded.isTrial then
            saveToken(key)
            return true, "TRIAL_OK"
        end
        if decoded.code == "OK" or decoded.code == "FIRST_BIND" then
            saveToken(key)
            return true, decoded.code
        end
    end

    if decoded.code == "HWID_BLACKLISTED" then
        return false, "HWID kamu di-blacklist"
    elseif decoded.code == "USERNAME_NOT_FOUND" then
        return false, "Username tidak terdaftar di key ini"
    elseif decoded.code == "INVALID_KEY" then
        return false, "Key tidak valid"
    elseif decoded.code == "BLACKLISTED" then
        return false, "Key di-blacklist"
    elseif decoded.code == "EXPIRED" then
        return false, "Key sudah expired"
    elseif decoded.code == "MISSING_PARAMS" then
        return false, "Parameter tidak lengkap"
    end

    return false, decoded.code or "AUTH_FAILED"
end

-- ================================
-- UI SETUP (TETAP SAMA)
-- ================================
local AuthTab = Window:Tab({ Title = "Authentication", Icon = "key" })
local I="77nEeYeFRp"
local U="https://discord.com/api/v10/invites/"..I.."?with_counts=true&with_expiration=true"
local R,E
xpcall(function()
    R=game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({
        Url=U,
        Method="GET",
        Headers={["Accept"]="application/json"}
    }).Body)
end,function(e)
    warn("err fetching discord info:"..tostring(e))
    E=tostring(e)
    R=nil
end)

if R and R.guild then
    local P={
        Title=R.guild.name,
        Desc='<font color="#52525b">•</font>Member Count:'..tostring(R.approximate_member_count)..'\n<font color="#16a34a">•</font>Online Count:'..tostring(R.approximate_presence_count),
        Image="https://cdn.discordapp.com/icons/"..R.guild.id.."/"..R.guild.icon..".png?size=256",
        ImageSize=42,
        Buttons={{
            Icon="link",
            Title="Copy Discord Invite",
            Callback=function()
                pcall(function()
                    setclipboard("https://discord.gg/"..I)
                end)
            end
        }}
    }
    if R.guild.banner then
        P.Thumbnail="https://cdn.discordapp.com/banners/"..R.guild.id.."/"..R.guild.banner..".png?size=256"
        P.ThumbnailSize=80
    end
    AuthTab:Paragraph(P)
else
    AuthTab:Paragraph({
        Title="Error when receiving information about the Discord server",
        Desc=E or"Unknown error occurred",
        Image="triangle-alert",
        ImageSize=26,
        Color="Red"
    })
end
Window:Divider()

-- Tab declarations (sama)
local AccountTab,PlayerTab,AutosummitTab,AutowalkTab,TeleportTab,CustomanimationTab,ToolsTab,DangerTab

local function SetupTab()
if not PlayerTab then PlayerTab=Window:Tab({Title="Player Menu",Icon="user-cog"})end
if not AutosummitTab then AutosummitTab=Window:Tab({Title="Auto Summit",Icon="mountain"})end
if not AutowalkTab then AutowalkTab=Window:Tab({Title="Auto Walk",Icon="bot"})end
if not CustomanimationTab then CustomanimationTab=Window:Tab({Title="Animation",Icon="person-standing"})end
if not TeleportTab then TeleportTab=Window:Tab({Title="Teleport",Icon="map-pin"})end
if not ToolsTab then ToolsTab=Window:Tab({Title="Tools",Icon="settings"})end
if not DangerTab then DangerTab=Window:Tab({Title="Danger Zone",Icon="skull"})end
end

local enteredKey = ""
local isAuthenticating = false
local menuCreated = false

local function DoAuth(key, isAuto)
    if isAuthenticating or menuCreated then return end
    if not key or key == "" then return end

    isAuthenticating = true
    WindUI:Notify({
        Title = isAuto and "Auto Login" or "Validating",
        Content = isAuto and "Mencoba login..." or "Memverifikasi key...",
        Duration = 2,
        Icon = "loader"
    })

    local valid, codeOrErr = ValidateKey(key)
    isAuthenticating = false

    if valid then
        saveToken(key)
        getgenv().AuthComplete = true
        getgenv().UserData = codeOrErr 

        SetupTab()
        menuCreated = true
        

        WindUI:Notify({
            Title = "Success",
            Content = isAuto and ("Auto login berhasil (" .. tostring(codeOrErr) .. ")") or "Authentication berhasil",
            Duration = 3,
            Icon = "check-check"
        })
    else
        if isAuto then
            deleteToken()
        end
        WindUI:Notify({
            Title = "Failed",
            Content = tostring(codeOrErr),
            Duration = 4,
            Icon = "ban"
        })
    end
end

AuthTab:Input({
    Title = "License Key",
    Placeholder = "FYY-000-000-000",
    InputIcon = "key",
    Callback = function(v)
        enteredKey = tostring(v or ""):upper():gsub("%s+", "")
    end
})

AuthTab:Select()

AuthTab:Button({
    Title = "Verify Key",
    Icon = "shield-check",
    Callback = function()
        DoAuth(enteredKey, false)
    end
})

task.spawn(function()
    task.wait(2)

    local saved = loadToken()
    if saved and not menuCreated then
        DoAuth(saved, true)
    end
end)

--//---------------------------------

local function setupPlayerTab()
if not PlayerTab then return end
local WalkSpeedInput={Value=16}
PlayerTab:Input({Title="Set WalkSpeed",Placeholder="Masukkan angka, contoh: 50",Callback=function(v)WalkSpeedInput.Value=tonumber(v)or 16 end})
PlayerTab:Toggle({Title="WalkSpeed",Type="Toggle",Default=false,Callback=function(s)
local p=game.Players.LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local h=c:WaitForChild("Humanoid")
h.WalkSpeed=s and(WalkSpeedInput.Value or 16)or 16
end})
PlayerTab:Space()PlayerTab:Divider()
local InfiniteJumpConnection=nil
PlayerTab:Toggle({Title="Infinite Jump",Type="Toggle",Default=false,Callback=function(s)
local p=game.Players.LocalPlayer
if s then
InfiniteJumpConnection=game:GetService("UserInputService").JumpRequest:Connect(function()
local c=p.Character
if c and c:FindFirstChild("Humanoid")then
c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end)
else
if InfiniteJumpConnection then
InfiniteJumpConnection:Disconnect()
InfiniteJumpConnection=nil
end
end
end})
local NoClipConnection=nil
PlayerTab:Toggle({Title="NoClip",Type="Toggle",Default=false,Callback=function(s)
local p=game.Players.LocalPlayer
if s then
NoClipConnection=game:GetService("RunService").Stepped:Connect(function()
local c=p.Character
if c then
for _,part in ipairs(c:GetChildren())do
if part:IsA("BasePart")then
part.CanCollide=false
end
end
end
end)
else
if NoClipConnection then
NoClipConnection:Disconnect()
NoClipConnection=nil
end
local c=p.Character
if c then
for _,part in ipairs(c:GetChildren())do
if part:IsA("BasePart")then
part.CanCollide=true
end
end
end
end
end})
PlayerTab:Toggle({Title="No Fall Damage",Type="Toggle",Default=false,Callback=function(s)
local p=game.Players.LocalPlayer
local heartbeat=game:GetService("RunService").Heartbeat
local rstepped=game:GetService("RunService").RenderStepped
local zeroVec=Vector3.new(0,0,0)
local noFallConnection=nil
local enabled=s
local function enableNoFall(chr)
local root=chr:WaitForChild("HumanoidRootPart",5)
if not root then return end
noFallConnection=heartbeat:Connect(function()
if not root.Parent then
if noFallConnection then
noFallConnection:Disconnect()
noFallConnection=nil
end
return
end
local oldvel=root.AssemblyLinearVelocity
root.AssemblyLinearVelocity=zeroVec
rstepped:Wait()
root.AssemblyLinearVelocity=oldvel
end)
end
local function disableNoFall()
if noFallConnection then
noFallConnection:Disconnect()
noFallConnection=nil
end
end
if s then
if p.Character then
enableNoFall(p.Character)
end
p.CharacterAdded:Connect(function(char)
if enabled then
enableNoFall(char)
end
end)
else
disableNoFall()
end
end})
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local LocalPlayer=Players.LocalPlayer
local CONFIG={textSize=20,textStrokeTransparency=0.6,yOffset=2}
local currentName="FyyOnTOP#1 👑"
local customGui=nil
local conns={}
local hiddenGuis={}
local enabled=false
local function rainbowColor(t)
local r=math.sin(t*2)*127+128
local g=math.sin(t*2+2)*127+128
local b=math.sin(t*2+4)*127+128
return Color3.fromRGB(r,g,b)
end
local function hideGuiIfTarget(gui)
if(gui:IsA("BillboardGui")or gui:IsA("SurfaceGui"))and gui.Name~="FyyOnTOP#1"then
if gui.Enabled~=false then
hiddenGuis[gui]=true
gui.Enabled=false
end
end
end
local function restoreHiddenGuis()
for gui in pairs(hiddenGuis)do
if gui and gui.Parent then
pcall(function()gui.Enabled=true end)
end
end
hiddenGuis={}
end
local function createNameTag(character)
local head=character:FindFirstChild("Head")or character:FindFirstChild("UpperTorso")
if not head then return end
if customGui then customGui:Destroy()customGui=nil end
local billboard=Instance.new("BillboardGui")
billboard.Name="FyyOnTOP#1"
billboard.Adornee=head
billboard.AlwaysOnTop=true
billboard.Size=UDim2.new(0,200,0,50)
billboard.StudsOffset=Vector3.new(0,CONFIG.yOffset,0)
billboard.Parent=head
local label=Instance.new("TextLabel")
label.BackgroundTransparency=1
label.Size=UDim2.new(1,0,1,0)
label.Text=currentName
label.Font=Enum.Font.SourceSansBold
label.TextSize=CONFIG.textSize
label.TextStrokeTransparency=CONFIG.textStrokeTransparency
label.TextColor3=Color3.fromRGB(255,0,0)
label.TextScaled=false
label.Parent=billboard
local t=0
local conn=RunService.RenderStepped:Connect(function(dt)
if not billboard.Parent then
pcall(function()conn:Disconnect()end)
return
end
t=t+dt
label.TextColor3=rainbowColor(t)
label.Text=currentName
end)
table.insert(conns,conn)
customGui=billboard
end
local function hideDefaultNameTag(character)
local humanoid=character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function()
humanoid.NameDisplayDistance=0
humanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
end)
end
local head=character:FindFirstChild("Head")
if head then
for _,gui in ipairs(head:GetChildren())do
hideGuiIfTarget(gui)
end
local conn=head.ChildAdded:Connect(function(child)
task.defer(function()hideGuiIfTarget(child)end)
end)
table.insert(conns,conn)
end
end
local function disconnectAll()
for i=#conns,1,-1 do
local c=conns[i]
pcall(function()
if c and typeof(c)=="RBXScriptConnection"then
c:Disconnect()
end
end)
conns[i]=nil
end
end
local function setEnabled(state)
enabled=state
if state then
if LocalPlayer.Character then
hideDefaultNameTag(LocalPlayer.Character)
createNameTag(LocalPlayer.Character)
end
else
disconnectAll()
if customGui then customGui:Destroy()customGui=nil end
restoreHiddenGuis()
end
end
_G.SetMyVisualName=function(newName)
currentName=tostring(newName)
if enabled and LocalPlayer.Character then
createNameTag(LocalPlayer.Character)
end
end
LocalPlayer.CharacterAdded:Connect(function(char)
if enabled then
task.delay(1,function()
if enabled and char:FindFirstChild("HumanoidRootPart")then
hideDefaultNameTag(char)
createNameTag(char)
end
end)
end
end)
setEnabled(false)
PlayerTab:Toggle({Title="Hide Name",Type="Toggle",Default=false,Callback=function(Value)setEnabled(Value)end})
local espEnabled=false
local espConnections={}
local function enableESPForPlayer(plr)
local char=plr.Character
if not char then return end
if char:FindFirstChild("FyyESP")then char.FyyESP:Destroy()end
if char:FindFirstChild("Head")and char.Head:FindFirstChild("FyyNameBill")then char.Head.FyyNameBill:Destroy()end
local hl=Instance.new("Highlight")
hl.Name="FyyESP"
hl.FillColor=Color3.fromRGB(255,0,0)
hl.OutlineColor=Color3.fromRGB(255,255,255)
hl.FillTransparency=0.5
hl.OutlineTransparency=0
hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
hl.Parent=char
if char:FindFirstChild("Head")then
local billboard=Instance.new("BillboardGui")
billboard.Name="FyyNameBill"
billboard.Size=UDim2.new(0,100,0,20)
billboard.StudsOffset=Vector3.new(0,3.5,0)
billboard.AlwaysOnTop=true
billboard.MaxDistance=500
local tl=Instance.new("TextLabel")
tl.Size=UDim2.new(1,0,1,0)
tl.BackgroundTransparency=1
tl.Text=plr.Name
tl.TextColor3=Color3.new(1,1,1)
tl.TextStrokeColor3=Color3.new(0,0,0)
tl.TextStrokeTransparency=0
tl.TextScaled=true
tl.Font=Enum.Font.GothamBold
tl.Parent=billboard
billboard.Parent=char.Head
end
end
local function disableESPForPlayer(plr)
local char=plr.Character
if char then
if char:FindFirstChild("FyyESP")then char.FyyESP:Destroy()end
if char:FindFirstChild("Head")and char.Head:FindFirstChild("FyyNameBill")then char.Head.FyyNameBill:Destroy()end
end
end
local function setupESP()
for _,plr in ipairs(game:GetService("Players"):GetPlayers())do
if plr~=game:GetService("Players").LocalPlayer then
if espEnabled then
if plr.Character then enableESPForPlayer(plr)end
espConnections[plr]=plr.CharacterAdded:Connect(function(char)
task.wait(1)
enableESPForPlayer(plr)
end)
else
disableESPForPlayer(plr)
if espConnections[plr]then
espConnections[plr]:Disconnect()
espConnections[plr]=nil
end
end
end
end
espConnections.playerAdded=game:GetService("Players").PlayerAdded:Connect(function(plr)
if espEnabled then
espConnections[plr]=plr.CharacterAdded:Connect(function(char)
task.wait(1)
enableESPForPlayer(plr)
end)
end
end)
end
PlayerTab:Toggle({Title="Player ESP",Type="Toggle",Default=false,Callback=function(state)
espEnabled=state
if espEnabled then
setupESP()
WindUI:Notify({Title="Player ESP",Content="ESP Enabled",Duration=3})
else
for _,plr in ipairs(game:GetService("Players"):GetPlayers())do
if plr~=game:GetService("Players").LocalPlayer then
disableESPForPlayer(plr)
end
end
for plr,connection in pairs(espConnections)do
if connection then connection:Disconnect()end
end
espConnections={}
WindUI:Notify({Title="Player ESP",Content="ESP Disabled",Duration=3})
end
end})
PlayerTab:Button({Title="Apply Anti Lag",Desc="Optimalkan game untuk mengurangi lag",Callback=function()
WindUI:Notify({Title="Anti Lag",Content="Mengaplikasikan optimasi...",Duration=2,Icon="loader"})
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local player=game.Players.LocalPlayer
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("BasePart")and not obj:IsDescendantOf(player.Character)then
obj.Material=Enum.Material.Plastic
end
end
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("ParticleEmitter")or obj:IsA("Beam")or obj:IsA("Trail")or obj:IsA("Sparkles")or obj:IsA("Smoke")or obj:IsA("Fire")then
obj.Enabled=false
end
end
for _,obj in ipairs(Lighting:GetChildren())do
if obj:IsA("BloomEffect")or obj:IsA("BlurEffect")or obj:IsA("ColorCorrectionEffect")or obj:IsA("DepthOfFieldEffect")or obj:IsA("SunRaysEffect")then
obj.Enabled=false
end
end
local camera=Workspace.CurrentCamera
for _,obj in ipairs(camera:GetChildren())do
if obj:IsA("BlurEffect")then obj.Enabled=false end
end
local sky=Lighting:FindFirstChildOfClass("Sky")
if sky then
sky.CelestialBodiesShown=false
sky.StarCount=0
end
Lighting.GlobalShadows=false
Lighting.Technology=Enum.Technology.Compatibility
Lighting.FogEnd=100000
Lighting.EnvironmentDiffuseScale=0
Lighting.EnvironmentSpecularScale=0
Lighting.Brightness=1
Lighting.OutdoorAmbient=Color3.new(0.5,0.5,0.5)
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("PointLight")or obj:IsA("SpotLight")or obj:IsA("SurfaceLight")then
obj.Enabled=false
end
end
for _,obj in ipairs(Workspace:GetDescendants())do
if obj:IsA("Sound")then obj.Playing=false end
end
WindUI:Notify({Title="Anti Lag",Content="Optimasi berhasil diaplikasikan!",Duration=3,Icon="check"})
end})

PlayerTab:Space()
PlayerTab:Divider()

PlayerTab:Section({Title="Gui External",Opened=true})
PlayerTab:Button({Title="Fly GUI",Callback=function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
 WindUI:Notify({Title="Fly",Content="Fly GUI berhasil dijalankan ✅",Duration=3,Icon="bell"})
end})
end

--- // auto summit tab setup
local function setupAutosummitTab()
    if not AutosummitTab then return end
AutosummitTab:Section({Title="Auto Summit"})local a=false;AutosummitTab:Toggle({Title="Expedition Antartika⚡",Type="Toggle",Default=false,Callback=function(b)a=b;if b then task.spawn(function()local c=1;local d=tick()local e=0;local f=game.Players.LocalPlayer;local g=game:GetService("Workspace")local h={Vector3.new(-3719,225,234),Vector3.new(1790,105,-138),Vector3.new(5892,321,-20),Vector3.new(8992,596,103),Vector3.new(11002,549,128)}local i={[1]="WaterRefill_Camp1",[2]="WaterRefill_Camp2",[3]="WaterRefill_Camp3",[4]="WaterRefill_Camp4"}local function j(k)if not f.Character or not f.Character:FindFirstChild("HumanoidRootPart")then return end;local l=f.Character.HumanoidRootPart;local m=Instance.new("Part")m.Anchored=true;m.CanCollide=true;m.Transparency=1;m.Size=Vector3.new(10,1,10)m.CFrame=CFrame.new(k)m.Parent=g;l.CFrame=CFrame.new(k+Vector3.new(0,5,0))task.wait(1)m:Destroy()end;local function n()if not f.Character then return false end;local o=f.Character:FindFirstChild("Humanoid")if not o then return false end;local p=f.Character:FindFirstChild("Water Bottle")if p then return true end;local q=f.Backpack:FindFirstChild("Water Bottle")if not q then return false end;o:EquipTool(q)local r=2;local s=tick()while tick()-s<r do if q.Parent==f.Character then return true end;task.wait(0.1)end;return false end;local function t()if not a then return end;local u=f.Character;if not u then return end;local q=u:FindFirstChild("Water Bottle")if not q then local v=n()if not v then return end;task.wait(0.3)end;q=u:FindFirstChild("Water Bottle")if not q then return end;if q:FindFirstChild("RemoteEvent")then pcall(function()q.RemoteEvent:FireServer()end)end end;local function w()if not a then return end;local x=g:FindFirstChild("Locally_Imported_Parts")if not x then return end;local y=i[c]local z=y and x:FindFirstChild(y)if z then local u=f.Character;local l=u and u:FindFirstChild("HumanoidRootPart")if not l then return end;local A=l.Position;j(z.Position+Vector3.new(0,3,0))task.wait(1)j(A)task.wait(1)end end;local function B()task.wait(3)if a then n()end end;f.CharacterAdded:Connect(function(u)task.wait(3)if a then task.wait(1)n()end end)local function C()local D=f:WaitForChild("Expedition Data",10)local E=D and D:FindFirstChild("Coins")local F=E and E.Value or 0;B()j(h[c])while a do local G=tick()if G-d>=5 then t()d=G end;if G-e>=20 then w()e=G end;if E and E.Value>F then F=E.Value;if c>=#h then j(Vector3.new(10952,313,122))pcall(function()if f.Character then f.Character:BreakJoints()end end)f.CharacterAdded:Wait()task.wait(3)c=1;j(h[c])else c=c+1;j(h[c])end end;local H=f.Character and f.Character:FindFirstChild("HumanoidRootPart")if H then H.CFrame=H.CFrame*CFrame.new(0,0,10)task.wait(5)if not a then break end;j(h[c])task.wait(5)else task.wait(1)end end end;C()end)end end})local I=false;AutosummitTab:Toggle({Title="MT Ravika",Type="Toggle",Default=false,Callback=function(b)I=b;if b then task.spawn(function()local f=game.Players.LocalPlayer;local J={Vector3.new(-785,87,-652),Vector3.new(-986,184,-79),Vector3.new(-955,178,807),Vector3.new(796,186,876),Vector3.new(971,98,136),Vector3.new(982,144,-535),Vector3.new(401,122,-230),Vector3.new(47,438,40)}local function j(k)if not f.Character or not f.Character:FindFirstChild("HumanoidRootPart")then return end;local l=f.Character.HumanoidRootPart;local m=Instance.new("Part")m.Anchored=true;m.CanCollide=true;m.Transparency=1;m.Size=Vector3.new(10,1,10)m.CFrame=CFrame.new(k)m.Parent=workspace;l.CFrame=CFrame.new(k+Vector3.new(0,5,0))task.wait(1)m:Destroy()end;while I do if not f.Character or not f.Character:FindFirstChild("HumanoidRootPart")then f.CharacterAdded:Wait()task.wait(1)end;for K,k in ipairs(J)do if not I then break end;j(k)if K==7 then task.wait(30)elseif K==8 then task.wait(3)if I and f.Character then pcall(function()f.Character:BreakJoints()end)f.CharacterAdded:Wait()f.Character:WaitForChild("HumanoidRootPart")end;break else task.wait(5)end end end end)end end})local L=false;AutosummitTab:Toggle({Title="MT Atin",Type="Toggle",Default=false,Callback=function(b)L=b;if b then task.spawn(function()local f=game.Players.LocalPlayer;local M=game:GetService("TeleportService")local N={Vector3.new(625,1799,3433),Vector3.new(777,2184,3934)}local function j(k)if not f.Character or not f.Character:FindFirstChild("HumanoidRootPart")then return end;local l=f.Character.HumanoidRootPart;local m=Instance.new("Part")m.Anchored=true;m.CanCollide=true;m.Transparency=1;m.Size=Vector3.new(10,1,10)m.CFrame=CFrame.new(k)m.Parent=workspace;l.CFrame=CFrame.new(k+Vector3.new(0,5,0))task.wait(1)m:Destroy()end;local function O(P,Q)for K=P,1,-1 do if not L then break end;WindUI:Notify({Title="MT Atin Countdown",Content=Q.." starting in "..K.." seconds...",Duration=1,Icon="clock"})task.wait(1)end end;local function R()local S=game:GetService("HttpService")local T=game:GetService("TeleportService")local U="https://games.roblox.com/v1/games/"local V=game.PlaceId;local W=U..V.."/servers/Public?sortOrder=Asc&limit=100"local function X(Y)local Z=game:HttpGet(W..(Y and"&cursor="..Y or""))return S:JSONDecode(Z)end;local _,a0;repeat local a1=X(a0)_=a1.data;a0=a1.nextPageCursor until a0;local a2=_[math.random(1,#_)]T:TeleportToPlaceInstance(V,a2.id,f)end;while L do O(3,"MT Atin")j(N[1])task.wait(2)if not L then break end;j(N[2])task.wait(3)if not L then break end;WindUI:Notify({Title="MT Atin",Content="Server hopping...",Duration=3,Icon="refresh-cw"})R()task.wait(10)end end)end end})local a3=false;AutosummitTab:Toggle({Title="MT Sibuatan",Type="Toggle",Default=false,Callback=function(b)a3=b;if b then task.spawn(function()local f=game.Players.LocalPlayer;local M=game:GetService("TeleportService")local a4=Vector3.new(5394,8109,2207)local function j(k)if not f.Character or not f.Character:FindFirstChild("HumanoidRootPart")then return end;local l=f.Character.HumanoidRootPart;local m=Instance.new("Part")m.Anchored=true;m.CanCollide=true;m.Transparency=1;m.Size=Vector3.new(10,1,10)m.CFrame=CFrame.new(k)m.Parent=workspace;l.CFrame=CFrame.new(k+Vector3.new(0,5,0))task.wait(1)m:Destroy()end;local function O(P,Q)for K=P,1,-1 do if not a3 then break end;WindUI:Notify({Title="MT Sibuatan Countdown",Content=Q.." starting in "..K.." seconds...",Duration=1,Icon="clock"})task.wait(1)end end;local function R()local S=game:GetService("HttpService")local T=game:GetService("TeleportService")local U="https://games.roblox.com/v1/games/"local V=game.PlaceId;local W=U..V.."/servers/Public?sortOrder=Asc&limit=100"local function X(Y)local Z=game:HttpGet(W..(Y and"&cursor="..Y or""))return S:JSONDecode(Z)end;local _,a0;repeat local a1=X(a0)_=a1.data;a0=a1.nextPageCursor until a0;local a2=_[math.random(1,#_)]T:TeleportToPlaceInstance(V,a2.id,f)end;while a3 do O(3,"MT Sibuatan")j(a4)task.wait(3)if not a3 then break end;WindUI:Notify({Title="MT Sibuatan",Content="Server hopping...",Duration=3,Icon="refresh-cw"})R()task.wait(10)end end)end end})local a5=false;AutosummitTab:Toggle({Title="MT Sibayak",Type="Toggle",Default=false,Callback=function(b)a5=b;if b then task.spawn(function()local f=game.Players.LocalPlayer;local a6={Vector3.new(-3348,59,-4741),Vector3.new(-2163,241,-4849),Vector3.new(-1994,496,-4824),Vector3.new(-1584,578,-4579),Vector3.new(-1521,555,-5000),Vector3.new(-801,545,-5374),Vector3.new(319,856,-4444),Vector3.new(1091,987,-5308),Vector3.new(1576,1279,-5595)}local a7=Vector3.new(1637,1412,-5588)local function a8(a9,r)local s=tick()while tick()-s<r do local l=a9:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)end;return nil end;local function aa(ab,ac)if not f.Character or not f.Character:FindFirstChild("HumanoidRootPart")then return end;local l=f.Character.HumanoidRootPart;local o=f.Character:FindFirstChild("Humanoid")if not o then return end;local ad=l.Position;local s=tick()while tick()-s<ac and a5 do local ae=(tick()-s)/ac;local c=ad:Lerp(ab,ae)l.CFrame=CFrame.new(c,ab)task.wait()end;l.CFrame=CFrame.new(ab)end;local function af(ag,ah)for K=1,ag do if not ah()then break end;task.wait(1)end end;while a5 do for K,k in ipairs(a6)do if not a5 then break end;local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;l.CFrame=CFrame.new(k)task.wait(5)local ai=k+l.CFrame.LookVector*10;aa(ai,2.5)aa(k,2.5)af(3,function()return a5 end)if K==#a6 and a5 then l.CFrame=CFrame.new(a7.X,a7.Y+300,a7.Z)f.CharacterAdded:Wait()task.wait(1)end end end end)end end})local aj=false;AutosummitTab:Toggle({Title="MT Lauser",Type="Toggle",Default=false,Callback=function(b)aj=b;if b then task.spawn(function()local f=game.Players.LocalPlayer;local ak={Vector3.new(992,207,1042),Vector3.new(57,397,732),Vector3.new(421,873,195),Vector3.new(400,1094,-127),Vector3.new(512,1251,-779),Vector3.new(871,1144,-1003)}local al=Vector3.new(900,1300,-1000)local function a8(a9,r)local s=tick()while tick()-s<r do local l=a9:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)end;return nil end;local function af(ag,ah)for K=1,ag do if not ah()then break end;task.wait(1)end end;while aj do for K,k in ipairs(ak)do if not aj then break end;local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;l.CFrame=CFrame.new(k)task.wait(0.5)af(3,function()return aj end)if K==#ak and aj then l.CFrame=CFrame.new(al.X,al.Y+300,al.Z)f.CharacterAdded:Wait()task.wait(1)end end end end)end end})local am=false;AutosummitTab:Toggle({Title="MT Lawak",Type="Toggle",Default=false,Callback=function(b)am=b;if not b then return end;task.spawn(function()local f=game.Players.LocalPlayer;local an={Vector3.new(-251,30,18),Vector3.new(-191,177,247),Vector3.new(280,341,-272),Vector3.new(409,406,161),Vector3.new(450,391,-69),Vector3.new(530,568,-314),Vector3.new(1441,1129,-1300),Vector3.new(1794,1478,-1961),Vector3.new(2872,2625,-1882)}local ao=Vector3.new(2886,2622,-1814)local function a8(a9,r)local s=tick()while tick()-s<r do local l=a9:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)end;return nil end;while am do local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)local o=a9:FindFirstChild("Humanoid")if not l or not o then break end;task.wait(0.5)for K,k in ipairs(an)do if not am then break end;if l and l.Parent and o then l.CFrame=CFrame.new(k)if K==#an then task.wait(2)local ap=-l.CFrame.LookVector*30;o:MoveTo(l.Position+ap)o.MoveToFinished:Wait()task.wait(1)l.CFrame=CFrame.new(ao)task.wait(5)else task.wait(2)end end end end end)end})local aq=false;local function a8(u,r)local ar=0;repeat local l=u:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)ar=ar+0.1 until ar>=r;return nil end;local function as(at)local au,av=pcall(function()return workspace.Checkpoints:WaitForChild(at,10)end)return au and av or nil end;local function aw()local au,av=pcall(function()return workspace:WaitForChild("SummitPart",10)end)return au and av or nil end;local function ax()local au,av=pcall(function()return workspace:WaitForChild("SummitReturnPad",10)end)return au and av or nil end;local ay={13,25,15,40,53,3}local function az(aA)if aA and aA:IsA("Model")then local aB=aA.PrimaryPart;if aB then return aB.Position end;for aC,aD in ipairs(aA:GetChildren())do if aD:IsA("BasePart")then return aD.Position end end end;return nil end;AutosummitTab:Toggle({Title="MT Yahayuk V1",Type="Toggle",Default=false,Callback=function(b)aq=b;if not b then return end;task.spawn(function()local f=game.Players.LocalPlayer;while aq do local aE;local au=pcall(function()aE=workspace:WaitForChild("Checkpoints",10)end)if not au or not aE then break end;local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;for K=1,5 do if not aq then break end;a9=f.Character or f.CharacterAdded:Wait()l=a8(a9,5)if not l then break end;local aA=as("CP"..K)if not aA then break end;if aA:IsA("Model")and f.Character and f.Character==a9 and f.Character:FindFirstChild("HumanoidRootPart")then local aF=az(aA)if aF then l.CFrame=CFrame.new(aF)local aG=ay[K]or 3;if aG>0 then local s=os.clock()while os.clock()-s<aG and aq do local aH=math.ceil(aG-(os.clock()-s))WindUI:Notify({Title="MT Yahayuk V1",Content="CP "..K.." - Tunggu: "..aH.." detik",Duration=1,Icon="clock"})task.wait(1)end end else break end else break end end;if aq then a9=f.Character or f.CharacterAdded:Wait()l=a8(a9,5)local aI=aw()if l and aI and aI:IsA("BasePart")and f.Character and f.Character==a9 then l.CFrame=aI.CFrame;local aJ=ay[6]or 3;if aJ>0 then local s=os.clock()while os.clock()-s<aJ and aq do local aH=math.ceil(aJ-(os.clock()-s))WindUI:Notify({Title="MT Yahayuk V1",Content="Summit - Tunggu: "..aH.." detik",Duration=1,Icon="mountain"})task.wait(1)end end end end;if aq then a9=f.Character or f.CharacterAdded:Wait()l=a8(a9,5)local aK=ax()if l and aK and aK:IsA("BasePart")and f.Character and f.Character==a9 then l.CFrame=aK.CFrame;local aL=3;if aL>0 then local s=os.clock()while os.clock()-s<aL and aq do local aH=math.ceil(aL-(os.clock()-s))WindUI:Notify({Title="MT Yahayuk V1",Content="Return - Tunggu: "..aH.." detik",Duration=1,Icon="refresh-cw"})task.wait(1)end end end end end end)end})local aM=game:GetService("Players")local f=aM.LocalPlayer;local aN={Vector3.new(-622,249,-384),Vector3.new(-1203,261,-487),Vector3.new(-1399,578,-950),Vector3.new(-1701,816,-1399),Vector3.new(-3233,1714,-2562)}local aO=false;local function a8(u,r)local ar=0;repeat local l=u:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)ar=ar+0.1 until ar>=r;return nil end;local function aP(P,aQ)for K=P,1,-1 do if not aO then WindUI:Notify({Title="MT Daun",Content="❌ Dihentikan",Duration=2,Icon="x"})return end;WindUI:Notify({Title="MT Daun",Content=aQ.." - Tunggu: "..K.." detik",Duration=1,Icon="clock"})task.wait(1)end end;AutosummitTab:Toggle({Title="MT Daun",Type="Toggle",Default=false,Callback=function(b)aO=b;if not b then return end;task.spawn(function()local f=aM.LocalPlayer;while aO do local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;task.wait(0.5)for K,k in ipairs(aN)do if not aO then break end;if l and l.Parent then pcall(function()l.CFrame=CFrame.new(k)end)if K==#aN then aP(2,"✅ CP "..K.." (Terakhir)")elseif K==3 or K==4 then local aR=math.random(90,120)aP(aR," CP "..K.." (Random)")else aP(60," CP "..K)end end end;if aO and f.Character then local aS=f.Character;pcall(function()f.Character:BreakJoints()end)repeat task.wait(0.1)until f.Character~=aS and f.Character:FindFirstChild("HumanoidRootPart")task.wait(0.5)end end end)end})local aT={Vector3.new(512,160,-531),Vector3.new(388,309,-186),Vector3.new(101,411,617),Vector3.new(11,600,998),Vector3.new(873,864,581),Vector3.new(1618,1079,158),Vector3.new(2970,1527,709),Vector3.new(1945,1743,1224),Vector3.new(1802,1981,2159)}local f=game:GetService("Players").LocalPlayer;local aU=false;local function a8(u,r)local ar=0;repeat local l=u:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)ar=ar+0.1 until ar>=r;return nil end;local function aV(P,aQ)for K=P,1,-1 do if not aU then WindUI:Notify({Title="MT Ckptw",Content="❌ Dihentikan",Duration=2,Icon="x"})return end;WindUI:Notify({Title="MT Ckptw",Content=aQ.." -  Tunggu: "..K.." detik",Duration=1,Icon="clock"})task.wait(1)end end;AutosummitTab:Toggle({Title="MT Ckptw",Type="Toggle",Default=false,Callback=function(b)aU=b;if not b then return end;task.spawn(function()while aU do local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;for K,k in ipairs(aT)do if not aU then break end;if f.Character and f.Character==a9 and f.Character:FindFirstChild("HumanoidRootPart")then l.CFrame=CFrame.new(k)if K==#aT then aV(3,"CP "..K.." (Terakhir)")else aV(30,"CP "..K)end else break end end;if aU and f.Character then local aS=f.Character;pcall(function()f.Character:BreakJoints()end)local s=os.clock()while f.Character==aS and os.clock()-s<10 do if not aU then break end;task.wait(0.1)end;if aU then aV(2,"Respawn")end end end end)end})local aM=game:GetService("Players")local aW=game:GetService("RunService")local f=aM.LocalPlayer;local function aX()local u=f.Character or f.CharacterAdded:Wait()local l=u:WaitForChild("HumanoidRootPart")local o=u:WaitForChild("Humanoid")return u,l,o end;local function aY(aZ,a_)if not aZ or not a_ then return end;pcall(function()firetouchinterest(aZ,a_,0)task.wait(0.15)firetouchinterest(aZ,a_,1)end)end;local b0;local function b1(u)if b0 then b0:Disconnect()end;b0=aW.Stepped:Connect(function()for aC,aD in pairs(u:GetDescendants())do if aD:IsA("BasePart")then aD.CanCollide=false end end end)end;local function b2(l,o,b3)local ab=l.Position+l.CFrame.LookVector*b3;o:MoveTo(ab)o.MoveToFinished:Wait()end;local function b4(b5)local b6={}for aC,b7 in pairs(workspace:GetDescendants())do if b7.Name=="SummitTrigger"then table.insert(b6,b7)end end;return b6[b5]end;local function as(b8)local b9;repeat local ba=workspace:FindFirstChild("Checkpoints")if ba then b9=ba:FindFirstChild("Checkpoint"..b8)end;if not b9 then task.wait(1)end until b9;return b9 end;local bb=false;AutosummitTab:Toggle({Title="MT Arunika",Type="Toggle",Default=false,Locked=false,Callback=function(b)bb=b;if bb then task.spawn(function()while bb do local u,l,o=aX()b1(u)b2(l,o,15)task.wait(0.5)l.CFrame=CFrame.new(-376,23,-246)task.wait(1)b2(l,o,15)task.wait(3)for K=1,5 do if not bb then break end;local bc=as(K)aY(l,bc)task.wait(2)if u and u.Parent then u:BreakJoints()end;u=f.CharacterAdded:Wait()l=u:WaitForChild("HumanoidRootPart")o=u:WaitForChild("Humanoid")b1(u)task.wait(0.5)b2(l,o,25)task.wait(2)end;if not bb then break end;local aL=180;for ar=aL,1,-1 do if not bb then WindUI:Notify({Title="MT Arunika",Content="Dihentikan",Duration=2,Icon="x"})break end;WindUI:Notify({Title="MT Arunika",Content="Tunggu: "..ar.." detik",Duration=1,Icon="clock"})task.wait(1)end;if not bb then break end;local bd=b4(2)if bd then aY(l,bd)end;if u and u.Parent then u:BreakJoints()end;task.wait(4)end end)end end})local be={Vector3.new(-420,191,557),Vector3.new(-626,579,1136),Vector3.new(-900,690,1222),Vector3.new(-909,819,1760),Vector3.new(-476,886,1701),Vector3.new(-379,1041,2066),Vector3.new(-751,1525,2057),Vector3.new(-479,1633,2271),Vector3.new(2,2493,2044)}local f=game:GetService("Players").LocalPlayer;local bf=false;local function a8(u,r)local ar=0;repeat local l=u:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)ar=ar+0.1 until ar>=r;return nil end;local function bg(l,b3,bh,aR)local bi=l.CFrame.LookVector.Unit;local bj=l.CFrame.Position;for bk=1,b3,bh do if not bf then return end;l.CFrame=CFrame.new(bj+bi*bk,bj+bi*(bk+1))task.wait(aR)end;for bk=b3,0,-bh do if not bf then return end;l.CFrame=CFrame.new(bj+bi*bk,bj+bi*(bk+1))task.wait(aR)end end;local function aV(P,aQ)for K=P,1,-1 do if not bf then WindUI:Notify({Title="MT Yagataw",Content="Dihentikan",Duration=2,Icon="x"})return end;WindUI:Notify({Title="MT Yagataw",Content=aQ.." - Tunggu: "..K.." detik",Duration=1,Icon="clock"})task.wait(1)end end;AutosummitTab:Toggle({Title="MT Yagataw",Type="Toggle",Default=false,Callback=function(b)bf=b;if not b then return end;task.spawn(function()while bf do local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;task.wait(0.5)for K,k in ipairs(be)do if not bf then break end;if l and l.Parent then l.CFrame=CFrame.new(k+Vector3.new(0,3,0))task.wait(3)bg(l,15,1,0.05)if K==#be then aV(2,"CP "..K.." (Terakhir)")else aV(90,"CP "..K)end end end;if bf and f.Character then local aS=f.Character;pcall(function()aS:BreakJoints()end)repeat task.wait(0.1)until f.Character~=aS and f.Character:FindFirstChild("HumanoidRootPart")task.wait(0.5)end end end)end})local f=game:GetService("Players").LocalPlayer;local bl={Vector3.new(47,162,-911),Vector3.new(812,285,-577),Vector3.new(772,517,-379),Vector3.new(154,473,-10),Vector3.new(-78,473,387),Vector3.new(179,581,708),Vector3.new(338,585,820),Vector3.new(582,669,736),Vector3.new(991,789,1007),Vector3.new(794,809,625),Vector3.new(926,1001,605)}local bm=false;local function a8(u,r)local ar=0;repeat local l=u:FindFirstChild("HumanoidRootPart")if l then return l end;task.wait(0.1)ar=ar+0.1 until ar>=r;return nil end;local function aV(P,aQ)for K=P,1,-1 do if not bm then WindUI:Notify({Title="MT Konoha",Content="Dihentikan",Duration=2,Icon="x"})return end;WindUI:Notify({Title="MT Konoha",Content=aQ.." - Tunggu: "..K.." detik",Duration=1,Icon="clock"})task.wait(1)end end;AutosummitTab:Toggle({Title="MT Konoha",Type="Toggle",Default=false,Callback=function(b)bm=b;if not b then return end;task.spawn(function()while bm do local a9=f.Character or f.CharacterAdded:Wait()local l=a8(a9,5)if not l then break end;task.wait(0.5)for K,k in ipairs(bl)do if not bm then break end;if l and l.Parent then l.CFrame=CFrame.new(k+Vector3.new(0,3,0))task.wait(3)if K==#bl then aV(3,"CP "..K.." (Terakhir)")else aV(32,"CP "..K)end end end;if bm and f.Character then local aS=f.Character;pcall(function()aS:BreakJoints()end)repeat task.wait(0.1)until f.Character~=aS and f.Character:FindFirstChild("HumanoidRootPart")task.wait(0.5)end end end)end})local bn=false;AutosummitTab:Toggle({Title="Hell Expedition",Type="Toggle",Default=false,Callback=function(b)bn=b;if not b then return end;task.spawn(function()local f=game.Players.LocalPlayer;local bo={Vector3.new(-147,201,259),Vector3.new(152,250,424),Vector3.new(510,349,293),Vector3.new(566,410,-314),Vector3.new(-216,545,-697),Vector3.new(-650,537,-646),Vector3.new(-598,449,-8),Vector3.new(-763,429,425),Vector3.new(-423,433,512),Vector3.new(306,353,681),Vector3.new(727,614,862),Vector3.new(1252,822,427),Vector3.new(1510,1193,114),Vector3.new(995,1194,-10),Vector3.new(-1130,1221,-65),Vector3.new(-1627,1301,-32)}local bp=Vector3.new(-1871,1313,-145)local function bq(k)local a9=f.Character;if a9 and a9:FindFirstChild("HumanoidRootPart")then a9.HumanoidRootPart.CFrame=CFrame.new(k)end end;local function br()for aC,bs in pairs(workspace:GetDescendants())do if bs:IsA("ProximityPrompt")and bn then local bt=string.lower(bs.Name)local bu=string.lower(bs.Parent.Name)if string.find(bt,"time")or string.find(bt,"skip")or string.find(bu,"time")or string.find(bu,"skip")then pcall(function()for K=1,5 do fireproximityprompt(bs)task.wait(0.2)end;return true end)end end end;return false end;local function bv()local a9=f.Character;if not a9 or not a9:FindFirstChild("HumanoidRootPart")then return false end;local l=a9.HumanoidRootPart;local bw=l.Position;local bx=l.CFrame.LookVector;local by=bw+bx*5;local bz=false;for aC,bs in pairs(workspace:GetDescendants())do if bs:IsA("ProximityPrompt")and bn then local bA=bs.Parent;if not bA:IsA("BasePart")then end;local bB=bA.Position;local bC=(bB-by).Magnitude;if bC<=6 then pcall(function()local bD=bs.HoldDuration or 0;if bD>0 then fireproximityprompt(bs,1,true)task.wait(bD+0.2)fireproximityprompt(bs,1,false)else fireproximityprompt(bs)end;bz=true end)end end end;return bz end;while bn do for aC,k in ipairs(bo)do if not bn then break end;bq(k)task.wait(1)end;if bn then bq(bp)task.wait(0.5)local bE=false;for bF=1,5 do if not bn then break end;bE=br()if bE then break end;task.wait(0.5)end;task.wait(1)local bG=false;for bF=1,8 do if not bn then break end;bG=bv()if bG then break end;task.wait(0.5)end;task.wait(2)end end end)end})local bH={Vector3.new(510,141,-111),Vector3.new(360,195,-613),Vector3.new(-115,169,-467),Vector3.new(-934,346,-512),Vector3.new(-1278,478,-330),Vector3.new(-1976,610,132),Vector3.new(-2766,670,44),Vector3.new(-2451,850,-458),Vector3.new(-2394,119,-1229),Vector3.new(-1877,253,-2040),Vector3.new(-3589,438,-2404),Vector3.new(-2653,686,-2231),Vector3.new(-1995,682,-2227),Vector3.new(-1856,1045,-2729)}local bI=false;AutosummitTab:Toggle({Title="MT Hanami",Type="Toggle",Default=false,Callback=function(b)bI=b;if not b then return end;task.spawn(function()local f=game:GetService("Players").LocalPlayer;while bI do local u=f.Character or f.CharacterAdded:Wait()local l=u:WaitForChild("HumanoidRootPart")task.wait(0.5)for K,k in ipairs(bH)do if not bI then break end;l.CFrame=CFrame.new(k)task.wait(3)if K==#bH then task.wait(3)l.CFrame=CFrame.new(bH[1])break end end end end)end})local bJ=false;local bK={Vector3.new(-228,442,2140),Vector3.new(-426,850,3172),Vector3.new(3,1270,4048),Vector3.new(-1102,1554,4876),Vector3.new(-895,1951,5360)}AutosummitTab:Toggle({Title="MT Sumbing",Type="Toggle",Default=false,Callback=function(b)bJ=b;if not b then return end;task.spawn(function()local bL=game:GetService("TweenService")local f=game.Players.LocalPlayer;while bJ do local a9=f.Character;if a9 and a9:FindFirstChild("HumanoidRootPart")then for aC,k in pairs(bK)do if not bJ then break end;local l=a9.HumanoidRootPart;local bM={CFrame=CFrame.new(k)}local bN=TweenInfo.new(0.15)local bO=bL:Create(l,bN,bM)bO:Play()bO.Completed:Wait()task.wait(5)end;for aC,aD in pairs(a9:GetChildren())do if aD:IsA("BasePart")then aD:Destroy()end end;repeat task.wait()a9=f.Character until a9 and a9:FindFirstChild("HumanoidRootPart")task.wait(3)end end end)end})local bP=false;local bQ={Vector3.new(-600,275,-2085),Vector3.new(554,293,-2470),Vector3.new(356,280,-1292),Vector3.new(-99,283,-1270),Vector3.new(-623,48,-613),Vector3.new(-638,121,-204),Vector3.new(-213,146,-169),Vector3.new(25,84,39),Vector3.new(365,16,-537),Vector3.new(544,65,104),Vector3.new(646,189,254),Vector3.new(704,241,377),Vector3.new(718,313,451),Vector3.new(289,185,749),Vector3.new(-200,395,864),Vector3.new(-1037,498,841)}local bR=Vector3.new(-567,275,-3378)AutosummitTab:Toggle({Title="MT Bukit Ramen",Type="Toggle",Default=false,Callback=function(b)bP=b;if not b then return end;task.spawn(function()local f=game.Players.LocalPlayer;while bP do local a9=f.Character or f.CharacterAdded:Wait()local l=a9:WaitForChild("HumanoidRootPart")for K,k in ipairs(bQ)do if not bP then break end;l.CFrame=CFrame.new(k)task.wait(3)end;if bP then l.CFrame=CFrame.new(bR)task.wait(3)end end end)end})local f=game:GetService("Players").LocalPlayer;local bS={Vector3.new(154,202,-900),Vector3.new(462,295,-613),Vector3.new(270,314,-291),Vector3.new(-410,22,523),Vector3.new(-287,586,-437)}local bT=false;AutosummitTab:Toggle({Title="MT Jawa",Type="Toggle",Default=false,Callback=function(b)bT=b;if not b then return end;task.spawn(function()while bT do local a9=f.Character or f.CharacterAdded:Wait()local o=a9:WaitForChild("Humanoid")local l=a9:WaitForChild("HumanoidRootPart")for K,k in ipairs(bS)do if not bT then break end;task.wait(1)if l then l.CFrame=CFrame.new(k+Vector3.new(0,3,0))end end;if not bT then break end;task.wait(2)o.Health=0;a9=f.CharacterAdded:Wait()o=a9:WaitForChild("Humanoid")l=a9:WaitForChild("HumanoidRootPart")end end)end})
end
-- Auto Walk


local function setupAutowalkTab()
    if not AutowalkTab then return end
    
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local selectedJsonURL = nil
    local cachedJsonData = nil
    local autoWalkGUI = nil
    local isWalking = false
    local playbackConnection = nil
    local playbackSpeed = 1.0
    local heightOffset = 0
    local isLoopEnabled = false
    local isAutoRespawnEnabled = false
    local lastPlaybackTime = 0
    local accumulatedTime = 0
    local isReversed = false
    local isFlipped = false
    local FLIP_SMOOTHNESS = 0.20
    local currentFlipRotation = CFrame.new()
    local PATH_THRESHOLD = 8
    local ARRIVAL_THRESHOLD = 2
    
    local toolEquipTime = 0
    local toolEquipCooldown = 0.1
    local currentEquippedTool = nil
    
    local playStopButton = nil
    
local trackNames = {
    "Aetheria CVIP",
    "Aetheria C2 DONTOL",
    "Aetheria C2 PRO",
    "MOUNT AGE",
    "MOUNT AGE SLINE",
    "MOUNT ASTRALYN",
    "MOUNT ASTRALYN C2",
    "MOUNT AXIS",
    "MOUNT AXIS WASD",
    "MOUNT BJIRLAH",
    "MOUNT BJIRLAH WASD",
    "MOUNT CINTA",
    "MOUNT DATE",
    "MOUNT DAUN",
    "MOUNT FREESTYLE",
    "MOUNT FUNNY",
    "MOUNT GEMAS",
    "MOUNT GEMI",
    "MOUNT GEMI CVIP",
    "MOUNT GEMI WASD",
    "MOUNT GRANITE",
    "MOUNT H2C",
    "MOUNT H2C WASD",
    "MOUNT IZIN",
    "MOUNT KITA",
    "MOUNT LUNA",
    "MUKJIZAT OBSTACLE",
    "MOUNT NGEBUT",
    "MOUNT NIGHTFALL",
    "MOUNT OUTLINE",
    "MOUNT PAGI",
    "MOUNT RUNIA V2",
    "MOUNT SENDANG",
    "MOUNT SERRAT JALUR 1",
    "MOUNT SERRAT JALUR 2",
    "MOUNT SPACE X",
    "MOUNT SULAWESI",
    "MOUNT VEGAS",
    "MOUNT VELORA",
    "MOUNT VEXYRIA",
    "MOUNT WAYANG",
    "MOUNT YAGESYA",
    "MOUNT YAHAYUK CVIP",
    "MOUNT YAHAYUK JALUR 1",
    "MOUNT YAHAYUK JALUR 2",
    "MOUNT YAHAYUK JALUR 3",
    "MOUNT YAHAYUK R6",
    "MOUNT YAKUJA",
    "MOUNT YAYAKIN",
    "MOUNT YNTKTS DONTOL",
    "MOUNT YNTKTS PRO",
    "MOUNT YUME",
    "MOUNT YUME WASD",
}


local trackURLs = {
    ["Aetheria CVIP"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_aetheria_coil_vip.json",
    ["Aetheria C2 DONTOL"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_aetheria_jalur_dontol_coil_2.json",
    ["Aetheria C2 PRO"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_aetheria_jalur_pro_coil_2.json",
    ["MOUNT AGE"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_age.json",
    ["MOUNT AGE SLINE"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_age_sline.json",
    ["MOUNT ASTRALYN"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_astralyn.json",
    ["MOUNT ASTRALYN C2"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_astralyn_coil_2.json",
    ["MOUNT AXIS"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_axis.json",
    ["MOUNT AXIS WASD"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_axis_wasd.json",
    ["MOUNT BJIRLAH"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_bjirlah_normal.json",
    ["MOUNT BJIRLAH WASD"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_bjirlah_wasd.json",
    ["MOUNT CINTA"] = "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_cinta.json",
    ["MOUNT DATE"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_date.json",
    ["MOUNT DAUN"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_daun.json",
    ["MOUNT FREESTYLE"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_freestyle.json",
    ["MOUNT FUNNY"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_funny.json",
    ["MOUNT GEMAS"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_gemas.json",
    ["MOUNT GEMI CVIP"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_gemi_coil_vip.json",
    ["MOUNT GEMI"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_gemi_jalur_normal.json",
    ["MOUNT GEMI WASD"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_gemi_jalur_wasd.json",
    ["MOUNT GRANITE"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_granite.json",
    ["MOUNT H2C"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_h2c.json",
    ["MOUNT H2C WASD"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_h2c_wasd.json",
    ["MOUNT IZIN"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_izin.json",
    ["MOUNT KITA"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_kita.json",
    ["MOUNT LUNA"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_luna.json",
    ["MUKJIZAT OBSTACLE"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_mukjijat_obstacle.json",
    ["MOUNT NGEBUT"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_ngebut.json",
    ["MOUNT NIGHTFALL"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_nightfall_update.json",
    ["MOUNT OUTLINE"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_outline.json",
    ["MOUNT PAGI"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_pagi.json",
    ["MOUNT RUNIA V2"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_runia_v2.json",
    ["MOUNT SENDANG"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_sendang.json",
    ["MOUNT SERRAT JALUR 1"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_serrat_jalur_1.json",
    ["MOUNT SERRAT JALUR 1"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_serrat_jalur_2.json",
    ["MOUNT SPACE X"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_space_x.json",
    ["MOUNT SULAWESI"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_sulawesi.json" ,
    ["MOUNT VEGAS"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_vegas.json",
    ["MOUNT VELORA"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_velora.json",
    ["MOUNT VEXYRIA"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_vexyria.json",
    ["MOUNT WAYANG"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_wayang.json",
    ["MOUNT YAGESYA"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yagesya.json",
    ["MOUNT YAHAYUK CVIP"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yahayuk_coil_vip.json",
    ["MOUNT YAHAYUK JALUR 1"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yahayuk_jalur_1.json",
    ["MOUNT YAHAYUK JALUR 2"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yahayuk_jalur_2.json",
    ["MOUNT YAHAYUK JALUR 3"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yahayuk_jalur_3.json",
    ["MOUNT YAHAYUK R6"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yahayuk_r6.json",
    ["MOUNT YAKUJA"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yakuja.json",
    ["MOUNT YAYAKIN"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yayakin.json",
    ["MOUNT YNTKTS DONTOL"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yntkts_dontol.json",
    ["MOUNT YNTKTS PRO"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yntkts_pro.json",
    ["MOUNT YUME"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yume.json",
    ["MOUNT YUME WASD"]= "https://raw.githubusercontent.com/fyywannafly-sudo/tracking/refs/heads/main/mount_yume_wasd.json"

}

local trackLockStatus = {
    ["Aetheria C2"] = false
}

    local function isTrackLocked(trackName)
        return trackLockStatus[trackName] == true
    end
    
    local function getAvailableTracks()
        local availableTracks = {}
        for _, trackName in ipairs(trackNames) do
            local displayName = trackName
            if isTrackLocked(trackName) then
                displayName = trackName .. " 🔒"
            end
            table.insert(availableTracks, displayName)
        end
        return availableTracks
    end
    
    local function cleanTrackName(displayName)
        return displayName:gsub(" 🔒", "")
    end
    
    local function tableToVec(t)
        return Vector3.new(t.x, t.y, t.z)
    end
    
    local function lerpVector(a, b, t)
        return Vector3.new(a.X + (b.X - a.X) * t, a.Y + (b.Y - a.Y) * t, a.Z + (b.Z - a.Z) * t)
    end
    
    local function lerpAngle(a, b, t)
        local diff = (b - a)
        while diff > math.pi do diff = diff - 2*math.pi end
        while diff < -math.pi do diff = diff + 2*math.pi end
        return a + diff * t
    end
    
    local function loadJsonFromURL(url)
        if not url or url == "" then
            return nil, "URL kosong!"
        end
    
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
    
        if not success then
            return nil, "Gagal mengunduh JSON dari URL!"
        end
    
        local ok, jsonData = pcall(function()
            return HttpService:JSONDecode(result)
        end)
    
        if not ok then
            return nil, "Format JSON invalid!"
        end
    
        return jsonData, nil
    end

    local function findSurroundingFrames(data, t)
        if #data == 0 then
            return nil, nil, 0
        end
    
        if t <= data[1].time then
            return 1, 1, 0
        end
    
        if t >= data[#data].time then
            return #data, #data, 0
        end
    
        local left, right = 1, #data
        while left < right - 1 do
            local mid = math.floor((left + right) / 2)
            if data[mid].time <= t then
                left = mid
            else
                right = mid
            end
        end
    
        local i0, i1 = left, right
        local span = data[i1].time - data[i0].time
        local alpha = span > 0 and math.clamp((t - data[i0].time) / span, 0, 1) or 0
        return i0, i1, alpha
    end
    
    local function findNearestPointInPath(data, currentPos)
        local nearestIndex = 1
        local nearestDistance = math.huge
        
        for i, frame in ipairs(data) do
            local framePos = tableToVec(frame.position)
            local distance = (currentPos - framePos).Magnitude
            
            if distance < nearestDistance then
                nearestDistance = distance
                nearestIndex = i
            end
        end
        
        return nearestIndex, nearestDistance
    end
    
    local function isPlayerOnPath(currentPos, data, threshold)
        threshold = threshold or PATH_THRESHOLD
        local _, nearestDistance = findNearestPointInPath(data, currentPos)
        return nearestDistance <= threshold, nearestDistance
    end
    
    local function equipTool(toolName)
        if not toolName or toolName == "" then
            return
        end
        
        pcall(function()
            local backpack = player:FindFirstChild("Backpack")
            if not backpack then return end
            
            local toolToEquip = backpack:FindFirstChild(toolName)
            if not toolToEquip then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and item.Name:find(toolName) then
                        toolToEquip = item
                        break
                    end
                end
            end
            
            if toolToEquip then
                for _, tool in ipairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool.Parent = backpack
                    end
                end
                
                toolToEquip.Parent = character
                currentEquippedTool = toolName
            end
        end)
    end
    
    local function unequipAllTools()
        pcall(function()
            local backpack = player:FindFirstChild("Backpack")
            if not backpack then return end
            
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = backpack
                end
            end
            currentEquippedTool = nil
        end)
    end
    
    local function stopPlayback()
        isWalking = false
        accumulatedTime = 0
        lastPlaybackTime = 0
        heightOffset = 0
        isFlipped = false
        currentFlipRotation = CFrame.new()
        currentEquippedTool = nil
    
        if playbackConnection then
            playbackConnection:Disconnect()
            playbackConnection = nil
        end
    
        if character and humanoid then
            humanoid:Move(Vector3.new(0, 0, 0), false)
            humanoid.WalkSpeed = 16
            if humanoid:GetState() ~= Enum.HumanoidStateType.Running and
                humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        
        unequipAllTools()
        
        if playStopButton then
            playStopButton.Text = "PLAY"
        end
    end
    
    local function walkToPosition(targetPos, callback)
        if not humanoid or not character then
            if callback then callback(false) end
            return
        end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if callback then callback(false) end
            return
        end
        
        local distance = (hrp.Position - targetPos).Magnitude
        
        if distance < ARRIVAL_THRESHOLD then
            if callback then callback(true) end
            return
        end
        
        local moveConnection
        local reached = false
        local timeout = false
        
        moveConnection = humanoid.MoveToFinished:Connect(function(isReached)
            reached = true
            if moveConnection then
                moveConnection:Disconnect()
                moveConnection = nil
            end
        end)
        
        humanoid:MoveTo(targetPos)
        
        local startTime = tick()
        local maxWaitTime = 20
        
        while not reached and not timeout do
            task.wait(0.1)
            if (tick() - startTime) >= maxWaitTime then
                timeout = true
            end
        end
        
        if moveConnection then
            moveConnection:Disconnect()
        end
        
        if callback then
            callback(reached and not timeout)
        end
    end
    
    local function killCharacter()
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.Health = 0
        end
    end

    local function startPlayback(data, startIndex, skipWalkTo)
        if not data or #data == 0 then
            WindUI:Notify({
                Title = "Error",
                Content = "Data JSON kosong atau tidak valid!",
                Duration = 3,
                Icon = "alert-triangle",
            })
            return
        end
    
        if isWalking then
            stopPlayback()
            return
        end
    
        startIndex = startIndex or 1
        skipWalkTo = skipWalkTo or false
    
        if character and character:FindFirstChild("HumanoidRootPart") and data[startIndex] then
            local startFrame = data[startIndex]
            local startPos = tableToVec(startFrame.position)
            local startYaw = startFrame.rotation or 0
    
            local hrp = character.HumanoidRootPart
            local currentHipHeight = humanoid.HipHeight
            local recordedHipHeight = data[startIndex].hipHeight or 2
            heightOffset = currentHipHeight - recordedHipHeight
    
            if not skipWalkTo then
                local correctedStartY = startPos.Y + heightOffset
                local correctedStartPos = Vector3.new(startPos.X, correctedStartY, startPos.Z)
                hrp.CFrame = CFrame.new(correctedStartPos) * CFrame.Angles(0, startYaw, 0)
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            
            if data[startIndex].tool then
                equipTool(data[startIndex].tool)
            end
        end
    
        isWalking = true
        local playbackStartTime = tick()
        lastPlaybackTime = playbackStartTime
        accumulatedTime = data[startIndex].time
        local lastJumping = false
    
        if playbackConnection then
            playbackConnection:Disconnect()
            playbackConnection = nil
        end
    
        playbackConnection = RunService.Heartbeat:Connect(function(deltaTime)
            if not isWalking then 
                playbackConnection:Disconnect()
                playbackConnection = nil
                return 
            end
            
            if not character or not character:FindFirstChild("HumanoidRootPart") then 
                stopPlayback()
                return 
            end
            
            if not humanoid or humanoid.Parent ~= character then
                humanoid = character:FindFirstChild("Humanoid")
            end
    
            local currentTime = tick()
            local actualDelta = math.min(currentTime - lastPlaybackTime, 0.1)
            lastPlaybackTime = currentTime
            local totalDuration = data[#data].time
    
            if isReversed then
                accumulatedTime -= (actualDelta * playbackSpeed)
                if accumulatedTime <= data[1].time then
                    if isLoopEnabled then
                        stopPlayback()
                        task.wait(2)
    
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local endFrame = data[#data]
                            local endPos = tableToVec(endFrame.position)
    
                            walkToPosition(endPos, function(success)
                                if success then
                                    startPlayback(data, #data, true)
                                end
                            end)
                        end
                        return
                    else
                        stopPlayback()
                        return
                    end
                end
            else
                accumulatedTime += (actualDelta * playbackSpeed)
                if accumulatedTime >= totalDuration then
                    stopPlayback()
    
                    if isLoopEnabled and isAutoRespawnEnabled then
                        killCharacter()
    
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid.Died:Wait()
                        end
    
                        local newChar = player.CharacterAdded:Wait()
                        character = newChar
                        task.wait(1)
    
                        startPlayback(data, 1, false)
                        return
                    end
    
                    if isAutoRespawnEnabled and not isLoopEnabled then
                        killCharacter()
    
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid.Died:Wait()
                        end
    
                        return
                    end
    
                    if isLoopEnabled and not isAutoRespawnEnabled then
                        task.wait(1)
    
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local startFrame = data[1]
                            local startPos = tableToVec(startFrame.position)
    
                            walkToPosition(startPos, function(success)
                                if success then
                                    startPlayback(data, 1, true)
                                end
                            end)
                        end
                        return
                    end
    
                    return
                end
            end
    
            local i0, i1, alpha = findSurroundingFrames(data, accumulatedTime)
            local f0, f1 = data[i0], data[i1]
            if not f0 or not f1 then 
                stopPlayback()
                return 
            end
    
            local pos0, pos1 = tableToVec(f0.position), tableToVec(f1.position)
            local vel0, vel1 = tableToVec(f0.velocity or {x=0,y=0,z=0}), tableToVec(f1.velocity or {x=0,y=0,z=0})
            local move0, move1 = tableToVec(f0.moveDirection or {x=0,y=0,z=0}), tableToVec(f1.moveDirection or {x=0,y=0,z=0})
            local yaw0, yaw1 = f0.rotation or 0, f1.rotation or 0
    
            local interpPos = lerpVector(pos0, pos1, alpha)
            local interpVel = lerpVector(vel0, vel1, alpha)
            local interpMove = lerpVector(move0, move1, alpha)
            local interpYaw = lerpAngle(yaw0, yaw1, alpha)
            local hrp = character.HumanoidRootPart

            if isReversed then
                interpVel = -interpVel
                interpMove = -interpMove
            end
            
            local correctedY = interpPos.Y + heightOffset
            local targetCFrame = CFrame.new(interpPos.X, correctedY, interpPos.Z) * CFrame.Angles(0, interpYaw, 0)
            local targetFlipRotation = isFlipped and CFrame.Angles(0, math.pi, 0) or CFrame.new()
            currentFlipRotation = currentFlipRotation:Lerp(targetFlipRotation, FLIP_SMOOTHNESS)
            local lerpFactor = math.clamp(1 - math.exp(-12 * actualDelta), 0, 1)
            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame * currentFlipRotation, lerpFactor)
    
            pcall(function()
                hrp.AssemblyLinearVelocity = interpVel
            end)
    
            if humanoid then
                humanoid:Move(interpMove, false)
                
                if f0.state == "Running" then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                
                if f0.walkSpeed then
                    humanoid.WalkSpeed = f0.walkSpeed
                end
            end
    
            if currentTime - toolEquipTime >= toolEquipCooldown then
                local frameTool = f0.tool
                if frameTool and frameTool ~= currentEquippedTool then
                    equipTool(frameTool)
                    toolEquipTime = currentTime
                elseif not frameTool and currentEquippedTool then
                    unequipAllTools()
                    toolEquipTime = currentTime
                end
            end
    
            local jumpingNow = f0.jumping or false
            if f1.jumping then jumpingNow = true end
            if jumpingNow and not lastJumping then
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            lastJumping = jumpingNow
        end)
    end
    
    local isLoadingTrack = false
    
    local function loadTrackData()
        if isLoadingTrack then return false end
        
        if not selectedJsonURL then
            WindUI:Notify({
                Title = "Auto Walk",
                Content = "Silakan pilih track terlebih dahulu!",
                Duration = 3,
                Icon = "triangle-alert",
            })
            return false
        end
        
        if not cachedJsonData then
            isLoadingTrack = true
            WindUI:Notify({
                Title = "Loading",
                Content = "Mendownload checkpoint...",
                Duration = 1.5,
                Icon = "download",
            })
            
            local jsonData, errorMsg = loadJsonFromURL(selectedJsonURL)
            
            if not jsonData then
                isLoadingTrack = false
                WindUI:Notify({
                    Title = "Error",
                    Content = errorMsg or "Gagal memuat track!",
                    Duration = 5,
                    Icon = "alert-triangle",
                })
                return false
            end
            
            cachedJsonData = jsonData
            isLoadingTrack = false
            WindUI:Notify({
                Title = "Success",
                Content = "Checkpoint siap!",
                Duration = 1.5,
                Icon = "check",
            })
        end
        
        return true
    end
    
    local function toggleAutoWalk()
        if not loadTrackData() then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            WindUI:Notify({
                Title = "Error",
                Content = "Character tidak ditemukan!",
                Duration = 2,
                Icon = "alert-triangle",
            })
            return
        end

        local currentPos = hrp.Position
        local nearestIndex, nearestDistance = findNearestPointInPath(cachedJsonData, currentPos)
        local MAX_PLAY_DISTANCE = 50
        
        if nearestDistance > MAX_PLAY_DISTANCE then
            WindUI:Notify({
                Title = "Auto Walk",
                Content = string.format("Terlalu jauh dari jalur (%.1f studs)!", nearestDistance),
                Duration = 3,
                Icon = "bot",
            })
            return
        end

        if isWalking then
            stopPlayback()
            return
        end

        if autoWalkGUI and autoWalkGUI.Enabled then
            local container = autoWalkGUI:FindFirstChild("MainFrame")
            if container then
                container = container:FindFirstChild("container")
                if container then
                    for _, child in ipairs(container:GetChildren()) do
                        if child:IsA("TextButton") and (child.Text == "PLAY" or child.Text == "STOP") then
                            child.Text = "STOP"
                            playStopButton = child
                            break
                        end
                    end
                end
            end
        end

        local onPath = isPlayerOnPath(currentPos, cachedJsonData, PATH_THRESHOLD)
        if onPath then
            startPlayback(cachedJsonData, nearestIndex, true)
        else
            local targetFrame = cachedJsonData[nearestIndex]
            local targetPos = tableToVec(targetFrame.position)
            walkToPosition(targetPos, function(success)
                if success then
                    startPlayback(cachedJsonData, nearestIndex, false)
                else
                    if playStopButton then
                        playStopButton.Text = "PLAY"
                    end
                end
            end)
        end
    end
    
    local function createAutoWalkGUI()
        if autoWalkGUI then
            autoWalkGUI.Enabled = true
            return
        end
    
        local playerGui = player:WaitForChild("PlayerGui")
    
        autoWalkGUI = Instance.new("ScreenGui")
        autoWalkGUI.Name = "AutoWalkControlGUI"
        autoWalkGUI.ResetOnSpawn = false
        autoWalkGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
        local success = pcall(function()
            autoWalkGUI.Parent = game:GetService("CoreGui")
        end)
        if not success then
            autoWalkGUI.Parent = playerGui
        end
    
        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        if isMobile then
            mainFrame.Size = UDim2.new(0, 220, 0, 60)
            mainFrame.Position = UDim2.new(0.5, -110, 1, -120)
        else
            mainFrame.Size = UDim2.new(0, 280, 0, 70)
            mainFrame.Position = UDim2.new(0.5, -140, 1, -140)
        end
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Selectable = true
        mainFrame.Parent = autoWalkGUI
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = mainFrame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(138, 43, 226)
        stroke.Thickness = 2
        stroke.Parent = mainFrame
        
        local dragBar = Instance.new("Frame")
        dragBar.Name = "DragBar"
        dragBar.Size = UDim2.new(0.7, 0, 0, isMobile and 6 or 8)
        dragBar.Position = UDim2.new(0.15, 0, 1, isMobile and 4 or 6)
        dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        dragBar.BorderSizePixel = 0
        dragBar.Active = true
        dragBar.Selectable = true
        dragBar.Parent = mainFrame
        
        local dragCorner = Instance.new("UICorner")
        dragCorner.CornerRadius = UDim.new(1, 0)
        dragCorner.Parent = dragBar
        
        local dragStroke = Instance.new("UIStroke")
        dragStroke.Color = Color3.fromRGB(138, 43, 226)
        dragStroke.Thickness = 1
        dragStroke.Parent = dragBar
        
        dragBar.MouseEnter:Connect(function()
            dragBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        end)
        dragBar.MouseLeave:Connect(function()
            dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end)
    
        local dragging = false
        local dragInput, dragStart, startPos
    
        local function update(input)
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    
        local function startDrag(input)
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
    
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    
        local function connectDragArea(guiObject)
            guiObject.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   input.UserInputType == Enum.UserInputType.Touch then
                    startDrag(input)
                end
            end)
    
            guiObject.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or
                   input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
        end
    
        connectDragArea(mainFrame)
        connectDragArea(dragBar)
    
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                             input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        
        local container = Instance.new("Frame")
        container.Name = "container"
        container.Size = UDim2.new(1, -16, 1, -16)
        container.Position = UDim2.new(0, 8, 0, 8)
        container.BackgroundTransparency = 1
        container.Parent = mainFrame
    
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, isMobile and 6 or 10)
        layout.Parent = container
    
        local function createButton(icon, callback)
            local btn = Instance.new("TextButton")
            if isMobile then
                btn.Size = UDim2.new(0, 60, 0, 32)
            else
                btn.Size = UDim2.new(0, 80, 0, 40)
            end
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            btn.BorderSizePixel = 0
            btn.Text = icon
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = isMobile and 10 or 12
            btn.Font = Enum.Font.GothamBold
            btn.AutoButtonColor = false
            btn.Parent = container
    
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, isMobile and 6 or 8)
            c.Parent = btn
    
            local s = Instance.new("UIStroke")
            s.Color = Color3.fromRGB(138, 43, 226)
            s.Thickness = 1.5
            s.Parent = btn
    
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            end)
            btn.MouseLeave:Connect(function()
                local currentColor = btn.BackgroundColor3
                if currentColor ~= Color3.fromRGB(138, 43, 226) and currentColor ~= Color3.fromRGB(30, 180, 80) then
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                end
            end)
    
            btn.Activated:Connect(function()
                if callback then 
                    callback(btn)
                end
            end)
            
            return btn
        end
    
        playStopButton = createButton("PLAY", function(btn)
            toggleAutoWalk()
        end)

        local rollbackBtn = createButton("REV", function(btn)
            isReversed = not isReversed
            if isReversed then
                btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                WindUI:Notify({
                    Title = "Auto Walk",
                    Content = "Reverse Mode: ON",
                    Duration = 2,
                    Icon = "rewind",
                })
            else
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                WindUI:Notify({
                    Title = "Auto Walk",
                    Content = "Reverse Mode: OFF",
                    Duration = 2,
                    Icon = "rewind",
                })
            end
        end)

        local rotateBtn = createButton("FLIP", function(btn)
            isFlipped = not isFlipped
            if isFlipped then
                btn.BackgroundColor3 = Color3.fromRGB(30, 180, 80)
                WindUI:Notify({
                    Title = "Auto Walk",
                    Content = "Flip Mode: ON (Karakter berputar 180°)",
                    Duration = 3,
                    Icon = "rotate-ccw",
                })
            else
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                WindUI:Notify({
                    Title = "Auto Walk",
                    Content = "Flip Mode: OFF",
                    Duration = 2,
                    Icon = "rotate-ccw",
                })
            end
        end)
    end
    
    local function hideAutoWalkGUI()
        if autoWalkGUI and autoWalkGUI.Parent then
            autoWalkGUI.Enabled = false
        end
    end
    
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = character:WaitForChild("Humanoid")
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        if isWalking then
            stopPlayback()
        end
    end)

    AutowalkTab:Section({ 
        Title = "Auto Walk | Setting",
        TextTransparency = 0.05,
        TextXAlignment = "Left",
        TextSize = 17,
    })

    AutowalkTab:Toggle({
        Title = "Enable Loop",
        Desc = "Berfungsi menjalankan auto walk secara berulang ulang.",
        Icon = "check",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            isLoopEnabled = state
        end
    })

    AutowalkTab:Toggle({
        Title = "Auto Respawn",
        Desc = "Respawn otomatis saat mencapai checkpoint terakhir.",
        Icon = "check",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            isAutoRespawnEnabled = state
        end
    })

    AutowalkTab:Slider({
        Title = "Speed Auto Walk",
        Desc = "Berfungsi mengatur kecepatan auto walk.",
        Step = 0.1,
        Value = {
            Min = 0.5,
            Max = 5,
            Default = 1.0,
        },
        Callback = function(value)
            playbackSpeed = value
        end
    })

    AutowalkTab:Divider()

    AutowalkTab:Section({ 
        Title = "Auto Walk | Menu",
        TextTransparency = 0.05,
        TextXAlignment = "Left",
        TextSize = 17,
    })

    AutowalkTab:Dropdown({
        Title = "SELECT TRACK",
        Values = getAvailableTracks(),
        Multi = false,
        AllowNone = true,
        SearchBarEnabled = true,
        Callback = function(selectedName)
            local cleanName = cleanTrackName(selectedName)

            if isTrackLocked(cleanName) then
                WindUI:Notify({
                    Title = "Map Locked 🔒",
                    Content = "Track masih terkunci!",
                    Duration = 4,
                    Icon = "lock",
                })
                selectedJsonURL = nil
                cachedJsonData = nil
                return
            end

            selectedJsonURL = trackURLs[cleanName]
            cachedJsonData = nil

            WindUI:Notify({
                Title = "Track",
                Content = "Track '" .. cleanName .. "' dipilih!",
                Duration = 2,
                Icon = "check",
            })
        end
    })

    AutowalkTab:Toggle({
        Title = "Show/Hide Auto Walk",
        Desc = "Menampilkan / menyembunyikan menu Auto Walk.",
        Icon = "eye",
        Value = false,
        Callback = function(state)
            if state == true then
                createAutoWalkGUI()
            else
                hideAutoWalkGUI()
            end
        end
    })
end

--// animation


local function setupCustomanimationTab()
    if not CustomanimationTab then return end

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local OriginalAnimations = {
        Idle = {},
        Walk = "",
        Run = "",
        Jump = "",
    }

    _G.LastSelectedAnim = {
        Idle = "Original",
        Walk = "Original",
        Run = "Original",
        Jump = "Original",
    }

    local CustomInputs = {
        Idle = "",
        Walk = "",
        Run = "",
        Jump = ""
    }

    local canAutoJump = false

    local function ForceRefresh()
        if not canAutoJump then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    local function SaveOriginalAnimations()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local animate = char:WaitForChild("Animate")

        if animate:FindFirstChild("idle") then
            OriginalAnimations.Idle = {}
            for _, a in ipairs(animate.idle:GetChildren()) do
                if a:IsA("Animation") then
                    table.insert(OriginalAnimations.Idle, a.AnimationId)
                end
            end
        end

        OriginalAnimations.Walk = animate.walk.WalkAnim.AnimationId
        OriginalAnimations.Run = animate.run.RunAnim.AnimationId
        OriginalAnimations.Jump = animate.jump.JumpAnim.AnimationId
    end

    SaveOriginalAnimations()
    
    task.delay(0.5, function()
        canAutoJump = true
    end)

    local function ApplyOriginal(typeName)
        local char = LocalPlayer.Character
        if not char then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end

        if typeName == "Idle" then
            local idle = animate:FindFirstChild("idle")
            if idle then
                for i, anim in ipairs(idle:GetChildren()) do
                    if anim:IsA("Animation") and OriginalAnimations.Idle[i] then
                        anim.AnimationId = OriginalAnimations.Idle[i]
                    end
                end
            end
        elseif typeName == "Walk" then
            animate.walk.WalkAnim.AnimationId = OriginalAnimations.Walk
        elseif typeName == "Run" then
            animate.run.RunAnim.AnimationId = OriginalAnimations.Run
        elseif typeName == "Jump" then
            animate.jump.JumpAnim.AnimationId = OriginalAnimations.Jump
        end

        _G.LastSelectedAnim[typeName] = "Original"
        ForceRefresh()
    end

    local function ApplyCustom(typeName, animData)
        local char = LocalPlayer.Character
        if not char then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end

        if typeName == "Idle" then
            local idle = animate:FindFirstChild("idle")
            if idle then
                for i, anim in ipairs(idle:GetChildren()) do
                    if anim:IsA("Animation") and animData[i] then
                        anim.AnimationId = "rbxassetid://" .. animData[i]
                    end
                end
            end
        elseif typeName == "Walk" then
            animate.walk.WalkAnim.AnimationId = "rbxassetid://" .. animData
        elseif typeName == "Run" then
            animate.run.RunAnim.AnimationId = "rbxassetid://" .. animData
        elseif typeName == "Jump" then
            animate.jump.JumpAnim.AnimationId = "rbxassetid://" .. animData
        end

        _G.LastSelectedAnim[typeName] = animData
        ForceRefresh()
    end

    local function ParseAnimationId(input, isIdle)
        if not input or input == "" then return nil end
        
        input = input:gsub("rbxassetid://", ""):gsub("%s+", "")
        
        if isIdle then
            local ids = {}
            for id in input:gmatch("([^,]+)") do
                id = id:gsub("%s+", "")
                if id:match("^%d+$") then
                    table.insert(ids, id)
                end
            end
            
            if #ids == 1 then
                return {ids[1], ids[1]}
            elseif #ids >= 2 then
                return {ids[1], ids[2]}
            end
            return nil
        else
            if input:match("^%d+$") then
                return input
            end
        end
        
        return nil
    end

    LocalPlayer.CharacterAdded:Connect(function()
        canAutoJump = false
        
        SaveOriginalAnimations()
        
        for typeName, lastValue in pairs(_G.LastSelectedAnim) do
            if lastValue ~= "Original" then
                task.spawn(function()
                    task.wait(0.2)
                    ApplyCustom(typeName, lastValue)
                end)
            end
        end
        
        task.delay(0.5, function()
            canAutoJump = true
        end)
    end)

    local IdleAnimations = {
        ["Original"] = "Original",
        ["Adidas Community"] = { "122257458498464", "102357151005774" },
        ["Vampire"] = { "1083445855", "1083450166"},
        ["Wicked (Popular)"]  = { "118832222982049", "76049494037641"  },
        ["NFL"] = { "92080889861410", "74451233229259"},
        ["Astronaut"] = { "891621366", "891633237" },
        ["Bubbly"] = { "910004836", "910009958" },
        ["Cartoony"] = { "742637544", "742638445" },
        ["Elder"] = { "845397899", "845400520" },
        ["Knight"] = { "657595757", "657568135" },
        ["Levitation"] = { "616006778", "616008087" },
        ["Mage"] = { "707742142", "707855907" },
        ["Ninja"] = { "656117400", "656118341" },
        ["Pirate"] = { "750781874", "750782770" },
        ["Robot"] = { "616088211", "616089559" },
        ["Rthro"] = { "2510197257", "2510196951" },
        ["Stylish"] = { "616136790", "616138447" },
        ["Superhero"] = { "616111295", "616113536" },
        ["Toy"] = { "782841498", "782845736" },
        ["Werewolf"] = { "1083195517", "1083214717" },
        ["Zombie"] = { "616158929", "616160636" },
        ["Boxing Idle"] = { "80933111363555" },
    }

    local WalkAnimations = {
        ["Original"] = "Original",
        ["Adidas Community"] = "122150855457006",
        ["Sports (Adidas)"] = "18537392113",
        ["Wicked (Popular)"] = "92072849924640",
        ["Astronaut"] = "891636393",
        ["Bubbly"] = "910034870",
        ["Cartoony"] = "742640026",
        ["Elder"] = "845403856",
        ["Knight"] = "657552124",
        ["Levitation"] = "616013216",
        ["Mage"] = "707897309",
        ["Ninja"] = "656121766",
        ["Pirate"] = "750785693",
        ["Robot"] = "616095330",
        ["Rthro"] = "2510202577",
        ["Stylish"] = "616146177",
        ["Superhero"] = "616122287",
        ["Toy"] = "782843345",
        ["Vampire"] = "1083473930",
        ["Werewolf"] = "1083178339",
        ["Zombie"] = "616168032",
    }

    local RunAnimations = {
        ["Original"] = "Original",
        ["Adidas Community"] = "82598234841035",
        ["Sports (Adidas)"] = "18537384940",
        ["Wicked (Popular)"] = "72301599441680",
        ["Astronaut"] = "891636393",
        ["Bubbly"] = "910025107",
        ["Cartoony"] = "742638842",
        ["Elder"] = "845386501",
        ["Knight"] = "657564596",
        ["Levitation"] = "616010382",
        ["Mage"] = "707861613",
        ["Ninja"] = "656118852",
        ["Pirate"] = "750783738",
        ["Robot"] = "616091570",
        ["Rthro"] = "2510198475",
        ["Stylish"] = "616140816",
        ["Superhero"] = "616117076",
        ["Toy"] = "782842708",
        ["Vampire"] = "1083462077",
        ["Werewolf"] = "1083216690",
        ["Zombie"] = "616163682",
        ["Animasi Viral"] = "138994056657038",
    }

    local JumpAnimations = {
        ["Original"] = "Original",
        ["Adidas Community"] = "75290611992385",
        ["Sports (Adidas)"] = "18537380791",
        ["Wicked (Popular)"] = "104325245285198",
        ["Astronaut"] = "891627522",
        ["Bubbly"] = "910016857",
        ["Cartoony"] = "742637942",
        ["Elder"] = "845398858",
        ["Knight"] = "658409194",
        ["Levitation"] = "616008936",
        ["Mage"] = "707853694",
        ["Ninja"] = "656117878",
        ["Pirate"] = "750782230",
        ["Robot"] = "616090535",
        ["Rthro"] = "2510197830",
        ["Stylish"] = "616139451",
        ["Superhero"] = "616115533",
        ["Toy"] = "782847020",
        ["Vampire"] = "1083455352",
        ["Werewolf"] = "1083218792",
        ["Zombie"] = "616161997",
        ["Jump Viral"] = "86368998086661",
    }

    local function MakeValuesList(animTable)
        local list = {"Original"}
        for name,_ in pairs(animTable) do
            if name ~= "Original" then
                table.insert(list, name)
            end
        end
        table.sort(list)
        return list
    end

    local function MakeDropdown(title, animTable, typeName)
        CustomanimationTab:Dropdown({
            Title = "" .. title,
            Values = MakeValuesList(animTable),
            Value = "Original",
            SearchBarEnabled = true,
            Callback = function(value)
                if value == "Original" then
                    ApplyOriginal(typeName)
                else
                    ApplyCustom(typeName, animTable[value])
                end
            end
        })
    end

    CustomanimationTab:Section({ 
        Title = "Emot Menu",
    })

    CustomanimationTab:Divider()

    CustomanimationTab:Paragraph({
        Title = "Emot Menu",
        Desc = "Pada emot menu ini fitur tambahan yang dimana kalian bisa menggunakan emot secara free, script emot ini dibuat oleh: Vexro Emots",
    })

    CustomanimationTab:Toggle({
        Title = "OPEN EMOT MENU",
        Icon = "smile",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            if state then
                WindUI:Notify({
                    Title = "Emot Menu",
                    Content = "Tunggu sebentar...",
                    Duration = 5,
                    Icon = "smile",
                })
                loadstring(game:HttpGet("https://raw.githubusercontent.com/zyrovell/Vexro-Emotes/main/vexroemotes.lua"))()
            end
        end
    })

    CustomanimationTab:Divider()

    CustomanimationTab:Section({ Title = "Animation" })

    CustomanimationTab:Divider()

    CustomanimationTab:Paragraph({
        Title = "Animation Preset",
        Desc = "Pada animation preset ini anda tidak perlu mencari id animation, tinggal anda sesuaikan saja.",
    })

    MakeDropdown("Idle Animation", IdleAnimations, "Idle")
    MakeDropdown("Walk Animation", WalkAnimations, "Walk")
    MakeDropdown("Run Animation", RunAnimations, "Run")
    MakeDropdown("Jump Animation", JumpAnimations, "Jump")

    CustomanimationTab:Divider()
    CustomanimationTab:Section({ Title = "Custom Animation" })

    CustomanimationTab:Paragraph({
        Title = "Custom Animation",
        Desc = "Buat yang anda bingung nyari id animation nya, anda bisa salin link website di bawah ini dan paste di browser kalian.",
    })
    
    CustomanimationTab:Button({
        Title = "COPY LINK WEBSITE",
        Icon = "clipboard",
        Callback = function()
            local link = "https://id.pinterest.com/ideas/roblox-animation-id-codes/927157409080/"
            if setclipboard then
                setclipboard(link)
            elseif toclipboard then
                toclipboard(link)
            end
            WindUI:Notify({
                Title = "ID Animation",
                Content = "Url id animation berhasil di salin!",
                Duration = 3,
                Icon = "clipboard",
            })
        end
    })

    CustomanimationTab:Divider()

    CustomanimationTab:Input({
        Title = "Idle Animation",
        Type = "Input",
        InputIcon = "person-standing",
        Placeholder = "Masukan ID",
        Callback = function(input) 
            local ids = ParseAnimationId(input, true)
            if ids then
                CustomInputs.Idle = ids
                WindUI:Notify({
                    Title = "Idle",
                    Content = "ID tersimpan!",
                    Duration = 2,
                    Icon = "check",
                })
            else
                CustomInputs.Idle = ""
            end
        end
    })

    CustomanimationTab:Input({
        Title = "Walk Animation",
        Type = "Input",
        InputIcon = "person-standing",
        Placeholder = "Masukan ID",
        Callback = function(input) 
            local id = ParseAnimationId(input, false)
            CustomInputs.Walk = id or ""
        end
    })

    CustomanimationTab:Input({
        Title = "Run Animation",
        Type = "Input",
        InputIcon = "person-standing",
        Placeholder = "Masukan ID",
        Callback = function(input) 
            local id = ParseAnimationId(input, false)
            CustomInputs.Run = id or ""
        end
    })

    CustomanimationTab:Input({
        Title = "Jump Animation",
        Type = "Input",
        InputIcon = "person-standing",
        Placeholder = "Masukan ID",
        Callback = function(input) 
            local id = ParseAnimationId(input, false)
            CustomInputs.Jump = id or ""
        end
    })

    CustomanimationTab:Divider()

    CustomanimationTab:Toggle({
        Title = "APPLY ANIMATION",
        Callback = function(state)
            if state then
                local applied = false
                
                if CustomInputs.Idle ~= "" then
                    ApplyCustom("Idle", CustomInputs.Idle)
                    applied = true
                end
                if CustomInputs.Walk ~= "" then
                    ApplyCustom("Walk", CustomInputs.Walk)
                    applied = true
                end
                if CustomInputs.Run ~= "" then
                    ApplyCustom("Run", CustomInputs.Run)
                    applied = true
                end
                if CustomInputs.Jump ~= "" then
                    ApplyCustom("Jump", CustomInputs.Jump)
                    applied = true
                end
                
                WindUI:Notify({
                    Title = "Animation",
                    Content = applied and "Animation berhasil di ubah!" or "Tidak ada animation!",
                    Duration = 3,
                    Icon = applied and "person-standing" or "triangle-alert",
                })
            else
                ApplyOriginal("Idle")
                ApplyOriginal("Walk")
                ApplyOriginal("Run")
                ApplyOriginal("Jump")
                
                WindUI:Notify({
                    Title = "Animation",
                    Content = "Animation dikembalikan ke original!",
                    Duration = 3,
                    Icon = "person-standing",
                })
            end
        end
    })
end

--// teleport


local function setupTeleportTab()
    if not TeleportTab then return end

TeleportTab:Section({ 
    Title = "Select Player & Teleport",
})

local selectedPlayer = nil

local function createPlayerDropdown()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    
    if #players == 0 then
        players = {"No other players"}
    end
    
TeleportTab:Dropdown({
        Title = "Teleport to Player",
        Values = players,
        Value = players[1],
        Callback = function(selected)
            selectedPlayer = selected
        end
    })
    
    selectedPlayer = players[1]
    return dropdown
end

local playerDropdown = createPlayerDropdown()

TeleportTab:Button({
    Title = "Teleport to Selected Player",
    Desc = "Teleport ke player yang dipilih",
    Callback = function()
        if not selectedPlayer or selectedPlayer == "No other players" then
            WindUI:Notify({
                Title = "Teleport Player",
                Content = "Pilih player yang valid terlebih dahulu!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        local player = game.Players.LocalPlayer
        
        if not targetPlayer then
            WindUI:Notify({
                Title = "Teleport Player",
                Content = "Player '" .. selectedPlayer .. "' tidak ditemukan!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WindUI:Notify({
                Title = "Teleport Player",
                Content = "Karakter player '" .. selectedPlayer .. "' tidak ditemukan!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            WindUI:Notify({
                Title = "Teleport Player",
                Content = "Karakter kamu tidak ditemukan!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        local hrp = player.Character.HumanoidRootPart
        local tempPart = Instance.new("Part")
        tempPart.Anchored = true
        tempPart.CanCollide = true
        tempPart.Transparency = 1
        tempPart.Size = Vector3.new(10,1,10)
        tempPart.CFrame = CFrame.new(targetPos)
        tempPart.Parent = workspace
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0,5,0))
        task.wait(1)
        tempPart:Destroy()
        
        WindUI:Notify({
            Title = "Teleport Player",
            Content = "Berhasil teleport ke " .. selectedPlayer,
            Duration = 3,
            Icon = "user-check",
        })
    end
})

TeleportTab:Button({
    Title = "Refresh Player List",
    Desc = "Refresh daftar player",
    Callback = function()
        playerDropdown:Remove()
        playerDropdown = createPlayerDropdown()
        
        WindUI:Notify({
            Title = "Player List",
            Content = "Daftar player diperbarui",
            Duration = 2,
            Icon = "refresh-cw",
        })
    end
})

game.Players.PlayerAdded:Connect(function()
    task.wait(1)
    playerDropdown:Remove()
    playerDropdown = createPlayerDropdown()
end)

game.Players.PlayerRemoving:Connect(function()
    task.wait(1)
    playerDropdown:Remove()
    playerDropdown = createPlayerDropdown()
end)

TeleportTab:Space()
TeleportTab:Divider()

local Section = TeleportTab:Section({ 
    Title = "Save Position & Back Position",
})

local savedPosition = nil

TeleportTab:Button({
    Title = "Save Position",
    Desc = "Simpan posisi saat ini",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedPosition = player.Character.HumanoidRootPart.Position
            WindUI:Notify({
                Title = "SavePos",
                Content = "Posisi berhasil disimpan!",
                Duration = 3,
                Icon = "save",
            })
        else
            WindUI:Notify({
                Title = "SavePos",
                Content = "Karakter tidak ditemukan",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

TeleportTab:Button({
    Title = "Back to Position",
    Desc = "Kembali ke posisi yang disimpan",
    Callback = function()
        local player = game.Players.LocalPlayer
        if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
            WindUI:Notify({
                Title = "SavePos",
                Content = "Berhasil teleport ke posisi!",
                Duration = 3,
                Icon = "arrow-left",
            })
        else
            WindUI:Notify({
                Title = "SavePos",
                Content = "Posisi belum disimpan atau karakter tidak ditemukan",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

TeleportTab:Space()
TeleportTab:Divider()

TeleportTab:Section({ 
    Title = "Teleport Tool",
})

TeleportTab:Button({
    Title = "Teleport Tool",
    Desc = "Buat tool untuk teleport dengan klik",
    Callback = function()
        local player = game.Players.LocalPlayer
        local backpack = player:WaitForChild("Backpack")
        
        for _, v in ipairs(backpack:GetChildren()) do 
            if v:IsA("Tool") and v.Name == "Click Teleport" then 
                v:Destroy() 
            end 
        end 
        
        if player.Character then 
            for _, v in ipairs(player.Character:GetChildren()) do 
                if v:IsA("Tool") and v.Name == "Click Teleport" then 
                    v:Destroy() 
                end 
            end 
        end
        
        local function TeleportTo(pos)
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            local hrp = player.Character.HumanoidRootPart
            local tempPart = Instance.new("Part")
            tempPart.Anchored = true
            tempPart.CanCollide = true
            tempPart.Transparency = 1
            tempPart.Size = Vector3.new(10,1,10)
            tempPart.CFrame = CFrame.new(pos)
            tempPart.Parent = workspace
            hrp.CFrame = CFrame.new(pos + Vector3.new(0,5,0))
            task.wait(1)
            tempPart:Destroy()
        end
        
        local tool = Instance.new("Tool")
        tool.Name = "Click Teleport"
        tool.RequiresHandle = false
        tool.CanBeDropped = false
        tool.Parent = backpack
        
        tool.Equipped:Connect(function(mouse)
            local m = mouse or player:GetMouse()
            local activatedConn
            activatedConn = tool.Activated:Connect(function()
                TeleportTo(m.Hit.p + Vector3.new(0,3,0))
            end)
            tool.Unequipped:Connect(function()
                if activatedConn then 
                    activatedConn:Disconnect() 
                end
            end)
        end)
        
        WindUI:Notify({
            Title = "Teleport Tool",
            Content = "Tool teleport berhasil dibuat! Cek backpack kamu.",
            Duration = 3,
            Icon = "tool",
        })
    end
})
end

--// tools


local function setupToolsTab()
    if not ToolsTab then return end

ToolsTab:Section({ 
    Title = "Frezze Object & Full Bright",
})

local FreezeToggle = false
local OriginalStates = {}
local FreezeDistance = 100

task.spawn(function()
    while task.wait(0.3) do
        if FreezeToggle and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local charPos = player.Character.HumanoidRootPart.Position
            local nearbyParts = workspace:GetPartBoundsInRadius(charPos, FreezeDistance)
            local stillNear = {}
            for _, part in ipairs(nearbyParts) do
                if part and part:IsA("BasePart") then
                    local model = part:FindFirstAncestorOfClass("Model")
                    if model and Players:GetPlayerFromCharacter(model) then
                    else
                        stillNear[part] = true
                        if OriginalStates[part] == nil then OriginalStates[part] = part.Anchored end
                        pcall(function()
                            part.Anchored = true
                            part.Velocity = Vector3.zero
                            part.RotVelocity = Vector3.zero
                        end)
                    end
                end
            end
            for part, anchoredState in pairs(OriginalStates) do
                if not stillNear[part] then
                    if part and part.Parent then pcall(function() part.Anchored = anchoredState end) end
                    OriginalStates[part] = nil
                end
            end
        end
    end
end)

ToolsTab:Toggle({
    Title = "Freeze Object",
    Type = "Toggle",
	Desc = "Frezze Objek Yang Bergoyang",
    Default = false,
    Callback = function(Value)
        FreezeToggle = Value
        if not Value then
            for part, anchoredState in pairs(OriginalStates) do
                if part and part.Parent then
                    pcall(function() part.Anchored = anchoredState end)
                end
            end
            OriginalStates = {}
        end
    end
})

ToolsTab:Slider({
    Title = "Freeze Radius",
    Step = 10,
    Value = {
        Min = 0,
        Max = 500,
        Default = 100,
    },
    Callback = function(Value)
        FreezeDistance = Value
    end
})

ToolsTab:Space()
ToolsTab:Divider()

local FullBrightEnabled = false
local savedLighting = nil
local FullBrightLoopConn = nil
local currentBrightness = 2
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

ToolsTab:Toggle({
    Title = "Full Bright Loop",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
        FullBrightEnabled = Value
        if Value then
            if not savedLighting then
                savedLighting = {
                    Brightness = Lighting.Brightness,
                    ClockTime = Lighting.ClockTime,
                    FogEnd = Lighting.FogEnd,
                    GlobalShadows = Lighting.GlobalShadows,
                    OutdoorAmbient = Lighting.OutdoorAmbient
                }
            end
            if not FullBrightLoopConn then
                FullBrightLoopConn = RunService.RenderStepped:Connect(function()
                    Lighting.Brightness = currentBrightness
                    Lighting.ClockTime = 12
                    Lighting.FogEnd = 1e6
                    Lighting.GlobalShadows = false
                    Lighting.OutdoorAmbient = Color3.new(1,1,1)
                end)
            end
        else
            if FullBrightLoopConn then 
                FullBrightLoopConn:Disconnect()
                FullBrightLoopConn = nil 
            end
            if savedLighting then
                Lighting.Brightness = savedLighting.Brightness
                Lighting.ClockTime = savedLighting.ClockTime
                Lighting.FogEnd = savedLighting.FogEnd
                Lighting.GlobalShadows = savedLighting.GlobalShadows
                Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
                savedLighting = nil
            end
        end
    end
})

ToolsTab:Slider({
    Title = "Adjust Brightness",
    Step = 0.2,
    Value = {
        Min = 0,
        Max = 10,
        Default = 2,
    },
    Callback = function(Value)
        currentBrightness = Value
        if FullBrightEnabled then 
            Lighting.Brightness = currentBrightness 
        end
    end
})

ToolsTab:Space()
ToolsTab:Divider()

local AntiAFK_Enabled = false

ToolsTab:Toggle({
    Title = "Anti AFK",
    Type = "Toggle",
    Default = false,
    Callback = function(Value)
        AntiAFK_Enabled = Value
        if not Value then return end

        task.spawn(function()
            local vu = game:GetService("VirtualUser")
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer

            player.Idled:Connect(function()
                if not AntiAFK_Enabled then return end
                pcall(function()
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end)

            while AntiAFK_Enabled do
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.Angles(0, math.rad(10), 0)
                end
                task.wait(60)
            end
        end)
    end
})

ToolsTab:Button({
    Title = "Respawn",
    Desc = "Respawn karakter kamu",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
            WindUI:Notify({
                Title = "Respawn",
                Content = "Karakter berhasil di-respawn",
                Duration = 3,
                Icon = "refresh-cw",
            })
        end
    end
})

ToolsTab:Button({
    Title = "Rejoin",
    Desc = "Rejoin server yang sama",
    Callback = function()
        WindUI:Notify({
            Title = "Rejoin",
            Content = "Sedang rejoin server...",
            Duration = 3,
            Icon = "rotate-cw",
        })
        
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        TeleportService:Teleport(placeId, game.Players.LocalPlayer)
    end
})

ToolsTab:Button({
    Title = "ServerHop",
    Desc = "Pindah ke server lain",
    Callback = function()
        WindUI:Notify({
            Title = "ServerHop",
            Content = "Mencari server baru...",
            Duration = 3,
            Icon = "server",
        })
        
        local function serverHop()
            local Http = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            
            local placeId = game.PlaceId
            local servers = {}
            local nextCursor = ""
            
            -- Dapatkan list server
            repeat
                local success, result = pcall(function()
                    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
                    if nextCursor ~= "" then
                        url = url .. "&cursor=" .. nextCursor
                    end
                    local response = game:HttpGet(url)
                    return Http:JSONDecode(response)
                end)
                
                if success and result and result.data then
                    for _, server in ipairs(result.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            table.insert(servers, server)
                        end
                    end
                    nextCursor = result.nextPageCursor or ""
                else
                    nextCursor = ""
                end
            until nextCursor == "" or #servers >= 50
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                WindUI:Notify({
                    Title = "ServerHop",
                    Content = "Menemukan server! Teleporting...",
                    Duration = 2,
                    Icon = "check",
                })
                
                task.wait(1)
                
                TPS:TeleportToPlaceInstance(placeId, randomServer.id, player)
            else
                WindUI:Notify({
                    Title = "ServerHop",
                    Content = "Tidak ada server lain yang ditemukan",
                    Duration = 3,
                    Icon = "x",
                })
            end
        end
        
        local success, error = pcall(serverHop)
        if not success then
            WindUI:Notify({
                Title = "ServerHop Error",
                Content = "Gagal: " .. tostring(error),
                Duration = 5,
                Icon = "x",
            })
        end
    end
})
end


local function setupDangerTab()
    if not DangerTab then return end
local Section = DangerTab:Section({ 
    Title = "Enjoy Exploit!!",
})

local SkidFlingButton = DangerTab:Button({
    Title = "Fling All",
    Desc = "Fling semua player di server",
    Callback = function()
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        
        local function GetPlayer(Name)
            Name = Name:lower()
            if Name == "all" or Name == "others" then
                return true
            elseif Name == "random" then
                local GetPlayers = Players:GetPlayers()
                if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
                return GetPlayers[math.random(#GetPlayers)]
            elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
                for _,x in next, Players:GetPlayers() do
                    if x ~= Player then
                        if x.Name:lower():match("^"..Name) then
                            return x;
                        elseif x.DisplayName:lower():match("^"..Name) then
                            return x;
                        end
                    end
                end
            else
                return
            end
        end
        
        local function SkidFling(TargetPlayer)
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Humanoid.RootPart

            local TCharacter = TargetPlayer.Character
            local THumanoid
            local TRootPart
            local THead
            local Accessory
            local Handle

            if TCharacter:FindFirstChildOfClass("Humanoid") then
                THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
            end
            if THumanoid and THumanoid.RootPart then
                TRootPart = THumanoid.RootPart
            end
            if TCharacter:FindFirstChild("Head") then
                THead = TCharacter.Head
            end
            if TCharacter:FindFirstChildOfClass("Accessory") then
                Accessory = TCharacter:FindFirstChildOfClass("Accessory")
            end
            if Accessory and Accessory:FindFirstChild("Handle") then
                Handle = Accessory.Handle
            end

            if Character and Humanoid and RootPart then
                if RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = RootPart.CFrame
                end
                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif not THead and Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                elseif THumanoid and TRootPart then
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end
                if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                    return
                end
                
                local FPos = function(BasePart, Pos, Ang)
                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end
                
                local SFBasePart = function(BasePart)
                    local TimeToWait = 2
                    local Time = tick()
                    local Angle = 0

                    repeat
                        if RootPart and THumanoid then
                            if BasePart.Velocity.Magnitude < 50 then
                                Angle = Angle + 100

                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                            else
                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                            end
                        else
                            break
                        end
                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                end
                
                workspace.FallenPartsDestroyHeight = 0/0
                
                local BV = Instance.new("BodyVelocity")
                BV.Name = "EpixVel"
                BV.Parent = RootPart
                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                
                if TRootPart and THead then
                    if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                        SFBasePart(THead)
                    else
                        SFBasePart(TRootPart)
                    end
                elseif TRootPart and not THead then
                    SFBasePart(TRootPart)
                elseif not TRootPart and THead then
                    SFBasePart(THead)
                elseif not TRootPart and not THead and Accessory and Handle then
                    SFBasePart(Handle)
                else
                    return
                end
                
                BV:Destroy()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = Humanoid
                
                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                    Humanoid:ChangeState("GettingUp")
                    table.foreach(Character:GetChildren(), function(_, x)
                        if x:IsA("BasePart") then
                            x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                        end
                    end)
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            else
                return
            end
        end
        
        if not getgenv().Welcome then
            WindUI:Notify({
                Title = "Fling All",
                Content = "Enjoy!",
                Duration = 3,
                Icon = "zap",
            })
        end
        getgenv().Welcome = true
        
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.UserId ~= 1414978355 then
                    SkidFling(x)
                end
            end
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local config = {
    radius = 99999,
    height = 99999,
    rotationSpeed = 99999,
    attractionStrength = 99999,
}

local ringPartsEnabled = false
local parts = {}

local function scanAllParts()
    parts = {}
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) then
            table.insert(parts, part)
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not ringPartsEnabled then return end
    
    local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local tornadoCenter = humanoidRootPart.Position
        
        for _, part in pairs(parts) do
            if part and part.Parent and not part.Anchored then
                part.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0, 0, 0)
                part.CanCollide = false
                
                local pos = part.Position
                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                local newAngle = angle + math.rad(config.rotationSpeed)
                local targetPos = Vector3.new(
                    tornadoCenter.X + math.cos(newAngle) * math.min(config.radius, distance),
                    tornadoCenter.Y + (config.height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / config.height)))),
                    tornadoCenter.Z + math.sin(newAngle) * math.min(config.radius, distance)
                )
                local directionToTarget = (targetPos - part.Position).Unit
                part.Velocity = directionToTarget * config.attractionStrength
            end
        end
    end
end)

local TornadoToggle = DangerTab:Toggle({
    Title = "Terbangkan Part",
    Desc = "If Not Work Wait Until Scan Finish",
    Type = "Toggle",
    Default = false,

    Callback = function(state)
        ringPartsEnabled = state
        
        if state then
            scanAllParts()
            WindUI:Notify({
                Title = "Tornado",
                Content = "Tornado diaktifkan - " .. #parts .. " part terbang!",
                Duration = 3,
                Icon = "wind",
            })
        else
            for _, part in pairs(parts) do
                if part and part.Parent then
                    part.CustomPhysicalProperties = nil
                    part.CanCollide = true
                    part.Velocity = Vector3.new(0, 0, 0)
                end
            end
            parts = {}
            WindUI:Notify({
                Title = "Tornado",
                Content = "Tornado dimatikan",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

workspace.DescendantAdded:Connect(function(part)
    if ringPartsEnabled and part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) then
        if not table.find(parts, part) then
            table.insert(parts, part)
        end
    end
end)
end

--// Tools

task.spawn(function()
    while true do
        task.wait(1)
        if menuCreated then
            setupPlayerTab()
            setupAutosummitTab()
            setupAutowalkTab()
            setupTeleportTab()
            setupToolsTab()
            setupDangerTab()
            setupCustomanimationTab()
            break
        end
    end
end)
