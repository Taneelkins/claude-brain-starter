-- one place that owns player + character lifetimes. other services listen to these signals
-- and put their cleanup in the janitor they get, so nothing leaks when a player leaves or respawns
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)

local PlayerService = {}
PlayerService.PlayerAdded = Signal.new()
PlayerService.PlayerRemoving = Signal.new()
PlayerService.CharacterAdded = Signal.new()

local PlayerJanitors = {}
local CharacterJanitors = {}

function PlayerService.GetJanitor(Player: Player)
	return PlayerJanitors[Player]
end

function PlayerService.GetCharacterJanitor(Player: Player)
	return CharacterJanitors[Player]
end

local function OnCharacterAdded(Player: Player, Character: Model)
	local Old = CharacterJanitors[Player]
	if Old then
		Old:Destroy()
	end

	local CharacterJanitor = Janitor.new()
	CharacterJanitors[Player] = CharacterJanitor
	CharacterJanitor:LinkToInstance(Character)

	PlayerService.CharacterAdded:Fire(Player, Character, CharacterJanitor)
end

local function OnPlayerAdded(Player: Player)
	if PlayerJanitors[Player] then
		return
	end

	local PlayerJanitor = Janitor.new()
	PlayerJanitors[Player] = PlayerJanitor

	PlayerJanitor:Add(Player.CharacterAdded:Connect(function(Character)
		OnCharacterAdded(Player, Character)
	end), "Disconnect")

	PlayerService.PlayerAdded:Fire(Player, PlayerJanitor)

	if Player.Character then
		OnCharacterAdded(Player, Player.Character)
	end
end

local function OnPlayerRemoving(Player: Player)
	PlayerService.PlayerRemoving:Fire(Player)

	local CharacterJanitor = CharacterJanitors[Player]
	if CharacterJanitor then
		CharacterJanitor:Destroy()
		CharacterJanitors[Player] = nil
	end

	local PlayerJanitor = PlayerJanitors[Player]
	if PlayerJanitor then
		PlayerJanitor:Destroy()
		PlayerJanitors[Player] = nil
	end
end

function PlayerService.Start()
	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoving)

	-- players who joined before this ran (common in studio)
	for _, Player in Players:GetPlayers() do
		task.spawn(OnPlayerAdded, Player)
	end
end

return PlayerService
