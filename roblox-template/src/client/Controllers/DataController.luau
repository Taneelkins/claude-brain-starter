-- read-only view of this player's saved data (the server's DataService replicates it)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replion = require(ReplicatedStorage.Packages.Replion)

local DataController = {}

function DataController.Wait()
	return Replion.Client:WaitReplion("Data")
end

function DataController.Get(Path: string)
	local Data = Replion.Client:GetReplion("Data")
	return Data and Data:Get(Path)
end

-- runs Callback now with the current value and again on every change. returns the connection
function DataController.Observe(Path: string, Callback: (any) -> ())
	local Data = DataController.Wait()
	Callback(Data:Get(Path))
	return Data:OnChange(Path, Callback)
end

return DataController
