-- RAYFIELD STYLE UI + ANTICHEAT BYPASS + INFINITE YIELD + BRING PARTS + TORNADO ESP
-- CLEAN NO EMOJIS VERSION

print("=== LOADING ANTICHEAT BYPASS FIRST ===")

-- ============================================
-- ORIGINAL ANTICHEAT BYPASS (UNCHANGED)
-- ============================================
print("=== ANTICHEAT BYPASS LOADING ===")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
print("[BYPASS] Blocking anticheat script...")
for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
    if script:IsA("LocalScript") and (script.Name:match("\n") or script.Name:match("\a")) then
        script:Destroy()
        print("[SUCCESS] Destroyed anticheat script")
    end
end
print("[BYPASS] Hooking kick and anticheat remote...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = ReplicatedStorage:WaitForChild("events", 5)
local ClientSignal = events and events:FindFirstChild("ClientSignal")
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == LocalPlayer then
        warn("[BLOCKED] Kick attempt blocked")
        return
    end
    if ClientSignal and self == ClientSignal and method == "FireServer" then
        warn("[BLOCKED] Anticheat report blocked")
        return
    end
    return oldNamecall(self, ...)
end)
print("[BYPASS] Spoofing Humanoid properties...")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if self == Humanoid then
        if key == "WalkSpeed" then
            local real = oldIndex(self, key)
            if real >= 30 then return 16 end
        elseif key == "Health" then
            local real = oldIndex(self, key)
            if real > 100 then return 100 end
        elseif key == "JumpHeight" then
            local real = oldIndex(self, key)
            if real >= 8.1 then return 7.2 end
        end
    end
    return oldIndex(self, key)
end)
print("[BYPASS] Blocking fly detection...")
local blockedBodyMovers = {"BodyGyro", "BodyVelocity", "BodyPosition", "BodyAngularVelocity", "BodyThrust", "BodyForce"}
local oldInstanceNew = Instance.new
local newInstanceNew = newcclosure(function(className, parent)
    local instance = oldInstanceNew(className, parent)
    if table.find(blockedBodyMovers, className) then
        instance.Name = "Movement"
    end
    return instance
end)
setreadonly(Instance, false)
Instance.new = newInstanceNew
setreadonly(Instance, true)
print("[BYPASS] Blocking GUI detection...")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local connections = getconnections(PlayerGui.ChildAdded)
for _, connection in pairs(connections) do
    connection:Disable()
end
print("Anticheat bypassed successfully!")

-- ============================================
-- CUSTOMIZED RAYFIELD GUI - NO EMOJIS
-- ============================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "TWISTED HUB",
    LoadingTitle = "Twisted Hub",
    LoadingSubtitle = "Bypass Active",

    Theme = {
        TextColor = Color3.fromRGB(255, 255, 255),

        Background = Color3.fromRGB(10, 10, 25),
        Topbar = Color3.fromRGB(20, 15, 40),
        Shadow = Color3.fromRGB(0, 0, 0),

        NotificationBackground = Color3.fromRGB(15, 15, 35),
        NotificationActionsBackground = Color3.fromRGB(30, 30, 60),

        TabBackground = Color3.fromRGB(25, 20, 50),
        TabStroke = Color3.fromRGB(60, 40, 120),
        TabBackgroundSelected = Color3.fromRGB(80, 60, 180),
        TabTextColor = Color3.fromRGB(200, 200, 255),
        SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

        ElementBackground = Color3.fromRGB(20, 20, 45),
        ElementBackgroundHover = Color3.fromRGB(30, 25, 70),

        SecondaryElementBackground = Color3.fromRGB(15, 15, 35),
        ElementStroke = Color3.fromRGB(80, 60, 150),
        SecondaryElementStroke = Color3.fromRGB(60, 40, 120),

        SliderBackground = Color3.fromRGB(120, 80, 255),
        SliderProgress = Color3.fromRGB(170, 120, 255),
        SliderStroke = Color3.fromRGB(200, 150, 255),

        ToggleBackground = Color3.fromRGB(30, 20, 60),
        ToggleEnabled = Color3.fromRGB(170, 100, 255),
        ToggleDisabled = Color3.fromRGB(90, 90, 120),

        ToggleEnabledStroke = Color3.fromRGB(200, 150, 255),
        ToggleDisabledStroke = Color3.fromRGB(120, 120, 140),

        ToggleEnabledOuterStroke = Color3.fromRGB(100, 80, 200),
        ToggleDisabledOuterStroke = Color3.fromRGB(70, 70, 90),

        DropdownSelected = Color3.fromRGB(40, 30, 80),
        DropdownUnselected = Color3.fromRGB(25, 20, 50),

        InputBackground = Color3.fromRGB(20, 20, 45),
        InputStroke = Color3.fromRGB(100, 80, 200),
        PlaceholderColor = Color3.fromRGB(180, 180, 255)
    },

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TwistedHub",
        FileName = "Settings"
    },

    Discord = { Enabled = false },
    KeySystem = false
})

-- TABS
local HomeTab = Window:CreateTab("HOME", nil)
local VisualsTab = Window:CreateTab("VISUALS", nil)
local ScriptsTab = Window:CreateTab("SCRIPTS", nil)

-- HOME
HomeTab:CreateSection("PLAYER")

local currentWalkSpeed = 16
HomeTab:CreateToggle({
    Name = "Infinite WalkSpeed",
    CurrentValue = false,
    Flag = "InfWalkSpeed",
    Callback = function(Value)
        if Humanoid then
            if Value then
                currentWalkSpeed = 100
                Humanoid.WalkSpeed = 100
                task.spawn(function()
                    while Value and Humanoid and Humanoid.Parent do
                        if Humanoid.WalkSpeed ~= currentWalkSpeed then 
                            Humanoid.WalkSpeed = currentWalkSpeed 
                        end
                        task.wait(0.1)
                    end
                end)
            else
                currentWalkSpeed = 16
                Humanoid.WalkSpeed = 16
            end
        end
    end
})

local infJumpConnection = nil
HomeTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        if Value then
            if infJumpConnection then infJumpConnection:Disconnect() end
            infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if Humanoid then 
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
                end
            end)
        else
            if infJumpConnection then 
                infJumpConnection:Disconnect() 
                infJumpConnection = nil 
            end
        end
    end
})

HomeTab:CreateSection("STATUS")
HomeTab:CreateParagraph({
    Title = "System",
    Content = "Anticheat: BYPASSED\nWalkSpeed: READY\nJump: READY"
})

-- VISUALS
VisualsTab:CreateSection("TORNADO ESP")

local ESPEnabled = false
local espTexts = {}
local Camera = workspace.CurrentCamera
local espColor = Color3.fromRGB(255, 255, 255)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TornadoESP"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local function createTextLabel()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 0, 30)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = screenGui
    return label
end

local function updateESP()
    if not ESPEnabled then return end
    local storms = workspace:FindFirstChild("storm_related") and workspace.storm_related:FindFirstChild("storms")
    if not storms then return end
    
    for _, storm in pairs(storms:GetChildren()) do
        if storm:IsA("Model") then
            local rotation = storm:FindFirstChild("rotation")
            if rotation then
                local tornadoPart = rotation:FindFirstChild("tornado_scan")
                if tornadoPart and tornadoPart:IsA("BasePart") then
                    local configs = storm:FindFirstChild("configs")
                    if configs then
                        local tornadoConfig = configs:FindFirstChild("tornado")
                        if tornadoConfig then
                            local winds = tornadoConfig:FindFirstChild("winds")
                            if winds then
                                local currentWinds = math.floor(winds.Value)
                                local screenPos, onScreen = Camera:WorldToScreenPoint(tornadoPart.Position)
                                
                                if onScreen then
                                    if not espTexts[storm.Name] then
                                        espTexts[storm.Name] = createTextLabel()
                                    end
                                    local label = espTexts[storm.Name]
                                    label.Position = UDim2.new(0, screenPos.X - 60, 0, screenPos.Y - 30)
                                    label.Text = currentWinds .. " MPH"
                                    label.TextColor3 = espColor
                                    label.Visible = true
                                else
                                    if espTexts[storm.Name] then
                                        espTexts[storm.Name].Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function clearESP()
    for _, label in pairs(espTexts) do
        pcall(function() label:Destroy() end)
    end
    espTexts = {}
end

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColor",
    Callback = function(Color)
        espColor = Color
    end
})

VisualsTab:CreateToggle({
    Name = "Enable Tornado ESP",
    CurrentValue = false,
    Flag = "TornadoESP",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            clearESP()
            task.spawn(function()
                while ESPEnabled do
                    updateESP()
                    task.wait(0.016)
                end
                clearESP()
            end)
        else
            clearESP()
        end
    end
})

-- SCRIPTS
ScriptsTab:CreateSection("SCRIPT LOADER")

ScriptsTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        Rayfield:Notify({ Title = "Infinite Yield", Content = "Loaded", Duration = 2 })
    end
})

-- ADDED BRING PARTS BUTTON
ScriptsTab:CreateButton({
    Name = "Bring Parts",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/BringParts/refs/heads/main/loadstring.lua"))()
        Rayfield:Notify({ Title = "Bring Parts", Content = "Loaded", Duration = 2 })
    end
})

-- NOTIFY
Rayfield:Notify({
    Title = "Twisted Hub",
    Content = "Ready",
    Duration = 2,
})

print("Twisted Hub Loaded")
