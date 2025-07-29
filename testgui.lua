-- CUBEgui v1.0 by vinh404 (2-column layout, Fling + F3X)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

-- Nếu đã có GUI thì chặn
if player:FindFirstChild("PlayerGui"):FindFirstChild("CUBEgui") then
	local msg = Instance.new("Message", workspace)
	msg.Text = "gui already here!!"
	task.delay(2, function() msg:Destroy() end)
	return
end

-- Tạo GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CUBEgui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0, 0, 0)
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Text = "CUBEgui v1.0"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Nút ẩn/hiện GUI
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -35, 0, 0)
toggleButton.Text = "-"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.TextSize = 20
toggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
toggleButton.BorderSizePixel = 0

local toggled = true
toggleButton.MouseButton1Click:Connect(function()
	toggled = not toggled
	leftFrame.Visible = toggled
	rightFrame.Visible = toggled
	toggleButton.Text = toggled and "-" or "+"
end)

-- Tạo khung chia 2 cột
local leftFrame = Instance.new("Frame", frame)
leftFrame.Size = UDim2.new(0.5, -15, 1, -60)
leftFrame.Position = UDim2.new(0, 10, 0, 40)
leftFrame.BackgroundTransparency = 1

local rightFrame = Instance.new("Frame", frame)
rightFrame.Size = UDim2.new(0.5, -15, 1, -60)
rightFrame.Position = UDim2.new(0.5, 5, 0, 40)
rightFrame.BackgroundTransparency = 1

local layoutLeft = Instance.new("UIListLayout", leftFrame)
layoutLeft.Padding = UDim.new(0, 5)

local layoutRight = Instance.new("UIListLayout", rightFrame)
layoutRight.Padding = UDim.new(0, 5)

-- Hàm tạo nút
local function createButton(name, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Text = name
	btn.Font = Enum.Font.SourceSans
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.new(0, 0, 0)
	btn.BorderColor3 = Color3.fromRGB(100, 255, 100)
	btn.BorderSizePixel = 1
	btn.MouseButton1Click:Connect(callback)
end

-- Các nút bên trái
createButton("Noclip", leftFrame, function()
	RunService.Stepped:Connect(function()
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid:ChangeState(11)
		end
	end)
end)

createButton("Unnoclip", leftFrame, function()
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid:ChangeState(8)
	end
end)

createButton("Fly", leftFrame, function()
	-- thêm logic bay
end)

createButton("Unfly", leftFrame, function()
	-- thêm logic dừng bay
end)

local tpBox = Instance.new("TextBox", leftFrame)
tpBox.Size = UDim2.new(1, 0, 0, 30)
tpBox.PlaceholderText = "Username"
tpBox.TextColor3 = Color3.fromRGB(0, 255, 0)
tpBox.BackgroundColor3 = Color3.new(0, 0, 0)
tpBox.Text = ""
tpBox.Font = Enum.Font.SourceSans
tpBox.TextSize = 16

createButton("TP to Pos", leftFrame, function()
	local target = Players:FindFirstChild(tpBox.Text)
	if target and target.Character and char then
		char:MoveTo(target.Character:GetPrimaryPartCFrame().p)
	end
end)

-- Các nút bên phải
createButton("Fling", rightFrame, function()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local bv = Instance.new("BodyAngularVelocity")
	bv.AngularVelocity = Vector3.new(99999, 99999, 99999)
	bv.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bv.P = 1250
	bv.Name = "FlingForce"
	bv.Parent = hrp
	task.wait(3)
	bv:Destroy()
end)

createButton("F3X", rightFrame, function()
	local tool = game:GetObjects("rbxassetid://168410621")[1]
	tool.Parent = player.Backpack
end)
