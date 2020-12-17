import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_cases.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_friends.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_gigs.dart';
import 'package:qbk_simple_app/a_screens_pages/load_screen.dart';
import 'package:flutter/services.dart';

import 'package:qbk_simple_app/models/user.dart';

import 'package:qbk_simple_app/services/wrapper_widget.dart';
import 'package:qbk_simple_app/a_screens_pages/registration_information_page.dart';
import 'package:qbk_simple_app/a_screens_pages/registration_page.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/settings_page.dart';
import 'package:qbk_simple_app/a_screens_pages/sign_in_page.dart';
import 'package:qbk_simple_app/services/auth.dart';
import 'a_screens_pages/home_page.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_gig_page.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/new_gig_page.dart';

import 'a_screens_pages/registration_information_page.dart';
import 'services/wrapper_widget.dart';

///Read but not Documentated
void main() => runApp(QBKApp());

class QBKApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<UserData>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'BioRhyme'),
        initialRoute: WrapperQBK.id,
        routes: {
          WrapperQBK.id: (context) => WrapperQBK(),
          QBKHomePage.id: (context) => QBKHomePage(),
          // CopyLoadPage.id: (context) => CopyLoadPage(),
          CreateGigPage.id: (context) => CreateGigPage(),
          CreateLoadPage.id: (context) => CreateLoadPage(),
          NewGigPage.id: (context) => NewGigPage(),
          // CrewQBK.id: (context) => CrewQBK(),
          // NewTourPage.id: (context) => NewTourPage(),
          SettingsPage.id: (context) => SettingsPage(),
          SignInPage.id: (context) => SignInPage(),
          RegistrationPage.id: (context) => RegistrationPage(),
          RegistrationInformationPage.id: (context) =>
              RegistrationInformationPage(),
          MyGigs.id: (context) => MyGigs(),
          MyCases.id: (context) => MyCases(),
          MyFriends.id: (context) => MyFriends(),
          LoadPage.id: (context) => LoadPage(),
        },
      ),
    );
  }
}
