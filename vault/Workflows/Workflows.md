#Workflows

# 🏭 Workflows

> How each type of work gets done, the same way every time. One contract per work type, shared by every project. Back to [[Claude Brain]]

%% Waypoint %%

## How to use (every task)
1. Find the project and the **work type**, then read that workflow. Mixed task = read each type it touches.
2. Load only what its **Inputs** table names. Project notes are the references; workflows never copy them.
3. Follow the steps in order. At every **Checkpoint**, stop and show; don't run past it.
4. Run the **Audit** before showing anything. Fail = fix first. Say which checks passed.

## Two shapes
- **Loop:** iterative engineering. Short contract, checkpoints only for big calls, then an audit.
- **Pipeline:** fixed stages with an approval between each (design work, content, assets). Every stage output is a file you can edit; the next stage reads it.

## Work types
| Work | Shape |
|---|---|
| [[Feature]] | Loop |
| [[Bug Fix]] | Loop |
| [[Roblox Scripting]] | Loop |
| [[UI Screen]] | Pipeline |
| [[3D Asset]] | Pipeline |

Shared by every Roblox workflow: [[Studio Safety]].

Add your own from `_templates/Workflow.md` when a kind of task keeps coming up (VFX, sound, lore, monetization…).

## Outputs
Each task's files (briefs, previews, renders, build scripts) go in the game's `Work/<YYYY-MM-DD> <task>/` folder, outside `src/`. Pipelines add stage folders: `01 Brief/`, `02 Blockout/`…

## Rules
- **Workflows say how; project notes say what.** Point at a project note; never copy its facts.
- Each contract stays under 80 lines. When `/save` catches a repeat mistake, it adds an Audit line here.
