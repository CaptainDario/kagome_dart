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

then clone kagome inside of this repo

``` bash
git clone https://github.com/ikawaha/kagome
```

## Usage

Usage of this package is fairly simpe as it only provides the two top level function `analyze` and `wakati` from kagome.

## Compiling kagome yourself

### Windows

I had to uses Msys2 and MinGW to compile the go source to a `.dll` on windows.

``` bash
go.exe build -o libkagome.dll -buildmode=c-shared kagome.go
```

## Additional information

This would obviously not be possible without [kagome](https://github.com/ikawaha/kagome) so please take a look at this project.
If you want to see this package used in a larger project, take a look at [DaKanji](https://github.com/CaptainDario/DaKanji).
