import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/constants/app_constants.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/widgets/home_search_bar_widget.dart';
import 'package:vocably/widgets/score_board_widget.dart';
import 'package:vocably/widgets/search_history_card_widget.dart';
import 'package:vocably/widgets/word_of_the_day_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              text: AppConstants.appName,
              style: GoogleFonts.playfairDisplay(
                fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.activeNavIconColor,
              ),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bottomNavBackground,
        elevation: 2,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(8.0), child: Container()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: HomeSearchBarWidget(),
            ),

            // Word of the day widget
            Padding(padding: const EdgeInsets.all(10.0), child: WordOfTheDayWidget()),

            // Search history card widget
            Padding(padding: const EdgeInsets.all(10.0), child: SearchHistoryCardWidget()),

            // Score board widget
            Padding(padding: const EdgeInsets.all(10.0), child: ScoreBoardWidget()),

            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
