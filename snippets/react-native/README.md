## Steps to compile the snippets locally
1. Build a react native package
  - By running the publish-all-platforms CI in the breez-liquid-sdk repository (use dummy binaries)
2. Download the react-native-{VERSION} artifact 
3. Unzip the artifact and put the `sdk-react-native.tgz` file in the `snippets/react-native/packages` folder
4. Run `yarn` to install the package.
5. Happy coding

## Nix

```
yarn add @breeztech/react-native-breez-liquid-sdk

nix develop

yarn
tsc
yarn run lint
```