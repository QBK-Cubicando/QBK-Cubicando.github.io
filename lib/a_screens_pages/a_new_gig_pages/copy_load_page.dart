// //READED but not Documented
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
// import 'package:qbk_simple_app/models/user.dart';
// import 'package:qbk_simple_app/models/new_gig.dart';
// import 'package:qbk_simple_app/utilities/loading_widget.dart';
//
// import 'package:qbk_simple_app/services/database.dart';
// import 'package:qbk_simple_app/utilities/constants.dart';
//
// //TODO: Check that you can see all gigs but the one you are
//
//
// class CopyLoadPage extends StatelessWidget {
//   static const String id = 'copy_load_page';
//
//   final String uidThisGig; // **JUST FOR COPY LOAD SCREEN
//
//
//   CopyLoadPage({this.uidThisGig});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserData>(context);
//
//     return StreamBuilder<List<NewGig>>(
//         stream: DatabaseService(userUid: user.uid).gigList,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             print(snapshot.error);
//           }
//
//           if (snapshot.hasData) {
//             return UpperBar(
//                 text: 'My Gigs',
//                 body: snapshot.data.length != 0
//                     ? GigList(isCopyLoad: true, uidThisGig: uidThisGig)
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Center(
//                             child: Container(
//                               child: Text(
//                                 'No Gigs created yet !',
//                                 style: kTextStyle,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ));
//           } else {
//             return Loading();
//           }
//         });
//   }
// }
