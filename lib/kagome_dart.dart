import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
import 'dart:ffi' as ffi; // For FFI
import 'dart:ffi';



// Definitions to print kagome version
typedef ShowVersion = void Function();
typedef ShowVersionFunc = Void Function();

// Definitions to initialize the tokenizer
typedef InitTokenizer = void Function();
typedef InitTokenizerFunc = Void Function();

// Definitions to initialize the tokenizer
typedef DestroyTokenizer = void Function();
typedef DestroyTokenizerFunc = Void Function();

// Definitions for running wakati
typedef RunWakati = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>); // Dart fn signature
typedef RunWakatiFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>); // FFI fn signature

// Definitions for running analyze
typedef RunAnalyzer =
  ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>); // Dart fn signature
typedef RunAnalyzerFunc =
  ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>); // FFI fn signature

// enums
enum AnalyzeModes {
  normal, search, extended
}



class Kagome {

  // Load Kagome's dynamic library 
  late final DynamicLibrary _lib;

  // Print the 
  late final ShowVersion showVersion;
    
  /// Initializes the tokenizer, needs to be called before `wakati` or `analyze`
  /// 
  /// IMPORTANT: do not forget to destroy it at some point
  late final InitTokenizer initTokenizer;

  /// Destroy the tokenizer and free its memory
  late final DestroyTokenizer destroyTokenizer;

  late final RunWakati _runWakati;

  late final RunAnalyzer _runAnalyzer;


  Kagome(){
    // load the dynamic library matching the current platform
    loadDynamicLibrary();

    showVersion = _lib.lookup<NativeFunction<ShowVersionFunc>>('ShowVersion').asFunction();

    initTokenizer = _lib.lookup<NativeFunction<InitTokenizerFunc>>('InitTokenizer').asFunction();
    
    destroyTokenizer = _lib.lookup<NativeFunction<DestroyTokenizerFunc>>('DestroyTokenizer').asFunction();

    _runAnalyzer = _lib.lookup<ffi.NativeFunction<RunAnalyzerFunc>>('RunAnalyzer').asFunction();

    _runWakati = _lib.lookup<ffi.NativeFunction<RunWakatiFunc>>('RunWakati').asFunction();

    initTokenizer();
  }

  /// Loads the kagome C-Lib matching the current platform
  void loadDynamicLibrary(){
    debugPrint(Directory(Platform.resolvedExecutable).path);

    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libkagome_droid.so');
    }
    else if (Platform.isIOS) {
      _lib = DynamicLibrary.process();
    }
    else if (Platform.isMacOS) {

      _lib = DynamicLibrary.open(
        "${Directory(Platform.resolvedExecutable).parent.path}/blobs/libkagome_mac.dylib"
      );
    }
    else if (Platform.isLinux) {
      _lib = DynamicLibrary.open(
        "${Directory(Platform.resolvedExecutable).parent.path}/blobs/libkagome_lin.so"
      );
    }
    else if (Platform.isWindows) {
      _lib = DynamicLibrary.open(
        "${Directory(Platform.resolvedExecutable).parent.path}/blobs/libkagome_win.dll"
      );
    }
    else {
      throw UnsupportedError('Unsupported platform!');
    }
  }

  /// Function to remove all instances of █ in the input string as it is used
  /// as delimiter
  String _sanitizeInput(String input){
    if(input.contains("█")){
      debugPrint("█ is not allowed in the input string");
    }

    return input.replaceAll("█", " ");
  }

  /// Wakati tokenizes the given `inputText` and returns its divided surface strings.
  List<String> runWakati(String inputText) {
    inputText = _sanitizeInput(inputText);
    String out = _runWakati(inputText.toNativeUtf8()).toDartString();
    return out.split("█");
  }

  /// Runs kagome's analyzer on the given `inpuText` and returns the result
  /// 
  /// Note: █ is not allowed as an input and will be removed from the input
  Tuple2<List<String>, List<List<String>>>
    runAnalyzer(String inputText, AnalyzeModes mode) {

    inputText = _sanitizeInput(inputText);

    String analyzerOut = _runAnalyzer(
      inputText.toNativeUtf8(),
      mode.toString().split('.').last.toNativeUtf8()
    ).toDartString();

    var s = analyzerOut.split("███");
    var s_1 = s[1].split("██");

    var ret = Tuple2(
      s[0].split("██"),
      List.generate(s_1.length,
        (index) => s_1[index].split("█")
      )
    );

    return ret;
  }
}



