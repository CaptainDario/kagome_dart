/// sourced from:
/// * https://pypi.org/project/unidic/
/// * https://clrd.ninjal.ac.jp/unidic/faq.html#output



/// The field types used in the UniDic
enum UnidicTypes {
  pos1, pos2, pos3, pos4,
  cType,
  cForm,
  lForm,
  lemma,
  orth,
  pron,
  orthBase,
  pronBase,
  goshu,
  iType,
  iForm,
  fType,
  fForm,
  iConType,
  fConType,
  type,
  kana,
  kanaBase,
  form,
  formBase,
  aType,
  aConType,
  aModType,
  lid,
  lemma_id,
}

/// The type of the output elements of a node output
final List<UnidicTypes> unidicNodeFormat = [
  UnidicTypes.pos1,
  UnidicTypes.pos2,
  UnidicTypes.pos3,
  UnidicTypes.pos4,
  UnidicTypes.cType,
  UnidicTypes.cForm,
  UnidicTypes.lForm,
  UnidicTypes.lemma,
  UnidicTypes.orth,
  UnidicTypes.pron,
  UnidicTypes.orthBase,
  UnidicTypes.pronBase,
  UnidicTypes.goshu,
  UnidicTypes.iType,
  UnidicTypes.iForm,
  UnidicTypes.fType,
  UnidicTypes.fForm,
];

/// The type of the output elements of a node output
final List<UnidicTypes> unidicUnkFormat = [
  UnidicTypes.pos1,
  UnidicTypes.pos2,
  UnidicTypes.pos3,
  UnidicTypes.pos4,
  UnidicTypes.cType,
  UnidicTypes.cForm,
];

///Map to get a description for the different fields in the UniDic
Map<UnidicTypes, String> unidicTypesToDesc = {
  UnidicTypes.pos1     : "Part of speech fields. The earlier fields are more general, the later fields are more specific.",
  UnidicTypes.pos2     : "Part of speech fields. The earlier fields are more general, the later fields are more specific.",
  UnidicTypes.pos3     : "Part of speech fields. The earlier fields are more general, the later fields are more specific.",
  UnidicTypes.pos4     : "Part of speech fields. The earlier fields are more general, the later fields are more specific.",
  UnidicTypes.cType    : "活用型, conjugation type. Will have a value like 五段-ラ行.",
  UnidicTypes.cForm    : "活用形, conjugation shape. Will have a value like 連用形-促音便.",
  UnidicTypes.lForm    : "語彙素読み, lemma reading. The reading of the lemma in katakana, this uses the same format as the kana field, not pron.",
  UnidicTypes.lemma    : "語彙素（＋語彙素細分類）. The lemma is a non-inflected 'dictionary form' of a word. UniDic lemmas sometimes include extra info or have unusual forms, like using katakana for some place names.",
  UnidicTypes.orth     : "書字形出現形, the word as it appears in text, this appears to be identical to the surface.",
  UnidicTypes.pron     : "発音形出現形, pronunciation. This is similar to kana except that long vowels are indicated with a ー, so 講師 is こーし.",
  UnidicTypes.orthBase : "書字形基本形, the uninflected form of the word using its current written form. For example, for 彷徨った the lemma is さ迷う but the orthBase is 彷徨う.",
  UnidicTypes.pronBase : "発音形基本形, the pronunciation of the base form. Like pron for the lemma or orthBase.",
  UnidicTypes.goshu    : "語種, word type. Etymological category. In order of frequency, 和, 固, 漢, 外, 混, 記号, 不明. Defined for all dictionary words, blank for unks.",
  UnidicTypes.iType    : "語頭変化化型, 'i' is for 'initial'. This is the type of initial transformation the word undergoes when combining, for example 兵 is へ半濁 because it can be read as べい in combination. This is available for <2% of entries.",
  UnidicTypes.iForm    : "語頭変化形, this is the initial form of the word in context, such as 基本形 or 半濁音形.",
  UnidicTypes.fType    : "語末変化化型, 'f' is for 'final', but otherwise as iType. For example 医学 is ク促 because it can change to いがっ (apparently). This is available for <0.1% of entries.",
  UnidicTypes.fForm    : "語末変化形, as iForm but for final transformations.",
  UnidicTypes.iConType : "語頭変化結合型, initial change fusion type. Describes phonetic change at the start of the word in counting expressions. Only available for a few hundred entries, mostly numbers. Values are N followed by a letter or number; most entries with this value are numeric.",
  UnidicTypes.fConType : "語末変化結合型, final change fusion type. This is also used for counting expressions, and like iConType it is only available for a few hundred entries. Unlike iConType the values are very complicated, like B1S6SjShS,B1S6S8SjShS.",
  UnidicTypes.type     : "Not entirely clear what this is, seems to have some overlap with POS.",
  UnidicTypes.kana     : "読みがな, this is the typical representation of a word in kana, unlike pron. 講師 is こうし.",
  UnidicTypes.kanaBase : "仮名形基本形, this is the typical kana representation of the lemma.",
  UnidicTypes.form     : "語形出現形, seems to be the same as pron.",
  UnidicTypes.formBase : "語形基本形 seems to be the same as pronBase.",
  UnidicTypes.aType    : "Accent type. This is a (potentially) comma-separated field which has the number of the mora taking the accent in 標準語 (standard language). When there are multiple values, more common accent patterns come first.",
  UnidicTypes.aConType : "This describes how the accent shifts when the word is used in a counter expression. It uses complicated notation.",
  UnidicTypes.aModType : "Presumably accent related but unclear use. Available for <25% of entries and only has 6 non-default values.",
  UnidicTypes.lid      : "語彙表ID. A long lemma ID. This seems to be a kind of GUID. There is usually one entry per line in the CSV, except that half-width and full-width variations can be combined.",
  UnidicTypes.lemma_id : "語彙素ID. A shorter lemma id, starting from 1. This seems to be as unique as the lemma field, so many CSV lines can share this value.",
};