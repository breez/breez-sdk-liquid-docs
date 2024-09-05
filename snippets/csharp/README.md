## Steps to compile the snippets locally
1. Build a C# package
  - By running the publish-all-platforms CI in the breez-sdk-liquid repository (use dummy binaries)
  - or by downloading from nuget https://www.nuget.org/packages/Breez.Sdk.Liquid
2. Place it in the root folder

From the `snippets/csharp` folder run the following command (replace the version):
```bash
nuget add ../../Breez.Sdk.Liquid.1.0.0.nupkg -Source ./packages
```

Add a package reference to your local nuget package:
```bash
dotnet add package Breez.Sdk.Liquid -s ./packages
```

Happy coding