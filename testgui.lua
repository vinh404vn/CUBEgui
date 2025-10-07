-- LocalScript trong StarterPlayerScripts hoặc StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
toggleButton.Size = UDim2.new(0, 80, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Hide GUI"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
toggleButton.BorderColor3 = Color3.fromRGB(100, 255, 100)
toggleButton.BorderSizePixel = 1

-- Frame chính (sử dụng ScrollingFrame để có thể trượt lên xuống)
local scrollingFrame = Instance.new("ScrollingFrame", screenGui)
scrollingFrame.Size = UDim2.new(0, 400, 0, 250)
scrollingFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
scrollingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
scrollingFrame.BorderColor3 = Color3.fromRGB(100, 255, 100)
scrollingFrame.BorderSizePixel = 2
scrollingFrame.Active = true
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)  -- Giảm CanvasSize vì bỏ TextBox tốc độ

-- Thanh tiêu đề
local dragBar = Instance.new("TextLabel", screenGui)
dragBar.Size = UDim2.new(0, 400, 0, 25)
dragBar.Position = scrollingFrame.Position + UDim2.new(0, 0, 0, -25)
dragBar.BackgroundColor3 = Color3.new(0, 0, 0)
dragBar.Text = "CUBEgui"
dragBar.TextColor3 = Color3.fromRGB(150, 255, 150)
dragBar.Font = Enum.Font.SourceSansBold
dragBar.TextSize = 16
dragBar.TextXAlignment = Enum.TextXAlignment.Center

-- Kéo GUI toàn bộ
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	scrollingFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	dragBar.Position = scrollingFrame.Position + UDim2.new(0, 0, 0, -25)
end

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = scrollingFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

dragBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

-- Nút chức năng
local function createButton(name, posX, posY, callback)
	local btn = Instance.new("TextButton", scrollingFrame)
	btn.Size = UDim2.new(1, -210, 0, 25)
	btn.Position = UDim2.new(0, posX, 0, posY)
	btn.Text = name
	btn.Font = Enum.Font.SourceSans
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.new(0, 0, 0)
	btn.BorderColor3 = Color3.fromRGB(100, 255, 100)
	btn.BorderSizePixel = 1
	btn.MouseButton1Click:Connect(callback)
end

local flying = false
local noclipConn = nil
local flyConn = nil
local bodyVelocity = nil

-- Fly (giống Infinite Yield, dùng WalkSpeed và hỗ trợ di động)
createButton("Fly", 10, 10, function()
	if flying then return end
	local lp = game.Players.LocalPlayer
	local char = lp.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	flying = true
	hum.PlatformStand = true

	-- Tạo BodyVelocity để điều khiển bay
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = hrp

	-- Điều khiển bay
	flyConn = RunService.RenderStepped:Connect(function()
		if not flying or not hrp or not hum then
			if flyConn then flyConn:Disconnect() end
			if bodyVelocity then bodyVelocity:Destroy() end
			flying = false
			return
		end

		local cam = workspace.CurrentCamera
		local moveDirection = Vector3.new(0, 0, 0)
		local speed = hum.WalkSpeed  -- Lấy WalkSpeed làm tốc độ bay

		-- Xử lý input từ bàn phím
		local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
		local backward = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
		local left = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
		local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
		local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
		local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0

		-- Xử lý input từ joystick (di động)
		local joystickInput = hum.MoveDirection

		-- Kết hợp input từ bàn phím và joystick
		local moveDir = Vector3.new(
			(joystickInput.X + left + right),
			0,
			(joystickInput.Z + forward + backward)
		).Unit

		-- Tính vector di chuyển theo hướng camera
		local camLook = cam.CFrame.LookVector
		local camRight = cam.CFrame.RightVector
		local finalMove = (camLook * moveDir.Z + camRight * moveDir.X) * speed

		-- Thêm chuyển động dọc
		if up ~= 0 or down ~= 0 then
			finalMove = finalMove + Vector3.new(0, (up + down) * speed, 0)
		end

		-- Xử lý input chạm cho di động (bay lên/xuống)
		if UserInputService.TouchEnabled then
			for _, input in pairs(UserInputService:GetConnectedGamepads()) do
				if input == Enum.UserInputType.Touch then
					local touchPos = UserInputService:GetMouseLocation()
					if touchPos.Y < workspace.CurrentCamera.ViewportSize.Y / 2 then
						finalMove = finalMove + Vector3.new(0, speed, 0)  -- Chạm nửa trên: bay lên
					else
						finalMove = finalMove + Vector3.new(0, -speed, 0)  -- Chạm nửa dưới: hạ xuống
					end
				end
			end
		end

		bodyVelocity.Velocity = finalMove
	end)
end)

-- UnFly
createButton("Unfly", 10, 40, function()
	local lp = game.Players.LocalPlayer
	local char = lp.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	flying = false
	if flyConn then
		flyConn:Disconnect()
		flyConn = nil
	end
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	hum.PlatformStand = false
	hrp.Velocity = Vector3.new(0, 0, 0)
end)

-- Noclip
createButton("Noclip", 10, 70, function()
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
createButton("UnNoclip", 10, 100, function()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
end)

-- Nhập tọa độ
local posBox = Instance.new("TextBox", scrollingFrame)
posBox.Size = UDim2.new(1, -210, 0, 25)
posBox.Position = UDim2.new(0, 10, 0, 130)
posBox.PlaceholderText = "Nhập tọa độ X,Y,Z hoặc ng chơi"
posBox.Font = Enum.Font.SourceSans
posBox.TextSize = 14
posBox.TextColor3 = Color3.new(1, 1, 1)
posBox.BackgroundColor3 = Color3.new(0, 0, 0)
posBox.BorderColor3 = Color3.fromRGB(100, 255, 100)
posBox.ClearTextOnFocus = false

-- TPPos
createButton("TP to Pos", 10, 160, function()
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

-- Thêm TextBox cho Animation ID
local animBox = Instance.new("TextBox", scrollingFrame)
animBox.Size = UDim2.new(1, -210, 0, 25)
animBox.Position = UDim2.new(0, 10, 0, 190)
animBox.PlaceholderText = "place your animation id here"
animBox.Font = Enum.Font.SourceSans
animBox.TextSize = 14
animBox.TextColor3 = Color3.new(1, 1, 1)
animBox.BackgroundColor3 = Color3.new(0, 0, 0)
animBox.BorderColor3 = Color3.fromRGB(100, 255, 100)
animBox.ClearTextOnFocus = false

-- Nút Play Animation
createButton("Play Animation", 10, 220, function()
	local animId = animBox.Text
	if animId == "" then return end

	local lp = game.Players.LocalPlayer
	local char = lp.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	if not hum then return end

	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animId

	local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
	local track = animator:LoadAnimation(animation)
	track:Play()
end)

-- Fling
createButton("Fling", 200, 10, function()
	local lp = game.Players.LocalPlayer
	local char = lp.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	-- Tạo BodyVelocity để đẩy nhân vật theo hướng ngẫu nhiên
	local flingVelocity = Instance.new("BodyVelocity")
	flingVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	local randomDir = Vector3.new(
		math.random(-1, 1),
		math.random(0, 1),
		math.random(-1, 1)
	).Unit * 200
	flingVelocity.Velocity = randomDir
	flingVelocity.Name = "FlingForce"
	flingVelocity.Parent = hrp

	-- Tắt va chạm để tránh kẹt
	hum.PlatformStand = true
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end

	-- Dọn dẹp sau 3 giây
	task.spawn(function()
		task.wait(3)
		if flingVelocity then
			flingVelocity:Destroy()
		end
		if hum then
			hum.PlatformStand = false
		end
		if hrp then
			hrp.Velocity = Vector3.new(0, 0, 0)
		end
	end)
end)

-- F3X
createButton("F3X", 200, 40, function()
	local tool = game:GetObjects("rbxassetid://168410621")[1]
	tool.Parent = game.Players.LocalPlayer.Backpack
end)

-- Print Your Avatar
createButton("Print Your Avatar", 200, 70, function()
	local userId = Players.LocalPlayer.UserId
	local avatarURL = ("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png"):format(userId)

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("MeshPart") then
			local hasTexture = false

			-- Kiểm tra nếu đã có Decal/Texture/Image rồi
			for _, child in pairs(obj:GetChildren()) do
				if child:IsA("Decal") or child:IsA("Texture") then
					child.Texture = avatarURL
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

-- SFX
createButton("SFX", 200, 100, function()
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

-- AntiLag
createButton("AntiLag", 200, 130, function()
	local debris = workspace:GetChildren()
	for _, obj in ipairs(debris) do
		if obj:IsA("Part") or obj:IsA("UnionOperation") or obj:IsA("MeshPart") or obj:IsA("Decal") then
			if not obj:IsDescendantOf(game.Players) then
				pcall(function()
					obj:Destroy()
				end)
			end
		end
	end
	print("AntiLag: Cleared unused parts.")
end)

-- Console
createButton("Console", 200, 160, function()
	if game.CoreGui:FindFirstChild("CubeConsole") then return end

	local gui = Instance.new("ScreenGui", game.CoreGui)
	gui.Name = "CubeConsole"

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 250, 0, 180)
	frame.Position = UDim2.new(0.5, -125, 0.5, -90)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Parent = gui
	frame.Active = true
	frame.Draggable = true

	local predict = Instance.new("TextButton", frame)
	predict.Size = UDim2.new(0, 120, 0, 25)
	predict.Position = UDim2.new(0, 10, 1, -65)
	predict.Text = "Predict Next Ammo"
	predict.TextColor3 = Color3.fromRGB(0, 255, 0)
	predict.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	predict.Font = Enum.Font.SourceSansBold
	predict.TextSize = 12

	predict.MouseButton1Click:Connect(function()
		if game.PlaceId ~= 16104162437 then
			output.Text = "Not Buckshot Frenzy"
			return
		end

		local foundVal
		for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if obj:IsA("StringValue") and obj.Name:lower():find("next") and obj.Value ~= "" then
				foundVal = obj.Value
				break
			elseif obj:IsA("IntValue") and obj.Name:lower():find("shell") then
				foundVal = tostring(obj.Value)
				break
			end
		end

		if foundVal then
			output.Text = "Predicted: " .. foundVal
		else
			output.Text = "Cannot detect next ammo type"
		end
	end)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 25)
	title.Text = "CUBE Console"
	title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	title.TextColor3 = Color3.fromRGB(0, 255, 0)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 18

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1, -10, 0, 25)
	box.Position = UDim2.new(0, 5, 0, 35)
	box.PlaceholderText = "print('hello') or math.random()"
	box.TextColor3 = Color3.fromRGB(0, 255, 0)
	box.BackgroundColor3 = Color3.new(0, 0, 0)
	box.Text = ""
	box.Font = Enum.Font.Code
	box.TextSize = 14
	box.ClearTextOnFocus = false

	local output = Instance.new("TextLabel", frame)
	output.Size = UDim2.new(1, -10, 0, 80)
	output.Position = UDim2.new(0, 5, 0, 65)
	output.BackgroundColor3 = Color3.new(0, 0, 0)
	output.TextColor3 = Color3.fromRGB(0, 255, 0)
	output.Font = Enum.Font.Code
	output.TextSize = 12
	output.Text = ""
	output.TextWrapped = true
	output.TextXAlignment = Enum.TextXAlignment.Left
	output.TextYAlignment = Enum.TextYAlignment.Top

	local exec = Instance.new("TextButton", frame)
	exec.Size = UDim2.new(0, 50, 0, 25)
	exec.Position = UDim2.new(1, -60, 1, -30)
	exec.Text = "Run"
	exec.TextColor3 = Color3.fromRGB(0, 255, 0)
	exec.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	exec.Font = Enum.Font.SourceSansBold
	exec.TextSize = 14

	exec.MouseButton1Click:Connect(function()
		local success, result = pcall(function()
			return loadstring(box.Text)()
		end)
		if success then
			output.Text = tostring(result or "Executed.")
		else
			output.Text = "Error: " .. result
		end
	end)
end)

-- Toggle Hiện/Ẩn GUI
toggleButton.MouseButton1Click:Connect(function()
	if scrollingFrame.Visible then
		scrollingFrame.Visible = false
		dragBar.Visible = false
		toggleButton.Text = "Show GUI"
	else
		scrollingFrame.Visible = true
		dragBar.Visible = true
		toggleButton.Text = "Hide GUI"
	end
end)

-- Ghi phiên bản GUI ở góc dưới
local versionLabel = Instance.new("TextLabel", scrollingFrame)
versionLabel.Size = UDim2.new(0, 80, 0, 15)
versionLabel.Position = UDim2.new(1, -85, 0, 370)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "CUBEgui dev0.23"
versionLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
versionLabel.Font = Enum.Font.SourceSansItalic
versionLabel.TextSize = 12
versionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Memories meme
local SoundService = game:GetService("SoundService")
local lp = Players.LocalPlayer

lp.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")

	humanoid.Died:Connect(function()
		local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"

		-- 🛑 Dừng tất cả âm thanh đang chạy
		for _, s in pairs(SoundService:GetDescendants()) do
			if s:IsA("Sound") and s.Playing then
				s:Pause()
			end
		end

		-- 🎵 Phát nhạc sau 1 giây
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://1837474332"
		sound.Volume = 2
		sound.Looped = false
		sound.Parent = workspace
		task.delay(1, function()
			sound:Play()
		end)

		-- 📺 Tạo GUI
		local gui = Instance.new("ScreenGui")
		gui.Name = "ShedletMemes"
		gui.IgnoreGuiInset = true
		gui.ResetOnSpawn = false
		gui.Parent = game:GetService("CoreGui")

		-- Nền đen full màn
		local bg = Instance.new("Frame")
		bg.BackgroundColor3 = Color3.new(0, 0, 0)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Position = UDim2.new(0, 0, 0, 0)
		bg.BorderSizePixel = 0
		bg.Parent = gui

		-- Avatar trái màn hình
		local avatar = Instance.new("ImageLabel")
		avatar.Image = avatarUrl
		avatar.BackgroundTransparency = 1
		avatar.ImageTransparency = 1
		avatar.Size = UDim2.new(0, 200, 0, 200)
		avatar.Position = UDim2.new(0, 60, 0.5, -100)
		avatar.Parent = gui

		-- Hiện dần avatar sau 1 giây
		task.delay(1, function()
			for i = 1, 25 do
				if avatar then
					avatar.ImageTransparency = 1 - (i * 0.03)
					task.wait(0.05)
				end
			end
		end)

		-- ⏱️ Hồi sinh chậm (nếu hỗ trợ)
		if lp:FindFirstChild("RespawnTime") then
			lp.RespawnTime.Value = 8
		end

		-- ❌ Tự huỷ GUI + dừng nhạc khi hồi sinh
		local function cleanup()
			if gui then gui:Destroy() end
			if sound then
				sound:Stop()
				sound:Destroy()
			end
		end

		lp.CharacterAdded:Once(function()
			cleanup()
		end)
	end)
end)
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

UserInputService.InputChanged:Connect(function(input)
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
local bodyVelocity = nil

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
	local lp = game.Players.LocalPlayer
	local char = lp.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	flying = true
	hum.PlatformStand = true

	-- Tạo BodyVelocity để điều khiển bay
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = hrp

	-- Điều khiển bay bằng MoveDirection và phím Space/Shift
	flyConn = RunService.RenderStepped:Connect(function()
		if not flying then return end
		local moveDir = hum.MoveDirection
		local cam = workspace.CurrentCamera
		local camDir = cam.CFrame.LookVector
		local forwardVector = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * 50
		local velocity = Vector3.new(0, 0, 0)

		-- Di chuyển theo hướng camera
		if forwardVector.Magnitude > 0 then
			velocity = velocity + cam.CFrame:VectorToWorldSpace(forwardVector)
		end

		-- Bay lên/xuống bằng phím Space/Shift
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			velocity = velocity + Vector3.new(0, 50, 0)
		elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			velocity = velocity + Vector3.new(0, -50, 0)
		end

		bodyVelocity.Velocity = velocity
	end)
end)

-- UnFly
createButton("Unfly", 10, 160, function()
	local lp = game.Players.LocalPlayer
	local char = lp.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	flying = false
	if flyConn then
		flyConn:Disconnect()
		flyConn = nil
	end
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	hum.PlatformStand = false
	hrp.Velocity = Vector3.new(0, 0, 0)
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

-- F3X
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

			-- Kiểm tra nếu đã có Decal/Texture/Image rồi
			for _, child in pairs(obj:GetChildren()) do
				if child:IsA("Decal") or child:IsA("Texture") then
					child.Texture = avatarURL
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

-- Random SFX
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

-- AntiLag
createButton("AntiLag", 250, 200, function()
	local debris = workspace:GetChildren()
	for _, obj in ipairs(debris) do
		if obj:IsA("Part") or obj:IsA("UnionOperation") or obj:IsA("MeshPart") or obj:IsA("Decal") then
			if not obj:IsDescendantOf(game.Players) then
				pcall(function()
					obj:Destroy()
				end)
			end
		end
	end
	print("AntiLag: Cleared unused parts.")
end)

-- Console
createButton("Console", 250, 240, function()
	if game.CoreGui:FindFirstChild("CubeConsole") then return end

	local gui = Instance.new("ScreenGui", game.CoreGui)
	gui.Name = "CubeConsole"

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 200)
	frame.Position = UDim2.new(0.5, -150, 0.5, -100)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Parent = gui
	frame.Active = true
	frame.Draggable = true

	local predict = Instance.new("TextButton", frame)
	predict.Size = UDim2.new(0, 140, 0, 30)
	predict.Position = UDim2.new(0, 10, 1, -75)
	predict.Text = "Predict Next Ammo"
	predict.TextColor3 = Color3.fromRGB(0, 255, 0)
	predict.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	predict.Font = Enum.Font.SourceSansBold
	predict.TextSize = 14

	predict.MouseButton1Click:Connect(function()
		if game.PlaceId ~= 16104162437 then
			output.Text = "Not Buckshot Frenzy"
			return
		end

		local foundVal
		for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if obj:IsA("StringValue") and obj.Name:lower():find("next") and obj.Value ~= "" then
				foundVal = obj.Value
				break
			elseif obj:IsA("IntValue") and obj.Name:lower():find("shell") then
				foundVal = tostring(obj.Value)
				break
			end
		end

		if foundVal then
			output.Text = "Predicted: " .. foundVal
		else
			output.Text = "Cannot detect next ammo type"
		end
	end)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Text = "CUBE Console"
	title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	title.TextColor3 = Color3.fromRGB(0, 255, 0)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 20

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1, -10, 0, 30)
	box.Position = UDim2.new(0, 5, 0, 40)
	box.PlaceholderText = "print('hello') or math.random()"
	box.TextColor3 = Color3.fromRGB(0, 255, 0)
	box.BackgroundColor3 = Color3.new(0, 0, 0)
	box.Text = ""
	box.Font = Enum.Font.Code
	box.TextSize = 16
	box.ClearTextOnFocus = false

	local output = Instance.new("TextLabel", frame)
	output.Size = UDim2.new(1, -10, 0, 100)
	output.Position = UDim2.new(0, 5, 0, 80)
	output.BackgroundColor3 = Color3.new(0, 0, 0)
	output.TextColor3 = Color3.fromRGB(0, 255, 0)
	output.Font = Enum.Font.Code
	output.TextSize = 14
	output.Text = ""
	output.TextWrapped = true
	output.TextXAlignment = Enum.TextXAlignment.Left
	output.TextYAlignment = Enum.TextYAlignment.Top

	local exec = Instance.new("TextButton", frame)
	exec.Size = UDim2.new(0, 60, 0, 30)
	exec.Position = UDim2.new(1, -70, 1, -35)
	exec.Text = "Run"
	exec.TextColor3 = Color3.fromRGB(0, 255, 0)
	exec.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	exec.Font = Enum.Font.SourceSansBold
	exec.TextSize = 16

	exec.MouseButton1Click:Connect(function()
		local success, result = pcall(function()
			return loadstring(box.Text)()
		end)
		if success then
			output.Text = tostring(result or "Executed.")
		else
			output.Text = "Error: " .. result
		end
	end)
end)

-- Ghi phiên bản GUI ở góc dưới
local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(1, -105, 1, -25)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "CUBEgui dev0.23"
versionLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
versionLabel.Font = Enum.Font.SourceSansItalic
versionLabel.TextSize = 14
versionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Memories meme
local SoundService = game:GetService("SoundService")
local lp = Players.LocalPlayer

lp.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")

	humanoid.Died:Connect(function()
		local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"

		-- 🛑 Dừng tất cả âm thanh đang chạy
		for _, s in pairs(SoundService:GetDescendants()) do
			if s:IsA("Sound") and s.Playing then
				s:Pause()
			end
		end

		-- 🎵 Phát nhạc sau 1 giây
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://1837474332"
		sound.Volume = 2
		sound.Looped = false
		sound.Parent = workspace
		task.delay(1, function()
			sound:Play()
		end)

		-- 📺 Tạo GUI
		local gui = Instance.new("ScreenGui")
		gui.Name = "ShedletMemes"
		gui.IgnoreGuiInset = true
		gui.ResetOnSpawn = false
		gui.Parent = game:GetService("CoreGui")

		-- Nền đen full màn
		local bg = Instance.new("Frame")
		bg.BackgroundColor3 = Color3.new(0, 0, 0)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Position = UDim2.new(0, 0, 0, 0)
		bg.BorderSizePixel = 0
		bg.Parent = gui

		-- Avatar trái màn hình
		local avatar = Instance.new("ImageLabel")
		avatar.Image = avatarUrl
		avatar.BackgroundTransparency = 1
		avatar.ImageTransparency = 1
		avatar.Size = UDim2.new(0, 200, 0, 200)
		avatar.Position = UDim2.new(0, 60, 0.5, -100)
		avatar.Parent = gui

		-- Hiện dần avatar sau 1 giây
		task.delay(1, function()
			for i = 1, 25 do
				if avatar then
					avatar.ImageTransparency = 1 - (i * 0.03)
					task.wait(0.05)
				end
			end
		end)

		-- ⏱️ Hồi sinh chậm (nếu hỗ trợ)
		if lp:FindFirstChild("RespawnTime") then
			lp.RespawnTime.Value = 8
		end

		-- ❌ Tự huỷ GUI + dừng nhạc khi hồi sinh
		local function cleanup()
			if gui then gui:Destroy() end
			if sound then
				sound:Stop()
				sound:Destroy()
			end
		end

		lp.CharacterAdded:Once(function()
			cleanup()
		end)
	end)
end)
