local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Janitor = require(ReplicatedStorage.Packages.Janitor)

local Player = Players.LocalPlayer

local WalkSpeed = 16
local SprintSpeed = 24

local CharacterController = {}

local function OnCharacterAdded(Character: Model)
	local CharacterJanitor = Janitor.new()
	local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid

	CharacterJanitor:Add(UserInputService.InputBegan:Connect(function(Input, Processed)
		if not Processed and Input.KeyCode == Enum.KeyCode.LeftShift then
			Humanoid.WalkSpeed = SprintSpeed
		end
	end), "Disconnect")

	CharacterJanitor:Add(UserInputService.InputEnded:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.LeftShift then
			Humanoid.WalkSpeed = WalkSpeed
		end
	end), "Disconnect")

	CharacterJanitor:Add(Humanoid.Died:Connect(function()
		CharacterJanitor:Cleanup()
	end), "Disconnect")

	CharacterJanitor:LinkToInstance(Character)
end

function CharacterController.Start()
	if Player.Character then
		task.spawn(OnCharacterAdded, Player.Character)
	end
	Player.CharacterAdded:Connect(OnCharacterAdded)
end

return CharacterController
