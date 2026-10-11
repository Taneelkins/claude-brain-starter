-- every remote in the game lives here as a Packet. pick the smallest type that fits:
-- NumberU8 (0-255), NumberU16, NumberU32, NumberF32, Boolean8, String, Vector3F24, Instance, Any...
-- :Response(...) makes it a request the server answers (client calls :Fire() and gets the reply)
local Packet = require(script.Parent.Vendor.Packet)

return {
	ClaimDaily = Packet("ClaimDaily"):Response(Packet.Boolean8, Packet.NumberU32),
}
