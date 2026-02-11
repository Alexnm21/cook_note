import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'base_font_size.dart';

BaseTextStyle baseTextStyle = BaseTextStyle();

class BaseTextStyle {
  ///Fonts: **inter**
  ///FontSize: 24,
  ///FontWeight: w600,
  ///Color: Black,
  TextStyle h1 = GoogleFonts.inter(
    fontSize: BaseFontSize.xl24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 18,
  ///FontWeight: w500,
  ///Color: Black,
  TextStyle h2 = GoogleFonts.inter(
    fontSize: BaseFontSize.l18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 14,
  ///FontWeight: w500,
  ///Color: Black,
  TextStyle h3 = GoogleFonts.inter(
    fontSize: BaseFontSize.m14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 11,
  ///FontWeight: w400,
  ///Color: Black,
  TextStyle body = GoogleFonts.inter(
    fontSize: BaseFontSize.s11,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 13,
  ///FontWeight: w600,
  ///Color: Black,
  TextStyle h5 = GoogleFonts.inter(
    fontSize: BaseFontSize.m13,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 12,
  ///FontWeight: w500,
  ///Color: Black,
  TextStyle h6 = GoogleFonts.inter(
    fontSize: BaseFontSize.m12,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 8,
  ///FontWeight: w500,
  ///Color: Black,
  TextStyle body2 = GoogleFonts.inter(
    fontSize: BaseFontSize.xs8,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 15,
  ///FontWeight: w400,
  ///Color: Black,
  TextStyle body3 = GoogleFonts.inter(
    fontSize: BaseFontSize.m15,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  ///Fonts: **inter**
  ///FontSize: 14,
  ///FontWeight: w400,
  ///Color: Black,
  TextStyle inputs = GoogleFonts.inter(
    fontSize: BaseFontSize.m14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}
