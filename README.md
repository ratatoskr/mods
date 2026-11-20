# Mods

Mods for [Wraith](https://wraith.io) in any language it runs, both plugins and projects are supported. Everything here is published on the [Wraith Hub](https://hub.wraith.io).

## Releasing

A package's version is the one in its `wraith.json`. Bump it and push to `main`.

CI publishes every version the Hub doesn't have yet, and a failed one is tried again on the next push. `0.0.0` never ships. Before building, CI copies the version into the package's `build.zig.zon` and `package.json`, if it has them, commits that, and tags the commit, like `freecam@1.2.0`. That commit is only pushed as the tag, so `main` is never changed, and those files there can lag behind. Leave them be.

## License

AGPL-3.0, see [LICENSE](LICENSE), unless a package has a license of its own.
