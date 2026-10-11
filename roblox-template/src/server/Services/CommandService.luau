-- Cmdr admin console (F2 in game). default commands + everything in server/Commands
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Cmdr = require(ServerScriptService.ServerPackages.Cmdr)
local Permissions = require(ReplicatedStorage.Shared.Permissions)

Cmdr.Registry:RegisterDefaultCommands()
Cmdr.Registry:RegisterCommandsIn(script.Parent.Parent.Commands)

Cmdr.Registry:RegisterHook("BeforeRun", function(Context)
	if not Permissions.IsAdmin(Context.Executor) then
		return "You don't have permission to run commands."
	end
	return nil
end)

return {}
