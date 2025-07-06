import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/views/screens/home_screen/home_screen_widgets/title_card.dart';

class EtymologyCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final MeaningDTO selectedMeaning;

  const EtymologyCard({super.key, required this.isDark, required this.theme, required this.selectedMeaning});

  @override
  Widget build(BuildContext context) {
    if (selectedMeaning.etymologyText != null && selectedMeaning.etymologyText!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          TitleCard(isDark: isDark, theme: theme, title: 'Etymology'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1.2, color: theme.primaryColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedMeaning.etymologyText ?? 'No etymology found',
                        style: GoogleFonts.merriweather(
                          fontSize: 14,
                          height: 1.5,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
