import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/themes/app_colors.dart';

class SearchHistoryItems extends StatelessWidget {
  const SearchHistoryItems({super.key, required this.historyMap});

  final Map<String, List<String>> historyMap;

  @override
  Widget build(BuildContext context) {
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
                            width: 16,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccentColor.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          // word
                          Text(
                            words[i],
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: AppColors.secondaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Text(date, style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.secondaryTextColor)),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      children: [
                        // Line
                        Container(width: 2, height: 20, color: AppColors.primaryAccentColor.withValues(alpha: .5)),
                        const SizedBox(width: 16.0),
                        // word
                        Text(
                          words[i],
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            color: AppColors.secondaryTextColor,
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
