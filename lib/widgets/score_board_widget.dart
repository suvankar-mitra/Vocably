import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/animations/colorized_no_fade_animated_text.dart';
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
            AnimatedTextKit(
              animatedTexts: [
                ColorizeNoFadeAnimatedText(
                  'Weekly Score Card',
                  textStyle: GoogleFonts.playfair(
                    fontWeight: FontWeight.bold,
                    color: AppColors.appTitleColor,
                    fontSize: 22.0,
                  ),
                  colors: [AppColors.primaryAccentColor, AppColors.secondaryAccentColor, AppColors.primaryAccentColor],
                  speed: Duration(milliseconds: 1000),
                  textAlign: TextAlign.justify,
                ),
              ],
              // isRepeatingAnimation: true,
              repeatForever: true,
              onTap: () {},
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
                          // Text('🔥 ', style: GoogleFonts.poppins(fontSize: 12.0)),
                          Text('3', style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold)),
                          Text(' day streak', style: GoogleFonts.poppins(fontSize: 12.0)),
                          // Text(' Keep learning!', style: GoogleFonts.poppins(fontSize: 12.0)),
                        ],
                      ),
                      Text('🥉 On a roll', style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Text('🤓 ', style: GoogleFonts.poppins(fontSize: 12.0)),
                          Text('16', style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold)),
                          Text(' words searched', style: GoogleFonts.poppins(fontSize: 12.0)),
                        ],
                      ),
                      Text(
                        '🧠 Active this week',
                        style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Text('🔖 ', style: GoogleFonts.poppins(fontSize: 12.0)),
                          Text('2', style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold)),
                          Text(' words bookmarked', style: GoogleFonts.poppins(fontSize: 12.0)),
                        ],
                      ),
                      Text('🔖 Nice curation', style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20.0, child: Divider(height: 0, thickness: 1)),

                  Text('📅 Weekly Summary', style: GoogleFonts.poppins(fontSize: 12.0)),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      SizedBox(height: 150, child: WeeklySearchLineChart(searches: [0, 5, 2, 18, 22, 0, 0])),
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
