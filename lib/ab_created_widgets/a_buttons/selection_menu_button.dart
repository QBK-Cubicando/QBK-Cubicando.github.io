import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class SelectionMenuButton extends StatelessWidget {
  SelectionMenuButton({@required this.text, this.onPress});

  final String text;
  final onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      color: Colors.grey.shade800,
      child: FlatButton(
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kTextStyle(context),
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
