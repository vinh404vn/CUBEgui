--[[
	CUBE_DoD - indev 0.4+ (vinh404)
	- Version tăng thủ công: thay BASE_VERSION khi update
	- Bắt đầu: 0.4 → 0.5 → 0.6...
	- Notification: góc trên bên phải
	- GUI: CUBE_DoD
--]]

local Players      = game:GetService("Players")
local Replicated   = game:GetService("ReplicatedStorage")
local Events       = Replicated:WaitForChild("Events")
local TweenService = game:GetService("TweenService")
local Player       = Players.LocalPlayer
local PlayerGui    = Player:WaitForChild("PlayerGui")

-- XÓA GUI CŨ
local old = PlayerGui:FindFirstChild("CUBE_DoD")
if old then old:Destroy() end

-----------------------------------------------------------------
-- VERSION: TĂNG THỦ CÔNG KHI UPDATE GITHUB
-----------------------------------------------------------------
local BASE_VERSION = 0.5   -- Thay đổi khi update
local HOTFIX = true
local HOTFIX_VERSION = 0.03
-----------------------------------------------------------------
-- Notification System (GÓC TRÊN BÊN PHẢI)
-----------------------------------------------------------------
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, 300, 0, 0)
notifContainer.Position = UDim2.new(1, -320, 0, 20)
notifContainer.BackgroundTransparency = 1
notifContainer.ClipsDescendants = true
notifContainer.Parent = PlayerGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifContainer

local function showNotification(text, color)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.BackgroundColor3 = color or Color3.fromRGB(100, 255, 100)
	frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
	frame.BorderSizePixel = 2
	frame.Position = UDim2.new(1, 20, 0, 0)
	frame.Parent = notifContainer

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(0, 0, 0)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextScaled = true
	label.Parent = frame

	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)})
	tweenIn:Play()

	task.delay(3, function()
		local tweenOut = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 20, 0, 0)})
		tweenOut:Play()
		tweenOut.Completed:Connect(function()
			frame:Destroy()
			notifContainer.Size = UDim2.new(0, 300, 0, notifLayout.AbsoluteContentSize.Y)
		end)
	end)

	notifContainer.Size = UDim2.new(0, 300, 0, notifLayout.AbsoluteContentSize.Y + 60)
end

-----------------------------------------------------------------
-- GUI chính
-----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CUBE_DoD"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 300)
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
titleBar.Text = "CUBE_DoD"
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
showBtn.Text = "Show DoD"
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
-- Tab bar (bây giờ có 4 tab)
-----------------------------------------------------------------
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,30)
tabFrame.Position = UDim2.new(0,0,0,25)
tabFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
tabFrame.Parent = mainFrame

local chooseTab = Instance.new("TextButton")
chooseTab.Size = UDim2.new(0.25,0,1,0)
chooseTab.Text = "Choose"
chooseTab.TextColor3 = Color3.fromRGB(150,255,150)
chooseTab.BackgroundColor3 = Color3.new(0,0,0)
chooseTab.Font = Enum.Font.SourceSansBold
chooseTab.Parent = tabFrame

local runTab = Instance.new("TextButton")
runTab.Size = UDim2.new(0.25,0,1,0)
runTab.Position = UDim2.new(0.25,0,0,0)
runTab.Text = "Run"
runTab.TextColor3 = Color3.fromRGB(150,255,150)
runTab.BackgroundColor3 = Color3.new(0,0,0)
runTab.Font = Enum.Font.SourceSansBold
runTab.Parent = tabFrame

local killerTab = Instance.new("TextButton")
killerTab.Size = UDim2.new(0.25,0,1,0)
killerTab.Position = UDim2.new(0.5,0,0,0)
killerTab.Text = "Killer"
killerTab.TextColor3 = Color3.fromRGB(150,255,150)
killerTab.BackgroundColor3 = Color3.new(0,0,0)
killerTab.Font = Enum.Font.SourceSansBold
killerTab.Parent = tabFrame

local miscTab = Instance.new("TextButton")
miscTab.Size = UDim2.new(0.25,0,1,0)
miscTab.Position = UDim2.new(0.75,0,0,0)
miscTab.Text = "Misc"
miscTab.TextColor3 = Color3.fromRGB(150,255,150)
miscTab.BackgroundColor3 = Color3.new(0,0,0)
miscTab.Font = Enum.Font.SourceSansBold
miscTab.Parent = tabFrame

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1,-10,1,-65)
tabContainer.Position = UDim2.new(0,5,0,60)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-----------------------------------------------------------------
-- TAB 1: Choose (giữ nguyên hoàn toàn)
-----------------------------------------------------------------
local chooseFrame = Instance.new("Frame")
chooseFrame.Size = UDim2.new(1,0,1,0)
chooseFrame.BackgroundTransparency = 1
chooseFrame.Visible = true
chooseFrame.Parent = tabContainer

local savedValue1 = PlayerGui:FindFirstChild("DoD_Value1") and PlayerGui.DoD_Value1.Value or nil
local savedValue2 = PlayerGui:FindFirstChild("DoD_Value2") and PlayerGui.DoD_Value2.Value or nil

-- Dropdown 1 & 2 + options (giữ nguyên code cũ của bạn)
local dropdown1 = Instance.new("TextButton")
dropdown1.Size = UDim2.new(1,-20,0,30)
dropdown1.Position = UDim2.new(0,10,0,10)
dropdown1.Text = savedValue1 and ("1: " .. savedValue1) or "Select Value 1"
dropdown1.TextColor3 = Color3.new(1,1,1)
dropdown1.BackgroundColor3 = Color3.new(0,0,0)
dropdown1.BorderColor3 = Color3.fromRGB(100,255,100)
dropdown1.ZIndex = 10
dropdown1.Parent = chooseFrame

local list1 = Instance.new("ScrollingFrame")
list1.Size = UDim2.new(1,-20,0,120)
list1.Position = UDim2.new(0,10,0,45)
list1.BackgroundColor3 = Color3.fromRGB(10,10,10)
list1.BorderColor3 = Color3.fromRGB(100,255,100)
list1.ScrollBarThickness = 6
list1.Visible = false
list1.ZIndex = 10
list1.Parent = chooseFrame

local layout1 = Instance.new("UIListLayout")
layout1.SortOrder = Enum.SortOrder.LayoutOrder
layout1.Parent = list1

local dropdown2 = Instance.new("TextButton")
dropdown2.Size = UDim2.new(1,-20,0,30)
dropdown2.Position = UDim2.new(0,10,0,53)
dropdown2.Text = savedValue2 and ("2: " .. savedValue2) or "Select Value 2"
dropdown2.TextColor3 = Color3.new(1,1,1)
dropdown2.BackgroundColor3 = Color3.new(0,0,0)
dropdown2.BorderColor3 = Color3.fromRGB(100,255,100)
dropdown2.ZIndex = 9
dropdown2.Parent = chooseFrame

local list2 = Instance.new("ScrollingFrame")
list2.Size = UDim2.new(1,-20,0,120)
list2.Position = UDim2.new(0,10,0,88)
list2.BackgroundColor3 = Color3.fromRGB(10,10,10)
list2.BorderColor3 = Color3.fromRGB(100,255,100)
list2.ScrollBarThickness = 6
list2.Visible = false
list2.ZIndex = 5
list2.Parent = chooseFrame

local layout2 = Instance.new("UIListLayout")
layout2.SortOrder = Enum.SortOrder.LayoutOrder
layout2.Parent = list2

local options = {"Banana","Revolver","Caretaker","BonusPad","Punch","Block","Hotdog","Dash","Cloak","Adrenaline","Taunt"}
local value1 = savedValue1
local value2 = savedValue2

for i, name in ipairs(options) do
	local opt1 = Instance.new("TextButton")
	opt1.Size = UDim2.new(1,-10,0,22)
	opt1.BackgroundColor3 = Color3.new(0,0,0)
	opt1.BorderColor3 = Color3.fromRGB(100,255,100)
	opt1.Text = name
	opt1.TextColor3 = Color3.new(1,1,1)
	opt1.Font = Enum.Font.SourceSans
	opt1.LayoutOrder = i
	opt1.ZIndex = 10
	opt1.Parent = list1
	opt1.MouseButton1Click:Connect(function()
		value1 = name
		dropdown1.Text = "1: " .. name
		list1.Visible = false
		list2.Visible = false
		local save = PlayerGui:FindFirstChild("DoD_Value1") or Instance.new("StringValue", PlayerGui)
		save.Name = "DoD_Value1"
		save.Value = name
	end)

	local opt2 = opt1:Clone()
	opt2.ZIndex = 5
	opt2.Parent = list2
	opt2.MouseButton1Click:Connect(function()
		value2 = name
		dropdown2.Text = "2: " .. name
		list2.Visible = false
		list1.Visible = false
		local save = PlayerGui:FindFirstChild("DoD_Value2") or Instance.new("StringValue", PlayerGui)
		save.Name = "DoD_Value2"
		save.Value = name
	end)
end

list1.CanvasSize = UDim2.new(0,0,0, #options * 24)
list2.CanvasSize = UDim2.new(0,0,0, #options * 24)

dropdown1.MouseButton1Click:Connect(function()
	list1.Visible = not list1.Visible
	list2.Visible = false
end)

dropdown2.MouseButton1Click:Connect(function()
	list2.Visible = not list2.Visible
	list1.Visible = false
end)

local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0,100,0,30)
executeBtn.Position = UDim2.new(0.5,-50,0,255)
executeBtn.Text = "Execute"
executeBtn.TextColor3 = Color3.new(1,1,1)
executeBtn.BackgroundColor3 = Color3.new(0,0,0)
executeBtn.BorderColor3 = Color3.fromRGB(100,255,100)
executeBtn.ZIndex = 10
executeBtn.Parent = chooseFrame

executeBtn.MouseButton1Click:Connect(function()
	if value1 and value2 then
		pcall(function()
			Events:WaitForChild("RemoteEvents"):WaitForChild("AbilitySelection"):FireServer({value1, value2})
			showNotification("Sent: " .. value1 .. " + " .. value2, Color3.fromRGB(100, 255, 100))
		end)
	else
		showNotification("Chọn cả 2 value!", Color3.fromRGB(255, 100, 100))
	end
end)

-----------------------------------------------------------------
-- TAB 2 & 3: Run + Killer (giữ nguyên function cũ)
-----------------------------------------------------------------
local function createRunTab(tabName, abilities, frameName)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Name = frameName
	frame.Parent = tabContainer

	local dropdown = Instance.new("TextButton")
	dropdown.Size = UDim2.new(1,-20,0,30)
	dropdown.Position = UDim2.new(0,10,0,10)
	dropdown.Text = "Select " .. tabName
	dropdown.TextColor3 = Color3.new(1,1,1)
	dropdown.BackgroundColor3 = Color3.new(0,0,0)
	dropdown.BorderColor3 = Color3.fromRGB(100,255,100)
	dropdown.Parent = frame

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1,-20,0,140)
	list.Position = UDim2.new(0,10,0,45)
	list.BackgroundColor3 = Color3.fromRGB(10,10,10)
	list.BorderColor3 = Color3.fromRGB(100,255,100)
	list.ScrollBarThickness = 6
	list.Visible = false
	list.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	local value = nil
	for i, ab in ipairs(abilities) do
		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1,-10,0,22)
		opt.BackgroundColor3 = Color3.new(0,0,0)
		opt.BorderColor3 = Color3.fromRGB(100,255,100)
		opt.Text = ab
		opt.TextColor3 = Color3.new(1,1,1)
		opt.Font = Enum.Font.SourceSans
		opt.LayoutOrder = i
		opt.Parent = list
		opt.MouseButton1Click:Connect(function()
			value = ab
			dropdown.Text = ab
			list.Visible = false
		end)
	end
	list.CanvasSize = UDim2.new(0,0,0, #abilities * 24)

	dropdown.MouseButton1Click:Connect(function()
		list.Visible = not list.Visible
	end)

	local runBtn = Instance.new("TextButton")
	runBtn.Size = UDim2.new(0,100,0,30)
	runBtn.Position = UDim2.new(0.5,-50,0,255)
	runBtn.Text = "Run"
	runBtn.TextColor3 = Color3.new(1,1,1)
	runBtn.BackgroundColor3 = Color3.new(0,0,0)
	runBtn.BorderColor3 = Color3.fromRGB(100,255,100)
	runBtn.Parent = frame

	runBtn.MouseButton1Click:Connect(function()
		if value then
			pcall(function()
				Events:WaitForChild("RemoteFunctions"):WaitForChild("UseAbility"):InvokeServer(value)
				showNotification("Ran: " .. value, tabName == "Killer" and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100))
			end)
		end
	end)

	return frame
end

local runFrame = createRunTab("Ability", options, "RunFrame")
local killerFrame = createRunTab("Killer", {"Howl","Stalk","Unshroud","Implement","Flight","Detonate"}, "KillerFrame")

-----------------------------------------------------------------
-- TAB 4: Misc - Auto Delete Barrier
-----------------------------------------------------------------
local miscFrame = Instance.new("Frame")
miscFrame.Size = UDim2.new(1,0,1,0)
miscFrame.BackgroundTransparency = 1
miscFrame.Visible = false
miscFrame.Parent = tabContainer

-- Label
local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0.65,0,0,30)
toggleLabel.Position = UDim2.new(0,10,0,20)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Auto Delete Barrier"
toggleLabel.TextColor3 = Color3.fromRGB(200,255,200)
toggleLabel.Font = Enum.Font.SourceSansBold
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Parent = miscFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,70,0,30)
toggleBtn.Position = UDim2.new(1,-80,0,20)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1,0,0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,0,0)
toggleBtn.BorderColor3 = Color3.fromRGB(100,255,100)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = miscFrame

local autoDeleteEnabled = false

toggleBtn.MouseButton1Click:Connect(function()
	autoDeleteEnabled = not autoDeleteEnabled
	if autoDeleteEnabled then
		toggleBtn.Text = "ON"
		toggleBtn.TextColor3 = Color3.fromRGB(0,255,0)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0,50,0)
		showNotification("Auto Delete Barrier: ON", Color3.fromRGB(100,255,100))
		
		spawn(function()
			while autoDeleteEnabled do
				task.wait(0.3)  -- Có thể giảm xuống 0.1 nếu muốn nhanh hơn
				
				local barriersFolder = workspace:FindFirstChild("GameAssets")
				if barriersFolder then barriersFolder = barriersFolder:FindFirstChild("Map") end
				if barriersFolder then barriersFolder = barriersFolder:FindFirstChild("Config") end
				if barriersFolder then barriersFolder = barriersFolder:FindFirstChild("Barriers") end
				
				if barriersFolder and barriersFolder:IsA("Folder") then
					for _, item in pairs(barriersFolder:GetChildren()) do
						item:Destroy()
					end
				end
			end
		end)
	else
		toggleBtn.Text = "OFF"
		toggleBtn.TextColor3 = Color3.new(1,0,0)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50,0,0)
		showNotification("Auto Delete Barrier: OFF")
	end
end)

-----------------------------------------------------------------
-- Chuyển tab
-----------------------------------------------------------------
chooseTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = true
	runFrame.Visible = false
	killerFrame.Visible = false
	miscFrame.Visible = false
end)

runTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = false
	runFrame.Visible = true
	killerFrame.Visible = false
	miscFrame.Visible = false
end)

killerTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = false
	runFrame.Visible = false
	killerFrame.Visible = true
	miscFrame.Visible = false
end)

miscTab.MouseButton1Click:Connect(function()
	chooseFrame.Visible = false
	runFrame.Visible = false
	killerFrame.Visible = false
	miscFrame.Visible = true
end)

-----------------------------------------------------------------
-- Version Label
-----------------------------------------------------------------
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0,250,0,20)
version.Position = UDim2.new(0,5,1,-22)
version.BackgroundTransparency = 1
if HOTFIX then
    version.Text = "CUBE_DoD - indevHOTFIX " .. string.format("%.2f", BASE_VERSION + HOTFIX_VERSION)
else
    version.Text = "CUBE_DoD - indev " .. string.format("%.1f", BASE_VERSION)
end
version.Font = Enum.Font.SourceSans
version.TextSize = 14
version.TextColor3 = Color3.fromRGB(120,255,120)
version.Parent = mainFrame

-- Cleanup on respawn
Player.CharacterAdded:Connect(function()
	for _, v in pairs({"DoD_Value1", "DoD_Value2"}) do
		if PlayerGui:FindFirstChild(v) then PlayerGui[v]:Destroy() end
	end
end)

-- Thông báo load thành công
showNotification("CUBE_DoD v" .. BASE_VERSION .. " Loaded!", Color3.fromRGB(100,255,100))
