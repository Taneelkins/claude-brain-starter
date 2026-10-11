local RunService = game:GetService("RunService")

local Config = require(script.Parent.Config)

local Permissions = {}

local Cache = {}

function Permissions.IsAdmin(Player: Player)
	if RunService:IsStudio() then
		return true
	end
	if Cache[Player] ~= nil then
		return Cache[Player]
	end

	local IsAdmin = table.find(Config.Admins, Player.UserId) ~= nil
	if not IsAdmin then
		if game.CreatorType == Enum.CreatorType.User then
			IsAdmin = Player.UserId == game.CreatorId
		else
			local Ok, Rank = pcall(Player.GetRankInGroup, Player, game.CreatorId)
			IsAdmin = Ok and Rank >= Config.AdminRank
		end
	end

	Cache[Player] = IsAdmin
	return IsAdmin
end

return Permissions
