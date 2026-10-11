# Roblox Template

A small, clean starting point for a Roblox game: one server script, one client script, and every system as a module. The rules behind it are in the vault's `Roblox/Roblox Framework.md`.

It ships one working example: players earn a coin every 10 seconds. The coins are saved with ProfileStore, sent with Packet and shown with Fusion. There's also a Shift-to-sprint that cleans up with Janitor. Delete the examples once you've read them.

## Start a new game
1. Install [Rokit](https://github.com/rojo-rbx/rokit) once (see its README).
2. Copy the template and install tools + packages:
   ```bash
   cp -R ~/Developer/claude-brain-starter/roblox-template ~/Developer/my-game
   ```
   ```bash
   cd ~/Developer/my-game && rokit install && wally install
   ```
3. Download `Packet.rbxm` from the [Packet DevForum post](https://devforum.roblox.com/t/packet-networking-library/3573907) into `src/shared/Vendor/` (optional: `TextPlus.rbxm` from [Text+ releases](https://github.com/AlexanderLindholt/TextPlus/releases/latest)).
4. Install the Rojo Studio plugin once:
   ```bash
   rojo plugin install
   ```
5. Run `rojo serve`, open a place in Studio, click **Connect** in the Rojo plugin, and press Play.
6. In Claude Code: `/new-project my-game ~/Developer/my-game`.

## Layout
```
src/
  server/Main.server.luau        the only Script: requires Services, calls Start()
  server/Services/               DataService (ProfileStore), CoinService
  client/Main.client.luau        the only LocalScript: requires Controllers, calls Start()
  client/Controllers/            CoinController (Fusion UI), CharacterController (Janitor)
  shared/Network.luau            every remote, as Packets
  shared/Vendor/                 .rbxm libraries that aren't on Wally
```
