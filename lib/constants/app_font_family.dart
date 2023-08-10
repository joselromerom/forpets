import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontFamily {
  TextStyle titleFont({color, double fontSize = 32}) => GoogleFonts.inter(
        textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: color,
          fontSize: fontSize,
        ),
      );

  TextStyle subtitleFont({color, double fontSize = 24}) => GoogleFonts.inter(
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: fontSize,
        ),
      );

  TextStyle textFont({color, double fontSize = 16}) => GoogleFonts.inter(
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: color,
          fontSize: fontSize,
        ),
      );

  TextStyle textLight({color, double fontSize = 16}) => GoogleFonts.inter(
        textStyle: TextStyle(
          fontWeight: FontWeight.w300,
          color: color,
          fontSize: fontSize,
        ),
      );
}
