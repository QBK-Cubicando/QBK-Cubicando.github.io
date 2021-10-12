import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';
import 'package:qbk_simple_app/a_screens_pages/sign_in_page.dart';
import 'package:qbk_simple_app/models/user.dart';

///Documentated

class WrapperQBK extends StatelessWidget {
  static const String id = 'wrapper_qbk';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    //function authentification

    if (user == null) {
      return SignInPage();
    } else {
      try {
        return QBKHomePage();
      } catch (e) {
        print(e);
        return SignInPage();
      }
    }
  }
}
