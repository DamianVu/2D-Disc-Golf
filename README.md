# 2D-Disc-Golf

## Overview
This game was developed by [Damian Vu](https://github.com/DamianVu) and [Andy Kunz](https://github.com/Kunzy83). Initially this project was developed in a 24 hour time period for the [HackKU](http://hackku.org/) 2018 Hackathon. We plan to continue work on this project and make it less of a "hack" and follow better and more efficient standards. [v0.1-alpha](https://github.com/DamianVu/2D-Disc-Golf/releases/tag/v0.1-alpha) is the version we developed for the hackathon. Any following version will contain code/changes implemented after the event. Our project took 2nd place in the hackathon.

## Current Version: [v0.1-alpha](https://github.com/DamianVu/2D-Disc-Golf/releases/tag/v0.1-alpha)
### Summary:
This release marks end of submissions after the HackKU Event that ran from April 20-22. This event was a 24 hour long hackathon that us two Computer Science Undergraduates: Damian Vu and Andrew (Andy) Kunz worked on.

This submission was intended as a "hack" i.e. we have sacrificed some coding conventions and separation of game state into multiple files to save time. In other words, almost all gameplay is handled in the main.lua and the only separation is into different handlers.

### Contributors
- Damian Vu: [Website](damianvu.com "Damian's Website") - [Github](https://github.com/DamianVu "Damian's Github Profile") 
- Andy Kunz: [Github](https://github.com/Kunzy83 "Andy's Github Profile")

### Programming Overview
This game was developed using the open source [LÖVE](https://love2d.org "love2d Webpage") game engine. All development was done in the programming language [Lua](https://www.lua.org/ "Lua Homepage").

### Gameplay Overview
#### Handlers
- Collision Handler: Basic AABB Collision implemented between circular disc object and square obstacles based on height.
- Course Handler: One course implemented. 3 Dummy holes also added for testing purposes. If more are added to the centennial course folder, then they will automatically be used by the game.
- Menu Handler: Basic Menu Framework is in place. Only menu created so far is main menu.
- Round Handler: Keeps track of strokes thrown for each hole and total strokes. Also keeps track of course par by utilizing the Course Handler.
- Scorecard Handler: Generates a scorecard for up to 18 holes using both the round handler and course handler. Currently, this scorecard is only displayed when pausing the game (esc).
#### Gameplay
##### Throws
- Power bar
  - Pressing the space bar stops the power bar.
  - Power can range from a value of 10-100. 10 being the weakest throw and 100 being the strongest.
- Height bar
  - Pressing the space bar stops the height bar.
  - Height can range from an angle of 0 to 80 degrees. 0 indicates a throw going straight from the starting height of 5 ft, and 80 degrees indicates a throw going almost straight upward.
- Point and shoot
  - After power and height have been locked in, you can click to chooses the direction to throw.
