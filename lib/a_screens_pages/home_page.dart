import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_friends.dart';

import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_gigs.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/settings_page.dart';
import 'package:qbk_simple_app/a_screens_pages/sign_in_page.dart';
import 'package:qbk_simple_app/ab_created_widgets/calendar.dart';
import 'package:qbk_simple_app/ab_created_widgets/notification_stack.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/services/auth.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/services/push_notification_service.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:provider/provider.dart';

import 'package:qbk_simple_app/ab_created_widgets/a_buttons/new_gig_button.dart';
import 'package:qbk_simple_app/ab_created_widgets/perfil_icon_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/menu_widget.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:share/share.dart';

import 'drawer_home_page/my_cases.dart';
import 'drawer_home_page/my_gigs.dart';

import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_menu_button.dart';
import 'a_new_gig_pages/new_gig_page.dart';
import 'package:qbk_simple_app/services/push_notification_service.dart';

///Documentated
class QBKHomePage extends StatefulWidget {
  static const String id = 'qbk_Home_Page';

  @override
  _QBKHomePageState createState() => _QBKHomePageState();
}

class _QBKHomePageState extends State<QBKHomePage> {
  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text =
        'A friend wants to invite you to QBK-App, follow this link to download the App: ' +
            'https://www.getqbk.com';

    Share.share(
      text,
      subject: 'Invitation to QBK-App',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    final AuthService _auth = AuthService();

    //TODO: Maybe you can delete StreamBuilder

    try {
      return StreamBuilder<UserData>(
          stream: DatabaseService(userUid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return PushNotificationMessage(
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.black,
                    drawer: Container(
                      width: displayWidth(context) * 0.7,
                      child: Drawer(
                        child: Container(
                          color: Colors.black,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: displayHeight(context) * 0.02,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Container(
                                  color: Colors.black,
                                  height: displayHeight(context) * 0.2,
                                  child:
                                      Image.asset(
                                      'images/logo_sin_escrita_qbk.png'),
                                ),
                              ),
                              // Profile Picture
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                          
                                  userData.name,
                                  style: kTextStyle(context),
                              
                                ),
                              ),
                              //Name
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  userData.speciality ?? 'Random',
                                  style: kTextStyle(context)
                                      ,
                                ),
                              ),
                              // Speciality
                              
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                color: Colors.black,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, MyGigs.id),
                                      child: NotificationStack(
                                        userUid: user.uid,
                                        notificationType: 'gigs',
                                        icon: SelectionMenuButton(
                                          text: 'GIGS',
                                          color: kgreenQBK,
                                          onPress: () => Navigator.pushNamed(
                                              context, MyGigs.id),
                                        ),
                                      ),
                                    ),
                                    //My Gigs
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, MyCases.id),
                                      child: SelectionMenuButton(
                                        text: 'CASES',
                                        color: kredQBK,
                                        onPress: () => Navigator.pushNamed(
                                            context, MyCases.id),
                                      ),
                                    ),
                                    //My Cases
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyFriends(
                                                userUid: userData.uid)),
                                      ),
                                      child: NotificationStack(
                                        userUid: user.uid,
                                        notificationType: 'friends',
                                        icon: SelectionMenuButton(
                                          text: 'CREW',
                                          color: kblueQBK,
                                          onPress: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyFriends(
                                                    userUid: userData.uid)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // My Friends
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, SettingsPage.id);
                                      },
                                      child: SelectionMenuButton(
                                        text: 'PROFILE',
                                        color: kpurpleQBK,
                                        onPress: () {
                                          Navigator.pushNamed(
                                              context, SettingsPage.id);
                                        },
                                      ),
                                    ),
                                    //Modify Profile
                                    SelectionMenuButton(
                                      text: 'SIGN OUT',
                                      color: Colors.grey.shade500,
                                      onPress: () {
                                        _auth.signOut();
                                        Navigator.pushNamed(
                                            context, SignInPage.id);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.01,
                              ),
                              Container(
                                height: displayHeight(context) * 0.06,
                                width: displayWidth(context) * 0.6,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: InkWell(
                                    child: Text(
                                      'Share with a friend',
                                      style: kTextStyle(context)
                                          .copyWith(color: Colors.blueAccent),
                                    ),
                                    onTap: () => share(context),
                                  ),
                                ),
                              ), //Menu Drawer Options
                            ],
                          ),
                        ),
                      ),
                    ),
//                     appBar: AppBar(
//                       toolbarHeight: displayHeight(context) * 0.1,
//                       backgroundColor: Colors.grey.shade800,
//                       leading: PerfilIconButton(),
//                       title: Center(
//                         child: Text(
//                           'QBK',
//                           style: kTitleTextStile(context)
//                               .copyWith(fontSize: displayWidth(context) * 0.1),
//                         ),
//                       ),
//                       actions: <Widget>[
//                         PopupMenuQBK(
// //TODO: Create send list and print list function
// //TODO: Create a send gig and print gig option
//                             ),
//                       ],
//                     ),
                    body: SafeArea(
                      child: Center(
                        child: Container(
                          height: displayHeight(context) * 0.98,
                          width: displayWidth(context) * 0.9,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PerfilIconButton(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewGigPage(
                                                        userName:
                                                            userData.name)),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Container(
                                                width:
                                                    displayWidth(context) * 0.1,
                                                height:
                                                    displayWidth(context) * 0.1,
                                                color: kgreenQBK,
                                                child: Icon(
                                                    Icons.music_note_sharp),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              'GIG',
                                              style: kTextStyle(context)
                                                  .copyWith(
                                                      fontSize: displayWidth(
                                                              context) *
                                                          0.07),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: displayHeight(context) * 0.7,
                                      width: displayWidth(context) * 0.9,

                                      child: QBKCalendar(),
                                    ), //Calendar
                                  ],
                                ), //Calendar
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              //TODO: Erase this down (AntiBug for Firebase Auth)
              final AuthService _auth = AuthService();

              return Loading();
              // return Container(
              //   child: FloatingActionButton(
              //     onPressed: _auth.signOut,
              //     child: Text('Wait 15 sec if nothing happens tap here'),
              //   ),
              // );

              // return Hero(tag: 'loading', child: Loading());
            }
          });
    } catch (e) {
      return Center(child: Loading());
      print(e);
    }
  }
}
