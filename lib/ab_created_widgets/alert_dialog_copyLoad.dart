// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qbk_simple_app/models/flight_case.dart';
// import 'package:qbk_simple_app/models/user.dart';
// import 'package:intl/intl.dart';
//
// import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';
//
// import 'package:qbk_simple_app/utilities/constants.dart';
// import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
// import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
// import 'package:qbk_simple_app/services/database.dart';
// import 'package:qbk_simple_app/utilities/loading_widget.dart';
//
// ///Documentated
// class AlertDialogCopyLoad extends StatefulWidget {
//   final String uidCopiedGig;
//   final String uidCopiedLoad;
//   final String uidThisGig;
//   final String nameGig;
//
//   AlertDialogCopyLoad(
//       {this.uidCopiedGig, this.uidThisGig, this.nameGig, this.uidCopiedLoad});
//
//   @override
//   _AlertDialogCopyLoadState createState() => _AlertDialogCopyLoadState();
// }
//
// class _AlertDialogCopyLoadState extends State<AlertDialogCopyLoad> {
//   final _formKey = GlobalKey<FormState>();
//
//   final dateTimeNow =
//       DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa').format(DateTime.now());
//
//   String nameLoad;
//
//   @override
//   Widget build(BuildContext context) {
//     UserData user = Provider.of<UserData>(context);
//
//     //TODO: Maybe can delete this Stream Builder
//     return StreamBuilder<List<FlightCase>>(
//         stream: DatabaseService(
//                 userUid: user.uid,
//                 uidGig: widget.uidCopiedGig,
//                 uidLoad: widget.uidCopiedLoad)
//             .flightCaseListData,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<FlightCase> listFlightCasesCopiedLoad = snapshot.data;
//
//             _copyLoadIntoNewLoad({
//               String uidThisGig,
//               String uidThisLoad,
//             }) async {
//               for (FlightCase flightCase in listFlightCasesCopiedLoad) {
//                 ///Set FlightCases List to Firebase
//                 await DatabaseService(
//                         userUid: user.uid,
//                         uidGig: uidThisGig,
//                         uidLoad: uidThisLoad,
//                         uidFlightCase:
//                             '$dateTimeNow ${flightCase.nameFlightCase}')
//                     .setFlightCaseData(
//                   nameFlightCase: flightCase.nameFlightCase,
//                   typeFlightCase: flightCase.typeFlightCase,
//                   quantity: flightCase.quantity,
//                   wheels: flightCase.wheels,
//                   tilt: flightCase.tilt,
//                   stack: flightCase.stack,
//                   loaded: false,
//                 );
//               }
//             }
//
//             return Form(
//               key: _formKey,
//               child: AlertDialog(
//                 title: Column(
//                   children: <Widget>[
//                     Center(
//                         child: Text(
//                       'Name your new Load',
//                       textAlign: TextAlign.center,
//                       style: kTextStyle.copyWith(color: Colors.black),
//                     )),
//                     SizedBox(height: 10.0),
//                     TextFieldQBK(
//                       maxLength: 6,
//                       hintText: 'Name Load',
//                       onChanged: (value) {
//                         setState(() {
//                           nameLoad = value;
//                         });
//                       },
//                       validator: (value) =>
//                           value.isEmpty ? 'Tipe a valid Name' : null,
//                     ),
//                   ],
//                 ),
//                 actions: <Widget>[
//                   SelectionButton(
//                     text: 'Cancel',
//                     color: Colors.redAccent,
//                     onPress: () => Navigator.pop(context),
//                   ),
//                   SelectionButton(
//                     text: 'Create',
//                     color: Colors.green,
//                     onPress: () async {
//                       if (_formKey.currentState.validate()) {
//                         await DatabaseService(
//                                 userUid: user.uid,
//                                 uidGig: widget.uidThisGig,
//
//                                 ///GET THIS GIGS UID
//                                 uidLoad: '$dateTimeNow $nameLoad')
//                             .setLoadData(
//                           nameLoad: nameLoad,
//                         );
//
//                         await _copyLoadIntoNewLoad(
//                             uidThisGig: widget.uidThisGig,
//                             uidThisLoad: '$dateTimeNow $nameLoad');
//
//                         await Navigator.push(context,
//                             MaterialPageRoute(builder: (context) {
//                           return CreateLoadPage(
//                             uidGig: widget.uidThisGig,
//
//                             ///GET THIS GIGS UID
//                             nameGig: widget.nameGig,
//                             uidLoad: '$dateTimeNow $nameLoad',
//                           );
//                         }));
//
//                         Navigator.pop(context);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             snapshot.error != null ? print(snapshot.error.toString()) : null;
//             return Loading();
//           }
//         });
//   }
// }
