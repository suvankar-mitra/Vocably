import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/widgets/search_history_items.dart';

class SearchHistoryCardWidget extends StatelessWidget {
  const SearchHistoryCardWidget({super.key, required this.historyMap});

  final Map<String, List<String>> historyMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),

        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            blurStyle: BlurStyle.normal,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // card title
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? theme.colorScheme.surface : theme.colorScheme.primary.withValues(alpha: 0.9),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search History',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                            fontSize: 16.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Show more history')));
                          },
                          child: Icon(
                            HugeIcons.strokeRoundedArrowRight01,
                            color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.0, child: Divider(color: isDark ? Colors.grey : Colors.transparent)),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SearchHistoryItems(historyMap: historyMap)],
            ),
          ),
        ],
      ),
    );
  }
}
