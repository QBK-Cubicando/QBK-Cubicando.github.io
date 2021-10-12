import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

//TextStyle Constants

// const kTitleTextStile  = TextStyle(
//   fontSize: displayWidth(context),
//   letterSpacing: 1,
//   fontWeight: FontWeight.w800,
//   color: Color(0xffffdd0f),
// );

TextStyle kTitleTextStile(BuildContext context) {
  return TextStyle(
      fontSize: displayWidth(context) * 0.065,
      letterSpacing: 1,
      fontWeight: FontWeight.w800,
      color: Color(0xffffdd0f));
}

TextStyle kButtonsTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: displayWidth(context) * 0.06,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
}

TextStyle kTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: displayWidth(context) * 0.05,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

// const kTextStyle = TextStyle(
//   color: Colors.white,
//   fontSize: 23.0,
//   fontStyle: FontStyle.italic,
//   fontWeight: FontWeight.bold,
// );

//TODO: Create a color constants
Color kgreenQBK = Color.fromRGBO(80, 239, 178, 1.0);
Color kredQBK = Color.fromRGBO(255, 21, 97, 1.0);
Color kblueQBK = Color.fromRGBO(38, 218, 247, 1.0);
Color kpurpleQBK = Color.fromRGBO(200, 155, 201, 1.0);
Color kyellowQBK = Color.fromRGBO(255, 221, 0, 1.0);


//TODO: Make a constant for the Profile image so any user has their own
