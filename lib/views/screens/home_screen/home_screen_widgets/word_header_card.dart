import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/models/word_entry_dto.dart';

class WordHeaderCard extends StatelessWidget {
  final WordEntryDTO wordEntry;
  final bool isGayThemeOn;
  final List<Widget> audioWidgets;
  final List<Widget> soundTextWidgets;

  const WordHeaderCard({
    super.key,
    required this.wordEntry,
    required this.isGayThemeOn,
    required this.audioWidgets,
    required this.soundTextWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        decoration:
            isGayThemeOn
                ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade800,
                      Colors.orange.shade800,
                      Colors.yellow.shade800,
                      Colors.green.shade800,
                      Colors.blue.shade800,
                      Colors.indigo.shade800,
                      Colors.purple.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1.2, color: Colors.transparent),
                )
                : BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1.2, color: theme.primaryColor),
                ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            wordEntry.word ?? '',
                            style: GoogleFonts.merriweather(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: isGayThemeOn ? Colors.white : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (audioWidgets.isNotEmpty)
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: audioWidgets),
                    if (soundTextWidgets.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.center,
                          children: soundTextWidgets,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
