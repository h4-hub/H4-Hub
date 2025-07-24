-- H4-Hub | MM2 Peak Farming GUI for Delta Executor
-- Fully Customizable: Coin Farm, Fling, Reset, Anti-Fling, Performance Mode

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Settings
local _G = {
    FarmEnabled = false,
    FlingEnabled = false,
    ResetEachRound = false,
    AntiFlingEnabled = true,
    PerformanceMode = false,
    TweenSpeed = 100,
    TPDelay = 0.05,
    FlingPower = 9999,
    PreFarmTP = Vector3.new(0, 9999, 0),  -- out of map before farming
    PostFarmTP = Vector3.new(0, 9999, 0), -- out of map after farming
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

-- Fling Function
function fling(target)
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(_G.FlingPower, _G.FlingPower, _G.FlingPower)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.P = 1250
    bv.Parent = hrp
    hrp.CFrame = target.CFrame
    wait(0.1)
    bv:Destroy()
end

-- Anti-Fling
RunService.Stepped:Connect(function()
    if _G.AntiFlingEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end
end)

-- Find Murderer
function getMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
            return plr.Character:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil
end

-- Teleport
function tp(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- Coin Farm
function farmCoins()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Coin" then
            tp(obj.Position)
            wait(_G.TPDelay)
        end
    end
end

-- Reset Char
function resetChar()
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end

-- Performance Mode
function enablePerformanceMode()
    Lighting.FogEnd = 1000000
    Lighting.Brightness = 0
    Lighting.GlobalShadows = false
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") then
            v:Destroy()
        end
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 230, 0, 270)
Frame.Position = UDim2.new(0.1, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

function addButton(name, y, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 15, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
end

addButton("Toggle Auto Farm", 10, function()
    _G.FarmEnabled = not _G.FarmEnabled
end)

addButton("Toggle Auto Fling Murd", 50, function()
    _G.FlingEnabled = not _G.FlingEnabled
end)

addButton("Toggle Auto Reset", 90, function()
    _G.ResetEachRound = not _G.ResetEachRound
end)

addButton("Toggle Anti-Fling", 130, function()
    _G.AntiFlingEnabled = not _G.AntiFlingEnabled
end)

addButton("Toggle Performance Mode", 170, function()
    _G.PerformanceMode = not _G.PerformanceMode
    if _G.PerformanceMode then enablePerformanceMode() end
end)

addButton("Close GUI", 210, function()
    ScreenGui:Destroy()
end)

-- Main Loop
while true do
    pcall(function()
        if _G.FarmEnabled then
            tp(_G.PreFarmTP)
            wait(0.2)
            farmCoins()
            tp(_G.PostFarmTP)
        end

        if _G.FlingEnabled then
            local murd = getMurderer()
            if murd then fling(murd) end
        end

        if _G.ResetEachRound and LocalPlayer:FindFirstChild("Backpack") and #LocalPlayer.Backpack:GetChildren() == 0 then
            resetChar()
        end
    end)
    wait(0.1)
end
