import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/constants/app_constants.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/widgets/home_search_bar_widget.dart';
import 'package:vocably/widgets/word_of_the_day_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Lottie.asset('assets/lottie/lottie_floating_book_blue.json'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: AppConstants.appName,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.appTitleColor,
                            ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0), child: HomeSearchBarWidget()),
              const SizedBox(height: 10.0),
              // Word of the day widget
              Padding(padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0), child: WordOfTheDayWidget()),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
