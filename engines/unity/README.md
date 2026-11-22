# Unity

For games made with Unity, on Mono or IL2CPP, with the built-in render pipeline, URP or HDRP.

- Camera Tools moves the game's main camera, so the free camera and orbiting work without a plugin for the game.
- Posing poses the characters nearest the camera. Each of the scene's Animators is one, with the transforms under it as its bones.
- Other plugins get Unity's main thread, where its engine calls and methods work, through the `Unity` service. Depend on `unity`, then `onFrame` calls you there once a frame. See `schemas/unity.sal`.

Needs Camera Tools and Posing. Games that draw with their own camera rather than Unity's, like Tales of Berseria, need a plugin of their own.
