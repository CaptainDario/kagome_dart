import 'dart:io';

import 'package:tuple/tuple.dart';
import 'dart:ffi' as ffi; // For FFI
import 'dart:ffi';
import 'package:ffi/src/utf8.dart';


// Load dynamic library 
final DynamicLibrary kagomeDartLib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libkagome_droid.so');
  }
  else if (Platform.isIOS) {
    return DynamicLibrary.process();
  }
  else if (Platform.isMacOS) {

    return DynamicLibrary.open(
      "${Directory(Platform.resolvedExecutable).parent.path}/blobs/libkagome_mac.dylib"
    );
  }
  else if (Platform.isLinux) {
    return DynamicLibrary.open(
      "${Directory(Platform.resolvedExecutable).parent.path}/blobs/libkagome_lin.so"
    );
  }
  else if (Platform.isWindows) {
    return DynamicLibrary.open(
      "${Directory(Platform.resolvedExecutable).parent.path}/blobs/libkagome_win.dll"
    );
  }
  else {
    throw UnsupportedError('Unsupported platform!');
  }
}();
DynamicLibrary _lib = DynamicLibrary.open('blobs/libkagome.dll');

// enums
enum AnalyzeModes {
  normal, search, extended
} 

/// Function to remove all instances of █ in the input string as it is used
/// as delimiter
String _sanitizeInput(String input){
  if(input.contains("█")){
    print("█ is not allowed in the input string");
  }

  return input.replaceAll("█", " ");
}

// Definitions to print kagome version
typedef ShowVersion = void Function();
typedef ShowVersion_func = Void Function();
final ShowVersion showVersion =
  _lib.lookup<NativeFunction<ShowVersion_func>>('ShowVersion').asFunction();

// Definitions to initialize the tokenizer
typedef InitTokenizer = void Function();
typedef InitTokenizer_func = Void Function();
/// Initializes the tokenizer, needs to be called before `wakati` or `analyze`
/// 
/// IMPORTANT: do not forget to destroy it at some point
final InitTokenizer initTokenizer =
  _lib.lookup<NativeFunction<InitTokenizer_func>>('InitTokenizer').asFunction();

// Definitions to initialize the tokenizer
typedef DestroyTokenizer = void Function();
typedef DestroyTokenizer_func = Void Function();
/// Destroy the tokenizer and free its memory
final DestroyTokenizer destroyTokenizer =
  _lib.lookup<NativeFunction<DestroyTokenizer_func>>('DestroyTokenizer').asFunction();

// Definitions for running wakati
typedef RunWakati = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>); // Dart fn signature
typedef RunWakati_func = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>); // FFI fn signature
final RunWakati _runWakati =
    _lib.lookup<ffi.NativeFunction<RunWakati_func>>('RunWakati').asFunction();
/// Wakati tokenizes the given `inputText` and returns its divided surface strings.
List<String> runWakati(String inputText) {
  inputText = _sanitizeInput(inputText);
  String out = _runWakati(inputText.toNativeUtf8()).toDartString();
  return out.split("█");
}

// Definitions for running analyze
typedef RunAnalyzer =
  ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>); // Dart fn signature
typedef RunAnalyzer_func =
  ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>); // FFI fn signature
final RunAnalyzer _runAnalyzer =
  _lib.lookup<ffi.NativeFunction<RunAnalyzer_func>>('RunAnalyzer').asFunction();
/// Runs kagome's analyzer on the given `inpuText` and returns the result
Tuple2<List<String>, List<String>> runAnalyzer(String inputText, AnalyzeModes mode) {

  inputText = _sanitizeInput(inputText);

  String analyzerOut = _runAnalyzer(
    inputText.toNativeUtf8(),
    mode.toString().split('.').last.toNativeUtf8()
  ).toDartString();

  var s = analyzerOut.split("██");
  return Tuple2(s[0].split("█"), s[1].split("█"));
}
