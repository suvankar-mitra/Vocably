import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/widgets/bouncable_wrapper_widget.dart';
import 'package:vocably/widgets/search_history_items.dart';

class SearchHistoryCardWidget extends StatelessWidget {
  const SearchHistoryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> historyMap = {
      'June 5': ['readable', 'resource', 'make believe', ''],
      'June 4': ['audacity', 'redundant', ''],
      'June 3': ['remove', 'gracious', ''],
    };

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),

        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Search History',
                  style: GoogleFonts.playfair(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchHistoryItems(historyMap: historyMap),

                  const SizedBox(height: 10.0),

                  InkWell(
                    onTap: () {
                      // Navigate to the details page or perform any action
                      // For now, just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Show more history')));
                    },
                    child: Row(
                      children: [
                        Text(
                          'Show more',
                          style: GoogleFonts.poppins(
                            color: theme.colorScheme.secondary,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        BouncableWrapperWidget(
                          leftToRight: true,
                          child: Icon(
                            HugeIcons.strokeRoundedArrowRight02,
                            color: theme.colorScheme.secondary,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
