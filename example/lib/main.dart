import 'package:kagome_dart/kagome_dart.dart';

import 'package:tuple/tuple.dart';



void main() {

  String input = "日本経済新聞";
  showVersion();

  // important to call before any other methods
  initTokenizer();

  // create space in input
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