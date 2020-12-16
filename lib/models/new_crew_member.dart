import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

import 'package:qbk_simple_app/utilities/constants.dart';

///READ but not Documentated
class NewCrewMember {
  //TODO: get the email or uid so you can delete with no error
  final String uidCrewMember;
  final String nameCrew;
  final String permission;
  final int index; //TODO: erase index

  NewCrewMember(
      {this.uidCrewMember, this.nameCrew, this.permission, this.index});
}

// class NewCrewMemberOnList extends StatelessWidget {
//   NewCrewMemberOnList({this.newCrewMember, this.uidGig, this.userUid});
//
//   final NewCrewMember newCrewMember;
//   final String userUid;
//   final String uidGig;
//   //TODO: Add picture of Crew Member
//
//   Color _colorCrewMember(String permission) {
//     if (permission == 'Admin') {
//       return Colors.green;
//     } else if (permission == 'Just Read') {
//       return Colors.redAccent;
//     } else {
//       return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     void _deleteCrewMember() {
//       DatabaseService(
//               userUid: userUid,
//               uidGig: uidGig,
//               uidCrewGig: newCrewMember.uidCrewMember)
//           .deleteCrewMember();
//     }
//
//     return Container(
//       height: 20,
//       width: 5.0,
//       child: GestureDetector(
//         onLongPress: () {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Center(
//                       child: Text(
//                     'Are you sure you want to delete ${newCrewMember.nameCrew}?',
//                     style: kTextStyle.copyWith(color: Colors.black),
//                   )),
//                   actions: <Widget>[
//                     SelectionButton(
//                       text: 'Cancel',
//                       color: Colors.blueAccent,
//                       onPress: () => Navigator.pop(context),
//                     ),
//                     SelectionButton(
//                       text: 'Delete',
//                       color: Colors.redAccent,
//                       onPress: () {
//                         Navigator.pop(context);
//                         _deleteCrewMember();
//                       },
//                     ),
//                   ],
//                 );
//               });
//         },
//         child: Column(
//           children: <Widget>[
//             Icon(
//               Icons.accessibility_new,
//               size: 40.0,
//             ),
//             Container(
//               color: _colorCrewMember(newCrewMember.permission),
//               //TODO: Give a font and size
//               child: Center(
//                 child: Text(
//                   newCrewMember.nameCrew,
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CrewMembersList extends StatefulWidget {
//   final String uidGig;
//
//   CrewMembersList({this.uidGig});
//
//   @override
//   _CrewMembersListState createState() => _CrewMembersListState();
// }
//
// class _CrewMembersListState extends State<CrewMembersList> {
//   @override
//   Widget build(BuildContext context) {
//     UserData user = Provider.of<UserData>(context);
//
//     return StreamBuilder<List<NewCrewMember>>(
//         stream: DatabaseService(userUid: user.uid, uidGig: widget.uidGig)
//             .crewMemberList,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             print(snapshot.error);
//           }
//
//           if (snapshot.hasData) {
//             List<NewCrewMember> crewMember = snapshot.data;
//
//             return GridView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: crewMember.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 4,
//                 ),
//                 itemBuilder: (context, index) {
//                   return NewCrewMemberOnList(
//                     newCrewMember: crewMember[index],
//                     userUid: user.uid,
//                     uidGig: widget.uidGig,
//                   );
//                 });
//           } else {
//             return Loading();
//           }
//         });
//   }
// }
