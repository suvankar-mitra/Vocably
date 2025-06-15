import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
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
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.9)),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Score card',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                            fontSize: 18.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share this card')));
                          },
                          child: Icon(HugeIcons.strokeRoundedShare08, color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Text('🔥 ', style: GoogleFonts.poppins(fontSize: 12.0)),
                        Text('5', style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold)),
                        Text(' day streak', style: GoogleFonts.poppins(fontSize: 14.0)),
                        // Text(' Keep learning!', style: GoogleFonts.poppins(fontSize: 12.0)),
                      ],
                    ),
                    Text('🏅 On a roll', style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Text('🤓 ', style: GoogleFonts.poppins(fontSize: 14.0)),
                        Text('16', style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold)),
                        Text(' words searched', style: GoogleFonts.poppins(fontSize: 14.0)),
                      ],
                    ),
                    Text(
                      '🧠 Active this week',
                      style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold),
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
                        Text('2', style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold)),
                        Text(' words bookmarked', style: GoogleFonts.poppins(fontSize: 14.0)),
                      ],
                    ),
                    Text('🔖 Nice curation', style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                  child: Divider(height: 0, thickness: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                ),

                Text('📅 Your Weekly Summary', style: GoogleFonts.poppins(fontSize: 14.0)),
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
    );
  }
}
