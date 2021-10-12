import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/notification_stack.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

///Documentated
class PerfilIconButton extends StatelessWidget {
  PerfilIconButton({this.iconButtonPageGo});
  final iconButtonPageGo;

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    return NotificationStack(
    
      notificationType: 'home',
      userUid: user.uid,
      icon: Hero(
        tag: 'logo',
        child: IconButton(
          iconSize: displayHeight(context) * 0.2,
          icon: ClipRRect(
              // borderRadius: BorderRadius.circular(50.0),
              child: Image.asset('images/logo_sin_escrita_qbk.png')),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}
