import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/models/BlocRow.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/services/global_variables.dart';

import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/ab_created_widgets/a_buttons/load_selection_button_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/popup_load_widget.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:reorderables/reorderables.dart';

import '../../ui/sizes-helpers.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'dart:async';

//TODO: Collapse Bloc Rows



///Documentated
class CreateLoadPage extends StatefulWidget {
  static const String id = 'create_load_page';

  CreateLoadPage(
      {@required this.uidGig, this.nameGig, this.uidLoad, this.nameLoad});

  final String uidGig;
  final String nameGig;
  final String uidLoad;
  final String nameLoad;

  @override
  _CreateLoadPageState createState() => _CreateLoadPageState();
}

class _CreateLoadPageState extends State<CreateLoadPage> {
  ///List of flightCases first time you create a load
  ///and there is nothing to fetch from firebase
  ///and also the list to work with OFFLINE
  List<FlightCase> flightCaseCreateList = [];

  Map<String, List<FlightCase>> totalFlightCaseLists = {};
  List<BlocRow> blocRowList = [];

  Map<String, int> idAndBlocRow = {};
  Color color = Colors.grey.shade500;

  final Stream<int> streamBlocRow = streamControllerBlocRow.stream;

  ///List of cases fetched from firebase
  Future<List<FlightCase>> flightCaseFetchedList;
  Future<List<BlocRow>> blocRowFetchedList;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    streamBlocRow.listen((event) {
      mySetStateBlocRow(event);
    });

    blocRowFetchedList =
        DatabaseService(uidLoad: widget.uidLoad).getLoadListOncePRUEBA();

    _fetchBlocRowListFromFirebase();
  }

  void mySetStateBlocRow(int event) {
    // setState(() {});
  }

  ///Fetch the list of cases from firebase and set it to OFFLINE list of cases

  _fetchBlocRowListFromFirebase() async {
    if (blocRowFetchedList != null) {
      int i = 1;
      blocRowList = await blocRowFetchedList;
      // Assign Strem to every BlocRow
      blocRowList.forEach((element) {
        element.stream = streamControllerBlocRow.stream;
        element.isLoadPage = false;
        idAndBlocRow[element.id] = i;
        i += 1;
        totalFlightCaseLists[element.id] = element.flightCaseList;
      });
    } else {
      blocRowList = [];
    }

    setState(() {});
  }

  createFlightCaseListForBlockRow(String id) {
    totalFlightCaseLists[id] = [];
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) async {
      blocRowList.insert(newIndex, blocRowList.removeAt(oldIndex));
      streamControllerBlocRow.add(idAndBlocRow[selectedBlocRowId]);
      setState(() {});
    }

    var wrap = ReorderableWrap(
      alignment: WrapAlignment.center,
      maxMainAxisCount: 1,
      spacing: 15.0,
      runSpacing: 4.0,
      padding: const EdgeInsets.all(8),
      children: blocRowList,
      onReorder: _onReorder,
      onNoReorder: (int index) {
        //this callback is optional
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
      },
    );

    var buttonBar = Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.bottomLeft,
      color: Colors.grey.shade600,
      height: displayHeight(context) * 0.09,
      width: displayWidth(context) * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
              child: Text(
            'BLOCK ROW',
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
          Row(
            children: [
              FloatingActionButton(
                  child: Icon(Icons.remove),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    setState(() {
                      blocRowList.removeLast();
                      streamControllerBlocRow
                          .add(idAndBlocRow[selectedBlocRowId]);
                    });
                  }),
              SizedBox(
                width: displayWidth(context) * 0.1,
              ),
                  FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    String id = randomAlphaNumeric(5);
                    idAndBlocRow[id] = idAndBlocRow.length + 1;
                    createFlightCaseListForBlockRow(id);
                    blocRowList.add(BlocRow(
                        isLoadPage: false,
                        index: idAndBlocRow[id],
                        isCrica: false,
                        id: id,
                        stream: streamControllerBlocRow.stream,
                        flightCaseList: totalFlightCaseLists[id]));
                    setState(() {});
                  }),
            ],
          ),
          
        ],
      ),
    );

    var column = SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        wrap,
        buttonBar,
      ]),
    );

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      
      drawer: SafeArea(
        child: Container(
          width: double.infinity,
          child: Drawer(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 15, 5, 15),
                child: Center(
                  child: Container(
                    width: displayWidth(context),
                    child: Column(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            
                            SizedBox(
                              height: 8,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                width: displayWidth(context) * 0.85,
                                height: displayHeight(context) * 0.06,
                                color: kyellowQBK,
                                child: Text(
                                  'Block Row $selectedBlockRowIndex',
                                  textAlign: TextAlign.center,
                                  style: kTextStyle(context)
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            child: Container(
                              height: displayHeight(context) * 0.07,
                              width: displayWidth(context) * 0.42,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Text(
                                  'NEW CASE',
                                  style: kTextStyle(context).copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              final updatedList = await showDialog(
                                context: context,
                                builder: (context) {
                                  return PopupCreateLoad(
                                    title: 'Own',
                                    uidGig: widget.uidGig,
                                    uidLoad: widget.uidLoad,
                                    flightCaseList:
                                        totalFlightCaseLists[selectedBlocRowId],
                                  );
                                },
                                barrierDismissible: false,
                              );
                              setState(() =>
                                  totalFlightCaseLists[selectedBlocRowId] =
                                      updatedList);
                            },
                          ),
                        ),
                        
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: OwnCaseTileList(
                            uidGig: widget.uidGig,
                            uidLoad: widget.uidLoad,
                            flightCaseList:
                                totalFlightCaseLists[selectedBlocRowId],
                            isLoadPage: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SelectionButton(
                            text: 'SAVE',
                            color: kyellowQBK,
                            onPress: () {
                              _scaffoldKey.currentState.openEndDrawer();
                              streamControllerBlocRow
                                  .add(idAndBlocRow[selectedBlocRowId]);
                              setState(() {});
                            },
                            height: displayHeight(context) * 0.07,
                            width: displayWidth(context) * 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) => KeyboardAvoider(
            autoScroll: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //              TextFieldQBK(
                ////TODO: Make that you can search any flight case you previously created
                //                icon: Icons.search,
                //                hintText: '  What you\'re looking for?',
                //              ),//Searching
                
                    Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin:
                        EdgeInsets.only(right: displayWidth(context) * 0.04),
                    width: 100,
                    height: 50,
                    child: Image.asset('images/letras_qbk.png'),
                  ),
                ),
                 
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //TODO CRIKA
                    GestureDetector(
                      child: Container(
                        height: displayHeight(context) * 0.08,
                        width: displayWidth(context) * 0.45,
                        color: Colors.grey.shade400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'CRICA',
                              style: kTextStyle(context)
                                  .copyWith(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              size: 35,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        String id = randomAlphaNumeric(5);
                        idAndBlocRow[id] = idAndBlocRow.length + 1;
                        createFlightCaseListForBlockRow(id);
                        blocRowList.add(BlocRow(
                            stream: streamControllerBlocRow.stream,
                            isLoadPage: false,
                            index: blocRowList.length + 1,
                            isCrica: true,
                            id: id,
                            loaded: false,
                            flightCaseList: []));
                        setState(() {});
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: displayHeight(context) * 0.08,
                        width: displayWidth(context) * 0.45,
                        color: Colors.grey.shade400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'CASE',
                              style: kTextStyle(context).copyWith(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              size: 35,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (selectedBlockRowIndex != null) {
                            Scaffold.of(context).openDrawer();
                          }
                        });
                      },
                    ),
                    //New Custom
                  ],
                ), //Buttons New cases
                SizedBox(
                  height: 8.0,
                ),
                SingleChildScrollView(
                  child: Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(3),
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: displayWidth(context),
                      color: Colors.grey,
                      child: column),
                ),
                SizedBox(
                  height: 8.0,
                ),

                Container(
                  width: displayWidth(context) * 0.85,
                  alignment: Alignment.centerRight,
                  child: SelectionButton(
                    text: 'SAVE',
                    width: displayWidth(context) * 0.3,
                    color: kyellowQBK,
                    onPress: () async {
                      int indexCase = 1;
                      int indexBlocRow = 1;
                      Map<String, int> temp = {};

                      // Reassign indexes of bloc Rows
                      blocRowList.forEach((e) {
                        temp[e.id.toString()] = indexBlocRow;
                        indexBlocRow += 1;
                      });

                      idAndBlocRow = temp;

                      // Reassign indexes of Cases
                      totalFlightCaseLists.forEach((key, value) {
                        List<FlightCase> flightCaseList = value;

                        for (FlightCase flightCase in flightCaseList) {
                          flightCase.index = indexCase;
                          indexCase++;
                        }
                      });

                      ///Set the OFFLINE list of cases to firebase
                      await DatabaseService(uidLoad: widget.uidLoad)
                          .updateNewLoadListDataPRUEBA(
                        loadName: widget.nameLoad,
                        mapOfFlightCasesOnList: totalFlightCaseLists,
                        listBlocRow: blocRowList,
                        flightCasesLoaded: 0,
                        idAndBlockRow: idAndBlocRow,
                      );

                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(
                  height: 5.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///The DragTarget for the cases that are meant to be erased
class BinForFlightCases extends StatefulWidget {
  final List<FlightCase> list;

  BinForFlightCases({this.list});

  @override
  _BinForFlightCasesState createState() => _BinForFlightCasesState();
}

class _BinForFlightCasesState extends State<BinForFlightCases> {
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, List<int> data, rj) {
        bool _isDeletingCase = false;

        data.isNotEmpty ? _isDeletingCase = true : _isDeletingCase = false;

        return Container(
          color:
              _isDeletingCase == true ? Colors.red : Colors.redAccent.shade100,
          height: 50,
          width: 10,
          child: Icon(
            Icons.delete_forever,
            size: 50,
          ),
        );
      },
      onAccept: (data) {
        try {
          widget.list.removeAt(data);
        } catch (e) {}

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    );
  }
}
