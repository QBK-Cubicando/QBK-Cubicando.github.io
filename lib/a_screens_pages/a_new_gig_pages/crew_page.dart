// TODO: Document and check for optimization

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  CrewQBK({this.uidGig, this.userUid, this.userPermission});

  final String uidGig;
  final String userUid;
  final String userPermission;

  @override
  CrewQBKState createState() => CrewQBKState();
}

String selectedPermission = 'Just Read';

class CrewQBKState extends State<CrewQBK> {
  final _formKey = GlobalKey<FormState>();

  var futureFriendsList;
  var friendsList = [];
  NewFriend newCrewMember;

  // int indexOfCrew;
  TextEditingController _controller = TextEditingController();

  List<String> permissions = ['Just Read', 'Admin', 'Loader'];

  _setFriendList() async {
    if (futureFriendsList != null) {
      friendsList = await futureFriendsList;
    } else {
      friendsList = [];
    }

    setState(() {});
  }

  @override
  void initState() {
    futureFriendsList =
        DatabaseService(userUid: widget.userUid).getFriendsListOnce();
    _setFriendList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    try {
      return StreamBuilder<List<NewCrewMember>>(
          stream: DatabaseService(userUid: user.uid, uidGig: widget.uidGig)
              .gigCrewMemberList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              List<NewCrewMember> crewMember = snapshot.data;

              return UpperBar(
                text: 'Crew',
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          width: displayWidth(context) * 0.85,
                          height: displayHeight(context) * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedPermission,
                            onChanged: (String newValue) {
                              setState(() {
                                selectedPermission = newValue;
                              });
                            },
                            items: permissions.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) =>
                                value == 'Just Read' ? 'Just Read' : null,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFieldQBK(
                              width: displayWidth(context) * 0.6,
                              validator: (value) =>
                                  value.isEmpty ? 'Enter name' : null,
                              controller: _controller,
                              hintText: 'Name',
                              maxLines: 1,
                            ),
                            SizedBox(
                              width: displayWidth(context) * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: FloatingActionButton(
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.search),
                                onPressed: () async {
                                  bool isLoader = await DatabaseService(
                                          uidGig: widget.uidGig)
                                      .checkForLoaderToAdd();

                                  if (crewMember.length < 5) {
                                    newCrewMember = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Container(
                                            color: Colors.grey,
                                            height:
                                                displayHeight(context) * 0.3,
                                            width: displayWidth(context) * 0.9,
                                            child: FriendList(
                                              friendsList: friendsList,
                                              isCrewPage: true,
                                              crewMember: _controller.text,
                                              uidGig: widget.uidGig,
                                              userUid: user.uid,
                                              permission: selectedPermission,
                                              indexOfCrew:
                                                  crewMember.length + 1,
                                              isLoader: isLoader,
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
                                              height:
                                                  displayHeight(context) * 0.2,
                                              width:
                                                  displayWidth(context) * 0.7,
                                              child: Center(
                                                child: Text(
                                                  'You reached the max crew for this Gig',
                                                  style: kTextStyle(context),
                                                  textAlign: TextAlign.center,
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
                        ), //Name of the participant
                        SizedBox(
                          height: 15,
                        ),
//TODO: Do a scrollable page to the right so you can see all your participants and your participants
                        Container(
                            padding: EdgeInsets.all(8),
                            width: displayWidth(context) * 0.85,
                            height: displayHeight(context) * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
//TODO: Create a list which shows all the loads in the Gig
                            child: CrewMembersList(
                              uidGig: widget.uidGig,
                              userPermission: widget.userPermission,
                            )), //Where all the participants go
                        SizedBox(
                          height: 15,
                        ),
                        SelectionButton(
                          text: 'I\'ve got my Crew',
                          width: displayWidth(context) * 0.85,
                          color: Colors.green,
                          onPress: () => Navigator.pop(context),
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
    } catch (e) {
      // print(e);
      return Container(
        child: Loading(),
        color: Colors.black,
      );
    }
  }
}

//TODO: Add crew from friend list
//TODO: New Crew should see the gig (My gigs, Shared with me)
