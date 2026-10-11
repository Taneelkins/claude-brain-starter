local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.Services.DataService)

return function(_, Player: Player, Amount: number)
	local Data = DataService.Get(Player)
	if not Data then
		return `{Player.Name}'s data isn't loaded yet.`
	end
	Data:Increase("Coins", Amount)
	return `Gave {Player.Name} {Amount} coins (now {Data:Get("Coins")}).`
end
