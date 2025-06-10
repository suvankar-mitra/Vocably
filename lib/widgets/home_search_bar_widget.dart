import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/views/screens/home_screen/search_screen.dart';

class HomeSearchBarWidget extends StatelessWidget {
  const HomeSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
        child: Hero(
          tag: 'searchBar',
          child: Material(
            color: Colors.transparent,
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedSearch01,
                      color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                      size: 14.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            'Search a word or phrase',
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        pause: const Duration(milliseconds: 2000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                    Icon(HugeIcons.strokeRoundedBook02, color: Theme.of(context).colorScheme.secondary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
