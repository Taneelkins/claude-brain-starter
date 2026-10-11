# 01 Spec: Lanternlight HUD

**What it does:** shows the player's coins at all times and lets them claim a daily reward.
**Owner:** `HudController` (client) + `RewardService` (server), from the base framework.
**Real data:** `Coins` from `DataController.Observe("Coins")`. Claim result from the `ClaimDaily` packet (`claimed, secondsLeft`).

| State | What shows |
|---|---|
| Loading (data not replicated yet) | `0`, button visible (the server answers safely if data isn't ready) |
| Ready to claim | button idle; hover grows it, press shrinks it |
| Just claimed | coins count up, status `+100 coins` |
| On cooldown | status `back in 6h 12m` |

**Constraints:** 1920×1080 canvas (UIController), readable over a bright night scene, fonts Roblox ships, no movement lock.
