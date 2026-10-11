-- Stage 05 in Studio (run with the bridge's run_code in your test place, never a live game).
-- Rebuilds the lantern from Parts straight from 04 Materials/boxes.json, so colours can be tuned under
-- the game's real lighting BEFORE the final mesh is exported/uploaded. Paste boxes.json into Json.
-- Not run for this example (no test place was open); it is the step to do next.
local HttpService = game:GetService("HttpService")

local Json = [==[ PASTE 04 Materials/boxes.json HERE ]==]
local Data = HttpService:JSONDecode(Json)

local function Lantern(At: CFrame)
	local Model = Instance.new("Model")
	Model.Name = "LanternPreview"
	for _, B in Data.Boxes do
		local Part = Instance.new("Part")
		Part.Name = B.Name
		Part.Anchored = true
		Part.Size = Vector3.new(B.Size[1], B.Size[2], B.Size[3])
		Part.CFrame = At * CFrame.new(B.Position[1], B.Position[2], B.Position[3]) * CFrame.Angles(0, math.rad(B.RotY), 0)
		local C = Data.Palette[B.Slot]
		Part.Color = Color3.fromRGB(C[1], C[2], C[3])
		Part.Material = if B.Slot == "Glass" or B.Slot == "Flame" then Enum.Material.Neon
			elseif B.Slot == "Brass" then Enum.Material.Metal
			else Enum.Material.SmoothPlastic
		Part.Parent = Model
		if B.Name == "Body" then
			local Light = Instance.new("PointLight")
			Light.Color = Color3.fromRGB(255, 170, 90)
			Light.Range = 16
			Light.Brightness = 2
			Light.Shadows = true
			Light.Parent = Part
		end
	end
	Model.Parent = workspace
	return Model
end

Lantern(CFrame.new(0, 0.5, -10))
-- tune: recolour Parts live under your Lighting, copy the winning colours back into Palette in
-- build_lantern.py, re-run 04, then export: Blender 04/Lantern.blend --python tools/3d/blender_export_roblox.py -- Lantern
