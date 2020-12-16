import 'package:flutter/material.dart';
import 'package:qbk_simple_app/a_screens_pages/sign_in_page.dart';
import 'package:qbk_simple_app/services/auth.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class PopupMenuQBK extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _choiceAction(String choiceSelected) {
      if (choiceSelected == 'Sign Out') {
        _auth.signOut();
        Navigator.pushNamed(context, SignInPage.id);
      }
    }

    List<String> choicesPopupMenu = ['Sign Out'];

    return PopupMenuButton<String>(
      onSelected: _choiceAction,
      itemBuilder: (BuildContext context) {
        return choicesPopupMenu.map((String choice) {
          return PopupMenuItem<String>(
              value: choice,
              child: Text(
                choice,
                style: kButtonsTextStyle(context),
              ));
        }).toList();
      },
    );
  }
}
