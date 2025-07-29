-- CUBEgui v1.0 | 2-column layout by vinh404

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local allowed = true

local bannedPlaces = {
    [6516141723] = true, -- Doors
    [11644044128] = true, -- Untitled Tag Game
    [15502339080] = true, -- Pressure
    [70005410] = true -- Grow a Garden
}

if bannedPlaces[game.PlaceId] then
    allowed = false
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "❌ GUI không được phép ở đây!";
        Color = Color3.new(1, 0, 0);
        Font = Enum.Font.SourceSansBold;
        TextSize = 20;
    })

    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 0
    hum.JumpPower = 0
end

if not allowed then return end

if player:WaitForChild("PlayerGui"):FindFirstChild("CUBEgui") then
    local msg = Instance.new("Message", workspace)
    msg.Text = "gui already here!!"
    task.delay(2, function() msg:Destroy() end)
    return
end

-- GUI Setup
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "CUBEgui"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0, 0, 0)
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Text = "CUBEgui v1.0"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 30, 0, 30)
toggle.Position = UDim2.new(1, -35, 0, 0)
toggle.Text = "X"
toggle.BackgroundColor3 = Color3.new(0, 0, 0)
toggle.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Holder 2 cột
local holder = Instance.new("Frame", main)
holder.Size = UDim2.new(1, 0, 1, -30)
holder.Position = UDim2.new(0, 0, 0, 30)
holder.BackgroundTransparency = 1

local left = Instance.new("Frame", holder)
left.Size = UDim2.new(0.5, -5, 1, 0)
left.Position = UDim2.new(0, 5, 0, 0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame", holder)
right.Size = UDim2.new(0.5, -5, 1, 0)
right.Position = UDim2.new(0.5, 0, 0, 0)
right.BackgroundTransparency = 1

Instance.new("UIListLayout", left).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", right).Padding = UDim.new(0, 5)

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

-- Nút bên trái
createButton(left, "Noclip", function()
    RunService.Stepped:Connect(function()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(11)
        end
    end)
end)

createButton(left, "Unnoclip", function()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:ChangeState(8)
    end
end)

createButton(left, "Fly", function()
    -- thêm Fly nếu cần
end)

createButton(left, "Unfly", function()
    -- thêm Unfly nếu cần
end)

-- TPPos
local tpBox = Instance.new("TextBox", left)
tpBox.Size = UDim2.new(1, 0, 0, 30)
tpBox.PlaceholderText = "Username"
tpBox.TextColor3 = Color3.fromRGB(0, 255, 0)
tpBox.BackgroundColor3 = Color3.new(0, 0, 0)

createButton(left, "TP to Pos", function()
    local target = Players:FindFirstChild(tpBox.Text)
    if target and target.Character and char then
        char:MoveTo(target.Character:GetPrimaryPartCFrame().p)
    end
end)

-- Nút bên phải: Fling + F3X
createButton(right, "Fling", function()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyAngularVelocity")
    bv.AngularVelocity = Vector3.new(99999, 99999, 99999)
    bv.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bv.P = 1250
    bv.Name = "FlingForce"
    bv.Parent = hrp
    wait(3)
    bv:Destroy()
end)

createButton(right, "F3X", function()
    local tool = game:GetObjects("rbxassetid://168410621")[1]
    tool.Parent = player.Backpack
end)
