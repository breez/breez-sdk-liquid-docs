## Steps to compile the snippets locally
1. Build a Wasm package
  - By running the publish-all-platforms CI in the breez-sdk-liquid repository
2. Download the wasm-{VERSION} artifact 
3. Unzip the artifact and put the `breez-sdk-liquid.tgz` file in the `snippets/wasm/packages` folder
4. Run `yarn` to install the package.
5. Happy coding

The first few steps above can be done on the CLI with

```shell
mkdir packages
cd packages

wget $(npm view @breeztech/breez-sdk-liquid dist.tarball)
tar xvfz *.tgz
cp package/breez-sdk-liquid.tgz ../packages/
rm -rf package
cd ..
```

To use published bindings:
- Replace `"@breeztech/breez-sdk-liquid": "file:./packages/breez-sdk-liquid.tgz"` in `package.json` with
  - `"@breeztech/breez-sdk-liquid": "<package-version>"`
- run `yarn`

## Nix

```
yarn add @breeztech/breez-sdk-liquid

nix develop

yarn
tsc
yarn run lint
```