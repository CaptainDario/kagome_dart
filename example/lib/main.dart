import 'package:kagome_dart/kagome_dart.dart';

import 'package:tuple/tuple.dart';



void main() {

  String input = "日本経済新聞";
  Kagome kagome = Kagome();
  kagome.showVersion();

  // important to call before any other methods
  kagome.initTokenizer();

  // create space in input
  List w = kagome.runWakati(input);
  for (var i = 0; i < w.length; i++) {
    print(w[i]);
  }

  // analyze and create spaces
  Tuple2<List<String>, List<List<String>>> t = 
    kagome.runAnalyzer(input, AnalyzeModes.search);
  for (var i = 0; i < t.item1.length; i++) {
    print("${t.item1[i]} \t ${t.item2[i]}");
  }
  
  t = kagome.runAnalyzer(input, AnalyzeModes.normal);
  print(t);

  kagome.destroyTokenizer();
}