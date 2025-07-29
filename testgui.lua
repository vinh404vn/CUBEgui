-- Tạo GUI Screen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CUBEgui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Frame nền chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(144, 238, 144) -- xanh lá nhạt
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Label tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "CUBEgui v1.0"
Title.TextColor3 = Color3.fromRGB(144, 238, 144)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Scrolling Frame chứa các nút
local ButtonArea = Instance.new("ScrollingFrame")
ButtonArea.Size = UDim2.new(1, -10, 1, -40)
ButtonArea.Position = UDim2.new(0, 5, 0, 35)
ButtonArea.CanvasSize = UDim2.new(0, 0, 0, 0) -- sẽ được tính sau
ButtonArea.ScrollBarThickness = 8
ButtonArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ButtonArea.BorderSizePixel = 0
ButtonArea.Parent = MainFrame

-- UIListLayout để tự sắp nút
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)
layout.Parent = ButtonArea

-- Tự cập nhật CanvasSize khi thêm nút
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonArea.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Hàm tạo nút
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(144, 238, 144)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = ButtonArea
    button.MouseButton1Click:Connect(callback)
end

-- Các nút 
-- Nút ẩn/hiện GUI
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Hide GUI"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
toggleButton.BorderColor3 = Color3.fromRGB(100, 255, 100)
toggleButton.BorderSizePixel = 1


-- Kéo GUI toàn bộ
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

-- Nút chức năng
local function createButton(name, posY, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = name
	btn.Font = Enum.Font.SourceSans
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.new(0, 0, 0)
	btn.BorderColor3 = Color3.fromRGB(100, 255, 100)
	btn.BorderSizePixel = 1
	btn.MouseButton1Click:Connect(callback)
end

local flying = false
local noclipConn = nil
local flyConn = nil

-- Noclip
createButton("Noclip", 40, function()
	if noclipConn then return end
	noclipConn = RunService.Stepped:Connect(function()
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end)

-- UnNoclip
createButton("UnNoclip", 80, function()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
end)

-- Fly
createButton("Fly", 120, function()
	if flying then return end
	flying = true
	local hrp = char:WaitForChild("HumanoidRootPart")
	local bv = Instance.new("BodyVelocity", hrp)
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
	bv.Name = "FlyForce"

	flyConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * 50
	end)
end)

-- UnFly
createButton("UnFly", 160, function()
	if flying then
		flying = false
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp and hrp:FindFirstChild("FlyForce") then
			hrp.FlyForce:Destroy()
		end
		if flyConn then flyConn:Disconnect() end
	end
end)

-- Nhập tọa độ
local posBox = Instance.new("TextBox", frame)
posBox.Size = UDim2.new(1, -20, 0, 30)
posBox.Position = UDim2.new(0, 10, 0, 200)
posBox.PlaceholderText = "Nhập tọa độ X,Y,Z (vd: 0,10,0)"
posBox.Font = Enum.Font.SourceSans
posBox.TextSize = 16
posBox.TextColor3 = Color3.new(1, 1, 1)
posBox.BackgroundColor3 = Color3.new(0, 0, 0)
posBox.BorderColor3 = Color3.fromRGB(100, 255, 100)
posBox.ClearTextOnFocus = false

-- TPPos
createButton("TP to Pos", 240, function()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and posBox.Text then
		local x, y, z = posBox.Text:match("([^,]+),([^,]+),([^,]+)")
		if x and y and z then
			local vec = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
			hrp.CFrame = CFrame.new(vec)
		end
	end
end)

-- Ghi phiên bản GUI ở góc dưới
local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(1, -105, 1, -25)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "CUBEgui indev"
versionLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
versionLabel.Font = Enum.Font.SourceSansItalic
versionLabel.TextSize = 14
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
-- Bạn có thể thêm bao nhiêu nút cũng được mà không bị tràn