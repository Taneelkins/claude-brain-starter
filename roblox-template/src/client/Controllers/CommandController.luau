local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Permissions = require(ReplicatedStorage.Shared.Permissions)

local CommandController = {}

function CommandController.Start()
	local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))
	CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
	CmdrClient:SetEnabled(Permissions.IsAdmin(Players.LocalPlayer))
end

return CommandController
