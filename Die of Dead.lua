--[[
	CUBE_AbilityGui indev 0.2 (vinh404)
	- Tab 1: 2 Dropdown (giống Tab 2) thay TextBox
	- Tab 2: Run Ability
	- Tab 3: Killer Ability
	- Tất cả dropdown dùng ScrollingFrame + UIListLayout
--]]

local Players      = game:GetService("Players")
local Replicated   = game:GetService("ReplicatedStorage")
local Events       = Replicated:WaitForChild("Events")
local Player       = Players.LocalPlayer
local PlayerGui    = Player:WaitForChild("PlayerGui")

-- Xóa GUI cũ
local old = PlayerGui:FindFirstChild("CUBE_AbilityGui")
if old then old:Destroy() end

-----------------------------------------------------------------
-- GUI chính
-----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CUBE_AbilityGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 240)
mainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.new(0,0,0)
mainFrame.BorderColor3 = Color3.fromRGB(100,255,100)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Tiêu đề
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1,0,0,25)
titleBar.BackgroundColor3 = Color3.new(0,0,0)
titleBar.Text = "CUBE_AbilityGui"
titleBar.TextColor3 = Color3.fromRGB(150,255,150)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 16
titleBar.Parent = mainFrame

-- Nút ẩn/hiện
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0,50,0,25)
hideBtn.Position = UDim2.new(1,-55,0,0)
hideBtn.BackgroundColor3 = Color3.new(0,0,0)
hideBtn.BorderColor3 = Color3.fromRGB(100,255,100)
hideBtn.Text = "-"
hideBtn.TextColor3 = Color3.fromRGB(150,255,150)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.Parent = mainFrame

local showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0,100,0,30)
showBtn.Position = UDim2.new(0,10,0,10)
showBtn.BackgroundColor3 = Color3.new(0,0,0)
showBtn.BorderColor3 = Color3.fromRGB(100,255,100)
showBtn.Text = "Show GUI"
showBtn.TextColor3 = Color3.fromRGB(150,255,150)
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

-----------------------------------------------------------------
-- Tab bar (3 tabs)
-----------------------------------------------------------------
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,30)
tabFrame.Position = UDim2.new(0,0,0,25)
tabFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
tabFrame.Parent = mainFrame

local chooseTab = Instance.new("TextButton")
chooseTab.Size = UDim2.new(1/3,0,1,0)
chooseTab.Text = "Ability Choose"
chooseTab.TextColor3 = Color3.fromRGB(150,255,150)
chooseTab.BackgroundColor3 = Color3.new(0,0,0)
chooseTab.Font = Enum.Font.SourceSansBold
chooseTab.Parent = tabFrame

local runTab = Instance.new("TextButton")
runTab.Size = UDim2.new(1/3,0,1,0)
runTab.Position = UDim2.new(1/3,0,0,0)
runTab.Text = "Run Ability"
runTab.TextColor3 = Color3.fromRGB(150,255,150)
runTab.BackgroundColor3 = Color3.new(0,0,0)
runTab.Font = Enum.Font.SourceSansBold
runTab.Parent = tabFrame

local killerTab = Instance.new("TextButton")
killerTab.Size = UDim2.new(1/3,0,1,0)
killerTab.Position = UDim2.new(2/3,0,0,0)
killerTab.Text = "Killer Ability"
killerTab.TextColor3 = Color3.fromRGB(150,255,150)
killerTab.BackgroundColor3 = Color3.new(0,0,0)
killerTab.Font = Enum.Font.SourceSansBold
killerTab.Parent = tabFrame

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1,-10,1,-65)
tabContainer.Position = UDim2.new(0,5,0,60)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-----------------------------------------------------------------
-- TAB 1: 2 Dropdown (thay TextBox)
-----------------------------------------------------------------
local chooseFrame = Instance.new("Frame")
chooseFrame.Size = UDim2.new(1,0,1,0)
chooseFrame.BackgroundTransparency = 1
chooseFrame.Visible = true
chooseFrame.Parent = tabContainer

-- Dropdown 1
local dropdown1 = Instance.new("TextButton")
dropdown1.Size = UDim2.new(1,-20,0,30)
dropdown1.Position = UDim2.new(0,10,0,10)
dropdown1.Text = "Select Value1"
dropdown1.TextColor3 = Color3.new(1,1,1)
dropdown1.BackgroundColor3 = Color3.new(0,0,0)
dropdown1.BorderColor3 = Color3.fromRGB(100,255,100)
dropdown1.Parent = chooseFrame

local list1 = Instance.new("ScrollingFrame")
list1.Size = UDim2.new(1,-20,0,120)
list1.Position = UDim2.new(0,10,0,45)
list1.BackgroundColor3 = Color3.fromRGB(10,10,10)
list1.BorderColor3 = Color3.fromRGB(100,255,100)
list1.ScrollBarThickness = 6
list1.Visible = false
list1.Parent = chooseFrame

local layout1 = Instance.new("UIListLayout")
layout1.SortOrder = Enum.SortOrder.LayoutOrder
layout1.Parent = list1

-- Dropdown 2
local dropdown2 = Instance.new("TextButton")
dropdown2.Size = UDim2.new(1,-20,0,30)
dropdown2.Position = UDim2.new(0,10,0,170)
dropdown2.Text = "Select Value2"
dropdown2.TextColor3 = Color3.new(1,1,1)
dropdown2.BackgroundColor3 = Color3.new(0,0,0)
dropdown2.BorderColor3 = Color3.fromRGB(100,255,100)
dropdown2.Parent = chooseFrame

local list2 = Instance.new("ScrollingFrame")
list2.Size = UDim2.new(1,-20,0,120)
list2.Position = UDim2.new(0,10,0,205)
list2.BackgroundColor3 = Color3.fromRGB(10,10,10)
list2.BorderColor3 = Color3.fromRGB(100,255,100)
list2.ScrollBarThickness = 6
list2.Visible = false
list2.Parent = chooseFrame

local layout2 = Instance.new("UIListLayout")
layout2.SortOrder = Enum.SortOrder.LayoutOrder
layout2.Parent = list2

-- Danh sách khả dụng (có thể chỉnh tùy game)
local options = {
	"Banana","Revolver","Caretaker","BonusPad","Punch","Block",
	"Hotdog","Dash","Cloak","Adrenaline","Taunt"
}

local value1 = nil
local value2 = nil

-- Tạo option cho dropdown 1
for i, name in ipairs(options) do
	local opt = Instance.new("TextButton")
	opt.Size = UDim2.new(1,-10,0,22)
	opt.BackgroundColor3 = Color3.new(0,0,0)
	opt.BorderColor3 = Color3.fromRGB(100,255,100)
	opt.Text = name
	opt.TextColor3 = Color3.new(1,1,1)
	opt.Font = Enum.Font.SourceSans
	opt.LayoutOrder = i
	opt.Parent = list1
	opt.MouseButton1Click:Connect(function()
		value1 = name
		dropdown1.Text = "Value1: " .. name
		list1.Visible = false
	end)
end
list1.CanvasSize = UDim2.new(0,0,0, #options * 24)

-- Tạo option cho dropdown 2
for i, name in ipairs(options) do
	local opt = Instance.new("TextButton")
	opt.Size = UDim2.new(1,-10,0,22)
	opt.BackgroundColor3 = Color3.new(0,0,0)
	opt.BorderColor3 = Color3.fromRGB(100,255,100)
	opt.Text = name
	opt.TextColor3 = Color3.new(1,1,1)
	opt.Font = Enum.Font.SourceSans
	opt.LayoutOrder = i
	opt.Parent = list2
	opt.MouseButton1Click:Connect(function()
		value2 = name
		dropdown2.Text = "Value2: " .. name
		list2.Visible = false
	end)
end
list2.CanvasSize = UDim2.new(0,0,0, #options * 24)

-- Mở/đóng dropdown
dropdown1.MouseButton1Click:Connect(function()
	list1.Visible = not list1.Visible
	list2.Visible = false
end)

dropdown2.MouseButton1Click:Connect(function()
	list2.Visible = not list2.Visible
	list1.Visible = false
end)

-- Nút Execute
local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0,100,0,30)
executeBtn.Position = UDim2.new(0.5,-50,0,335)
executeBtn.Text = "Execute"
executeBtn.TextColor3 = Color3.new(1,1,1)
executeBtn.BackgroundColor3 = Color3.new(0,0,0)
executeBtn.BorderColor3 = Color3.fromRGB(100,255,100)
executeBtn.Parent = chooseFrame

executeBtn.MouseButton1Click:Connect(function()
	if value1 and value2 then
		Events:WaitForChild("RemoteEvents"):WaitForChild("AbilitySelection"):FireServer(value1, value2)
	end
end)

-----------------------------------------------------------------
-- TAB 2: Run Ability
-----------------------------------------------------------------
local runFrame = Instance.new("Frame")
runFrame.Size = UDim2.new(1,0,1,0)
runFrame.BackgroundTransparency = 1
runFrame.Visible = false
runFrame.Parent = tabContainer

local runDropdown = Instance.new("TextButton")
runDropdown.Size = UDim2.new(1,-20,0,30)
runDropdown.Position = UDim2.new(0,10,0,10)
runDropdown.Text = "Select Ability"
runDropdown.TextColor3 = Color3.new(1,1,1)
runDropdown.BackgroundColor3 = Color3.new(0,0,0)
runDropdown.BorderColor3 = Color3.fromRGB(100,255,100)
runDropdown.Parent = runFrame

local runList = Instance.new("ScrollingFrame")
runList.Size = UDim2.new(1,-20,0,140)
runList.Position = UDim2.new(0,10,0,45)
runList.BackgroundColor3 = Color3.fromRGB(10,10,10)
runList.BorderColor3 = Color3.fromRGB(100,255,100)
runList.ScrollBarThickness = 6
runList.Visible = false
runList.Parent = runFrame

local runLayout = Instance.new("UIListLayout")
runLayout.SortOrder = Enum.SortOrder.LayoutOrder
runLayout.Parent = runList

local runValue = nil
for i, name in ipairs(options) do
	local opt = Instance.new("TextButton")
	opt.Size = UDim2.new(1,-10,0,22)
	opt.BackgroundColor3 = Color3.new(0,0,0)
	opt.BorderColor3 = Color3.fromRGB(100,255,100)
	opt.Text = name
	opt.TextColor3 = Color3.new(1,1,1)
	opt.Font = Enum.Font.SourceSans
	opt.LayoutOrder = i
	opt.Parent = runList
	opt.MouseButton1Click:Connect(function()
		runValue = name
		runDropdown.Text = "Selected: " .. name
		runList.Visible = false
	end)
end
runList.CanvasSize = UDim2.new(0,0,0, #options * 24)

runDropdown.MouseButton1Click:Connect(function()
	runList.Visible = not runList.Visible
end)

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0,100,0,30)
runBtn.Position = UDim2.new(0.5,-50,0,195)
runBtn.Text = "Run"
runBtn.TextColor3 = Color3.new(1,1,1)
runBtn.BackgroundColor3 = Color3.new(0,0,0)
runBtn.BorderColor3 = Color3.fromRGB(100,255,100)
runBtn.Parent = runFrame

runBtn.MouseButton1Click:Connect(function()
	if runValue then
		Events:WaitForChild("RemoteFunctions"):WaitForChild("UseAbility"):InvokeServer(runValue)
	end
end)

-----------------------------------------------------------------
-- TAB 3: Killer Ability
-----------------------------------------------------------------
local killerFrame = Instance.new("Frame")
killerFrame.Size = UDim2.new(1,0,1,0)
killerFrame.BackgroundTransparency = 1
killerFrame.Visible = false
killerFrame.Parent = tabContainer

local killerDropdown = Instance.new("TextButton")
killerDropdown.Size = UDim2.new(1,-20,0,30)
killerDropdown.Position = UDim2.new(0,10,0,10)
killerDropdown.Text = "Select Killer Ability"
killerDropdown.TextColor3 = Color3.new(1,1,1)
killerDropdown.BackgroundColor3 = Color3.new(0,0,0)
killerDropdown.BorderColor3 = Color3.fromRGB(100,255,100)
killerDropdown.Parent = killerFrame

local killerList = Instance.new("ScrollingFrame")
killerList.Size = UDim2.new(1,-20,0,140)
killerList.Position = UDim2.new(0,10,0,45)
killerList.BackgroundColor3 = Color3.fromRGB(10,10,10)
killerList.BorderColor3 = Color3.fromRGB(100,255,100)
killerList.ScrollBarThickness = 6
killerList.Visible = false
killerList.Parent = killerFrame

local killerLayout = Instance.new("UIListLayout")
killerLayout.SortOrder = Enum.SortOrder.LayoutOrder
killerLayout.Parent = killerList

local killerAbilities = {"Howl","Stalk","Unshroud","Implement","Flight","Detonate"}
local killerValue = nil

for i, name in ipairs(killerAbilities) do
	local opt = Instance.new("TextButton")
	opt.Size = UDim2.new(1,-10,0,22)
	opt.BackgroundColor3 = Color3.new(0,0,0)
	opt.BorderColor3 = Color3.fromRGB(100,255,100)
	opt.Text = name
	opt.TextColor3 = Color3.new(1,1,1)
	opt.Font = Enum.Font.SourceSans
	opt.LayoutOrder = i
	opt.Parent = killerList
	opt.MouseButton1Click:Connect(function()
		killerValue = name
		killerDropdown.Text = "Selected: " .. name
		killerList.Visible = false
	end)
end
killerList.CanvasSize = UDim2.new(0,0,0, #killerAbilities * 24)

killerDropdown.MouseButton1Click:Connect(function()
	killerList.Visible = not killerList.Visible
end)

local killerBtn = Instance.new("TextButton")
killerBtn.Size = UDim2.new(0,100,0,30)
killerBtn.Position = UDim2.new(0.5,-50,0,195)
killerBtn.Text = "Run"
killerBtn.TextColor3 = Color3.new(1,1,1)
killerBtn.BackgroundColor3 = Color3.new(0,0,0)
killerBtn.BorderColor3 = Color3.fromRGB(100,255,100)
killerBtn.Parent = killerFrame

killerBtn.MouseButton1Click:Connect(function()
	if killerValue then
		Events:WaitForChild("RemoteFunctions"):WaitForChild("UseAbility"):InvokeServer(killerValue)
	end
end)

-----------------------------------------------------------------
-- Chuyển tab
-----------------------------------------------------------------
chooseTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = true
	runFrame.Visible = false
	killerFrame.Visible = false
end)

runTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = false
	runFrame.Visible = true
	killerFrame.Visible = false
end)

killerTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = false
	runFrame.Visible = false
	killerFrame.Visible = true
end)

-----------------------------------------------------------------
-- Version
-----------------------------------------------------------------
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0,220,0,20)
version.Position = UDim2.new(0,5,1,-22)
version.BackgroundTransparency = 1
version.Text = "CUBE_AbilityGui indev 0.2 (idiot)"
version.Font = Enum.Font.SourceSans
version.TextSize = 14
version.TextColor3 = Color3.fromRGB(120,255,120)
version.Parent = mainFrame
