# Kagome dart

A **simple** dart binding to [kagome](https://github.com/ikawaha/kagome).

## Features

This package enables the use of kagome from dart.

platform support:
| Windows | MacOS | Linux | iOS | Android | web |
| :------: | :------: | :------: | :------: | :------: | :------: |
|     ✅  |        |       |        |       |    see https://github.com/CaptainDario/kagome_dart/issues/1    |

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

Open CMakeLists.txt and at the end add

``` CMake
install(
  FILES ${PROJECT_BUILD_DIR}/../blobs/libkagome_win.dll 
  DESTINATION ${INSTALL_BUNDLE_DATA_DIR}/../blobs/
)
```

## Usage

Usage of this package is fairly simpe as it only provides the two top level function `analyze` and `wakati` from kagome.

``` dart

import 'package:kagome_dart/kagome_dart.dart';

import 'package:tuple/tuple.dart';



void main() {

  String input = "日本経済新聞";
  showVersion();

  // important to call before any other methods
  initTokenizer();

  // create spaces in input
  List w = runWakati(input);
  for (var i = 0; i < w.length; i++) {
    print(w[i]);
  }

  // analyze and create spaces
  Tuple2<List<String>, List<String>> t = runAnalyzer(input, analyzeModes.search);
  for (var i = 0; i < t.item1.length; i++) {
    print("${t.item1[i]} \t ${t.item2[i]}");
  }
  
  t = runAnalyzer(input, analyzeModes.normal);
  print(t);

  destroyTokenizer();
}
```

## Compiling kagome yourself
**Note for windows user,** use Msys2 and MinGW to compile the go source to a dynamic library on Windows.

This could be helpful if you want to use a different dictionary.
First you need to clone the kagome repo to have access to the source.

```bash
git clone https://github.com/ikawaha/kagome
```

Then copy the overwrite kagome's `kagome.go` with the `kagome.go` of this repository.

Cross compiling is easily possible with go, by just setting environment variables.
The supported platforms can be seen by calling `go.exe tool dist list`

Now only the environment variables must be set

``` bash
env GOOS=<YOUR SELECTION> GOARCH=<GOARCH>
```

Then build your lib by calling:

``` bash
go build -o libkagome<your_extension> -buildmode=c-shared kagome.go
```

## Additional information

This would obviously not be possible without [kagome](https://github.com/ikawaha/kagome) so please take a look at this project.
If you want to see this package used in a larger project, take a look at [DaKanji](https://github.com/CaptainDario/DaKanji).

NOTE: The character █ is not supported as input.
