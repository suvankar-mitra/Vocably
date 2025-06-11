import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/widgets/weekly_search_line_chart.dart';

class ScoreBoardWidget extends StatefulWidget {
  const ScoreBoardWidget({super.key});

  @override
  State<ScoreBoardWidget> createState() => _ScoreBoardWidgetState();
}

class _ScoreBoardWidgetState extends State<ScoreBoardWidget> {
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
            Text(
              'Weekly Score Card',
              style: GoogleFonts.playfair(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '5',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          Text(
                            ' day streak',
                            style: GoogleFonts.poppins(fontSize: 14.0, color: theme.textTheme.bodyMedium?.color),
                          ),
                          // Text(' Keep learning!', style: GoogleFonts.poppins(fontSize: 12.0)),
                        ],
                      ),
                      Text(
                        '🏅 On a roll',
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Text('🤓 ', style: GoogleFonts.poppins(fontSize: 14.0)),
                          Text(
                            '16',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          Text(
                            ' words searched',
                            style: GoogleFonts.poppins(fontSize: 14.0, color: theme.textTheme.bodyMedium?.color),
                          ),
                        ],
                      ),
                      Text(
                        '🧠 Active this week',
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Text('🔖 ', style: GoogleFonts.poppins(fontSize: 14.0)),
                          Text(
                            '2',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          Text(' words bookmarked', style: GoogleFonts.poppins(fontSize: 14.0)),
                        ],
                      ),
                      Text(
                        '🔖 Nice curation',
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                    child: Divider(height: 0, thickness: 1, color: theme.textTheme.bodyMedium?.color),
                  ),

                  Text(
                    '📅 Your Weekly Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: WeeklySearchLineChart(
                          searches: [1, 5, 2, 3, 5, 0, 0],
                          // days: ['SA', 'SU', 'MO', 'TU', 'WE', 'TH', 'FR'],
                        ),
                      ),
                    ],
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
