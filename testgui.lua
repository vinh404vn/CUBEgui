-- CUBEgui v1.0 -- One-script version with scrollable buttons, anti-fling, TPPos, GUI lock, and more

--== GAME LOCK (Kick in blacklisted games) ==--
local blockedPlaceIds = {
    [6839171747] = "DOORS",
    [10118559731] = "Untitled Tag Game",
    [15422299537] = "Pressure"
}

if blockedPlaceIds[game.PlaceId] then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "CUBEgui is blocked in: "..blockedPlaceIds[game.PlaceId]..". You will be kicked.",
        Color = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })

    wait(2)
    LocalPlayer:Kick("CUBEgui is not allowed in "..blockedPlaceIds[game.PlaceId])
    return
end

--== GUI DUPLICATION CHECK ==--
if game:GetService("CoreGui"):FindFirstChild("CUBEgui") then
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "gui already here!!",
        Color = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
    return
end

--== GUI CREATION ==--
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local scroll = Instance.new("ScrollingFrame")
local uiList = Instance.new("UIListLayout")
local toggleButton = Instance.new("TextButton")
local versionLabel = Instance.new("TextLabel")
local textBox = Instance.new("TextBox")

-- Main GUI setup
gui.Name = "CUBEgui"
gui.Parent = game:GetService("CoreGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

frame.Name = "MainFrame"
frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Active = true
frame.Draggable = true

-- Title bar
title.Name = "Title"
title.Parent = frame
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.BorderColor3 = Color3.fromRGB(144, 238, 144)
title.Size = UDim2.new(1, 0, 0, 25)
title.Font = Enum.Font.SourceSansBold
title.Text = "CUBEgui"
title.TextColor3 = Color3.fromRGB(144, 238, 144)
title.TextSize = 18

-- Toggle button
toggleButton.Name = "Toggle"
toggleButton.Parent = frame
toggleButton.Text = "✕"
toggleButton.Size = UDim2.new(0, 25, 0, 25)
toggleButton.Position = UDim2.new(1, -25, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.BorderColor3 = Color3.fromRGB(144, 238, 144)
toggleButton.TextColor3 = Color3.fromRGB(144, 238, 144)
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Version label
versionLabel.Name = "Version"
versionLabel.Parent = frame
versionLabel.BackgroundTransparency = 1
versionLabel.Position = UDim2.new(0, 5, 1, -20)
versionLabel.Size = UDim2.new(1, -10, 0, 20)
versionLabel.Font = Enum.Font.SourceSans
versionLabel.Text = "Version: test"
versionLabel.TextColor3 = Color3.fromRGB(144, 238, 144)
versionLabel.TextSize = 14
versionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Scrollable buttons area
scroll.Name = "ScrollFrame"
scroll.Parent = frame
scroll.Position = UDim2.new(0, 0, 0, 25)
scroll.Size = UDim2.new(1, 0, 1, -50)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
scroll.BorderColor3 = Color3.fromRGB(144, 238, 144)

uiList.Parent = scroll
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 5)

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
end)

--== UTILITY BUTTON MAKER ==--
local function makeButton(text, func)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = UDim2.new(1, -10, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.BorderColor3 = Color3.fromRGB(144, 238, 144)
    b.TextColor3 = Color3.fromRGB(144, 238, 144)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    b.Parent = scroll
    b.MouseButton1Click:Connect(func)
end

--== FEATURE BUTTONS ==--
makeButton("Noclip", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end)

makeButton("Unnoclip", function()
    for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
        end
    end
end)

makeButton("Fly", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InfinityModeYT/FE-Fly-Gui/main/FlyGui.lua"))()
end)

makeButton("Unfly", function()
    if _G.FLYING then _G.FLYING = false end
end)

-- TPPos
textBox.Parent = scroll
textBox.PlaceholderText = "Enter username or pos"
textBox.Size = UDim2.new(1, -10, 0, 30)
textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textBox.BorderColor3 = Color3.fromRGB(144, 238, 144)
textBox.TextColor3 = Color3.fromRGB(144, 238, 144)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 16

makeButton("TPPos", function()
    local text = textBox.Text
    local lp = game.Players.LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local plr = game.Players:FindFirstChild(text)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
    elseif string.find(text, ",") then
        local x,y,z = string.match(text,"(-?%d+),%s*(-?%d+),%s*(-?%d+)")
        if x and y and z then
            hrp.CFrame = CFrame.new(tonumber(x),tonumber(y),tonumber(z))
        end
    end
end)

makeButton("Bypass Anticheat", function()
    -- Dummy bypass switch, can customize per game
    print("Bypass toggled")
end)

--== ANTI-FLING ==--
game:GetService("RunService").Heartbeat:Connect(function()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end
end)
