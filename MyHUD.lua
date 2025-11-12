-- MyHUD.lua (LocalScript under StarterGui > MyHUD)
local gui = script.Parent
local label = gui:WaitForChild("TitleLabel")

-- Thiết lập giao diện
label.Size = UDim2.new(0.4, 0, 0.08, 0)
label.Position = UDim2.new(0.3, 0, 0.02, 0)
label.BackgroundTransparency = 0.4
label.TextSize = 24
label.Text = "🌟 BY NHH GAMING 🌟"
label.TextScaled = false
label.TextWrapped = true

-- Hiệu ứng mờ dần
label.TextTransparency = 1
for i = 1, 0, -0.1 do
	task.wait(0.03)
	if label and label:IsDescendantOf(game) then
		label.TextTransparency = i
	end
end

-- Sau 5 giây đổi màu nhẹ
task.delay(5, function()
	if label and label:IsDescendantOf(game) then
		label.TextColor3 = Color3.fromRGB(255, 255, 100)
	end
end)
