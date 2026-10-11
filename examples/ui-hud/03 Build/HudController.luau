-- Direction A "Brass Plaque", rebuilt from tools/ui/measure.mjs output (02 Preview/A Brass Plaque.html).
-- Drop-in replacement for roblox-template/src/client/Controllers/HudController.luau.
-- Every number below is the mock's measured offset in the 1920x1080 canvas.
-- NOTE: built from measurements but not playtested yet: run stage 04 (in-game screenshot vs preview) before shipping.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Network = require(ReplicatedStorage.Shared.Network)

local DataController = require(script.Parent.DataController)
local UIController = require(script.Parent.UIController)

local Text = require(script.Parent.Parent.UI.Components.Text)

local Children, OnEvent = Fusion.Children, Fusion.OnEvent

-- palette comes from the lantern model's own materials (iron, brass, amber glass)
local Iron = Color3.fromRGB(21, 19, 15)
local Brass = Color3.fromRGB(158, 107, 41)
local BrassLight = Color3.fromRGB(214, 164, 90)
local Amber = Color3.fromRGB(255, 217, 154)
local LabelGold = Color3.fromRGB(201, 154, 82)

local Serif = Font.fromName("Merriweather", Enum.FontWeight.Heavy)
local SerifBold = Font.fromName("Merriweather", Enum.FontWeight.Bold)
local Caps = Font.fromName("Oswald", Enum.FontWeight.SemiBold)

local HudController = {}

local function Clock(Seconds: number)
	return string.format("%dh %02dm", Seconds // 3600, Seconds % 3600 // 60)
end

local function Commas(N: number)
	local S = tostring(math.floor(N))
	return (S:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

-- CSS borders sit inside the box (the mock uses border-box); UIStroke sits outside the frame's edge,
-- so each stroked frame is inset by its stroke width to land on the same outer edge as the mock
local function Plate(Scope, Props)
	local Inset = Props.Stroke
	return Scope:New("Frame")({
		Name = Props.Name,
		Position = UDim2.fromOffset(Props.X + Inset, Props.Y + Inset),
		Size = UDim2.fromOffset(Props.W - Inset * 2, Props.H - Inset * 2),
		BackgroundColor3 = Props.Fill,
		[Children] = {
			Scope:New("UICorner")({ CornerRadius = Props.Corner or UDim.new(0, 6) }),
			Scope:New("UIStroke")({ Thickness = Props.Stroke, Color = Props.StrokeColor }),
			Props.Children,
		},
	})
end

function HudController.Start()
	UIController.Mount("Hud", function(Scope)
		local Coins = Scope:Value(0)
		local Status = Scope:Value("")
		local Hovering = Scope:Value(false)
		local Pressing = Scope:Value(false)
		local Claiming = false

		task.spawn(function()
			table.insert(Scope, DataController.Observe("Coins", function(Value)
				Coins:set(Value or 0)
			end))
		end)

		local Grow = Scope:Spring(
			Scope:Computed(function(Use)
				return if Use(Pressing) then 0.96 elseif Use(Hovering) then 1.04 else 1
			end),
			35,
			0.55
		)

		return {
			Plate(Scope, { Name = "Plaque", X = 48, Y = 40, W = 340, H = 104, Fill = Iron, Stroke = 2, StrokeColor = Brass }),

			Text(Scope, {
				Name = "Label", Text = "COINS",
				Position = UDim2.fromOffset(72, 58), Size = UDim2.fromOffset(200, 20),
				Font = Caps, TextSize = 16, Color = LabelGold, CharacterSpacing = 1.35,
			}),

			Text(Scope, {
				Name = "Coins",
				Text = Scope:Computed(function(Use)
					return Commas(Use(Coins))
				end),
				Position = UDim2.fromOffset(70, 78), Size = UDim2.fromOffset(300, 56),
				Font = Serif, TextSize = 46, Color = Amber,
			}),

			Plate(Scope, {
				Name = "CoinIcon", X = 330, Y = 66, W = 34, H = 34, Fill = Color3.fromRGB(224, 160, 58),
				Stroke = 3, StrokeColor = Color3.fromRGB(122, 78, 28), Corner = UDim.new(1, 0),
			}),

			Scope:New("TextButton")({
				Name = "Daily",
				Position = UDim2.fromOffset(48 + 2, 160 + 2),
				Size = UDim2.fromOffset(340 - 4, 64 - 4),
				Text = "",
				AutoButtonColor = false,
				BackgroundColor3 = Scope:Computed(function(Use)
					return if Use(Hovering) then Color3.fromRGB(176, 122, 50) else Brass
				end),

				[OnEvent("MouseEnter")] = function() Hovering:set(true) end,
				[OnEvent("MouseLeave")] = function() Hovering:set(false) Pressing:set(false) end,
				[OnEvent("MouseButton1Down")] = function() Pressing:set(true) end,
				[OnEvent("MouseButton1Up")] = function() Pressing:set(false) end,
				[OnEvent("Activated")] = function()
					if Claiming then
						return
					end
					Claiming = true
					local Claimed, TimeLeft = Network.ClaimDaily:Fire()
					Status:set(if Claimed then "+100 coins" else `back in {Clock(TimeLeft)}`)
					Claiming = false
				end,

				[Children] = {
					Scope:New("UICorner")({ CornerRadius = UDim.new(0, 6) }),
					Scope:New("UIStroke")({ Thickness = 2, Color = BrassLight, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
					Scope:New("UIScale")({ Scale = Grow }),
					Text(Scope, {
						Name = "DailyText", Text = "DAILY REWARD",
						Size = UDim2.fromScale(1, 1),
						Font = Caps, TextSize = 24, Color = Color3.fromRGB(26, 18, 10),
						XAlignment = "Center", CharacterSpacing = 1.3,
					}),
				},
			}),

			Text(Scope, {
				Name = "Status", Text = Status,
				Position = UDim2.fromOffset(52, 238), Size = UDim2.fromOffset(420, 32),
				Font = SerifBold, TextSize = 22, Color = Color3.fromRGB(242, 201, 138),
			}),
		}
	end)
end

return HudController
