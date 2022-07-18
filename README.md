# Kagome dart

A **simple** dart binding to [kagome](https://github.com/ikawaha/kagome).

## Features

This package enables the use of kagome from dart.

platform support:
| platform | supported |
| -------- | -------- |
| Windows  |    ✅    |
| MacOS    |          |
| Linux    |          |
| iOS      |          |
| Android  |          |

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
Afterwards, copy the kagome binaries from the [release section]() (or build yourself ) to this folder.

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

### Windows

I had to uses Msys2 and MinGW to compile the go source to a `.dll` on windows.

``` bash
go.exe build -o libkagome.dll -buildmode=c-shared kagome.go
```

## Additional information

This would obviously not be possible without [kagome](https://github.com/ikawaha/kagome) so please take a look at this project.
If you want to see this package used in a larger project, take a look at [DaKanji](https://github.com/CaptainDario/DaKanji).
