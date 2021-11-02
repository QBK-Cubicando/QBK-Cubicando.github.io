//READED but not Documented

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/models/BlocRow.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/services/global_variables.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';

import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:boardview/boardview.dart';

//TODO: Check that you can see all gigs but the one you are

class CopyLoadPage extends StatelessWidget {
  static const String id = 'copy_load_page';

  final String uidThisGig; // **JUST FOR COPY LOAD SCREEN

  CopyLoadPage({this.uidThisGig});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return Container();

    // return StreamBuilder<List<NewGig>>(
    //     stream: DatabaseService(userUid: user.uid).gigList,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         print(snapshot.error);
    //       }

    //       if (snapshot.hasData) {
    //         return UpperBar(
    //             text: 'My Gigs',
    //             body: snapshot.data.length != 0
    //                 ? GigList(isCopyLoad: true, uidThisGig: uidThisGig)
    //                 : Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       Center(
    //                         child: Container(
    //                           child: Text(
    //                             'No Gigs created yet !',
    //                             style: kTextStyle,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ));
    //       } else {
    //         return Loading();
    //       }
    //     });
  }
}

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:qbk_simple_app/models/user.dart';
// import 'package:qbk_simple_app/services/database.dart';
// import 'package:qbk_simple_app/ui/sizes-helpers.dart';

// import 'package:qbk_simple_app/utilities/constants.dart';
// import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

// import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
// import 'package:qbk_simple_app/ab_created_widgets/a_buttons/load_selection_button_widget.dart';
// import 'package:qbk_simple_app/models/flight_case.dart';
// import 'package:qbk_simple_app/utilities/loading_widget.dart';

// ///Documentated

// class LoadPage2 extends StatefulWidget {
//   static const String id = 'load_page';

//   LoadPage2(
//       {@required this.userUid,
//       this.uidGig,
//       this.nameGig,
//       this.uidLoad,
//       this.permission,
//       this.index});

//   final String userUid;
//   final String uidGig;
//   final String nameGig;
//   final String uidLoad;
//   final String permission;
//   final int index;

//   @override
//   _LoadPage2State createState() => _LoadPage2State();
// }

// class _LoadPage2State extends State<LoadPage2> {
//   ///The list of all cases OFFLINE
//   List<FlightCase> flightCaseTotalList = [];
//   List<BlocRow> blocRowTotalList = [];

//   Map<String, String> blocRowNotLoadedAndLoaded = {};

//   ///The list of loaded cases
//   List<FlightCase> flightCaseLoadedList = [];
//   List<BlocRow> blocRowLoadedList = [];

//   ///The List of NOT loaded cases
//   List<FlightCase> flightCaseNotLoadedList = [];
//   List<BlocRow> blocRowNotLoadedList = [];

//   ///The list of all cases fetched from firebase
//   Future<List<FlightCase>> flightCaseFetchedList;
//   Future<List<BlocRow>> blocRowFetchedList;
//   Future<List<int>> tempListLoadedAndTotalCases;

//   bool init = true; //Bool that indicates the load has begun

//   int casesLoaded = 0;
//   int casesLeft = 0;
//   bool refresh = false;
//   int fetchedLoadedCasesLength = 0;
//   String loader;
//   Future futureLoader;
//   int totalCases = 0;

//   ScrollController _scrollController = ScrollController();
//   final Stream<Map<FlightCase, bool>> streamFlightCase =
//       streamControllerFlightCase.stream;

//   ///When loading finishes firebase should be reset (All cases loaded false)
//   _resetAndExit() async {
//     var i = 1;
//     flightCaseTotalList = flightCaseLoadedList + flightCaseNotLoadedList;
//     for (FlightCase element in flightCaseTotalList) {
//       element.loaded = false;
//       element.index = i;
//       i++;
//     }

//     await DatabaseService(uidLoad: widget.uidLoad).updateNewLoadListData(
//       flightCasesOnList: flightCaseTotalList,
//       flightCasesLoaded: 0,
//     );

//     Navigator.pop(context);
//   }

//   ///Create a OFFLINE list of LOADED flightCases from firebase to work with
//   // _createLoadedList() {
//   //   for (FlightCase flightCase in flightCaseTotalList) {
//   //     if (flightCase.loaded == true) {
//   //       flightCaseLoadedList.add(flightCase);
//   //     }
//   //   }
//   //   setState(() {});
//   // }

//   ///Create a OFFLINE list of NOT LOADED flightCases from firebase to work with
//   // _createNotLoadedList() {
//   //   for (FlightCase flightCase in flightCaseTotalList) {
//   //     if (flightCase.loaded == false) {
//   //       flightCaseNotLoadedList.add(flightCase);
//   //     }
//   //   }
//   //   setState(() {});
//   // }

//   ///Load or unload cases OFFLINE
//   // _loadOrUnloadFlightCase(FlightCase flightCase) {
//   //   init = false;

//   //   if (flightCase.loaded == false) {
//   //     flightCaseLoadedList.add(flightCase);
//   //     flightCaseNotLoadedList.remove(flightCase);
//   //     flightCase.loaded = true;
//   //   } else {
//   //     flightCaseNotLoadedList.add(flightCase);
//   //     flightCaseLoadedList.remove(flightCase);
//   //     flightCase.loaded = false;
//   //   }

//   //   setState(() {});
//   // }

//   ///Fetch a list of loaded and unloaded cases from firebase
//   // _fetchLoadListFromFirebase() async {
//   //   flightCaseFetchedList =
//   //       DatabaseService(uidLoad: widget.uidLoad).getLoadListOnce();
//   //   if (flightCaseFetchedList != null) {
//   //     flightCaseTotalList = await flightCaseFetchedList;

//   //     await _setFlightCaseLists();
//   //   } else {
//   //     flightCaseTotalList = [];
//   //   }
//   //   setState(() {});

//   //   //TODO: Remove in the next update
//   //   ///Just to update the loads that don't have total case option
//   //   try {
//   //     if (init = true) {
//   //       FirebaseFirestore.instance
//   //           .collection('loads')
//   //           .doc(widget.uidLoad)
//   //           .update({
//   //         'totalCases': flightCaseTotalList.length,
//   //         'loadedCases': flightCaseLoadedList.length == null
//   //             ? 0
//   //             : flightCaseLoadedList.length,
//   //       });
//   //     }
//   //   } catch (e) {
//   //     // print(e);
//   //   }
//   // }

//   // Create blocRow in Loaded Part of the screen
//   int index = 1;
//   _createLoadedBlocRow(String id, bool isCrica) {
//     String reversedId = blocRowNotLoadedAndLoaded[id];

//     if (isCrica) {
//       blocRowLoadedList.add(BlocRow(
//           stream: streamControllerBlocRow.stream,
//           index: index,
//           isCrica: true,
//           flightCaseList: [],
//           id: reversedId,
//           isLoadPage: true,
//           loaded: blocRowNotLoadedList
//                 .firstWhere((element) => element.id == id)
//                 .loaded),
//       );
//     } else {
//       blocRowLoadedList.add(BlocRow(
//         stream: streamControllerBlocRow.stream,
//         index: index,
//         isCrica: false,
//         flightCaseList: [],
//         id: reversedId,
//         isLoadPage: true,
//       ));
//     }

//     index += 1;
//   }

//   _checkLoadedAndNoLoadedCases(List<BlocRow> blocRowList) {
//     blocRowList.forEach((blocRow) {
//       List<FlightCase> toLoad = [];
//       BlocRow loadedBlocRow = blocRowLoadedList.firstWhere(
//           (element) => element.id == blocRow.id.split('').reversed.join(''));

//       BlocRow notLoadedBlocRow = blocRowNotLoadedList
//           .firstWhere((element) => element.id == blocRow.id);

//       blocRow.flightCaseList.forEach((flightCase) {
        
//         if (flightCase.loaded == true) {
//           toLoad.add(flightCase);
//           casesLoaded += 1;
//         }
//       });
//       notLoadedBlocRow.flightCaseList.removeWhere((e) => toLoad.contains(e));
//       loadedBlocRow.flightCaseList.addAll(toLoad);
//       toLoad = [];
//     });
//   }

//   _fetchLoadedAndTotalCasesFromFirebase() async {
//     List<int> temp = await tempListLoadedAndTotalCases;
//     casesLoaded = temp[0];
//     totalCases = temp[1];
//   }

//   _fetchBlocRowListFromFirebase() async {
//     if (blocRowFetchedList != null) {
//       blocRowNotLoadedList = await blocRowFetchedList;
//       // Assign Strem to every BlocRow
//       blocRowNotLoadedList.forEach((blocRow) {
//         blocRow.stream = streamControllerBlocRow.stream;
//         blocRow.isLoadPage = true;
//         // blocRow.loaded = blocRow.isCrica;

//         // totalFlightCaseLists[blocRow.id] = blocRow.flightCaseList;

//         String reversedId = blocRow.id.split('').reversed.join('');

//         blocRowNotLoadedAndLoaded[blocRow.id] = reversedId;

//         // Create Loaded BlocRow List

//         _createLoadedBlocRow(blocRow.id, blocRow.isCrica);
//       });
//     } else {
//       blocRowNotLoadedList = [];
//       blocRowLoadedList = [];
//     }
//     _checkLoadedAndNoLoadedCases(blocRowNotLoadedList);
//     setState(() {});
//   }

//   ///When start the load fetch a list and make it offline
//   // _setFlightCaseLists() {
//   //   if (init == true) {
//   //     _createLoadedList();
//   //     _createNotLoadedList();
//   //   }
//   // }

//   ///Checks if firebase load is larger and replaces it
//   _refreshLoad() async {
//     if (loader == widget.userUid) {
//       // flightCaseTotalList = flightCaseLoadedList + flightCaseNotLoadedList;
//       Map<String, List<FlightCase>> mapOfFlightCasesOnList = {};

//       blocRowLoadedList.forEach((blocRow) {
//         String reversedId = blocRow.id.split('').reversed.join('');
//         // List<FlightCase> tempList = blocRow.flightCaseList;
//         // List<FlightCase> toReorder = [];

//         BlocRow loadedBlocRow =
//             blocRowLoadedList.firstWhere((element) => element.id == blocRow.id);

//         BlocRow notLoadedBlocRow = blocRowNotLoadedList
//             .firstWhere((element) => element.id == reversedId);

//         // print(loadedBlocRow.flightCaseList[0].loaded);

//         mapOfFlightCasesOnList[reversedId] =
//             loadedBlocRow.flightCaseList + notLoadedBlocRow.flightCaseList;

//         if (blocRowTotalList.length < blocRowNotLoadedList.length) {
//           blocRowTotalList.add(BlocRow(
//             isCrica: notLoadedBlocRow.isCrica,
//             flightCaseList:
//                 loadedBlocRow.flightCaseList + notLoadedBlocRow.flightCaseList,
//             id: notLoadedBlocRow.id,
//             isLoadPage: notLoadedBlocRow.isLoadPage,
//             index: notLoadedBlocRow.index,
//             stream: notLoadedBlocRow.stream,
//             loaded: notLoadedBlocRow.loaded,
//           ));
//         }
        
//       });

//       // blocRowTotalList.forEach((element) {
//       //   mapOfFlightCasesOnList[element.id] = element.flightCaseList;
//       // });
//       // print(casesLoaded);
//       await DatabaseService(uidLoad: widget.uidLoad)
//           .updateNewLoadListDataPRUEBA(
//         mapOfFlightCasesOnList: mapOfFlightCasesOnList,
//         listBlocRow: blocRowTotalList,
//         idAndBlockRow: idAndBlocRow,
//         flightCasesLoaded: casesLoaded,
//       );
//       blocRowTotalList.clear();

//       await FirebaseFirestore.instance
//           .collection('loads')
//           .doc(widget.uidLoad)
//           .update({'refresh': false});
//     } else {
//       // flightCaseLoadedList.clear();
//       // flightCaseNotLoadedList.clear();
//       // _fetchLoadListFromFirebase();
//     }

//     ///This is used if you want to implement simultaneous loaders

//     // if (fetchedLoadedCasesLength < flightCaseLoadedList.length &&
//     //     fetchedLoadedCasesLength != flightCaseTotalList.length) {
//     //   if (loader == widget.userUid) {
//     //     flightCaseTotalList = flightCaseLoadedList + flightCaseNotLoadedList;
//     //     await DatabaseService(uidLoad: widget.uidLoad).updateNewLoadListData(
//     //       flightCasesOnList: flightCaseTotalList,
//     //       flightCasesLoaded: flightCaseLoadedList.length,
//     //     );
//     //   }
//     //   await FirebaseFirestore.instance
//     //       .collection('loads')
//     //       .doc(widget.uidLoad)
//     //       .update({'refresh': true});
//     // } else if ((fetchedLoadedCasesLength > flightCaseLoadedList.length &&
//     //         fetchedLoadedCasesLength != flightCaseTotalList.length) ||
//     //     fetchedLoadedCasesLength == flightCaseTotalList.length &&
//     //         loader != widget.userUid) {
//     //   flightCaseLoadedList.clear(); don't do this, replace the list don't clear.
//     //   flightCaseNotLoadedList.clear(); don't do this, replace the list don't clear.
//     // _fetchLoadListFromFirebase();

//     //   await FirebaseFirestore.instance
//     //       .collection('loads')
//     //       .doc(widget.uidLoad)
//     //       .update({'refresh': false});
//     // }
//   }

//   ///Gets the loader
//   _getLoader() async {
//     futureLoader = FirebaseFirestore.instance
//         .collection('loads')
//         .doc(widget.uidLoad)
//         .get()
//         .then((val) {
//       return val.data['loader'];
//     });

//     if (futureLoader != null) {
//       loader = await futureLoader;
//     } else {
//       loader = 'No Loader';
//     }

//     await _setLoader(loader);
//     setState(() {});
//   }

//   ///Sets loader if it's null, checks who is the loader
//   _setLoader(loaderFunction) async {
//     if (loaderFunction == null || loaderFunction == 'No Loader') {
//       if (widget.permission == 'Admin' || widget.permission == 'Loader') {
//         await FirebaseFirestore.instance
//             .collection('loads')
//             .doc(widget.uidLoad)
//             .update({
//           'loader': widget.userUid,
//         });
//         loader = widget.userUid;
//       }
//     }
//   }

//   ///Clears the loader
//   _clearLoader() async {
//     await FirebaseFirestore.instance
//         .collection('loads')
//         .doc(widget.uidLoad)
//         .update({
//       'loader': 'No Loader',
//       'refresh': false,
//     });
//   }

//   Widget _refreshOrLoading(ref) {
//     return ref == true
//         ? Loading(
//             size: displayHeight(context) * 0.04,
//           )
//         : LoadSelectionButton(
//             text: Text(
//               'Refresh',
//               style: kTextStyle(context).copyWith(color: Colors.black),
//             ),
//             onPressed: () async {
//               if (fetchedLoadedCasesLength < totalCases) {
//                 await FirebaseFirestore.instance
//                     .collection('loads')
//                     .doc(widget.uidLoad)
//                     .update({'refresh': true});

//                 _refreshLoad();

//                 Timer(Duration(seconds: 5), () async {
//                   await FirebaseFirestore.instance
//                       .collection('loads')
//                       .doc(widget.uidLoad)
//                       .update({'refresh': false});
//                 });
//               }
//             },
//           );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getLoader();

//     // _fetchLoadListFromFirebase();
//     blocRowFetchedList =
//         DatabaseService(uidLoad: widget.uidLoad, isLoadPage: true)
//             .getLoadListOncePRUEBA();

//     _fetchBlocRowListFromFirebase();

//     // Get Loaded and Total Cases
//     tempListLoadedAndTotalCases =
//         DatabaseService(uidLoad: widget.uidLoad).getTotalAndLoadedCasesPRUEBA();
//     _fetchLoadedAndTotalCasesFromFirebase();

//     streamFlightCase.listen((event) {
//       _loadAndUnloadFlightcaseFromBlocRow(event);
//     });
//   }

//   void _loadAndUnloadFlightcaseFromBlocRow(
//       Map<FlightCase, bool> flightCaseAndLoaded) {
//     if (flightCaseAndLoaded != null) {
//       // setState(() {
//       FlightCase flightCase = flightCaseAndLoaded.keys.toList()[0];
//       bool loaded = flightCaseAndLoaded.values.toList()[0];
//       init = false;
//       if (loaded == false) {
//         String idLoadedBlocRow = blocRowNotLoadedAndLoaded[selectedBlocRowId];
//         BlocRow notLoadedBlocRow = blocRowNotLoadedList
//             .firstWhere((element) => element.id == selectedBlocRowId);
//         BlocRow loadedBlocRow = blocRowLoadedList
//             .firstWhere((element) => element.id == idLoadedBlocRow);
//         flightCase.loaded = true;

//         notLoadedBlocRow.flightCaseList
//             .removeWhere((element) => element.index == flightCase.index);
//         loadedBlocRow.flightCaseList.add(flightCase);

//         casesLoaded += 1;
//       } else {
//         selectedBlocRowId = selectedBlocRowId.split('').reversed.join('');
//         String idLoadedBlocRow = blocRowNotLoadedAndLoaded[selectedBlocRowId];
//         BlocRow notLoadedBlocRow = blocRowNotLoadedList
//             .firstWhere((element) => element.id == selectedBlocRowId);
//         BlocRow loadedBlocRow = blocRowLoadedList
//             .firstWhere((element) => element.id == idLoadedBlocRow);

//         flightCase.loaded = false;
//         loadedBlocRow.flightCaseList
//             .removeWhere((element) => element.index == flightCase.index);
//         notLoadedBlocRow.flightCaseList.add(flightCase);
//         casesLoaded -= 1;
//       }

//       streamControllerBlocRow.add(0);
//       setState(() {});
//       // });
//     } else {
//       streamControllerBlocRow.add(999);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserData>(context);
//     try {
//       _percentFlightCasesLeft() {
//         double percent = casesLoaded * 100 / totalCases;
//         return percent.roundToDouble();
//       }

//       return StreamBuilder(
//           stream: DatabaseService(userUid: user.uid, uidLoad: widget.uidLoad)
//               .refreshLoad,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               print(snapshot.error);
//             }

//             if (snapshot.hasData) {
//               fetchedLoadedCasesLength = snapshot.data['loadedCases'];

//               return StreamBuilder(
//                   stream: DatabaseService(
//                           userUid: user.uid, uidLoad: widget.uidLoad)
//                       .refreshLoad,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       print(snapshot.error);
//                     }

//                     if (snapshot.hasData) {
//                       refresh = snapshot.data['refresh'];
//                       if (refresh == true) {
//                         _refreshLoad();

//                         ///This is used if you want to implement simultaneus loaders

//                         // Timer(Duration(milliseconds: 500 * widget.index), () {
//                         //   _refreshLoad();
//                         // });
//                       }
//                       return UpperBar(
//                         text: widget.nameGig ?? 'Load Page',
//                         body: Center(
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.30,
//                                   padding: EdgeInsets.all(4),
//                                   width: displayWidth(context) * 0.95,
//                                   color: Colors.grey,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if (widget.permission == 'Admin' ||
//                                           widget.permission == 'Loader') {
//                                         if (loader == user.uid) {
//                                           // _loadOrUnloadFlightCase(
//                                           //     // flightCaseNotLoadedList[
//                                           //     //     index]);
//                                           // _scrollController.jumpTo(
//                                           //     _scrollController
//                                           //         .position
//                                           //         .maxScrollExtent);
//                                         } else {
//                                           setState(() {});
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             duration: Duration(seconds: 3),
//                                             content: Text(
//                                               'There is already a Loader',
//                                               style: kTextStyle(context)
//                                                   .copyWith(
//                                                       color: Colors
//                                                           .redAccent.shade100),
//                                             ),
//                                           ));
//                                         }
//                                       } else {
//                                         setState(() {});
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                           duration: Duration(seconds: 3),
//                                           content: Text(
//                                             'Only Admin Crew can Load',
//                                             style: kTextStyle(context).copyWith(
//                                                 color:
//                                                     Colors.redAccent.shade100),
//                                           ),
//                                         ));
//                                       }
//                                     },
//                                     child: SingleChildScrollView(
//                                       child: Column(
//                                         children: blocRowLoadedList,
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 //TODO: ESTO SERA la imagen de una crika que se va cerrando
//                                 Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.05,
//                                   width: displayWidth(context) * 0.95,
//                                   color: Colors.blueAccent,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: Center(
//                                         child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Text(
//                                           '${_percentFlightCasesLeft()} %',
//                                           style: kTextStyle(context)
//                                               .copyWith(color: Colors.black),
//                                         ),
//                                         _refreshOrLoading(refresh),
//                                       ],
//                                     )),
//                                   ),
//                                 ),

//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       width: displayWidth(context) * 0.95,
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.45,
//                                       padding: EdgeInsets.all(4),
//                                       color: Colors.grey,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           if (widget.permission == 'Admin' ||
//                                               widget.permission == 'Loader') {
//                                             if (loader == user.uid) {
//                                               // _loadOrUnloadFlightCase(
//                                               //     // flightCaseNotLoadedList[
//                                               //     //     index]);
//                                               // _scrollController.jumpTo(
//                                               //     _scrollController
//                                               //         .position
//                                               //         .maxScrollExtent);
//                                             } else {
//                                               setState(() {});
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(SnackBar(
//                                                 duration: Duration(seconds: 3),
//                                                 content: Text(
//                                                   'There is already a Loader',
//                                                   style: kTextStyle(context)
//                                                       .copyWith(
//                                                           color: Colors
//                                                               .redAccent
//                                                               .shade100),
//                                                 ),
//                                               ));
//                                             }
//                                           } else {
//                                             setState(() {});
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(SnackBar(
//                                               duration: Duration(seconds: 3),
//                                               content: Text(
//                                                 'Only Admin Crew can Load',
//                                                 style: kTextStyle(context)
//                                                     .copyWith(
//                                                         color: Colors.redAccent
//                                                             .shade100),
//                                               ),
//                                             ));
//                                           }
//                                         },
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             children: blocRowNotLoadedList,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 8.0,
//                                     ),
//                                     LoadSelectionButton(
//                                       text: Text(
//                                         'Done',
//                                         style: kTextStyle(context)
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                       width: displayWidth(context) * 0.85,
//                                       color: Colors.green,
//                                       onPressed: () async {
//                                         if ((widget.permission == 'Admin' ||
//                                                 widget.permission ==
//                                                     'Loader') &&
//                                             loader == widget.userUid) {
//                                           ///Reads and Organizes the loaded and unloaded cases in different lists to check them.
//                                           for (FlightCase element
//                                               in flightCaseTotalList) {
//                                             element.loaded == true
//                                                 ? casesLoaded++
//                                                 : casesLeft++;
//                                           }

//                                           ///Checks if all cases are loaded
//                                           if (casesLoaded == totalCases &&
//                                               casesLeft == 0) {
//                                             _resetAndExit();
//                                             await FirebaseFirestore.instance
//                                                 .collection('loads')
//                                                 .doc(widget.uidLoad)
//                                                 .update({'refresh': false});
//                                             if (loader == user.uid) {
//                                               _clearLoader();
//                                             }
//                                           } else {
//                                             showDialog(
//                                                 context: context,
//                                                 builder: (context) {
//                                                   return Container(
//                                                     height:
//                                                         displayHeight(context) *
//                                                             0.6,
//                                                     width:
//                                                         displayWidth(context) *
//                                                             0.5,
//                                                     child: AlertDialog(
//                                                       title: Center(
//                                                           child: Text(
//                                                         '''Not all flight cases are loaded yet!
//                                                            Do you want to continue?''',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: kTextStyle(
//                                                                 context)
//                                                             .copyWith(
//                                                                 color: Colors
//                                                                     .black),
//                                                       )),
//                                                       content: Container(
//                                                         height: displayHeight(
//                                                                 context) *
//                                                             0.2,
//                                                         width: displayWidth(
//                                                                 context) *
//                                                             0.7,
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Center(
//                                                               child: Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceEvenly,
//                                                                 children: [
//                                                                   SelectionButton(
//                                                                     text:
//                                                                         'Cancel',
//                                                                     color: Colors
//                                                                         .blueAccent,
//                                                                     onPress: () =>
//                                                                         Navigator.pop(
//                                                                             context),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 10,
//                                                                   ), //Cancel Button
//                                                                   SelectionButton(
//                                                                     text:
//                                                                         'Exit',
//                                                                     color: Colors
//                                                                         .orangeAccent,
//                                                                     onPress:
//                                                                         () {
//                                                                       _refreshLoad();
//                                                                       _clearLoader();
//                                                                       Navigator.pop(
//                                                                           context);
//                                                                       Navigator.pop(
//                                                                           context);
//                                                                     },
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               height: 8,
//                                                             ), //Exit Button
//                                                             SelectionButton(
//                                                               text:
//                                                                   'Reset & Exit',
//                                                               color: Colors
//                                                                   .redAccent,
//                                                               onPress: () {
//                                                                 Navigator.pop(
//                                                                     context);
//                                                                 _resetAndExit();
//                                                                 _clearLoader();
//                                                               },
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                           }
//                                         } else {
//                                           Navigator.pop(context);
//                                         }
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return Loading();
//                     }
//                   });
//             } else {
//               return Loading();
//             }
//           });
//     } catch (e) {
//       // print(e);
//       return Center(child: Loading());
//     }
//   }
// }
