local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packet = require(ReplicatedStorage.Shared.Vendor.Packet)

return {
	CoinsChanged = Packet("CoinsChanged", Packet.NumberU32),
	GetCoins = Packet("GetCoins"):Response(Packet.NumberU32),
}
