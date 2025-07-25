-- H4-Hub 🗡 | Unified MM2 Script Hub
-- Based on Vortex GUI with all major public features appended and toggleable

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local H4 = {
    AutoFarm = false,
    AutoEndRound = false,
    ESP = false,
    AutoReset = false,
    AntiFling = false,
    PerformanceMode = false
}

-- Anti-AFK
spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),Workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),Workspace.CurrentCamera.CFrame)
    end)
end)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "H4Hub"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 400)
Main.Position = UDim2.new(0.5, -175, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "H4-Hub 🗡"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name .. ": OFF"

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(state)
    end)
end

createToggle("Auto Farm", 50, function(v) H4.AutoFarm = v end)
createToggle("Auto End Round", 90, function(v) H4.AutoEndRound = v end)
createToggle("ESP", 130, function(v) H4.ESP = v end)
createToggle("Auto Reset", 170, function(v) H4.AutoReset = v end)
createToggle("Anti-Fling", 210, function(v) H4.AntiFling = v end)
createToggle("Performance Mode", 250, function(v)
    H4.PerformanceMode = v
    if v then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e6
        Lighting.Brightness = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then
                v:Destroy()
            end
        end
    end
end)

-- Feature Functions
function tp(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
    end
end

function farmCoins()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Coin" then
            tp(obj.Position)
            wait(0.05)
        end
    end
end

function getMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
            return plr.Character:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil
end

function fling(target)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not target then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(9999, 9999, 9999)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.P = 1250
    bv.Parent = hrp
    hrp.CFrame = target.CFrame
    wait(0.1)
    bv:Destroy()
end

function resetChar()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end

RunService.Stepped:Connect(function()
    if H4.AntiFling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end
end)

-- Main Loop
while true do
    pcall(function()
        if H4.AutoFarm then
            farmCoins()
        end
        if H4.AutoEndRound then
            local murd = getMurderer()
            if murd then fling(murd) end
        end
        if H4.AutoReset and LocalPlayer:FindFirstChild("Backpack") and #LocalPlayer.Backpack:GetChildren() == 0 then
            resetChar()
        end
    end)
    wait(0.1)
end
