import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/load_selection_button_widget.dart';
import 'package:qbk_simple_app/models/flight_case.dart';

import '../ui/sizes-helpers.dart';
import '../ui/sizes-helpers.dart';

///Documentated
class LoadPage extends StatefulWidget {
  static const String id = 'load_page';

  LoadPage({@required this.uidGig, this.nameGig, this.uidLoad});

  final String uidGig;
  final String nameGig;
  final String uidLoad;

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

  ScrollController _scrollController = ScrollController();

  ///When loading finishes firebase should be reset (All cases loaded false)
  _resetAndExit() {
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
    if (flightCaseFetchedList != null) {
      flightCaseTotalList = await flightCaseFetchedList;
    } else {
      flightCaseTotalList = [];
    }
    setState(() {});
  }

  ///When start the load fetch a list and make it offline
  _setFlightCaseLists() {
    if (init == true) {
      _createLoadedList();
      _createNotLoadedList();
    }
  }

  @override
  void initState() {
    super.initState();

    flightCaseFetchedList =
        DatabaseService(uidLoad: widget.uidLoad).getLoadListOnce();

    _fetchLoadListFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    _setFlightCaseLists();

    int casesLoaded = 0;
    int casesLeft = 0;
    int totalCases = flightCaseTotalList.length;

    _percentFlightCasesLeft() {
      double percent = flightCaseLoadedList.length * 100 / totalCases;
      return percent.roundToDouble();
    }

    return UpperBar(
      text: widget.nameGig ?? 'Load Page',
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                padding: EdgeInsets.all(5),
                width: displayWidth(context) * 0.95,
                color: Colors.grey,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  controller: _scrollController,
                  children: List.generate(
                      flightCaseLoadedList.length,
                      (index) => GestureDetector(
                            key: ValueKey(index),
                            onTap: () {
                              _loadOrUnloadFlightCase(
                                  flightCaseLoadedList[index]);
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                            },
                            child: FlightCaseOnList(
                              flightCaseList: flightCaseLoadedList,
                              flightCase: flightCaseLoadedList[index],
                              index: flightCaseLoadedList[index].index,
                              isLoadPage: true,
                            ),
                          )),
                ),
              ),

              //TODO: ESTO SERA la imagen de una crika que se va cerrando
              // TODO: y en medio un botón de reload para que se recargue la página y revise la carga de firbase
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: displayWidth(context) * 0.95,
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                      child: Text(
                    '${_percentFlightCasesLeft()} %',
                    style: kTextStyle(context).copyWith(color: Colors.black),
                  )),
                ),
              ),

              Column(
                children: <Widget>[
                  Container(
                    width: displayWidth(context) * 0.95,
                    height: MediaQuery.of(context).size.height * 0.60,
                    padding: EdgeInsets.fromLTRB(
                        4, 4, displayWidth(context) * 0.04, 4),
                    color: Colors.grey,
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 8,
                      children: List.generate(
                          flightCaseNotLoadedList.length,
                          (index) => GestureDetector(
                                key: ValueKey(index),
                                onTap: () {
                                  _loadOrUnloadFlightCase(
                                      flightCaseNotLoadedList[index]);
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                },
                                child: FlightCaseOnList(
                                  flightCaseList: flightCaseNotLoadedList,
                                  flightCase: flightCaseNotLoadedList[index],
                                  index: flightCaseNotLoadedList[index].index,
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
                          .copyWith(color: Colors.black), //TODO: Ampliar Font
                    ),
                    width: displayWidth(context) * 0.85,
                    color: Colors.green,
                    onPressed: () {
                      ///Reads and Organizes the loaded and unloaded cases in different lists to check them.
                      for (FlightCase element in flightCaseTotalList) {
                        element.loaded == true ? casesLoaded++ : casesLeft++;
                      }

                      ///Checks if all cases are loaded
                      if (casesLoaded == totalCases && casesLeft == 0) {
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
                                      .copyWith(color: Colors.black),
                                )),
                                actions: <Widget>[
                                  SelectionButton(
                                    text: 'Cancel',
                                    color: Colors.blueAccent,
                                    onPress: () => Navigator.pop(context),
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
  }
}
