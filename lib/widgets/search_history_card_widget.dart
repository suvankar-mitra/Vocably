import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/widgets/bouncable_wrapper_widget.dart';

class SearchHistoryCardWidget extends StatelessWidget {
  const SearchHistoryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
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
                    color: AppColors.appTitleColor,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dot + First Word and Date
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      // First Word and Date
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'readable',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.0,
                                  color: AppColors.secondaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'June 5',
                              style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Line + Word for same date
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      children: [
                        // Line
                        Container(width: 2, height: 16, color: AppColors.primaryAccentColor.withValues(alpha: .5)),
                        const SizedBox(width: 16.0),
                        // Word
                        Expanded(
                          child: Text(
                            'resource',
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: AppColors.secondaryTextColor,
                              // fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Line + Word for same date
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      children: [
                        // Line
                        Container(width: 2, height: 16, color: AppColors.primaryAccentColor.withValues(alpha: .5)),
                        const SizedBox(width: 16.0),
                        // Word
                        Expanded(
                          child: Text(
                            'make believe',
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: AppColors.secondaryTextColor,
                              // fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Line extension after last line of prev section, if there are more words below
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Container(width: 2, height: 16, color: AppColors.primaryAccentColor.withValues(alpha: .5)),
                  ),

                  // Dot + 2nd Word and Date
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      // 2nd Word and Date
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'audacity',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.0,
                                  color: AppColors.secondaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'June 4',
                              style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Line + Word for same date as above
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      children: [
                        // Line
                        Container(width: 2, height: 16, color: AppColors.primaryAccentColor.withValues(alpha: .5)),
                        const SizedBox(width: 16.0),
                        // Word
                        Expanded(
                          child: Text(
                            'redundant',
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: AppColors.secondaryTextColor,
                              // fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Line extension after last line of prev section, if there are more words below
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Container(width: 2, height: 16, color: AppColors.primaryAccentColor.withValues(alpha: .5)),
                  ),

                  // Dot + 3rd Word and Date
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      // 3rd Word and Date
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'remove',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.0,
                                  color: AppColors.secondaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'June 3',
                              style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

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
                            color: AppColors.secondaryAccentColor,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.secondaryAccentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        BouncableWrapperWidget(
                          leftToRight: true,
                          child: Icon(
                            HugeIcons.strokeRoundedArrowRight02,
                            color: AppColors.secondaryAccentColor,
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
