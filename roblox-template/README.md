# Roblox Base Framework

A clean, fully wired starting point for a Roblox game. Everything a real game needs on day one is already set up and talking to each other, so you start on gameplay instead of plumbing.

| Built in | With |
|---|---|
| Player data that saves, can't duplicate, and shows up on the client live | ProfileStore + Replion |
| Fast, typed networking + server-side checks | Packet + `Guard` |
| Player and character lifetimes with automatic cleanup | Janitor (`PlayerService`, `CharacterController`) |
| A UI root that fits every screen, reactive screens, custom-font text | Fusion + Text+ (`UIController`, `UI/Components`) |
| Admin console (F2) with permissions and your own commands | Cmdr (`CommandService`, `server/Commands`) |
| Linting + formatting | Selene + StyLua |

It ships one working example so you can see every piece connected: a **coin counter and a daily reward button** (`RewardService` + `HudController`) plus a `givecoins` admin command. Copy their pattern for your own features, then delete them.

## Start a new game
1. Install [Rokit](https://github.com/rojo-rbx/rokit) once.
2. Copy this folder and run setup (installs Rojo/Wally/Selene/StyLua, the packages, and downloads Packet):
   ```bash
   cp -R ~/Developer/claude-brain-starter/roblox-template ~/Developer/my-game && ~/Developer/my-game/setup.sh
   ```
   Or just ask Claude: `/new-game my-game`.
3. Install the Rojo Studio plugin once: `rojo plugin install`
4. `rojo serve` in the game folder → open a place in Studio → Rojo plugin → **Connect** → Play.
5. Turn on **Game Settings → Security → Enable Studio Access to API Services** if you want data to save in Studio.

## How it's put together
```
src/
  server/
    Main.server.luau          the ONLY Script: requires every Service, then calls Start()
    Guard.luau                Cooldown / Number / Near checks for anything a client sends
    Services/
      PlayerService.luau      PlayerAdded/Removing/CharacterAdded signals + a Janitor per player and per character
      DataService/            ProfileStore save + Replion live copy. Template.luau = every saved field
      CommandService.luau     Cmdr setup + permission hook
      RewardService.luau      example feature (daily reward)
    Commands/                 Cmdr commands: Name.luau (definition) + NameServer.luau (what it does)
  client/
    Main.client.luau          the ONLY LocalScript: requires every Controller, then calls Start()
    Controllers/
      DataController.luau     Get / Observe your own saved data
      UIController.luau       the App ScreenGui, 1920x1080 canvas scaled to fit, Mount/Unmount screens
      CharacterController.luau  CharacterAdded signal + a Janitor per character
      CommandController.luau  F2 console for admins
      HudController.luau      example screen
    UI/
      Theme.luau              colours + fonts in one place
      Components/             Text (Text+ in Fusion), Button (hover/press springs)
  shared/
    Config.luau               admins, admin rank, design size
    Permissions.luau          IsAdmin (always true in Studio)
    Network.luau              every remote, as Packets
    Vendor/                   Text+ (with a UIScale fix) and Packet
```

### The rules (the whole framework in seven lines)
1. **One Script, one LocalScript.** A new system is a new module in `Services/` or `Controllers/`.
2. **Top of a module = wiring** (requires, connecting signals and packets). **`Start()` = doing** (loops, building UI). So every module can connect to every other one before anything runs.
3. **Every remote is a Packet in `Network.luau`.** The server checks every value with `Guard`.
4. **Data changes only through the Replion** (`Data:Set`, `Data:Increase`, `Data:Update`) from `DataService.Get(Player)`. Never touch the profile directly.
5. **Anything with a lifetime gets a Janitor** (per player, per character, per screen scope).
6. **UI is built at 1920×1080 inside `UIController`'s canvas**, colours and fonts from `Theme`.
7. **Code lives on disk.** Rojo overwrites script edits made inside Studio.

### Adding a feature (the pattern to copy)
- Server: new `Services/ThingService.luau`. Add its packets to `Network.luau`, its saved fields to `DataService/Template.luau`.
- Client: new `Controllers/ThingController.luau`. Read data with `DataController.Observe`, draw UI with `UIController.Mount`.
- Admin/debug: add `Commands/thing.luau` + `Commands/thingServer.luau`.
