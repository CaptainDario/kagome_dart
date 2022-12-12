# Kagome dart

A **simple** dart binding to [kagome](https://github.com/ikawaha/kagome).

## Features

This package enables the use of kagome from dart.

platform support:
| Windows | MacOS | Linux | iOS | Android | web |
| :------: | :------: | :------: | :------: | :------: | :------: |
|     ✅  |    ✅   |       |    ✅   |   ✅   |    see [#1](https://github.com/CaptainDario/kagome_dart/issues/1)    |

## Getting started

First clone this repo

``` bash
git clone https://github.com/CaptainDario/kagome_dart
```

and add it to your `pubspec.yaml`

``` yaml
...

dependencies:
  kagome_dart: 1.0.0
```

now create a `blobs`-folder at the root of your project.
Afterwards, copy the kagome binaries from the [release section](https://github.com/CaptainDario/kagome_dart/releases/tag/binaries) (or [build yourself](#compiling-kagome-yourself)) to this folder.

Now the framework needs to know to include the libraries while build for that some additional configuartion for each platform is requried.

### Windows

Open CMakeLists.txt and at the end, add

``` CMake
install(
  FILES ${PROJECT_BUILD_DIR}/../blobs/libkagome_win.dll 
  DESTINATION ${INSTALL_BUNDLE_DATA_DIR}/../blobs/
)
```

### Linux

TODO

### MacOS

Add the MacOS .dylib to your xcode-project as a bundle resource:

Runner -> Build Phases -> Copy Bundle Resources

### Android

Copy and rename the android libraries to the matching folder in `android/app/src/main/jniLibs`

`libkagome_droid_386.so` -> `x86/libkagome_droid.so`,

`libkagome_droid_amd64.so` -> `x86_64/libkagome_droid.so`,

`libkagome_droid_arm.so` -> `armeabi-v7a/libkagome_droid.so`,

`libkagome_droid_arm64.so` -> `arm64-v8a/libkagome_droid.so`

### iOS

The setup for iOS is a bit more involved and follows the steps detailed [in this SO thread](https://stackoverflow.com/questions/69214595/how-to-manually-add-a-xcframework-to-a-flutter-ios-plugin)

TODO: add instructions from SO here

## Usage

Usage of this package is fairly simpe as it only provides the two top level function `analyze` and `wakati` from kagome.

``` dart
import 'package:flutter/cupertino.dart';
import 'package:kagome_dart/kagome_dart.dart';

import 'package:tuple/tuple.dart';



void main() {

  String input = "日本経済新聞";
  Kagome kagome = Kagome();
  kagome.showVersion();

  // important to call before any other methods
  kagome.initTokenizer();

  // create spaces in input
  List w = kagome.runWakati(input);
  for (var i = 0; i < w.length; i++) {
    debugPrint(w[i]);
  }

  // analyze and create spaces
  Tuple2<List<String>, List<List<String>>> t = 
    kagome.runAnalyzer(input, AnalyzeModes.search);
  for (var i = 0; i < t.item1.length; i++) {
    debugPrint("${t.item1[i]} \t ${t.item2[i]}");
  }
  
  t = kagome.runAnalyzer(input, AnalyzeModes.normal);
  debugPrint(t.toString());

  kagome.destroyTokenizer();
}
```

## Compiling kagome yourself

This could be helpful if you want to use a different dictionary.
First you need to clone the kagome repo to have access to the source (inside the repo of kagome_dart).

```bash
git clone https://github.com/ikawaha/kagome
```

Then copy and overwrite kagome's `kagome.go` with the `kagome.go` of this repository.

(Cross) Compiling to C is possible with cgo, by setting some environment variables.
The supported platforms can be seen by calling `go.exe tool dist list`

### Compile for Windows

**Note:** I only had success building on Windows using Msys2 and MinGW.

First setup the environment

``` bash
make windows
```

### Compile for MacOS

``` bash
make mac
```

### Compile for Linux

``` bash
make linux
```

### Compile for android

For android an Android NDK install is necessary.

``` bash
# path to your android NDK for cross compilation
export NDK=<PATH-TO-NDK>
```

With this kagome can be build by calling

``` bash
make android
```

## Additional information

This would obviously not be possible without [kagome](https://github.com/ikawaha/kagome) so please take a look at this project.
If you want to see this package used in a larger project, take a look at [DaKanji](https://github.com/CaptainDario/DaKanji).
Also thanks to [Roger Chapman for his guide](https://rogchap.com/2020/09/14/running-go-code-on-ios-and-android/) on how to cross compile for android and iOS.

NOTE: The character █ is not supported as input.
