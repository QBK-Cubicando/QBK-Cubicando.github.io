import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

///Documentated
class PerfilIconButton extends StatelessWidget {
  PerfilIconButton({this.iconButtonPageGo});
  final iconButtonPageGo;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: IconButton(
        iconSize: displayHeight(context) * 0.05,
        icon: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset('images/logoQBK_negro.jpg')),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}
