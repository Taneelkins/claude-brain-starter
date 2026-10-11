-- the only server Script. requires every service first so they can wire up to each other,
-- then calls Start() on the ones that have it
local Modules = {}

for _, Module in script.Parent.Services:GetChildren() do
	if Module:IsA("ModuleScript") then
		Modules[Module.Name] = require(Module)
	end
end

for _, Service in Modules do
	if type(Service.Start) == "function" then
		task.spawn(Service.Start)
	end
end
