#Godot Clicker Game Template
####🎮 A customizable clicker/incremental game template built with Godot 4!

This template provides all the core mechanics needed for a clicker game, including:
- Clicking mechanics with visual feedback
- Upgrade system to increase click power
- Power-ups for permanent boosts
- Auto-clicker with scaling efficiency
- Temporary boosters for massive short-term gains
- Visual progression with shape/level changes

##🚀 Features
###1. Core Clicking Mechanics
- Click the shape to earn points
- Total clicks tracked
- Animated feedback on click

###2. Upgrades
- Increase your click power per level
- Costs scale exponentially
- Visual shape changes per level (30+ included)

###3. Power-Ups
- Permanent +1 click power per level
- Costs increase linearly

###4. Auto-Clicker
- Automatically earns points over time
- Upgrades reduce interval and increase clicks per cycle
- After level 10, efficiency grows exponentially

###5. Booster
- Temporary +500 click power for 10 seconds
- Costs 200 points to activate

###6. Detailed UI
- Displays all stats (points, total clicks, click power)
- Shows upgrade costs and benefits
- Tracks contributions from each system

##🛠️ How to Use
####1. Clone or download this repository.
####2. Open in Godot 4.
####3. Run `main.tscn` to test the game.

###Customization
- Change shapes: Replace images in `res://assets/` or modify the `shapes` array.
- Adjust formulas: Modify cost scaling in `calculate_upgrade_cost()`, `calculate_autoclick_power_from_level`(), etc.
- Add new features: Extend the template with prestige systems, achievements, or new power-ups.

##📊 Game Progression

| System      | Effect per Level           | Cost Scaling               | Max Level |
|-------------|----------------------------|----------------------------|-----------|
| **Upgrade** | Triangular number growth   | `10 × 1.75^(level-1)`      | 30        |
| **Power-Up** | Linear +1 click           | `50 + (10 × level)`        | ∞         |
| **Auto-Click** | Exponential efficiency   | Fibonacci(level+5) × 15    | ∞         |
| **Booster** | 10-second 500% boost      | Flat 200 points            | N/A       |

*Note: All formulas are implemented in `Game.gd`*

##🎨 Assets Used
- Default Godot assets (modify with your own graphics)
- Sample shape progression (replace with custom art)

##📜 License
MIT License - Free to use, modify, and distribute. Attribution appreciated but not required.

##🔗 Links
####[Godot Engine](https://godotengine.org/ "Godot Engine")
####[Report Issues](https://github.com/yourusername/clicker-game-godot/issues "Report Issues")
####[More Godot Templates](https://github.com/topics/godot-template "More Godot Templates")

###🌟 Enjoy building your clicker game!
If you use this template, consider giving it a ⭐ on GitHub! 🚀
