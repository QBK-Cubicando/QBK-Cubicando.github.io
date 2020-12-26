import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/load_selection_button_widget.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';

import '../ui/sizes-helpers.dart';

///Documentated
class LoadPage extends StatefulWidget {
  static const String id = 'load_page';

  LoadPage(
      {@required this.uidGig, this.nameGig, this.uidLoad, this.permission});

  final String uidGig;
  final String nameGig;
  final String uidLoad;
  final String permission;

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  ///The list of all cases OFFLINE
  List<FlightCase> flightCaseTotalList = [];

  ///The list of loaded cases
  List<FlightCase> flightCaseLoadedList = [];

  ///The List of NOT loaded cases
  List<FlightCase> flightCaseNotLoadedList = [];

  ///The list of all cases fetched from firebase
  Future<List<FlightCase>> flightCaseFetchedList;

  bool init = true; //Bool that indicates the load has begun

  int casesLoaded = 0;
  int casesLeft = 0;
  bool refresh = false;
  int fetchedLoadedCasesLength = 0;

  ScrollController _scrollController = ScrollController();

  ///When loading finishes firebase should be reset (All cases loaded false)
  _resetAndExit() async {
    var i = 1;
    flightCaseTotalList = flightCaseLoadedList + flightCaseNotLoadedList;
    for (FlightCase element in flightCaseTotalList) {
      element.loaded = false;
      element.index = i;
      i++;
    }

    await DatabaseService(uidLoad: widget.uidLoad).updateNewLoadListData(
      flightCasesOnList: flightCaseTotalList,
      flightCasesLoaded: 0,
    );

    Navigator.pop(context);
  }

  ///Create a OFFLINE list of LOADED flightCases from firebase to work with
  _createLoadedList() {
    for (FlightCase flightCase in flightCaseTotalList) {
      if (flightCase.loaded == true) {
        flightCaseLoadedList.add(flightCase);
      }
    }
    setState(() {});
  }

  ///Create a OFFLINE list of NOT LOADED flightCases from firebase to work with
  _createNotLoadedList() {
    for (FlightCase flightCase in flightCaseTotalList) {
      if (flightCase.loaded == false) {
        flightCaseNotLoadedList.add(flightCase);
      }
    }
    setState(() {});
  }

  ///Load or unload cases OFFLINE
  _loadOrUnloadFlightCase(FlightCase flightCase) {
    init = false;

    if (flightCase.loaded == false) {
      flightCaseLoadedList.add(flightCase);
      flightCaseNotLoadedList.remove(flightCase);
      flightCase.loaded = true;
    } else {
      flightCaseNotLoadedList.add(flightCase);
      flightCaseLoadedList.remove(flightCase);
      flightCase.loaded = false;
    }

    setState(() {});
  }

  ///Fetch a list of loaded and unloaded cases from firebase
  _fetchLoadListFromFirebase() async {
    flightCaseFetchedList =
        DatabaseService(uidLoad: widget.uidLoad).getLoadListOnce();
    if (flightCaseFetchedList != null) {
      flightCaseTotalList = await flightCaseFetchedList;

      await _setFlightCaseLists();
    } else {
      flightCaseTotalList = [];
    }
    setState(() {});

    //TODO: Remove in the next update
    ///Just to update the loads that don't have total case option
    try {
      if (init = true) {
        Firestore.instance
            .collection('loads')
            .document(widget.uidLoad)
            .updateData({
          'totalCases': flightCaseTotalList.length,
          'loadedCases': flightCaseLoadedList.length == null
              ? 0
              : flightCaseLoadedList.length,
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  ///When start the load fetch a list and make it offline
  _setFlightCaseLists() {
    if (init == true) {
      _createLoadedList();
      _createNotLoadedList();
    }
  }

  ///Checks if firebase load is larger and replaces it
  _refreshLoad() async {
    print('fetched:$fetchedLoadedCasesLength');
    print('loaded:${flightCaseLoadedList.length}');

    if (fetchedLoadedCasesLength < flightCaseLoadedList.length &&
        fetchedLoadedCasesLength != flightCaseTotalList.length) {
      flightCaseTotalList = flightCaseLoadedList + flightCaseNotLoadedList;
      // print('total:$flightCaseTotalList');
      await DatabaseService(uidLoad: widget.uidLoad).updateNewLoadListData(
        flightCasesOnList: flightCaseTotalList,
        flightCasesLoaded: flightCaseLoadedList.length,
      );
      await Firestore.instance
          .collection('loads')
          .document(widget.uidLoad)
          .updateData({'refresh': true});
    } else if ((fetchedLoadedCasesLength > flightCaseLoadedList.length &&
            fetchedLoadedCasesLength != flightCaseTotalList.length) ||
        fetchedLoadedCasesLength == flightCaseTotalList.length) {
      flightCaseLoadedList.clear();
      flightCaseNotLoadedList.clear();
      _fetchLoadListFromFirebase();

      await Firestore.instance
          .collection('loads')
          .document(widget.uidLoad)
          .updateData({'refresh': false});
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchLoadListFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    int totalCases = flightCaseTotalList.length;

    _percentFlightCasesLeft() {
      double percent = flightCaseLoadedList.length * 100 / totalCases;
      return percent.roundToDouble();
    }

    try {
      return StreamBuilder(
          stream: DatabaseService(userUid: user.uid, uidLoad: widget.uidLoad)
              .refreshLoad,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              fetchedLoadedCasesLength = snapshot.data['loadedCases'];

              return StreamBuilder(
                  stream: DatabaseService(
                          userUid: user.uid, uidLoad: widget.uidLoad)
                      .refreshLoad,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }

                    if (snapshot.hasData) {
                      refresh = snapshot.data['refresh'];
                      if (refresh == true) {
                        Timer(Duration(milliseconds: 500), () {
                          _refreshLoad();
                        });
                      }
                      return UpperBar(
                        text: widget.nameGig ?? 'Load Page',
                        body: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  padding: EdgeInsets.all(5),
                                  width: displayWidth(context) * 0.95,
                                  color: Colors.grey,
                                  child: GridView.count(
                                    childAspectRatio: 0.7,
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    controller: _scrollController,
                                    children: List.generate(
                                        flightCaseLoadedList.length,
                                        (index) => GestureDetector(
                                              key: ValueKey(index),
                                              onTap: () {
                                                if (widget.permission ==
                                                    'Admin') {
                                                  _loadOrUnloadFlightCase(
                                                      flightCaseLoadedList[
                                                          index]);
                                                  _scrollController.jumpTo(
                                                      _scrollController.position
                                                          .maxScrollExtent);
                                                }
                                              },
                                              child: FlightCaseOnList(
                                                flightCaseList:
                                                    flightCaseLoadedList,
                                                flightCase:
                                                    flightCaseLoadedList[index],
                                                index:
                                                    flightCaseLoadedList[index]
                                                        .index,
                                                isLoadPage: true,
                                              ),
                                            )),
                                  ),
                                ),

                                //TODO: ESTO SERA la imagen de una crika que se va cerrando
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width: displayWidth(context) * 0.95,
                                  color: Colors.blueAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_percentFlightCasesLeft()} %',
                                          style: kTextStyle(context)
                                              .copyWith(color: Colors.black),
                                        ),
                                        LoadSelectionButton(
                                          text: Text(
                                            'Refresh',
                                            style: kTextStyle(context)
                                                .copyWith(color: Colors.black),
                                          ),
                                          onPressed: () async {
                                            if (fetchedLoadedCasesLength <
                                                flightCaseTotalList.length) {
                                              await Firestore.instance
                                                  .collection('loads')
                                                  .document(widget.uidLoad)
                                                  .updateData(
                                                      {'refresh': true});

                                              _refreshLoad();
                                            }
                                          },
                                        )
                                      ],
                                    )),
                                  ),
                                ),

                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: displayWidth(context) * 0.95,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.60,
                                      padding: EdgeInsets.fromLTRB(4, 4,
                                          displayWidth(context) * 0.04, 4),
                                      color: Colors.grey,
                                      child: GridView.count(
                                        childAspectRatio: 0.7,
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 8,
                                        children: List.generate(
                                            flightCaseNotLoadedList.length,
                                            (index) => GestureDetector(
                                                  key: ValueKey(index),
                                                  onTap: () {
                                                    if (widget.permission ==
                                                        'Admin') {
                                                      _loadOrUnloadFlightCase(
                                                          flightCaseNotLoadedList[
                                                              index]);
                                                      _scrollController.jumpTo(
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent);
                                                    }
                                                  },
                                                  child: FlightCaseOnList(
                                                    flightCaseList:
                                                        flightCaseNotLoadedList,
                                                    flightCase:
                                                        flightCaseNotLoadedList[
                                                            index],
                                                    index:
                                                        flightCaseNotLoadedList[
                                                                index]
                                                            .index,
                                                    isLoadPage: true,
                                                  ),
                                                )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    LoadSelectionButton(
                                      text: Text(
                                        'Done',
                                        style: kTextStyle(context)
                                            .copyWith(color: Colors.black),
                                      ),
                                      width: displayWidth(context) * 0.85,
                                      color: Colors.green,
                                      onPressed: () {
                                        ///Reads and Organizes the loaded and unloaded cases in different lists to check them.
                                        for (FlightCase element
                                            in flightCaseTotalList) {
                                          element.loaded == true
                                              ? casesLoaded++
                                              : casesLeft++;
                                        }

                                        ///Checks if all cases are loaded
                                        if (casesLoaded == totalCases &&
                                            casesLeft == 0) {
                                          _resetAndExit();
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Center(
                                                      child: Text(
                                                    '''Not all flight cases are loaded yet!
                                                         Do you want to continue?''',
                                                    textAlign: TextAlign.center,
                                                    style: kTextStyle(context)
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  )),
                                                  actions: <Widget>[
                                                    SelectionButton(
                                                      text: 'Cancel',
                                                      color: Colors.blueAccent,
                                                      onPress: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ), //Cancel Button
                                                    SelectionButton(
                                                      text: 'Exit',
                                                      color: Colors.redAccent,
                                                      onPress: () {
                                                        Navigator.pop(context);
                                                        _resetAndExit();
                                                      },
                                                    ), //Exit Button
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  });
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
