import 'package:flutter/material.dart';

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

  static String toRoman(int number) {
    final List<Map<int, String>> romanSymbols = [
      {1000: "M"},
      {900: "CM"},
      {500: "D"},
      {400: "CD"},
      {100: "C"},
      {90: "XC"},
      {50: "L"},
      {40: "XL"},
      {10: "X"},
      {9: "IX"},
      {5: "V"},
      {4: "IV"},
      {1: "I"},
    ];

    String result = "";
    for (var symbol in romanSymbols) {
      int value = symbol.keys.first;
      String numeral = symbol.values.first;
      while (number >= value) {
        result += numeral;
        number -= value;
      }
    }
    return result;
  }

  static List<TextSpan> highlightWordsContainingQuery(
    String source,
    String query,
    TextStyle defaultStyle,
    TextStyle highlightStyle,
  ) {
    if (query.isEmpty || source.isEmpty) {
      return [TextSpan(text: source, style: defaultStyle)];
    }

    // Find whole words that contain the query
    // \w* matches zero or more word characters
    // This looks for a word that has:
    // - optional word characters before the query
    // - the query itself
    // - optional word characters after the query
    final String escapedQuery = RegExp.escape(query);
    final RegExp pattern = RegExp(
      r'\b\w*' + escapedQuery + r'\w*\b', // Match a word containing the query
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    int currentPosition = 0;

    for (final Match match in pattern.allMatches(source)) {
      // Add text before the match
      if (match.start > currentPosition) {
        spans.add(TextSpan(text: source.substring(currentPosition, match.start), style: defaultStyle));
      }
      // Add the highlighted match (the whole word that contained the query)
      spans.add(TextSpan(text: source.substring(match.start, match.end), style: highlightStyle));
      currentPosition = match.end;
    }

    // Add remaining text
    if (currentPosition < source.length) {
      spans.add(TextSpan(text: source.substring(currentPosition), style: defaultStyle));
    }
    return spans.isEmpty ? [TextSpan(text: source, style: defaultStyle)] : spans;
  }
}
