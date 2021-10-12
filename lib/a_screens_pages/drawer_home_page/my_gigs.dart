import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/notification_stack.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

//TODO: Pending Gigs width double infinity remove.
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
              return DefaultTabController(
                
                length: 2,
                child: SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Container(),
                        backgroundColor: Colors.black,
                        automaticallyImplyLeading: false,
                        flexibleSpace: TabBar(
                          indicator: BoxDecoration(
                              color: kgreenQBK,
                              borderRadius: BorderRadius.circular(30)),
                          tabs: [
                            Center(
                              child: Text(
                                'My GIGS',
                                style: kTextStyle(context),
                              ),
                            ),
                            NotificationStack(
                              userUid: user.uid,
                              notificationType: 'gigs',
                              icon: Container(
                                width: double.infinity,
                                child: Text(
                                  'Pending',
                                  textAlign: TextAlign.center,
                                  style: kTextStyle(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: Container(
                        // color: Colors.white,
                        child: TabBarView(
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      width: displayWidth(context),
                                      height: displayHeight(context) * 0.50,
                                      child: snapshot.data.length != 0
                                          ? GigList(
                                              sharedGigs: false,
                                              isCopyLoad: false,
                                              pending:
                                                  false, //Bool indicates that this is not Copy Load Page
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child: Container(
                                                    width:
                                                        displayWidth(context) *
                                                            0.9,
                                                    child: Center(
                                                      child: Text(
                                                        'No Gigs created yet !',
                                                        style:
                                                            kTextStyle(context),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      height: displayHeight(context) * 0.08,
                                      child: Text(
                                        'Shared with you',
                                        style: kTextStyle(context).copyWith(
                                            fontSize:
                                                displayWidth(context) * 0.07),
                                      ),
                                    ),
                                    Container(
                                      width: displayWidth(context),
                                      height: displayHeight(context) * 0.3,
                                      child: GigList(
                                        sharedGigs: true,
                                        isCopyLoad:
                                            false, //Bool indicates that this is not Copy Load Page
                                        pending: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                width: displayWidth(context) * 0.85,
                                height: displayHeight(context) * 0.7,
                                child: GigList(
                                  sharedGigs: true,
                                  isCopyLoad:
                                      false, //Bool indicates that this is not Copy Load Page
                                  pending: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
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
