# att-stubs

Reference assemblies for building A Township Tale mods without the game files.

Every assembly in the game's `Managed` folder and in `MelonLoader/net35` is here, so anything that builds against a game install builds against this repo. They contain no code: every method body is removed, and only public members are kept. Root.Township keeps its private members too, made public, because mods use them.

The folders match a game install, so use this repo as the game directory:

```
dotnet build -p:GameDir=path/to/att-stubs
```

Made from the server build of 0.0.39.2. After a game update, run `./make-stubs.sh <game dir>` and commit the result.

MelonLoader is Apache-2.0. Harmony is MIT. The other third-party assemblies keep their own licenses; only their public API surface is included.
