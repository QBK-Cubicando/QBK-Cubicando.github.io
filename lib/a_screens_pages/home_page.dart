import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_friends.dart';

import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_gigs.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/settings_page.dart';
import 'package:qbk_simple_app/ab_created_widgets/calendar.dart';
import 'package:qbk_simple_app/ab_created_widgets/notification_stack.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/services/auth.dart';
import 'package:qbk_simple_app/services/database.dart';

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

///Documentated
class QBKHomePage extends StatefulWidget {
  static const String id = 'qbk_Home_Page';

  @override
  _QBKHomePageState createState() => _QBKHomePageState();
}

class _QBKHomePageState extends State<QBKHomePage> {

void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = 'A friend wants to invite you to QBK-App, follow this link to download the App: ' + 'https://www.getqbk.com';

    Share.share(
      text,
      subject: 'Invitation to QBK-App',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

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

              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade900,
                  drawer: Container(
                    width: displayWidth(context) * 0.7,
                    child: Drawer(
//TODO: Create a recommend to a friend
                      child: Container(
                        color: Colors.grey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: displayHeight(context) * 0.02,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Container(
                                color: Colors.black,
                                height: displayHeight(context) * 0.2,
                                child: Image.asset('images/logoQBK_negro.jpg'),
                              ),
                            ),
                            // Profile Picture
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userData.name,
                                style: kButtonsTextStyle(context),
                              ),
                            ),
                            //Name
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userData.speciality ?? 'Random',
                                style: kTextStyle(context)
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                            // Speciality
                            SizedBox(
                              height: displayHeight(context) * 0.05,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 15.0),
                              color: Colors.black,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  NotificationStack(
                                    userUid: user.uid,
                                    notificationType: 'gigs',
                                    icon: SelectionMenuButton(
                                      text: 'MY GIGS',
                                      onPress: () => Navigator.pushNamed(
                                          context, MyGigs.id),
                                    ),
                                  ),
                                  //My Gigs
                                  SelectionMenuButton(
                                    text: 'MY CASES',
                                    onPress: () => Navigator.pushNamed(
                                        context, MyCases.id),
                                  ),
                                  //My Cases
                                  NotificationStack(
                                    userUid: user.uid,
                                    notificationType: 'friends',
                                    icon: SelectionMenuButton(
                                      text: 'MY FRIENDS',
                                      onPress: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyFriends(
                                                userUid: userData.uid)),
                                      ),
                                    ),
                                  ),
                                  // My Friends
//TODO: Invite Friends
                                  SelectionMenuButton(
                                    text: 'MODIFY PROFILE',
                                    onPress: () {
                                      Navigator.pushNamed(
                                          context, SettingsPage.id);
                                    },
                                  ),
                                  //Modify Profile
                                ],
                              ),
                            ), //Menu Drawer Options
                            SizedBox(
                                height: displayHeight(context) * 0.01,
                              ),
                              Container(
                                height: displayHeight(context) * 0.06,
                                width: displayWidth(context) * 0.6,
                                decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
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
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  appBar: AppBar(
                    toolbarHeight: displayHeight(context) * 0.1,
                    backgroundColor: Colors.grey.shade800,
                    leading: PerfilIconButton(),
                    title: Center(
                      child: Text(
                        'QBK',
                        style: kTitleTextStile(context)
                            .copyWith(fontSize: displayWidth(context) * 0.1),
                      ),
                    ),
                    actions: <Widget>[
                      PopupMenuQBK(
//TODO: Create send list and print list function
//TODO: Create a send gig and print gig option
                          ),
                    ],
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: displayHeight(context) * 0.7,
                                width: displayWidth(context) * 0.8,
                                color: Colors.white,
                                child: QBKCalendar(),
                              ), //Calendar
                            ],
                          ), //Calendar
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              NewGigButton(
                                text: 'New Gig',
                                color: Colors.green,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewGigPage(
                                            userName: userData.name)),
                                  );
                                },
                              ),
//TODO: implement Tour Button
//                        SizedBox(width: 70.0,),
//                        NewGigButton(text: 'New Tour',
//                          color: Colors.orange,
//                          onPressGoTo: NewTourPage.id,),
                            ],
                          ), //Buttons New Gig & New Tour
                        ],
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