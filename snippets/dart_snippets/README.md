## Steps to compile the snippets locally
1. Build a flutter package
  - By running the publish-all-platforms CI in the breez-liquid-sdk repository (use dummy binaries)
  - or by cloning https://github.com/breez/breez-liquid-sdk-flutter
2. Place the files in the folder `snippets/dart-snippets/packages/breez-liquid-sdk-flutter`
3. Happy coding

To use a local path to the flutter bindings, see the `dependency_overrides` section in `pubspec.yaml`.

## Nix
Use the command `nix develop`