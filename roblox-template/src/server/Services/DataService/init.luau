-- saves player data with ProfileStore and mirrors it to that player's client with Replion.
-- change data ONLY through the replion (Data:Set / Data:Increase / Data:Update), never the profile,
-- so the client and the save always agree
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.ServerPackages.ProfileStore)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local PlayerService = require(script.Parent.PlayerService)
local Template = require(script.Template)

local Store = ProfileStore.New("PlayerData", Template)

local Profiles = {}
local Replions = {}

local DataService = {}
DataService.Loaded = Signal.new()

function DataService.Get(Player: Player)
	return Replions[Player]
end

-- yields until this player's data is ready (nil if they leave or it takes over 30s)
function DataService.Wait(Player: Player)
	local Started = os.clock()
	while not Replions[Player] and Player.Parent == Players and os.clock() - Started < 30 do
		task.wait(0.1)
	end
	return Replions[Player]
end

PlayerService.PlayerAdded:Connect(function(Player)
	local Profile = Store:StartSessionAsync(`Player_{Player.UserId}`, {
		Cancel = function()
			return Player.Parent ~= Players
		end,
	})

	if Profile == nil then
		Player:Kick("Couldn't load your data, please rejoin.")
		return
	end

	Profile:AddUserId(Player.UserId)
	Profile:Reconcile()

	Profile.OnSessionEnd:Connect(function()
		Profiles[Player] = nil
		Replions[Player] = nil
		Player:Kick("Your data was opened on another server, please rejoin.")
	end)

	if Player.Parent ~= Players then
		Profile:EndSession()
		return
	end

	local Data = Replion.Server.new({
		Channel = "Data",
		ReplicateTo = Player,
		Data = Profile.Data,
	})

	-- replion swaps in a new table on every change, so keep the profile pointing at the latest one
	Data:OnDataChange(function(NewData)
		Profile.Data = NewData
	end)

	Profiles[Player] = Profile
	Replions[Player] = Data
	DataService.Loaded:Fire(Player, Data)
end)

PlayerService.PlayerRemoving:Connect(function(Player)
	local Profile = Profiles[Player]
	if Profile then
		Profile:EndSession()
	end
end)

return DataService
