import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

//TODO: When you edit a case this page should refresh and show the new date

///READ but not Documentated
class MyCases extends StatefulWidget {
  static const String id = 'my_cases';
  @override
  _MyCasesState createState() => _MyCasesState();
}

class _MyCasesState extends State<MyCases> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return StreamBuilder<List<FlightCase>>(
        stream: DatabaseService(userUid: user.uid).ownCaseListData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            return UpperBar(
                text: 'My Cases',
                onBackGoTo: QBKHomePage(),
                body: snapshot.data.length != 0
                    ? OwnCaseTileList(
                        isLoadPage: false,
                      )
                    : UpperBar(
                        text: 'My Gigs',
                        onBackGoTo: QBKHomePage(),
                        body: Column(
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
                        )));
          } else {
            return Center(child: Loading());
          }
        });
  }
}
