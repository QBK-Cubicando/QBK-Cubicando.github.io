import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/copy_load_page.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/edit_case_popup.dart';
import 'package:qbk_simple_app/ab_created_widgets/popup_load_widget.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/services/global_variables.dart';
import 'package:qbk_simple_app/ui/base_widget.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

import 'package:qbk_simple_app/utilities/loading_widget.dart';

///Documentated

///CREATED CASES

class FlightCase {
  final String uidFlightCase;
  final String nameFlightCase;
  final String typeFlightCase;
  final int quantity;
  final bool wheels;
  final bool tilt;
  final bool stack;
  final String color;
  final String label;
  int index;
  bool loaded;

  FlightCase(
      {this.uidFlightCase,
      this.nameFlightCase,
      this.typeFlightCase,
      this.quantity,
      this.wheels,
      this.tilt,
      this.stack,
      this.index,
      this.loaded,
      this.color,
      this.label});
}

class FlightCaseOnList extends StatefulWidget {
  final List<FlightCase> flightCaseList;
  final FlightCase flightCase;
  final String userUid;
  final String uidGig;
  final String uidLoad;
  final int index;
  final bool isLoadPage;
  final String color;
  final String label;
  final String blocRowId;

  FlightCaseOnList(
      {Key key,
      this.flightCaseList,
      this.flightCase,
      this.userUid,
      this.uidGig,
      this.uidLoad,
      this.index,
      this.isLoadPage,
      this.color,
      this.label,
      this.blocRowId});

  @override
  _FlightCaseOnListState createState() => _FlightCaseOnListState();
}

class _FlightCaseOnListState extends State<FlightCaseOnList> {
  ///Function to set the case color
  Color _flightCaseListColor() {
    if (widget.flightCase.color == 'Red') {
      return kredQBK;
    } else if (widget.flightCase.color == 'Blue') {
      return kblueQBK;
    } else if (widget.flightCase.color == 'Green') {
      return kgreenQBK;
    } else if (widget.flightCase.color == 'Purple') {
      return kpurpleQBK;
    } else if (widget.flightCase.color == 'Orange') {
      return Colors.orangeAccent.shade200;
    } else {
      return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Checks if you are in Load Page or Create Load page
    return widget.isLoadPage
        ?

        ///LOAD PAGE WIDGET
        GestureDetector(
            onTap: () async {
              setState(() {
                bool loaded;
                if (idAndBlocRow.containsKey(widget.blocRowId)) {
                  loaded = false;
                } else {
                  loaded = true;
                }
                print(widget.blocRowId);

                Map<FlightCase, bool> temp = {};
                temp[widget.flightCase] = loaded;
                streamControllerFlightCase.add(temp);
                selectedBlocRowId = widget.blocRowId;
              });
              
            },
            child: FlightCaseOnLoadList(
              color: _flightCaseListColor(),
              flightCase: widget.flightCase,
              index: widget.flightCase.index,
            ),
          )
        :

        ///NO LOAD PAGE WIDGET
        FlightCaseOnLoadList(
            color: _flightCaseListColor(),
            flightCase: widget.flightCase,
            index: widget.index,
          );
  }
}

///LOAD & CREATE LOAD PAGE FLIGHT CASE WIDGET

class FlightCaseOnLoadList extends StatelessWidget {
  FlightCaseOnLoadList({this.color, this.flightCase, this.index});

  final Color color;
  final FlightCase flightCase;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.5),
      padding: EdgeInsets.all(3.0),
      height: displayHeight(context) * 0.15,
      width: displayWidth(context) * 0.225,
      decoration: BoxDecoration(
        
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$index:${flightCase.nameFlightCase}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: displayWidth(context) * 0.04),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              flightCase.wheels
                  ? Icon(
                      Icons.blur_circular,
                      size: displayWidth(context) * 0.055,
                    )
                  : SizedBox(
                      width: displayWidth(context) * 0.055,
                    ),
              flightCase.tilt
                  ? Icon(
                      Icons.file_upload,
                      size: displayWidth(context) * 0.055,
                    )
                  : SizedBox(
                      width: displayWidth(context) * 0.055,
                    ),
              flightCase.stack
                  ? Icon(
                      Icons.category,
                      size: displayWidth(context) * 0.055,
                    )
                  : SizedBox(
                      width: displayWidth(context) * 0.055,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

/// OWN CASES TILE WIDGET

class OwnCaseTile extends StatelessWidget {
  final FlightCase flightCase;
  final String uidGig;
  final String uidLoad;
  final List<FlightCase> flightCaseList;
  final bool isLoadPage;

  OwnCaseTile(
      {@required this.flightCase,
      this.uidGig,
      this.uidLoad,
      this.flightCaseList,
      this.isLoadPage});

  Color _flightCaseListColor() {
    if (flightCase.color == 'Red') {
      return kredQBK;
    } else if (flightCase.color == 'Blue') {
      return kblueQBK;
    } else if (flightCase.color == 'Green') {
      return kgreenQBK;
    } else if (flightCase.color == 'Purple') {
      return kpurpleQBK;
    } else if (flightCase.color == 'Orange') {
      return Colors.orangeAccent.shade200;
    } else {
      return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoadPage
        ?

        /// Load Page Own Case Tile
        GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                  height: displayHeight(context) * 0.1,
                  width: displayWidth(context) * 0.7,
                  decoration: BoxDecoration(
                      color: _flightCaseListColor(),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flightCase.nameFlightCase,
                          textAlign: TextAlign.center,
                          style:
                              kTextStyle(context)
                              .copyWith(color: Colors.black, fontSize: 25),
                        ),
                        Row(
                          children: [
                            flightCase.wheels
                                ? Icon(
                                    Icons.blur_circular,
                                    color: Colors.black,
                                    size: displayHeight(context) * 0.04,
                                  )
                                : SizedBox(
                                    height: displayHeight(context) * 0.04,
                                    width: displayHeight(context) * 0.04,
                                  ),
                            flightCase.tilt
                                ? Icon(
                                    Icons.file_upload,
                                    color: Colors.black,
                                    size: displayHeight(context) * 0.04,
                                  )
                                : SizedBox(
                                    height: displayHeight(context) * 0.04,
                                    width: displayHeight(context) * 0.04,
                                  ),
                            flightCase.stack
                                ? Icon(
                                    Icons.category,
                                    color: Colors.black,
                                    size: displayHeight(context) * 0.04,
                                  )
                                : SizedBox(
                                    height: displayHeight(context) * 0.04,
                                    width: displayHeight(context) * 0.04,
                                  )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return Container(
                    height: displayHeight(context) * 0.6,
                    width: displayWidth(context) * 0.7,
                    child: PopupOwnCases(
                      flightCase: flightCase,
                      title: flightCase.nameFlightCase,
                      uidGig: uidGig,
                      uidLoad: uidLoad,
                      flightCaseList: flightCaseList,
                    ),
                  );
                },
                barrierDismissible: false,
              );
            },
          )
        :

        /// My Cases Page Own case Tile

        ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 1),
              child: Container(
                  height: displayHeight(context) * 0.1,
                  width: displayWidth(context) * 0.7,
                  decoration: BoxDecoration(
                      color: _flightCaseListColor(),
                      ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flightCase.nameFlightCase,
                          textAlign: TextAlign.center,
                          style: kTextStyle(context).copyWith(
                              color: Colors.black,
                              fontSize: displayWidth(context) * 0.06),
                        ),
                        Row(
                          children: [
                            flightCase.wheels
                                ? Icon(
                                    Icons.blur_circular,
                                    color: Colors.black,
                                    size: displayHeight(context) * 0.04,
                                  )
                                : SizedBox(
                                    height: displayHeight(context) * 0.04,
                                    width: displayHeight(context) * 0.04,
                                  ),
                            flightCase.tilt
                                ? Icon(
                                    Icons.file_upload,
                                    color: Colors.black,
                                    size: displayHeight(context) * 0.04,
                                  )
                                : SizedBox(
                                    height: displayHeight(context) * 0.04,
                                    width: displayHeight(context) * 0.04,
                                  ),
                            flightCase.stack
                                ? Icon(
                                    Icons.category,
                                    color: Colors.black,
                                    size: displayHeight(context) * 0.04,
                                  )
                                : SizedBox(
                                    height: displayHeight(context) * 0.04,
                                    width: displayHeight(context) * 0.04,
                                  )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: displayHeight(context) * 0.6,
                      width: displayWidth(context) * 0.7,
                      child: EditCasePopup(
                        flightCase: flightCase,
                      ),
                    );
                  });
            },
          );
  }
}

/// OWN CASES LIST WIDGET

class OwnCaseTileList extends StatelessWidget {
  final String uidGig;
  final String uidLoad;
  final List<FlightCase> flightCaseList;
  final bool isLoadPage;

  OwnCaseTileList({
    @required this.uidGig,
    @required this.uidLoad,
    this.flightCaseList,
    this.isLoadPage,
  });

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<FlightCase>>(
        stream: DatabaseService(
          userUid: user.uid,
        ).ownCaseListData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            List<FlightCase> flightCaseOwnList = snapshot.data;

            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: flightCaseOwnList.length,
                itemBuilder: (context, index) {
                  return OwnCaseTile(
                    flightCase: flightCaseOwnList[index],
                    uidGig: uidGig,
                    uidLoad: uidLoad,
                    flightCaseList: flightCaseList,
                    isLoadPage: isLoadPage,
                  );
                });
          } else {
            return Center(child: Loading());
          }
        });
  }
}
