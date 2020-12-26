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
          stream: DatabaseService(
                  userUid: user.uid,
                  sharedGigs: false,
                  crewMemberData: user.uid)
              .gigList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              return UpperBar(
                  text: 'My Gigs',
                  onBackGoTo: QBKHomePage(),
                  body: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: displayWidth(context),
                            height: displayHeight(context) * 0.50,
                            child: snapshot.data.length != 0
                                ? GigList(
                                    sharedGigs: false,
                                    isCopyLoad:
                                        false, //Bool indicates that this is not Copy Load Page
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          width: displayWidth(context) * 0.9,
                                          child: Center(
                                            child: Text(
                                              'No Gigs created yet !',
                                              style: kTextStyle(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: displayHeight(context) * 0.08,
                              child: Text(
                                'Shared with you',
                                style: kTextStyle(context),
                              ),
                            ),
                          ),
                          Container(
                            width: displayWidth(context),
                            height: displayHeight(context) * 0.3,
                            child: GigList(
                              sharedGigs: true,
                              isCopyLoad:
                                  false, //Bool indicates that this is not Copy Load Page
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            } else {
              return Loading();
            }
          });
    } catch (e) {
      // print(e);
      return Center(child: Loading());
    }
  }
}
