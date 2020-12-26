import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///READ but not Documentated
class MyFriends extends StatefulWidget {
  static const String id = 'my_friends';
  final String userUid;

  const MyFriends({this.userUid});

  @override
  _MyFriendsState createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  var futureFriendsList;
  var friendsList = [];
  // List friendsListSearching = [];
  // List futureFriendsListSearching;
  NewFriend newFriend;

  TextEditingController _controller = TextEditingController();

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
    final user = Provider.of<UserData>(context);

    try {
      return StreamBuilder<List<NewFriend>>(
          stream: DatabaseService(
                  userUid: user.uid,
                  friendsList: friendsList,
                  isCrewPage: false,
                  searchingFriends: false)
              .crewMemberList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              Widget _friendsListIsEmpty() {
                return snapshot.data.length != 0
                    ? SingleChildScrollView(
                        child: FriendList(
                          friendsList: friendsList,
                          isCrewPage: false,
                          searchingFriends: false,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: displayWidth(context) * 0.9,
                              child: Center(
                                child: Text(
                                  'No Friends added yet !',
                                  style: kTextStyle(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              }

              return UpperBar(
                  text: 'My Friends',
                  onBackGoTo: QBKHomePage(),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFieldQBK(
                                width: displayWidth(context) * 0.6,
                                validator: (value) =>
                                    value.isEmpty ? 'Enter valid email' : null,
                                controller: _controller,
                                hintText: 'email',
                                maxLines: 1,
                              ),
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
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          color: Colors.grey,
                                          height: displayHeight(context) * 0.3,
                                          width: displayWidth(context) * 0.7,
                                          child: FriendList(
                                            friendsList: friendsList,
                                            isCrewPage: false,
                                            searchingFriends: true,
                                            crewMember: _controller.text,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  setState(() {});
                                  _controller.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Container(
                            width: displayWidth(context),
                            child: _friendsListIsEmpty(),
                          ),
                        ),
                        SizedBox()
                      ],
                    ),
                  ));
            } else {
              return Container(
                child: Loading(),
                color: Colors.black,
              );
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

//TODO: Refresh Page when delete friend
//TODO: Send Invitation and accept
