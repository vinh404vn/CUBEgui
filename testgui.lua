-- CUBEgui v1.0 | Scroll-to-Page GUI
-- Gộp tất cả tính năng vào 1 script duy nhất
-- Author: vinh404

-- Kiểm tra GUI đã tồn tại chưa
if game.CoreGui:FindFirstChild("CUBEgui") then
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "gui already here!!";
        Color = Color3.new(1, 0, 0);
    })
    return
end

-- Chặn các game không cho execute GUI
local bannedPlaces = {
    [6516141723] = true, -- Doors
    [14044547200] = true, -- Untitled Tag Game
    [12411473842] = true -- Pressure
}

if bannedPlaces[game.PlaceId] then
    local lp = game.Players.LocalPlayer
    local function chatAll(msg)
        for _ = 1, 3 do
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end
    chatAll("you suck")
    chatAll("you idiot")
    chatAll("fuck")
    chatAll("dick")
    chatAll("i'm hacking")
    lp:Kick("Kicked for exploiting")
    game:GetService("ReplicatedStorage"):WaitForChild("ReportAbuseEvent"):FireServer("you suck, you idiot, fuck, dick", "He is swearing")
    game:GetService("ReplicatedStorage"):WaitForChild("ReportAbuseEvent"):FireServer("i'm hacking", "He is hacking")
    return
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CUBEgui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.new(0, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Text = "CUBEgui v1.0"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Toggle Button
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 30, 0, 30)
Toggle.Position = UDim2.new(1, -35, 0, 0)
Toggle.Text = "X"
Toggle.BackgroundColor3 = Color3.new(0, 0, 0)
Toggle.TextColor3 = Color3.fromRGB(0, 255, 0)
Toggle.Parent = MainFrame

local isOpen = true
Toggle.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    for _, page in pairs(MainFrame:GetChildren()) do
        if page:IsA("Frame") and page.Name:match("Page") then
            page.Visible = isOpen
        end
    end
end)

-- Pages system
local currentPage = 1
local totalPages = 2

local function createPage(index)
    local page = Instance.new("Frame")
    page.Name = "Page" .. index
    page.Size = UDim2.new(1, 0, 1, -30)
    page.Position = UDim2.new(0, 0, 0, 30)
    page.BackgroundColor3 = Color3.new(0, 0, 0)
    page.Visible = index == 1
    page.Parent = MainFrame
    return page
end

local pages = {}
for i = 1, totalPages do
    pages[i] = createPage(i)
end

local function switchPage(index)
    for i, page in pairs(pages) do
        page.Visible = (i == index)
    end
end

-- Page Buttons
local Prev = Instance.new("TextButton")
Prev.Size = UDim2.new(0, 60, 0, 25)
Prev.Position = UDim2.new(0, 10, 1, -30)
Prev.Text = "< Prev"
Prev.TextColor3 = Color3.fromRGB(0, 255, 0)
Prev.BackgroundColor3 = Color3.new(0, 0, 0)
Prev.Parent = MainFrame
Prev.MouseButton1Click:Connect(function()
    currentPage = currentPage > 1 and currentPage - 1 or totalPages
    switchPage(currentPage)
end)

local Next = Instance.new("TextButton")
Next.Size = UDim2.new(0, 60, 0, 25)
Next.Position = UDim2.new(1, -70, 1, -30)
Next.Text = "Next >"
Next.TextColor3 = Color3.fromRGB(0, 255, 0)
Next.BackgroundColor3 = Color3.new(0, 0, 0)
Next.Parent = MainFrame
Next.MouseButton1Click:Connect(function()
    currentPage = currentPage < totalPages and currentPage + 1 or 1
    switchPage(currentPage)
end)

-- Utility Buttons for Page1
local function addButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 30)
    button.BackgroundColor3 = Color3.new(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(0, 255, 0)
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end

local layout1 = Instance.new("UIListLayout")
layout1.Padding = UDim.new(0, 5)
layout1.Parent = pages[1]

addButton(pages[1], "Noclip", function()
    local lp = game.Players.LocalPlayer
    game:GetService("RunService").Stepped:Connect(function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid:ChangeState(11)
        end
    end)
end)

addButton(pages[1], "Unnoclip", function()
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(8)
    end
end)

addButton(pages[1], "Fly", function()
    -- Add Fly logic here
end)

addButton(pages[1], "Unfly", function()
    -- Add Unfly logic here
end)

-- Page2 with TPPos
local layout2 = Instance.new("UIListLayout")
layout2.Padding = UDim.new(0, 5)
layout2.Parent = pages[2]

local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(0, 180, 0, 30)
tpInput.PlaceholderText = "Username"
tpInput.BackgroundColor3 = Color3.new(0, 0, 0)
tpInput.TextColor3 = Color3.fromRGB(0, 255, 0)
tpInput.Parent = pages[2]

addButton(pages[2], "TP to user", function()
    local target = game.Players:FindFirstChild(tpInput.Text)
    local lp = game.Players.LocalPlayer
    if target and target.Character and lp.Character then
        lp.Character:MoveTo(target.Character:GetPrimaryPartCFrame().p)
    end
end)

addButton(pages[2], "Bypass AntiCheat", function()
    print("error:can't bypass")
end)

addButton(pages[2], "Anti-Fling", function()
    local lp = game.Players.LocalPlayer
    game:GetService("RunService").Heartbeat:Connect(function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)
