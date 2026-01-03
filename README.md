# my_pet_game (Hamster Escape)

A tiny Flutter + Flame top-down hamster game.

## MVP loop

- Move with **WASD** (or arrow keys)
- **Shift** to sprint (uses stamina)
- Collect **food** (goal: 5)
- Avoid **traps**
- Reach the **exit** (only works once you have enough food)

## Run

### Windows

```powershell
flutter run -d windows
```

### Web (Chrome)

```powershell
flutter run -d chrome
```

## Project layout

The game code lives under `lib/`:
- `lib/game/` core game loop/state
- `lib/world/` level layout + bounds
- `lib/entities/` hamster/food/hazards
- `lib/systems/` movement + stamina
- `lib/ui/` Flutter overlays (HUD, pause, win/lose)
