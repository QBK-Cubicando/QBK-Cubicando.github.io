import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'dart:ui';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class NewGigButton extends StatelessWidget {
  NewGigButton({@required this.text, this.color, this.onPressGoTo});

  final String text;
  final String onPressGoTo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 20.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: this.color,
      child: Container(
        alignment: Alignment.center,
        height: displayHeight(context) * 0.15,
        width: displayWidth(context) * 0.23,
        child: Text(
          this.text,
          textAlign: TextAlign.center,
          style: kButtonsTextStyle(context),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, onPressGoTo);
      },
    );
  }
}
