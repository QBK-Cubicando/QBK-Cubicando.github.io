// TODO: Document and check for optimization

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/top_qbk.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';

class CrewQBK extends StatefulWidget {
  static const String id = 'crew_page';

  CrewQBK({this.uidGig, this.userUid, this.userPermission, this.crewNumber});

  final String uidGig;
  final String userUid;
  final String userPermission;
  final int crewNumber;

  @override
  CrewQBKState createState() => CrewQBKState();
}

String selectedPermission = 'Just Read';

class CrewQBKState extends State<CrewQBK> {
  final _formKey = GlobalKey<FormState>();

  var futureFriendsList;
  var friendsList = [];
  NewFriend newCrewMember;

  TextEditingController _controller = TextEditingController();

  List<bool> isSelected = [true, false, false];
  bool search = false;

  // _setFriendList() async {
  //   if (futureFriendsList != null) {
  //     friendsList = await futureFriendsList;
  //   } else {
  //     friendsList = [];
  //   }

  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   futureFriendsList =
  //       DatabaseService(userUid: widget.userUid).getFriendsListOnce();
  //   _setFriendList();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    List<Widget> permissions = [
      Container(
        width: displayWidth(context) * 0.282,
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'READ',
              style: kTextStyle(context).copyWith(
                  fontSize: displayWidth(context) * 0.04, color: Colors.black),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(color: kredQBK, shape: BoxShape.circle),
            )
          ],
        ),
      ),
      Container(
        width: displayWidth(context) * 0.282,
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'ADMIN',
              style: kTextStyle(context).copyWith(
                  fontSize: displayWidth(context) * 0.04, color: Colors.black),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration:
                  BoxDecoration(color: kgreenQBK, shape: BoxShape.circle),
            )
          ],
        ),
      ),
      Container(
        width: displayWidth(context) * 0.282,
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'LOAD',
              style: kTextStyle(context).copyWith(
                  fontSize: displayWidth(context) * 0.04, color: Colors.black),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration:
                  BoxDecoration(color: kyellowQBK, shape: BoxShape.circle),
            )
          ],
        ),
      ),
    ];

    try {
      return StreamBuilder<List<NewCrewMember>>(
          stream: DatabaseService(
            userUid: user.uid,
            uidGig: widget.uidGig,
            isCrewPage: true,
          ).gigCrewMemberList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              List<NewCrewMember> crewMember = snapshot.data;

              _listUidsCrewMember() {
                return crewMember.map((e) => e.uidCrewMember).toList();
              }

              return Scaffold(
                body: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: displayWidth(context) * 0.85,
                              child: TopQBK()),
                          SizedBox(
                            height: 10.0,
                          ),

                          Container(
                            height: displayHeight(context) * 0.1,
                            width: displayWidth(context) * 0.85,
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              color: kblueQBK,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'NEW ROADIE',
                                        textAlign: TextAlign.start,
                                        style: kTextStyle(context)
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    child: Icon(Icons.search_sharp),
                                    onTap: () {
                                      setState(() {
                                        search = !search;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          search == true
                              ? Container(
                                  margin: EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFieldQBK(
                                        width: displayWidth(context) * 0.6,
                                        validator: (value) =>
                                            value.isEmpty ? 'Enter name' : null,
                                        controller: _controller,
                                        hintText: 'Search ...',
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        width: displayWidth(context) * 0.05,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: FloatingActionButton(
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.search),
                                          onPressed: () async {
                                            bool isLoader =
                                                await DatabaseService(
                                                        uidGig: widget.uidGig)
                                                    .checkForLoaderToAdd();

                                            if (crewMember.length < 5) {
                                              newCrewMember = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child: Container(
                                                      color: Colors.grey,
                                                      height: displayHeight(
                                                              context) *
                                                          0.3,
                                                      width: displayWidth(
                                                              context) *
                                                          0.9,
                                                      child: FriendList(
                                                        isCrewPage: true,
                                                        crewMember:
                                                            _controller.text,
                                                        uidGig: widget.uidGig,
                                                        userUid: user.uid,
                                                        permission:
                                                            selectedPermission,
                                                        indexOfCrew:
                                                            crewMember.length +
                                                                1,
                                                        isLoader: isLoader,
                                                        lengthCrew:
                                                            crewMember.length,
                                                        listCrew:
                                                            _listUidsCrewMember(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child: Material(
                                                      child: Container(
                                                        color: Colors.grey,
                                                        height: displayHeight(
                                                                context) *
                                                            0.2,
                                                        width: displayWidth(
                                                                context) *
                                                            0.7,
                                                        child: Center(
                                                          child: Text(
                                                            'You reached the max crew for this Gig',
                                                            style: kTextStyle(
                                                                context),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                            setState(() {});
                                            _controller.clear();
                                            selectedPermission = 'Just Read';
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ) //Name of the participant
                              : Container(),
                          SizedBox(
                            height: 2,
                          ),

                          //TODO: Do a scrollable page to the right so you can see all your participants and your participants
                          Container(
                              padding: EdgeInsets.all(8),
                              width: displayWidth(context) * 0.85,
                              height: displayHeight(context) * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CrewMembersList(
                                uidGig: widget.uidGig,
                                userPermission: widget.userPermission,
                              )),
                          //Where all the participants go
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.white,
                            child: ToggleButtons(
                              children: permissions,
                              isSelected: isSelected,
                              selectedBorderColor: kredQBK,
                              borderWidth: 3,
                              onPressed: (int index) {
                                setState(() {
                                  for (int buttonIndex = 0;
                                      buttonIndex < isSelected.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      isSelected[buttonIndex] = true;
                                    } else {
                                      isSelected[buttonIndex] = false;
                                    }
                                  }
                                  if (index == 0) {
                                    selectedPermission = 'Just Read';
                                  } else if (index == 1) {
                                    selectedPermission = 'Admin';
                                  } else {
                                    selectedPermission = 'Loader';
                                  }
                                });
                              },
                            ),
                          ),

                          SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: displayWidth(context) * 0.85,
                            alignment: Alignment.centerRight,
                            child: SelectionButton(
                              text: 'SAVE',
                              width: displayWidth(context) * 0.3,
                              color: kyellowQBK,
                              onPress: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Loading();
            }
          });
    } catch (e) {
      // print(e);
      return Container(
        child: Loading(),
        color: Colors.black,
      );
    }
  }
}
