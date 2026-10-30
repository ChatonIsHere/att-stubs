# att-stubs

Reference assemblies for building A Township Tale mods without the game files.

Every assembly in the game's `Managed` folder and in `MelonLoader/net35` is here, so anything that builds against a game install builds against this repo. They contain no code: every method body is removed, and only public members are kept. Root.Township keeps its private members too, made public, because mods use them.

This is the `full` branch, about 22 MB. `main`, the default, has only the assemblies TavernLib, Rover and Canary build against (about 6 MB), which is what CI downloads. In a workflow, pick this one with `ref: full` on the checkout.

The folders match a game install, so use this repo as the game directory:

```
dotnet build -p:GameDir=path/to/att-stubs
```

Made from the server build of 0.0.39.2. After a game update, run `./make-stubs.sh <game dir>` and commit the result.

MelonLoader is Apache-2.0. Harmony is MIT. The other third-party assemblies keep their own licenses; only their public API surface is included.
