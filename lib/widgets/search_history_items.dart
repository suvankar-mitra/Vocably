import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/themes/app_colors.dart';

class SearchHistoryItems extends StatelessWidget {
  const SearchHistoryItems({super.key, required this.historyMap});

  final Map<String, List<String>> historyMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          historyMap.entries.map((entry) {
            final date = entry.key;
            final words = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(words.length, (i) {
                if (i == 0) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Dot
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: theme.textTheme.titleLarge?.color?.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          // word
                          Text(
                            words[i],
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: theme.textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Text(date, style: GoogleFonts.poppins(fontSize: 12.0, color: theme.textTheme.bodyMedium?.color)),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        // Line
                        Container(
                          width: 2,
                          height: 18,
                          color: theme.textTheme.titleLarge?.color?.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 16.0),
                        // word
                        Text(
                          words[i],
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            color: theme.textTheme.bodyMedium?.color,
                            // fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                }
              }),
            );
          }).toList(),
    );
  }
}
