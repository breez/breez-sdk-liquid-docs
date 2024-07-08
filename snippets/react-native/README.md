## Steps to compile the snippets locally
1. Build a react native package
  - By running the publish-all-platforms CI in the breez-liquid-sdk repository (use dummy binaries)
2. Download the react-native-{VERSION} artifact 
3. Unzip the artifact and put the `breez-liquid-sdk-react-native.tgz` file in the `snippets/react-native/packages` folder
4. Run `yarn` to install the package.
5. Happy coding

The first few steps above can be done on the CLI with

```shell
mkdir packages
cd packages

wget $(npm view @breeztech/react-native-breez-liquid-sdk dist.tarball)
tar xvfz *.tgz
cp package/breez-liquid-sdk-react-native.tgz ../packages/
rm -rf package
cd ..
```

To use locally-generated bindings:
- Replace `"@breeztech/react-native-breez-liquid-sdk": "^0.1.2-dev5"` in `package.json` with
  - `"@breeztech/react-native-breez-liquid-sdk": "file:./packages/breez-liquid-sdk-react-native.tgz"`
- run `yarn`

## Nix

```
yarn add @breeztech/react-native-breez-liquid-sdk

nix develop

yarn
tsc
yarn run lint
```