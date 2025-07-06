import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final String title;

  const TitleCard({
    super.key,
    required this.isDark,
    required this.theme,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : theme.primaryColor.withAlpha(230),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}