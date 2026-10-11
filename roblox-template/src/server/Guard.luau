-- server-side checks for anything a client sends. clients can send any value, so check everything
local Players = game:GetService("Players")

local Guard = {}

local LastUsed = {}

function Guard.Cooldown(Player: Player, Key: string, Seconds: number)
	local Times = LastUsed[Player]
	if not Times then
		Times = {}
		LastUsed[Player] = Times
	end

	local Now = os.clock()
	if Times[Key] and Now - Times[Key] < Seconds then
		return false
	end

	Times[Key] = Now
	return true
end

function Guard.Number(Value: any, Min: number, Max: number)
	return type(Value) == "number" and Value == Value and Value >= Min and Value <= Max
end

function Guard.Near(Player: Player, Position: Vector3, MaxDistance: number)
	local Character = Player.Character
	local Root = Character and Character:FindFirstChild("HumanoidRootPart")
	if not Root then
		return false
	end
	return (Root.Position - Position).Magnitude <= MaxDistance
end

Players.PlayerRemoving:Connect(function(Player)
	LastUsed[Player] = nil
end)

return Guard
