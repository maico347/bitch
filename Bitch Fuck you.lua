local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local Enabled = false
local CurrentDirection = Vector3.new(1, 0, 0)

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "AutoMoveGUI"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.8, 0)
Frame.Parent = Gui

local OnButton = Instance.new("TextButton")
OnButton.Size = UDim2.new(0.45, 0, 0.5, 0)
OnButton.Position = UDim2.new(0.025, 0, 0.25, 0)
OnButton.Text = "ON"
OnButton.Parent = Frame

local OffButton = Instance.new("TextButton")
OffButton.Size = UDim2.new(0.45, 0, 0.5, 0)
OffButton.Position = UDim2.new(0.525, 0, 0.25, 0)
OffButton.Text = "OFF"
OffButton.Parent = Frame

local function RandomDirection()
	local x = math.random(-100, 100)
	local z = math.random(-100, 100)

	local dir = Vector3.new(x, 0, z)

	if dir.Magnitude < 1 then
		dir = Vector3.new(1, 0, 0)
	end

	return dir.Unit
end

CurrentDirection = RandomDirection()

OnButton.MouseButton1Click:Connect(function()
	Enabled = true
end)

OffButton.MouseButton1Click:Connect(function()
	Enabled = false

	local Character = Player.Character
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid:Move(Vector3.zero)
		end
	end
end)

-- Change direction every minute
task.spawn(function()
	while true do
		task.wait(60)

		if Enabled then
			CurrentDirection = RandomDirection()
		end
	end
end)

-- Jump every 5 minutes
task.spawn(function()
	while true do
		task.wait(300)

		if Enabled then
			local Character = Player.Character
			if Character then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				if Humanoid then
					Humanoid.Jump = true
				end
			end
		end
	end
end)

-- Stuck detector
task.spawn(function()
	while true do
		task.wait(5)

		if Enabled then
			local Character = Player.Character
			local Root = Character and Character:FindFirstChild("HumanoidRootPart")

			if Root then
				local OldPos = Root.Position

				task.wait(2)

				if (Root.Position - OldPos).Magnitude < 2 then
					CurrentDirection = RandomDirection()

					local Humanoid = Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						Humanoid.Jump = true
					end
				end
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not Enabled then
		return
	end

	local Character = Player.Character
	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return
	end

	Humanoid:Move(CurrentDirection, false)
end)