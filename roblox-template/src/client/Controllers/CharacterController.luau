-- this player's character lifetime. connect to CharacterAdded and put cleanup in the janitor
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Player = Players.LocalPlayer

local CharacterController = {}
CharacterController.CharacterAdded = Signal.new()

local Current

function CharacterController.Get()
	return Player.Character
end

local function OnCharacterAdded(Character: Model)
	if Current then
		Current:Destroy()
	end

	Current = Janitor.new()
	Current:LinkToInstance(Character)

	local Humanoid = Character:WaitForChild("Humanoid", 10)
	if Humanoid then
		Current:Add(Humanoid.Died:Connect(function()
			Current:Cleanup()
		end), "Disconnect")
	end

	CharacterController.CharacterAdded:Fire(Character, Current)
end

function CharacterController.Start()
	Player.CharacterAdded:Connect(OnCharacterAdded)
	if Player.Character then
		OnCharacterAdded(Player.Character)
	end
end

return CharacterController
