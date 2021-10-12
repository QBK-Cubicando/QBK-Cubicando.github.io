import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class SelectionMenuButton extends StatelessWidget {
  SelectionMenuButton({@required this.text, this.onPress, this.color});

  final String text;
  final onPress;
  final color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      margin: EdgeInsets.all(5.0),
      color: color,
      child: FlatButton(
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: kButtonsTextStyle(context),
        ),
        onPressed: onPress,
      ),
    );
  }
}
