local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Network = require(ReplicatedStorage.Shared.Network)

local Children = Fusion.Children
local Scope = Fusion.scoped(Fusion)
local Coins = Scope:Value(0)

local CoinController = {}

Network.CoinsChanged.OnClientEvent:Connect(function(Amount)
	Coins:set(Amount)
end)

function CoinController.Start()
	Coins:set(Network.GetCoins:Fire())

	Scope:New "ScreenGui" {
		Name = "Coins",
		ResetOnSpawn = false,
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),

		[Children] = Scope:New "TextLabel" {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 24),
			Size = UDim2.fromOffset(220, 40),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			FontFace = Font.fromEnum(Enum.Font.GothamBold),
			Text = Scope:Computed(function(Use)
				return `{Use(Coins)} coins`
			end),
		},
	}
end

return CoinController
