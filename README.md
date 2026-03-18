# BitBuddyLua

BitBuddy — a simple digital pet game written in Lua using LÖVE (Love2D).

Team Members
- Lucy Weller
- Jacob Dunford
- Kennedy Hooper
- Mikayla Ballowe
- Rhema Ehizele

Project Idea
Users choose a digital pet and manage its Hunger, Happiness, and Energy. Stats slowly
decrease over time; the player can `Feed`, `Play`, or `Sleep` their pet to restore stats.
If any stat reaches 0 the pet becomes Sad and the game ends.

Requirements
- LÖVE (Love2D) 11.3 or newer

Run (development)
Using Love2D from the project folder:

```powershell
love .
```

Controls
- Mouse: click action buttons (Feed / Play / Sleep)
- Keyboard: `1`/`2` choose pet, `R` restart

Files
- `main.lua`: Love2D entrypoint and game loop
- `conf.lua`: Love2D window configuration
- `src/pet.lua`: pet logic
- `assets/`: images and assets (placeholders)

Next steps
- Add artwork to `assets/` and animations
- Initialize git and add tests or packaging (rockspec)
