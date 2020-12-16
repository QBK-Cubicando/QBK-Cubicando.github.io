import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

//TODO: When you edit a gig's date this page should refresh and show the new date

///READ but not Documentated
class MyGigs extends StatefulWidget {
  static const String id = 'my_gigs';
  @override
  _MyGigsState createState() => _MyGigsState();
}

class _MyGigsState extends State<MyGigs> {
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
                  text: 'My Gigs',
                  onBackGoTo: QBKHomePage(),
                  body: snapshot.data.length != 0
                      ? GigList(
                          isCopyLoad:
                              false, //Bool indicates that this is not Copy Load Page
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                child: Text(
                                  'No Gigs created yet !',
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
