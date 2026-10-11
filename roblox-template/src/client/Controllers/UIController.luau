-- owns the one ScreenGui every screen lives in. screens are built at DesignSize (1920x1080)
-- in a centred canvas, and a UIScale fits that canvas to any screen
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Config = require(ReplicatedStorage.Shared.Config)

local Children = Fusion.Children

local UIController = {}

local Scope = Fusion.scoped(Fusion)
local Screens = {}
local Canvas

local function FitScale()
	local Viewport = workspace.CurrentCamera.ViewportSize
	return math.min(Viewport.X / Config.DesignSize.X, Viewport.Y / Config.DesignSize.Y)
end

-- Build(ScreenScope, Canvas) makes the screen's instances with Fusion. returns them (or a list)
function UIController.Mount(Name: string, Build: (any, Frame) -> any)
	UIController.Unmount(Name)
	local ScreenScope = Scope:innerScope()
	Screens[Name] = ScreenScope
	local Made = Build(ScreenScope, Canvas)
	if typeof(Made) == "Instance" then
		Made.Parent = Canvas
	elseif type(Made) == "table" then
		for _, Item in Made do
			Item.Parent = Canvas
		end
	end
end

function UIController.Unmount(Name: string)
	local ScreenScope = Screens[Name]
	if ScreenScope then
		Screens[Name] = nil
		Fusion.doCleanup(ScreenScope)
	end
end

function UIController.GetCanvas()
	return Canvas
end

local Scale = Scope:Value(FitScale())

Canvas = Scope:New("Frame")({
	Name = "Canvas",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(Config.DesignSize.X, Config.DesignSize.Y),
	BackgroundTransparency = 1,

	[Children] = Scope:New("UIScale")({
		Scale = Scale,
	}),
})

Scope:New("ScreenGui")({
	Name = "App",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),

	[Children] = Canvas,
})

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	Scale:set(FitScale())
end)

return UIController
