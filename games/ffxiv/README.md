# FFXIV

For Final Fantasy XIV.

This is early in development. Expect things to be missing, change or break, especially after game patches.

## Modules

- `src/plugin`, the Wraith plugin. It adds an FFXIV tab to the Workbench, with Sheets in it to look through every sheet's rows.
- `src/sqpack`, the game's packed files, read by path. It doesn't need Wraith, so other packages can take just this, as the `sqpack` module of this package's `build.zig`.
- `src/excel`, the game's Excel sheets read raw, with columns by index. It only needs `sqpack`, and is the `excel` module.
- `src/sheets`, a typed struct per sheet, with a function per column, made from [EXDSchema](https://github.com/xivdev/EXDSchema) by `tools/excel-sheets` with `zig build excel-sheets`. It's the `sheets` module. Don't edit it, as the next run replaces it. Bump EXDSchema's commit in `build.zig.zon` for newer schemas. Opening one checks the game's columns are still the ones it was made for, and fails with `error.SheetChanged` if not. Each has its `column_names` too, in the header's order, and `namedFor` finds them by sheet name.

`zig build test` runs the tests. With `WRAITH_FFXIV_GAME` set to the game's `game` folder, they read its files too.

## Thanks

- [FFXIVClientStructs](https://github.com/aers/FFXIVClientStructs), whose reverse engineered types and signatures are where the plugin's schemas in `schemas/clientstructs` come from. They're made by `tools/ClientStructsSal` with `zig build client-structs`.
- [Lumina](https://github.com/NotAdam/Lumina), whose reading of the game's files `src/sqpack` follows.
- [libdeflate](https://github.com/ebiggers/libdeflate), which unpacks them.
- [EXDSchema](https://github.com/xivdev/EXDSchema), whose schemas the typed sheets in `src/sheets` are made from.
- [Dalamud](https://github.com/goatcorp/Dalamud), for showing the way on a lot of this.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for their licenses.
