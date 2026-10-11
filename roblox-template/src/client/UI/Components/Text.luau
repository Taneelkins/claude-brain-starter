-- a Fusion component that draws its text with Text+ (custom fonts, stroke, spacing, alignment).
-- Text can be a plain string or a Fusion state, it re-renders when the state changes
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local TextPlus = require(ReplicatedStorage.Shared.Vendor.TextPlus)

local Theme = require(script.Parent.Parent.Theme)

local peek = Fusion.peek

return function(Scope, Props)
	local Frame = Scope:New("Frame")({
		Name = Props.Name or "Text",
		AnchorPoint = Props.AnchorPoint,
		Position = Props.Position,
		Size = Props.Size,
		BackgroundTransparency = 1,
		Parent = Props.Parent,
	})

	local Options = {
		Font = Props.Font or Theme.Fonts.Body,
		Size = Props.TextSize or 32,
		Color = Props.Color or Theme.Colors.Text,
		XAlignment = Props.XAlignment or "Left",
		YAlignment = Props.YAlignment or "Center",
		StrokeSize = Props.StrokeSize,
		StrokeColor = Props.StrokeSize and Theme.Colors.Stroke or nil,
		CharacterSpacing = Props.CharacterSpacing,
	}

	local Text = Scope:Computed(function(Use)
		return tostring(Use(Props.Text))
	end)

	local function Render()
		TextPlus.Create(Frame, peek(Text), Options)
	end

	Scope:Observer(Text):onBind(Render)

	return Frame
end
