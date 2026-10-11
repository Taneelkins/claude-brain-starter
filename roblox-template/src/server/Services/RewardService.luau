-- example feature: a daily coin reward the client asks for. shows the full loop:
-- packet in, guard checks, data change through the replion, answer back
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Shared.Network)
local DataService = require(script.Parent.DataService)
local Guard = require(script.Parent.Parent.Guard)

local DailyCoins = 100
local DailyWait = 20 * 60 * 60

local RewardService = {}

function RewardService.TimeLeft(Player: Player)
	local Data = DataService.Get(Player)
	if not Data then
		return DailyWait
	end
	return math.max(0, DailyWait - (os.time() - Data:Get("LastDaily")))
end

Network.ClaimDaily.OnServerInvoke = function(Player)
	if not Guard.Cooldown(Player, "ClaimDaily", 1) then
		return false, 0
	end

	local Data = DataService.Get(Player)
	if not Data then
		return false, 0
	end

	if RewardService.TimeLeft(Player) > 0 then
		return false, RewardService.TimeLeft(Player)
	end

	Data:Set("LastDaily", os.time())
	Data:Increase("Coins", DailyCoins)
	return true, 0
end

return RewardService
