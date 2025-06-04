import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/views/screens/home_screen/search_screen.dart';

class HomeSearchBarWidget extends StatelessWidget {
  const HomeSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.searchBarBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Hero(
          tag: 'searchBar',
          child: Material(
            color: Colors.transparent,
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search a word or phrase ...',
                  hintStyle: GoogleFonts.roboto(fontSize: 16.0, color: AppColors.searchBarHintColor),
                  suffixIcon: Icon(HugeIcons.strokeRoundedBook02, color: AppColors.secondaryAccentColor),
                  filled: false,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
