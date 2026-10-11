local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.ServerPackages.ProfileStore)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Template = {
	Coins = 0,
}

local Store = ProfileStore.New("PlayerData", Template)
local Profiles = {}

local DataService = {}
DataService.ProfileLoaded = Signal.new()

function DataService.Get(Player: Player)
	local Profile = Profiles[Player]
	return Profile and Profile.Data
end

local function OnPlayerAdded(Player: Player)
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
		Player:Kick("Your data was opened on another server, please rejoin.")
	end)

	if Player.Parent ~= Players then
		Profile:EndSession()
		return
	end

	Profiles[Player] = Profile
	DataService.ProfileLoaded:Fire(Player, Profile.Data)
end

function DataService.Start()
	for _, Player in Players:GetPlayers() do
		task.spawn(OnPlayerAdded, Player)
	end
	Players.PlayerAdded:Connect(OnPlayerAdded)

	Players.PlayerRemoving:Connect(function(Player)
		local Profile = Profiles[Player]
		if Profile then
			Profile:EndSession()
		end
	end)
end

return DataService
