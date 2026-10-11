local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataService = require(script.Parent.DataService)
local Network = require(ReplicatedStorage.Shared.Network)

local CoinService = {}

function CoinService.Add(Player: Player, Amount: number)
	local Data = DataService.Get(Player)
	if not Data then
		return
	end
	Data.Coins += Amount
	Network.CoinsChanged:FireClient(Player, Data.Coins)
end

Network.GetCoins.OnServerInvoke = function(Player)
	local Data = DataService.Get(Player)
	return if Data then Data.Coins else 0
end

DataService.ProfileLoaded:Connect(function(Player, Data)
	Network.CoinsChanged:FireClient(Player, Data.Coins)
end)

function CoinService.Start()
	while true do
		task.wait(10)
		for _, Player in Players:GetPlayers() do
			CoinService.Add(Player, 1)
		end
	end
end

return CoinService
