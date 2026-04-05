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

local Window = Rayfield:CreateWindow({
    Name = "TWISTED HUB",
    LoadingTitle = "Twisted Hub",
    LoadingSubtitle = "Bypass Active",
    Theme = "Dark",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TwistedHub",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- ONLY 3 TABS - CLEAN
local HomeTab = Window:CreateTab("HOME", nil)
local VisualsTab = Window:CreateTab("VISUALS", nil)
local ScriptsTab = Window:CreateTab("SCRIPTS", nil)

-- ============================================
-- HOME TAB
-- ============================================
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
                        if Humanoid.WalkSpeed ~= currentWalkSpeed then Humanoid.WalkSpeed = currentWalkSpeed end
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
                if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
        end
    end
})

HomeTab:CreateSection("STATUS")
HomeTab:CreateParagraph({
    Title = "System",
    Content = "Anticheat: BYPASSED\nWalkSpeed: READY\nJump: READY"
})

-- ============================================
-- VISUALS TAB
-- ============================================
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
    for name, label in pairs(espTexts) do
        pcall(function() label:Destroy() end)
        espTexts[name] = nil
    end
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

VisualsTab:CreateSection("ENVIRONMENT")

local Lighting = game:GetService("Lighting")
local originalBrightness = Lighting.Brightness
local originalFogEnd = Lighting.FogEnd
local originalFogStart = Lighting.FogStart
local originalFogColor = Lighting.FogColor
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.ExposureCompensation = 1
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = originalBrightness
            Lighting.ClockTime = game:GetService("ReplicatedStorage"):FindFirstChild("clock_time") and game:GetService("ReplicatedStorage").clock_time.Value or 14
            Lighting.ExposureCompensation = 0
            Lighting.Ambient = originalAmbient
            Lighting.OutdoorAmbient = originalOutdoorAmbient
        end
    end
})

VisualsTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(Value)
        if Value then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
            Lighting.FogColor = Color3.fromRGB(0, 0, 0)
        else
            Lighting.FogEnd = originalFogEnd
            Lighting.FogStart = originalFogStart
            Lighting.FogColor = originalFogColor
        end
    end
})

-- ============================================
-- SCRIPTS TAB
-- ============================================
ScriptsTab:CreateSection("SCRIPT LOADER")

ScriptsTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        Rayfield:Notify({
            Title = "Infinite Yield",
            Content = "Loaded",
            Duration = 2,
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Bring Parts",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/BringParts/refs/heads/main/loadstring.lua"))()
        Rayfield:Notify({
            Title = "Bring Parts",
            Content = "Loaded",
            Duration = 2,
        })
    end
})

ScriptsTab:CreateSection("INFO")
ScriptsTab:CreateParagraph({
    Title = "Tips",
    Content = "ESP Color can be changed\nFullbright and No Fog are toggles"
})

-- Startup Notification
Rayfield:Notify({
    Title = "Twisted Hub",
    Content = "Ready",
    Duration = 2,
})

print("Twisted Hub Loaded")
