-- example screen: live coin counter + a daily reward button. delete or reshape it for your game
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Shared.Network)

local DataController = require(script.Parent.DataController)
local UIController = require(script.Parent.UIController)

local Theme = require(script.Parent.Parent.UI.Theme)
local Text = require(script.Parent.Parent.UI.Components.Text)
local Button = require(script.Parent.Parent.UI.Components.Button)

local HudController = {}

local function Clock(Seconds: number)
	return string.format("%dh %02dm", Seconds // 3600, Seconds % 3600 // 60)
end

function HudController.Start()
	UIController.Mount("Hud", function(Scope)
		local Coins = Scope:Value(0)
		local Status = Scope:Value("")

		task.spawn(function()
			table.insert(Scope, DataController.Observe("Coins", function(Value)
				Coins:set(Value or 0)
			end))
		end)

		local Claiming = false

		return {
			Text(Scope, {
				Name = "Coins",
				Text = Scope:Computed(function(Use)
					return `{Use(Coins)} COINS`
				end),
				Position = UDim2.fromOffset(48, 40),
				Size = UDim2.fromOffset(500, 60),
				Font = Theme.Fonts.Title,
				TextSize = 48,
				Color = Theme.Colors.Accent,
				StrokeSize = 4,
			}),

			Button(Scope, {
				Name = "Daily",
				Text = "DAILY REWARD",
				Position = UDim2.fromOffset(48, 112),
				Size = UDim2.fromOffset(300, 64),
				OnClick = function()
					if Claiming then
						return
					end
					Claiming = true
					local Claimed, TimeLeft = Network.ClaimDaily:Fire()
					Status:set(if Claimed then "+100 coins!" else `come back in {Clock(TimeLeft)}`)
					Claiming = false
				end,
			}),

			Text(Scope, {
				Name = "Status",
				Text = Status,
				Position = UDim2.fromOffset(48, 188),
				Size = UDim2.fromOffset(500, 40),
				TextSize = 26,
				Color = Theme.Colors.Muted,
			}),
		}
	end)
end

return HudController
