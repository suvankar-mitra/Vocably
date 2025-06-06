import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VOutlinedButton extends StatelessWidget {
  const VOutlinedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.iconData,
    this.color = Colors.black,
  });

  final dynamic onPressed;
  final String label;
  final IconData? iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // backgroundColor: AppColors.secondaryAccentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        side: BorderSide(color: color, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: color, fontSize: 14.0)),
          iconData != null
              ? Padding(padding: const EdgeInsets.only(left: 8.0), child: Icon(iconData, color: color, size: 16.0))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
