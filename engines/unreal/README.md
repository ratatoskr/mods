# Unreal

For games made with Unreal Engine 4 or 5.

- Finds the engine's names, objects and class layouts as the game starts. It works them out from what every game has, so it doesn't need signatures or offsets for each engine version.
- Wraith's free camera moves the player's camera, cutscenes included, so the free camera and orbiting work without a plugin for the game. It goes in as a camera modifier, which the engine runs after the game's own camera code.
- Posing poses the 32 animated characters nearest the camera, once all their animation's done and before the frame's drawn. Clothes and hair that follow a character's pose follow edits. Things held in a socket, like a weapon in a hand, stay where the animation put them. Skeletons over 512 bones get their first 512.
- Unreal's game thread drives Wraith's ticks, so other plugins' `frame.onTick` runs there, once a frame, where calling into the engine is safe.
- Wraith's game speed goes through the world's time dilation, so only the world changes and the UI carries on. 0 pauses the world the engine's own way. The game's own slow motion still works underneath it.
- Games that ship without a console get one back, opened with the game's console key, usually ` or ~. The Unreal console window, under the plugin's button on the overlay's bar, runs commands too, for games with no console key.
- Asks the game's settings whether HDR's on, now and then, so Wraith's overlay matches the game even when Wraith joined the game late.
- The Workbench gets a Scene panel and a Classes panel. Scene lists the current world's levels and their actors, with attached actors under what they're attached to. Pick one to see its components and properties, read through the engine's reflection, and change numbers, bools, enums and vectors in place. Hide or show actors, orbit the free camera round them, copy them, or call any of their functions that take nothing. Classes lists every class, struct and enum, with their properties' offsets and their functions, and finds a live one of a class for Scene.
- Writes every class and struct, with their properties' offsets and types and their functions, to `%LOCALAPPDATA%\Wraith\dumps\unreal\<game id>.txt`, about 10 seconds after it finds them.
