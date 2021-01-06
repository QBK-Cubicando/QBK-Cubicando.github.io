import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/popup_loads_of_gig.dart';

import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/edit_gig_popup.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';

///Documentated
class NewGig {
  final String uidGig;
  final String nameGig;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String notes;

  NewGig(
      {this.uidGig,
      this.nameGig,
      this.startDate,
      this.endDate,
      this.location,
      this.notes});
}

class NewGigTile extends StatelessWidget {
  final NewGig gig;
  final bool isCopyPage;
  final bool pending;

  /// JUST FOR COPY LOAD SCREEN
  final String uidThisGig;

  NewGigTile({this.gig, this.isCopyPage, this.uidThisGig, this.pending});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),

        child: isCopyPage == false
            ? ListTile(
                onLongPress: () {
                  if(!pending){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditGigPopup(
                          uidGig: gig.uidGig,
                          nameGig: gig.nameGig,
                          startDate: gig.startDate,
                          endDate: gig.endDate,
                          location: gig.location,
                          notes: gig.notes ?? '',
                        );
                      });}
                },
                onTap: (){

                  if(pending){
                    showDialog(context: context,
                      builder: (context){
                        return Container(
                        height: displayHeight(context) * 0.6,
                        width: displayWidth(context) * 0.8,
                        child: AlertDialog(
                          title: Center(
                              child: Text(
                            'Do you accept this Gig?',
                            style: kTextStyle(context).copyWith(
                                color: Colors.black,
                                fontSize: displayWidth(context) * 0.05),
                          )),
                          actions: <Widget>[
                            SelectionButton(
                              text: 'No',
                              color: Colors.redAccent,
                              onPress: () async {
                                await DatabaseService(
                                      userUid: user.uid,
                                      uidGig: gig.uidGig,
                                      uidCrewGig: user.uid,
                                      crewMemberData: user.uid,
                                      isCrewPage: true)
                                  .gigDeleteCrewMember();
                                Navigator.pop(context);
                              },
                            ),
                            SelectionButton(
                              text: 'Yes',
                              color: Colors.greenAccent,
                              onPress: () async {
                                ///Accepting Gig
                                    await Firestore.instance
                                    .collection('gigs')
                                    .document(gig.uidGig)
                                    .updateData({
                                      '${user.uid}': true,
                                    });

                                    ///Set the CalendarGig info to firebase
                                    await DatabaseService(
                                      userUid: user.uid,
                                    ).setCalendarGigData(
                                      uidGig: gig.uidGig,
                                      nameGig: gig.nameGig,
                                      startDate: gig.startDate,
                                      endDate: gig.endDate,     
                                    );
                                    Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                      });}

                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      gig.nameGig.length > 10
                          ? gig.nameGig.substring(0, 10)
                          : gig.nameGig,
                      style: kTextStyle(context).copyWith(color: Colors.black),
                    ),
                    Text(
                      gig.location.length > 10
                          ? gig.location.substring(0, 9)
                          : gig.location,
                      style: kTextStyle(context).copyWith(color: Colors.black),
                    ),
                  ],
                ),
                subtitle: gig.startDate == gig.endDate
                    ? Text(
                        DateFormat('yyyy-MM-dd').format(gig.startDate),
                        style: kTextStyle(context)
                            .copyWith(color: Colors.black), //Todo:Reducir Font
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DateFormat('yyyy-MM-dd').format(gig.startDate),
                            style: kTextStyle(context).copyWith(
                                color: Colors.black), //Todo:Reducir Font
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(gig.endDate),
                            style: kTextStyle(context).copyWith(
                                color: Colors.black), //Todo:Reducir Font
                          )
                        ],
                      ),
              )
            :

            /// NewGigTile NO Copy

            ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PopupLoadsOfGig(
                          uidGig: gig.uidGig,
                          isCopyPage: isCopyPage,
                          uidThisGig: uidThisGig,
                        );
                      });
                  //TODO: Navigator.pop this when finish
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      gig.nameGig,
                      style: kTextStyle(context).copyWith(color: Colors.black),
                    ),
                    Text(
                      gig.location,
                      style: kTextStyle(context)
                          .copyWith(color: Colors.black), //Todo:Reducir Font
                    ),
                  ],
                ),
                subtitle: gig.startDate == gig.endDate
                    ? Text(
                        DateFormat('yyyy-MM-dd').format(gig.startDate),
                        style: kTextStyle(context)
                            .copyWith(color: Colors.black), //Todo:Reducir Font
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DateFormat('yyyy-MM-dd').format(gig.startDate),
                            style: kTextStyle(context).copyWith(
                                color: Colors.black), //Todo:Reducir Font
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(gig.endDate),
                            style: kTextStyle(context).copyWith(
                                color: Colors.black), //Todo:Reducir Font
                          )
                        ],
                      ),
              ),

        /// NewGigTile for Copy
      ),
    );
  }
}

class GigList extends StatefulWidget {
  final bool isCopyLoad;
  final bool sharedGigs;
  final bool pending;

  /// ONLY FOR COPY LOAD PAGE
  final String uidThisGig;

  GigList({this.isCopyLoad, this.sharedGigs, this.uidThisGig, this.pending});

  @override
  _GigListState createState() => _GigListState();
}

class _GigListState extends State<GigList> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    try {
      return StreamBuilder<List<NewGig>>(
          stream: DatabaseService(
                  userUid: user.uid,
                  sharedGigs: widget.sharedGigs,
                  crewMemberData: user.uid,
                  pending: widget.pending)
              .gigList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
            }

            if (snapshot.hasData) {
              List<NewGig> gigs = snapshot.data;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: gigs.length,
                itemBuilder: (context, index) {
                  return NewGigTile(
                    gig: gigs[index],
                    isCopyPage: widget.isCopyLoad,
                    uidThisGig: widget.uidThisGig,
                    pending: widget.pending,
                  );
                },
              );
            } else {
              return Loading();
            }
          });
    } catch (e) {
      print(e);
      return Container(color: Colors.black, child: Loading());
    }
  }
}
