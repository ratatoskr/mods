# Unity

For games made with Unity, on Mono or IL2CPP, with the built-in render pipeline, URP or HDRP.

- Camera Tools moves the game's main camera, so the free camera and orbiting work without a plugin for the game.
- Wraith's game speed goes through Unity's time scale, so only gameplay changes and 0 pauses. The game's own pauses and slow motion still work underneath it.
- Posing poses the characters nearest the camera. Each of the scene's Animators is one, with the transforms under it as its bones.
- `findObjectsOfType` for other plugins, like Unity's own, from any thread. Each type's answer is kept for about a second, since asking Unity is slow, and what's been destroyed since is left out.
- Unity's main thread drives Wraith's ticks, so other plugins' `frame.onTick` runs there, where Unity's engine calls and methods work, once a frame as the main camera's about to render. Nothing ticks till the game's C# is running. See `schemas/unity.sal` for the `Unity` service.

Needs Camera Tools and Posing. Games that draw with their own camera rather than Unity's, like Tales of Berseria, need a plugin of their own.
