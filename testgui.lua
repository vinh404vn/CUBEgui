-- LocalScript: đặt trong StarterPlayerScripts hoặc StarterGui nếu bạn muốn chống lại kẻ inject

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Bảo vệ bản thân: nếu script này không được chạy bởi nhà phát triển thì kick luôn
if not game:GetService("RunService"):IsStudio() and not player or player.UserId == 0 then
    -- Trường hợp script bị inject từ bên ngoài
    player:Kick("you are an idiot. You think you can h4ck")
end

-- Hoặc đơn giản hơn: auto kick bất kỳ ai "inject" script này
-- Vì người chơi bình thường sẽ không bao giờ có script này
player:Kick("you are an idiot. You think you can h4ck")