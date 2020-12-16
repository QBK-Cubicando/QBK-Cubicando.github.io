import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

///Documentated
class LoadSelectionButton extends StatelessWidget {
  LoadSelectionButton(
      {@required this.text,
      this.color,
      this.height,
      this.width,
      this.onPressed});
  final color;
  final Text text;
  final double height;
  final double width;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? displayHeight(context) * 0.065,
        width: width ?? displayWidth(context) * 0.25,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          color: color,
          child: text,
          onPressed: onPressed,
        ));
  }
}
