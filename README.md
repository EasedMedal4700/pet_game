# my_pet_game (Hamster Care)

A tiny Flutter + Flame game where you take care of a pet hamster by managing three stats:
- Hunger
- Energy
- Happiness

Stats decay every second. Use the buttons to **Feed / Play / Sleep**, and **tap the hamster** to pet it.

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
- `lib/game/` core game loop + stats
- `lib/entities/` game entities (hamster)
- `lib/ui/` Flutter overlays (HUD, pause, game over)
