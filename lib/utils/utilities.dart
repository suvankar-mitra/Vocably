class Utilities {
  static String getFullPartOfSpeech(String pos) {
    const posMap = {
      'adj': 'adjective',
      'adv': 'adverb',
      'adv_phrase': 'adverbial phrase',
      'affix': 'affix',
      'article': 'article',
      'character': 'character',
      'circumfix': 'circumfix',
      'combining_form': 'combining form',
      'conj': 'conjunction',
      'contraction': 'contraction',
      'det': 'determiner',
      'infix': 'infix',
      'interfix': 'interfix',
      'intj': 'interjection',
      'name': 'proper noun / name',
      'noun': 'noun',
      'num': 'numeral',
      'particle': 'particle',
      'phrase': 'phrase',
      'postp': 'postposition',
      'prefix': 'prefix',
      'prep': 'preposition',
      'prep_phrase': 'prepositional phrase',
      'pron': 'pronoun',
      'proverb': 'proverb',
      'punct': 'punctuation',
      'suffix': 'suffix',
      'symbol': 'symbol',
      'verb': 'verb',
    };

    return posMap[pos] ?? 'Unknown';
  }
}
