import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

import 'package:qbk_simple_app/ab_created_widgets/a_buttons/load_selection_button_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/popup_load_widget.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:reorderables/reorderables.dart';

import '../../ui/sizes-helpers.dart';
import 'package:boardview/boardview.dart';

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

  ///List of cases fetched from firebase
  Future<List<FlightCase>> flightCaseFetchedList;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    flightCaseFetchedList =
        DatabaseService(uidLoad: widget.uidLoad).getLoadListOnce();

    _fetchLoadListFromFirebase();
  }

  ///Fetch the list of cases from firebase and set it to OFFLINE list of cases
  _fetchLoadListFromFirebase() async {
    if (flightCaseFetchedList != null) {
      flightCaseCreateList = await flightCaseFetchedList;
    } else {
      flightCaseCreateList = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade800,
        title: Center(
          child: Text(
            widget.nameGig ?? 'Create Load',
            style: kTitleTextStile(context),
          ),
        ),
      ),
      drawer: SafeArea(
        child: Container(
          width: double.infinity,
          child: Drawer(
            child: Container(
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 15, 5, 15),
                child: Center(
                  child: Container(
                    width: displayWidth(context),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Text(
                                'My Cases',
                                textAlign: TextAlign.center,
                                style: kButtonsTextStyle(context),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            LoadSelectionButton(
                              text: Text(
                                'Update & Close',
                                textAlign: TextAlign.center,
                                style: kTextStyle(context)
                                    .copyWith(color: Colors.black),
                              ),
                              color: CupertinoColors.activeGreen,
                              onPressed: () {
                                _scaffoldKey.currentState.openEndDrawer();
                                setState(() {});
                              },
                              height: displayHeight(context) * 0.15,
                              width: displayWidth(context) * 0.3,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        LoadSelectionButton(
                          text: Text(
                            'New Own Case',
                            style: kTextStyle(context).copyWith(
                              color: Colors.black,
                            ),
                          ),
                          color: Colors.grey.shade400,
                          height: displayHeight(context) * 0.07,
                          width: displayWidth(context) * 0.5,
                          onPressed: () async {
                            final updatedList = await showDialog(
                              context: context,
                              builder: (context) {
                                return PopupCreateLoad(
                                  title: 'Own',
                                  uidGig: widget.uidGig,
                                  uidLoad: widget.uidLoad,
                                  flightCaseList: flightCaseCreateList,
                                );
                              },
                              barrierDismissible: false,
                            );
                            setState(() => flightCaseCreateList = updatedList);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: OwnCaseTileList(
                            uidGig: widget.uidGig,
                            uidLoad: widget.uidLoad,
                            flightCaseList: flightCaseCreateList,
                            isLoadPage: true,
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
      body: Builder(
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
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //TODO CRIKA
                  // LoadSelectionButton(
                  //   text: Text(
                  //     'CRIKA',
                  //     style: kTextStyle.copyWith(
                  //         color: Colors.black, fontSize: 23.0),
                  //   ),
                  //   height: 50.0,
                  //   width: 200.0,
                  //   color: Colors.red,
                  //   onPressed: () {
                  //     print('CRIKA pressed');
                  //     setState(() {});
                  //   },
                  // ),
                  LoadSelectionButton(
                    height: displayHeight(context) * 0.08,
                    text: Text(
                      'Case',
                      style: kTextStyle(context).copyWith(color: Colors.black),
                    ),
                    color: Colors.grey.shade400,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ), //New Custom
                ],
              ), //Buttons New cases
              SizedBox(
                height: 8.0,
              ),
              Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.all(3),
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: displayWidth(context),
                  color: Colors.grey,
                  child: ReorderableWrap(
                    spacing: 4,
                    runSpacing: 4,
                    onReorderStarted: (index) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 30),
                        content: BinForFlightCases(
                          list: flightCaseCreateList,
                        ),
                      ));
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        FlightCase row =
                            flightCaseCreateList.removeAt(oldIndex);
                        flightCaseCreateList.insert(newIndex, row);
                      });
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    onNoReorder: (index) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      setState(() {});
                    },
                    children: List.generate(
                        flightCaseCreateList.length,
                        (index) => FlightCaseOnList(
                              flightCaseList: flightCaseCreateList,
                              flightCase: flightCaseCreateList[index],
                              index: index + 1,
                              isLoadPage: false,
                            )),
                  )),
              SizedBox(
                height: 8.0,
              ),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: LoadSelectionButton(
                  height: displayHeight(context) * 0.09,
                  text: Text(
                    'I\'ve got everything',
                    style: kTextStyle(context).copyWith(color: Colors.black),
                  ),
                  width: displayWidth(context) * 0.85,
                  color: Colors.green,
                  onPressed: () async {
                    int index = 1;
                    for (FlightCase flightCase in flightCaseCreateList) {
                      flightCase.index = index;
                      index++;
                    }

                    ///Set the OFFLINE list of cases to firebase
                    await DatabaseService(uidLoad: widget.uidLoad)
                        .updateNewLoadListData(
                      loadName: widget.nameLoad,
                      flightCasesOnList: flightCaseCreateList,
                      flightCasesLoaded: 0,
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
        widget.list.removeAt(data);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    );
  }
}
