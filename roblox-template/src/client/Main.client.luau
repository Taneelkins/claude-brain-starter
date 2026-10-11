local Modules = {}

for _, Module in script.Parent.Controllers:GetChildren() do
	if Module:IsA("ModuleScript") then
		Modules[Module.Name] = require(Module)
	end
end

for _, Controller in Modules do
	if type(Controller.Start) == "function" then
		task.spawn(Controller.Start)
	end
end
