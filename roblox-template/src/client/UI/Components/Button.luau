-- a button with hover + press feedback. Props: Text, Position, Size, AnchorPoint, OnClick
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Theme = require(script.Parent.Parent.Theme)
local Text = require(script.Parent.Text)

local Children, OnEvent = Fusion.Children, Fusion.OnEvent

return function(Scope, Props)
	local Hovering = Scope:Value(false)
	local Pressing = Scope:Value(false)

	local Grow = Scope:Spring(
		Scope:Computed(function(Use)
			return if Use(Pressing) then 0.95 elseif Use(Hovering) then 1.05 else 1
		end),
		30,
		0.7
	)

	return Scope:New("TextButton")({
		Name = Props.Name or "Button",
		AnchorPoint = Props.AnchorPoint,
		Position = Props.Position,
		Size = Props.Size,
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Colors.Accent,

		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end,
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
			Pressing:set(false)
		end,
		[OnEvent("MouseButton1Down")] = function()
			Pressing:set(true)
		end,
		[OnEvent("MouseButton1Up")] = function()
			Pressing:set(false)
		end,
		[OnEvent("Activated")] = Props.OnClick,

		[Children] = {
			Scope:New("UICorner")({ CornerRadius = UDim.new(0, 12) }),
			Scope:New("UIScale")({ Scale = Grow }),
			Text(Scope, {
				Text = Props.Text,
				Size = UDim2.fromScale(1, 1),
				Font = Theme.Fonts.Title,
				TextSize = 30,
				Color = Theme.Colors.Panel,
				XAlignment = "Center",
			}),
		},
	})
end
