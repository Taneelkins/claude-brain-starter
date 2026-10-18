#Roblox

# 🎮 Roblox

> Making Roblox games with Claude: the framework every game starts from, the modules, the Studio tools (built-in MCP + upload bridge), the 3D pipeline, and the traps. Back to [[Claude Brain]]

> 🧠 **Claude wiring:** the starter repo is `~/Developer/claude-brain-starter` (template in `roblox-template/`, 3D helpers in `tools/3d/`). Studio bridge at `~/claude-studio-bridge` (health: `curl -s http://127.0.0.1:44755/health`). Blender MCP: slots `blender`…`blender6` ([[Running Many Chats]]); one chat = one slot. New game = `/new-game <name>`.

%% Waypoint %%

## Notes
- [[Roblox Framework]]: how every game is laid out and the rules. Read before adding any system.
- [[Roblox Kit]]: every module in the framework, what it's for, its one rule.
- [[Studio Bridge]]: which Studio tool does what (built-in MCP for read/edit/playtest/screenshots, bridge for uploads and Blender export) and the safety rules.
- [[UI Craft]]: taste rules that separate designed UI from generated UI, and the preview → exact Roblox numbers technique. Read before any UI work.
- [[3D Pipeline]]: models from idea to in-game (Blender MCP, AI generation, Substance, upload). Pairs with the [[3D Asset]] workflow.
- [[Roblox Gotchas]]: traps that already bite everyone once.
- [[Running Many Chats]]: several chats at once: Studio windows, Blender slots, `claude-lock`, guard hooks. Read before running two or more chats.
