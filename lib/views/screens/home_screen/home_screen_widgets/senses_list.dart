import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/views/screens/home_screen/definition_screen.dart';

class SensesList extends StatelessWidget {
  final List<SenseDTO> senses;
  final WordEntryDTO? wordEntry;
  final String Function(int) toRoman;
  final List<TextSpan> Function(String, String, TextStyle, TextStyle) highlightWordsContainingQuery;
  final TextStyle defaultExampleStyle;
  final TextStyle highlightExampleStyle;

  const SensesList({
    super.key,
    required this.senses,
    required this.wordEntry,
    required this.toRoman,
    required this.highlightWordsContainingQuery,
    required this.defaultExampleStyle,
    required this.highlightExampleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if (senses.isNotEmpty)
          ...senses.asMap().entries.map((wordEntryMap) {
            final index = wordEntryMap.key;
            final sense = wordEntryMap.value;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1.2, color: theme.primaryColor),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...sense.glosses!.asMap().entries.map((glossEntry) {
                      final gloss = glossEntry.value;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${index + 1}. ',
                                      style: GoogleFonts.merriweather(
                                        fontSize: 16,
                                        height: 1.5,
                                        fontWeight: FontWeight.w600,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    TextSpan(
                                      text: gloss,
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    // examples
                    if (sense.examples != null && sense.examples!.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Examples:',
                                    style: GoogleFonts.merriweather(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                            child: Column(
                              children: [
                                ...sense.examples!.asMap().entries.map((wordEntry) {
                                  final index = wordEntry.key;
                                  final example = wordEntry.value;
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${toRoman(index + 1)}.',
                                                    style: GoogleFonts.merriweather(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                                    ),
                                                  ),

                                                  ...highlightWordsContainingQuery(
                                                    ' $example',
                                                    this.wordEntry?.word ?? '',
                                                    defaultExampleStyle,
                                                    highlightExampleStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4.0),
                                    ],
                                  );
                                }),

                                // const SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                        ],
                      ),

                    // synonyms
                    if (sense.synonyms != null && sense.synonyms!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Synonyms:',
                                    style: GoogleFonts.merriweather(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children:
                                  sense.synonyms!.map((synonym) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => DefinitionScreen(word: synonym)),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF597445),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          synonym,
                                          style: GoogleFonts.merriweather(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    // antonyms
                    if (sense.antonyms != null && sense.antonyms!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Antonyms:',
                                    style: GoogleFonts.merriweather(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children:
                                  sense.antonyms!.map((antonym) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => DefinitionScreen(word: antonym)),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFB06161),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          antonym,
                                          style: GoogleFonts.merriweather(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),

                    if (sense.related != null && sense.related!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Related:',
                                    style: GoogleFonts.merriweather(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children:
                                  sense.related!.map((related) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => DefinitionScreen(word: related)),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDE8F5F),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          related,
                                          style: GoogleFonts.merriweather(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
