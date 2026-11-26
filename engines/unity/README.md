# Unity

For games made with Unity, on Mono or IL2CPP, with the built-in render pipeline, URP or HDRP.

- Wraith's free camera moves whichever camera's on screen, so the free camera and orbiting work without a plugin for the game. Every camera's listed in Photo mode's Camera panel with the one on screen marked. With Follow selection ticked, the selected one's drawn instead. Add one where the view is, which stays where you put it, or rename one. Unloading puts the game's cameras back as they were and takes away the added ones.
- Wraith's game speed goes through Unity's time scale, so only gameplay changes and 0 pauses. The game's own pauses and slow motion still work underneath it.
- Posing poses the characters nearest the camera. Anything with a skinned mesh is one, with the mesh's bones as its skeleton, and meshes sharing a skeleton, like a body and its hair, are one character named after its model. Its meshes' blend shapes, like a face's blinks and smiles, go to posing too, on Unity 2019 to 2022.
- `findObjectsOfType` for other plugins, like Unity's own, from any thread. Each type's answer is kept for about a second, since asking Unity is slow, and what's been destroyed since is left out.
- Unity's main thread drives Wraith's ticks, so other plugins' `threads.onTick` runs there, where Unity's engine calls and methods work, once a frame as the main camera's about to render. Nothing ticks till the game's C# is running. See `schemas/unity.sal` for the `Unity` service.
- A Scene panel in the Workbench, next to Classes: every GameObject as a tree, and the picked one's Transform and components with their fields, which can be changed, with a gizmo on it in the game. It only asks Unity anything while it's open, a slice of the tree a frame.
- Sets Wraith's view of the game each frame, once the free camera has moved it, for posing and anything else drawing over the world.

Games that draw with their own camera rather than Unity's, like Tales of Berseria, need a plugin of their own.
