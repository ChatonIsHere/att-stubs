# att-stubs

Reference assemblies for building A Township Tale mods without the game files.

They contain no game code: every method body is removed. Root.Township's private members are made public, because mods use them.

The folders match a game install, so use this repo as the game directory:

```
dotnet build -p:GameDir=path/to/att-stubs
```

Made from the server build of 0.0.39.2. After a game update, run `./make-stubs.sh <game dir>` and commit the result.

MelonLoader is Apache-2.0. Harmony is MIT.
