# Mods

Mods for [Wraith](https://wraith.io) in any language it runs: TypeScript, JavaScript, Lua, C#, C++, Rust, Zig and C. Both plugins and projects are supported. Everything here is published on the [Wraith Hub](https://hub.wraith.io).

## Want to download?

Get the Wraith app from [wraith.io](https://wraith.io). It installs Wraith, finds your games, and installs mods from the [Hub](https://hub.wraith.io). New to it? [Start here](https://docs.wraith.io/play/).

## Adding one

Start a package with `wraith new` in a folder under `engines/` or `games/<game>/`. What's in the folder says how it builds:

| Has | Language | Built with |
| --- | --- | --- |
| `build.zig` | Zig, or C and C++ with `--build zig` | `zig build` |
| `package.json` | TypeScript and JavaScript | `npm run build`, then `npm run pack` |
| `Cargo.toml` | Rust | `wraith sdk rust build` |
| `CMakeLists.txt` | C and C++ | CMake, for each arch in `wraith.json` |
| a `.csproj` | C# | `dotnet publish` |
| none of these | Lua, or a project | packaged as it is |

Rust, CMake and C# packages make their bindings with the `wraith` CLI: the one `WRAITH` points at, else one on your `PATH`, else the newest release, which CI downloads. `CMAKE` can point at a `cmake` that isn't on your `PATH`, like Visual Studio's. `node scripts/ci.mjs --only games/<game>/<mod>` builds and checks just one.

## Releasing

A package's version is the one in its `wraith.json`. Bump it and push to `main`.

CI publishes every version the Hub doesn't have yet, and a failed one is tried again on the next push. `0.0.0` never ships. Before building, CI copies the version into the package's `build.zig.zon` and `package.json`, if it has them, commits that, and tags the commit, like `unity@1.2.0`. That commit is only pushed as the tag, so `main` is never changed, and those files there can lag behind. Leave them be.

A package that depends on another one here points at it with `devDepends` in its `wraith.json`, like `"devDepends": { "unity": "../../engines/unity/wraith.json" }`, rather than a path in `build.zig.zon`. Releases leave `devDepends` out, release what's depended on first, and won't release a package whose dependency isn't on the Hub or going out with it.

The scripts in `scripts/` check each `wraith.json` against the Hub's schema and package it with the JS tools (`@ratatoskr.io/plugin-tools`), so run `npm ci` here before running them yourself.

## License

AGPL-3.0, see [LICENSE](LICENSE), unless a package has a license of its own.
