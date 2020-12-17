import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///READ but not Documentated
class MyFriends extends StatefulWidget {
  static const String id = 'my_friends';
  @override
  _MyFriendsState createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    try {
      return StreamBuilder<List<NewGig>>(
          stream: DatabaseService(userUid: user.uid).gigList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              return UpperBar(
                  text: 'My Friends',
                  onBackGoTo: QBKHomePage(),
                  body: snapshot.data.length != 0
                      ? Center(
                          child: Container(
                            width: displayWidth(context),
                            color: Colors.red,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: displayWidth(context) * 0.9,
                                child: Text(
                                  'No Friends added yet !',
                                  style: kTextStyle(context),
                                ),
                              ),
                            ),
                          ],
                        ));
            } else {
              return Loading();
            }
          });
    } catch (e) {
      return Center(child: Loading());
      print(e);
    }
  }
}
