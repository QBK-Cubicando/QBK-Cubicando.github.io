import 'package:flutter/material.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class SelectionButton extends StatelessWidget {
  SelectionButton(
      {@required this.text, this.color, this.height, this.width, this.onPress});

  final color;
  final String text;
  final double height;
  final double width;
  final onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: RaisedButton(
          
          color: color,
          child: Text(
            text,
            style: kButtonsTextStyle(context),
          ),
          onPressed: onPress,
        ));
  }
}
