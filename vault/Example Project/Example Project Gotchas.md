#ExampleProject

# ⚠️ Example Project Gotchas

> Traps that already bit once, one line each, grouped by area. Back to [[Example Project]]

## Redis
- **Keys without a TTL pile up forever** → always `SET key val EX <seconds>`.

## Build
- **`npm run build` passes but the server crashes on boot** when an env var is missing → `src/config.ts` validates on start; check its error first.
