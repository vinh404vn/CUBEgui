local player = game:GetService("Players").LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local events = replicated:WaitForChild("Events")
local playerGui = player:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu có
local old = playerGui:FindFirstChild("CUBE_AbilityGui")
if old then old:Destroy() end

-- GUI chính
local gui = Instance.new("ScreenGui")
gui.Name = "CUBE_AbilityGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 240)
mainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderColor3 = Color3.fromRGB(100, 255, 100)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

-- Thanh tiêu đề
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.new(0, 0, 0)
titleBar.Text = "CUBE_AbilityGui"
titleBar.TextColor3 = Color3.fromRGB(150, 255, 150)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 16
titleBar.Parent = mainFrame

-- Nút ẩn GUI
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 50, 0, 25)
hideBtn.Position = UDim2.new(1, -55, 0, 0)
hideBtn.BackgroundColor3 = Color3.new(0, 0, 0)
hideBtn.BorderColor3 = Color3.fromRGB(100, 255, 100)
hideBtn.Text = "-"
hideBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.Parent = mainFrame

-- Frame ẩn/hiện GUI
local showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0, 100, 0, 30)
showBtn.Position = UDim2.new(0, 10, 0, 10)
showBtn.BackgroundColor3 = Color3.new(0, 0, 0)
showBtn.BorderColor3 = Color3.fromRGB(100, 255, 100)
showBtn.Text = "Show GUI"
showBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
showBtn.Font = Enum.Font.SourceSansBold
showBtn.Visible = false
showBtn.Parent = gui

hideBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	showBtn.Visible = false
end)

-- Tab Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 25)
tabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
tabFrame.Parent = mainFrame

local abilityChooseTab = Instance.new("TextButton")
abilityChooseTab.Size = UDim2.new(0.5, 0, 1, 0)
abilityChooseTab.Text = "Ability Choose"
abilityChooseTab.TextColor3 = Color3.fromRGB(150, 255, 150)
abilityChooseTab.BackgroundColor3 = Color3.new(0, 0, 0)
abilityChooseTab.Font = Enum.Font.SourceSansBold
abilityChooseTab.Parent = tabFrame

local runAbilityTab = Instance.new("TextButton")
runAbilityTab.Size = UDim2.new(0.5, 0, 1, 0)
runAbilityTab.Position = UDim2.new(0.5, 0, 0, 0)
runAbilityTab.Text = "Run Ability"
runAbilityTab.TextColor3 = Color3.fromRGB(150, 255, 150)
runAbilityTab.BackgroundColor3 = Color3.new(0, 0, 0)
runAbilityTab.Font = Enum.Font.SourceSansBold
runAbilityTab.Parent = tabFrame

-- Tab container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -10, 1, -65)
tabContainer.Position = UDim2.new(0, 5, 0, 60)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-- === TAB 1 ===
local chooseFrame = Instance.new("Frame")
chooseFrame.Size = UDim2.new(1, 0, 1, 0)
chooseFrame.BackgroundTransparency = 1
chooseFrame.Parent = tabContainer

local box1 = Instance.new("TextBox")
box1.Size = UDim2.new(1, -20, 0, 30)
box1.Position = UDim2.new(0, 10, 0, 10)
box1.PlaceholderText = "Enter value1"
box1.TextColor3 = Color3.new(1, 1, 1)
box1.BackgroundColor3 = Color3.new(0, 0, 0)
box1.BorderColor3 = Color3.fromRGB(100, 255, 100)
box1.Parent = chooseFrame

local box2 = Instance.new("TextBox")
box2.Size = UDim2.new(1, -20, 0, 30)
box2.Position = UDim2.new(0, 10, 0, 50)
box2.PlaceholderText = "Enter value2"
box2.TextColor3 = Color3.new(1, 1, 1)
box2.BackgroundColor3 = Color3.new(0, 0, 0)
box2.BorderColor3 = Color3.fromRGB(100, 255, 100)
box2.Parent = chooseFrame

local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0, 100, 0, 30)
executeBtn.Position = UDim2.new(0.5, -50, 0, 90)
executeBtn.Text = "Execute"
executeBtn.TextColor3 = Color3.new(1, 1, 1)
executeBtn.BackgroundColor3 = Color3.new(0, 0, 0)
executeBtn.BorderColor3 = Color3.fromRGB(100, 255, 100)
executeBtn.Parent = chooseFrame

executeBtn.MouseButton1Click:Connect(function()
	local value1, value2 = box1.Text, box2.Text
	if value1 ~= "" and value2 ~= "" then
		local args = {{value1, value2}}
		events:WaitForChild("RemoteEvents"):WaitForChild("AbilitySelection"):FireServer(unpack(args))
	end
end)

-- === TAB 2 ===
local runFrame = Instance.new("Frame")
runFrame.Size = UDim2.new(1, 0, 1, 0)
runFrame.BackgroundTransparency = 1
runFrame.Visible = false
runFrame.Parent = tabContainer

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 10)
dropdown.Text = "Select Ability"
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.BackgroundColor3 = Color3.new(0, 0, 0)
dropdown.BorderColor3 = Color3.fromRGB(100, 255, 100)
dropdown.Parent = runFrame

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1, -20, 0, 140)
listFrame.Position = UDim2.new(0, 10, 0, 45)
listFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
listFrame.BorderColor3 = Color3.fromRGB(100, 255, 100)
listFrame.Visible = false
listFrame.Parent = runFrame

local abilities = {"Banana","Revolver","Caretaker","BonusPad","Punch","Block","Hotdog","Dash","Cloak","Adrenaline","Taunt"}
local value3 = nil

for i, name in ipairs(abilities) do
	local opt = Instance.new("TextButton")
	opt.Size = UDim2.new(1, -10, 0, 20)
	opt.Position = UDim2.new(0, 5, 0, (i - 1) * 22 + 5)
	opt.Text = name
	opt.TextColor3 = Color3.new(1, 1, 1)
	opt.BackgroundColor3 = Color3.new(0, 0, 0)
	opt.BorderColor3 = Color3.fromRGB(100, 255, 100)
	opt.Parent = listFrame
	opt.MouseButton1Click:Connect(function()
		value3 = name
		dropdown.Text = "Selected: " .. name
		listFrame.Visible = false
	end)
end

dropdown.MouseButton1Click:Connect(function()
	listFrame.Visible = not listFrame.Visible
end)

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0, 100, 0, 30)
runBtn.Position = UDim2.new(0.5, -50, 0, 190)
runBtn.Text = "Run"
runBtn.TextColor3 = Color3.new(1, 1, 1)
runBtn.BackgroundColor3 = Color3.new(0, 0, 0)
runBtn.BorderColor3 = Color3.fromRGB(100, 255, 100)
runBtn.Parent = runFrame

runBtn.MouseButton1Click:Connect(function()
	if value3 then
		local args = {value3}
		events:WaitForChild("RemoteFunctions"):WaitForChild("UseAbility"):InvokeServer(unpack(args))
	end
end)

-- Chuyển tab
abilityChooseTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = true
	runFrame.Visible = false
end)

runAbilityTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = false
	runFrame.Visible = true
end)

-- Version text
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 160, 0, 20)
version.Position = UDim2.new(0, 5, 1, -22)
version.BackgroundTransparency = 1
version.Text = "CUBE_AbilityGui indev 0.1"
version.Font = Enum.Font.SourceSans
version.TextSize = 14
version.TextColor3 = Color3.fromRGB(120, 255, 120)
version.Parent = mainFrame
