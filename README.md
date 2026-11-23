# Mods

Mods for [Wraith](https://wraith.io) in any language it runs, both plugins and projects are supported. Everything here is published on the [Wraith Hub](https://hub.wraith.io).

## Want to download?

Get the Wraith app from [wraith.io](https://wraith.io). It installs Wraith, finds your games, and installs mods from the [Hub](https://hub.wraith.io). New to it? [Start here](https://docs.wraith.io/play/).

## Releasing

A package's version is the one in its `wraith.json`. Bump it and push to `main`.

CI publishes every version the Hub doesn't have yet, and a failed one is tried again on the next push. `0.0.0` never ships. Before building, CI copies the version into the package's `build.zig.zon` and `package.json`, if it has them, commits that, and tags the commit, like `unity@1.2.0`. That commit is only pushed as the tag, so `main` is never changed, and those files there can lag behind. Leave them be.

A package that depends on another one here points at it with `devDepends` in its `wraith.json`, like `"devDepends": { "unity": "../../engines/unity/wraith.json" }`, rather than a path in `build.zig.zon`. Releases leave `devDepends` out, release what's depended on first, and won't release a package whose dependency isn't on the Hub or going out with it.

## License

AGPL-3.0, see [LICENSE](LICENSE), unless a package has a license of its own.
