# FFXIV

For Final Fantasy XIV.

This is early in development. Expect things to be missing, change or break, especially after game patches.

## Modules

- `src/plugin`, the Wraith plugin.
- `src/sqpack`, the game's packed files, read by path. It doesn't need Wraith, so other packages can take just this, as the `sqpack` module of this package's `build.zig`.

`zig build test` runs the tests. With `WRAITH_FFXIV_GAME` set to the game's `game` folder, they read its files too.

## Thanks

- [FFXIVClientStructs](https://github.com/aers/FFXIVClientStructs), whose reverse engineered types and signatures are where the plugin's schemas in `schemas/clientstructs` come from. They're made by `tools/ClientStructsSal` with `zig build client-structs`.
- [Lumina](https://github.com/NotAdam/Lumina), whose reading of the game's files `src/sqpack` follows.
- [libdeflate](https://github.com/ebiggers/libdeflate), which unpacks them.
- [Dalamud](https://github.com/goatcorp/Dalamud), for showing the way on a lot of this.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for their licenses.
