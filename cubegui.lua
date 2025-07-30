-- LocalScript trong StarterPlayerScripts hoặc StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local allowed = true

if game.PlaceId == 126884695634066 then -- Replace với đúng PlaceId của “Grow a Garden”
	allowed = false
	local StarterGui = game:GetService("StarterGui")
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "❌ GUI không được phép ở đây!";
		Color = Color3.new(1, 0, 0);
		Font = Enum.Font.SourceSansBold;
		TextSize = 20;
	})

	-- Ngăn nhân vật di chuyển
	local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = 0
	hum.JumpPower = 0
end

-- Chặn hiển thị GUI nếu bị khóa
if not allowed then return end
-- Kiểm tra nếu GUI đã tồn tại
if player:WaitForChild("PlayerGui"):FindFirstChild("CUBEgui") then
	local msg = Instance.new("TextLabel")
	msg.Text = "gui already here!!"
	msg.Size = UDim2.new(1, 0, 0, 50)
	msg.Position = UDim2.new(0, 0, 0.3, 0)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.fromRGB(255, 0, 0)
	msg.TextStrokeTransparency = 0
	msg.TextStrokeColor3 = Color3.new(0, 0, 0)
	msg.Font = Enum.Font.SourceSansBold
	msg.TextScaled = true
	msg.Parent = player.PlayerGui

	task.delay(3, function()
		if msg then msg:Destroy() end
	end)
	return
end

-- Tạo GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "CUBEgui"
screenGui.ResetOnSpawn = false

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

-- Frame chính
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(100, 255, 100)
frame.BorderSizePixel = 2
frame.Active = true

-- Thanh tiêu đề
local dragBar = Instance.new("TextLabel", frame)
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.new(0, 0, 0)
dragBar.Text = "CUBEgui"
dragBar.TextColor3 = Color3.fromRGB(150, 255, 150)
dragBar.Font = Enum.Font.SourceSansBold
dragBar.TextSize = 18
dragBar.TextXAlignment = Enum.TextXAlignment.Center

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
local function createButton(name, posX, posY, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -260, 0, 30)
	btn.Position = UDim2.new(0, posX, 0, posY)
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
createButton("Noclip", 10, 40, function()
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
createButton("UnNoclip", 10, 80, function()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
end)

-- Fly
createButton("Fly", 10, 120, function()
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
createButton("UnFly", 10, 160, function()
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
posBox.Size = UDim2.new(1, -260, 0, 30)
posBox.Position = UDim2.new(0, 10, 0, 200)
posBox.PlaceholderText = "Nhập tọa độ X,Y,Z hoặc ng chơi"
posBox.Font = Enum.Font.SourceSans
posBox.TextSize = 16
posBox.TextColor3 = Color3.new(1, 1, 1)
posBox.BackgroundColor3 = Color3.new(0, 0, 0)
posBox.BorderColor3 = Color3.fromRGB(100, 255, 100)
posBox.ClearTextOnFocus = false

-- TPPos
createButton("TP to Pos", 10, 240, function()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local text = posBox.Text
	if not hrp or text == "" then return end

	-- Nếu là tọa độ
	local x, y, z = text:match("([^,]+),([^,]+),([^,]+)")
	if x and y and z then
		local vec = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
		hrp.CFrame = CFrame.new(vec)
	else
		-- Nếu là tên người chơi
		local target = game.Players:FindFirstChild(text)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)
-- Fling
createButton("Fling", 250, 40, fling)
local function fling()
	local char = game.Players.LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local bv = Instance.new("BodyAngularVelocity")
	bv.AngularVelocity = Vector3.new(99999, 99999, 99999)
	bv.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bv.P = 1250
	bv.Name = "FlingForce"
	bv.Parent = hrp

	wait(5) -- Fling trong 5 giây
	bv:Destroy()
end

-- Toggle Hiện/Ẩn GUI
toggleButton.MouseButton1Click:Connect(function()
	if frame.Visible then
		frame.Visible = false
		toggleButton.Text = "Show GUI"
	else
		frame.Visible = true
		toggleButton.Text = "Hide GUI"
	end
end)
--f3x
createButton("F3X", 250, 80, function()
	local tool = game:GetObjects("rbxassetid://168410621")[1]
	tool.Parent = game.Players.LocalPlayer.Backpack
end)

-- Print avatar
createButton("Print Your Avatar", 250, 120, function()
	local userId = Players.LocalPlayer.UserId
	local avatarURL = ("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png"):format(userId)

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("MeshPart") then
			local hasTexture = false

			--Kiểm tra nếu đã có Decal/Texture/Image rồi
			for _, child in pairs(obj:GetChildren()) do
			    if child:IsA("Decal") or child:IsA("Texture") then																			child.Texture = avatarURL
																												hasTexture = true
																														end
																																			end

																																						-- Nếu chưa có, tự tạo decal mới cho mỗi mặt
																																									if not hasTexture then
																																													local faces = {
																																																		Enum.NormalId.Front,
																																																							Enum.NormalId.Back,
																																																												Enum.NormalId.Left,
																																																																	Enum.NormalId.Right,
																																																																						Enum.NormalId.Top,
																																																																											Enum.NormalId.Bottom
																																																																															}
																																																																																			for _, face in ipairs(faces) do
																																																																																								local decal = Instance.new("Decal")
																																																																																													decal.Face = face
																																																																																																		decal.Texture = avatarURL
																																																																																																							decal.Parent = obj
																																																																																																											end
																																																																																																														end

																																																																																																																	-- Nếu là MeshPart có TextureID → đổi luôn
																																																																																																																				if obj:IsA("MeshPart") and obj.TextureID ~= "" then
																																																																																																																								obj.TextureID = avatarURL
																																																																																																																											end
																																																																																																																													end
																																																																																																																														end
																																																																																																																														end)

-- random sfx
createButton("SFX", 250, 160, function()
	local sounds = {
			"rbxassetid://12222005",   -- Quack
					"rbxassetid://138186576",  -- LOL
							"rbxassetid://911882310",  -- Vine Boom
									"rbxassetid://6026984224", -- Bruh
											"rbxassetid://911201999",  -- Bwah sound
													"rbxassetid://142295308",  -- Scream
															"rbxassetid://2101148",    -- Glass break
																}
																
																	local soundId = sounds[math.random(1, #sounds)]

																		local sound = Instance.new("Sound", workspace)
																			sound.SoundId = soundId
																				sound.Volume = 3
																					sound:Play()

																						-- Dọn sau khi phát xong
																							sound.Ended:Connect(function()
																									sound:Destroy()
																										end)
																									end)
																																																																																																																							
-- Ghi phiên bản GUI ở góc dưới
local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(1, -105, 1, -25)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "CUBEgui indev v0.6"
versionLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
versionLabel.Font = Enum.Font.SourceSansItalic
versionLabel.TextSize = 14
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
