import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/notification_stack.dart';
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
  
  NewFriend newFriend;

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    try {
      return StreamBuilder<List<NewFriend>>(
          stream: DatabaseService(
                  userUid: user.uid,             
                  isCrewPage: false,
                  searchingFriends: false, 
                  pending: false,
                  waitingFriendsAnswer: false)
              .crewMemberList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              Widget _friendsListIsEmpty(bool pend, bool wait) {
                return snapshot.data.length != 0
                    ? FriendList(
                        isCrewPage: false,
                        searchingFriends: false,
                        pending: pend,
                        waitingFriendsAnswer: wait,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: displayWidth(context) * 0.9,
                              child: Center(
                                child: Text(pend ? 'No pending friend requests' :
                                  'No Friends added yet !',
                                  style: kTextStyle(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              }

              return DefaultTabController(
                length: 2,
                child: UpperBar(
                    text: 'My Friends',
                    onBackGoTo: QBKHomePage(),
                    tabBar: TabBar(
                      tabs: [
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                            child: Text(
                              'Friends',
                              style: kTextStyle(context),
                            ),
                          ),
                        NotificationStack(
                          
                          userUid: user.uid,
                          notificationType: 'friends',
                          icon: Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                            child: Text(
                              'Pending',
                              style: kTextStyle(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Container(
                      height: displayHeight(context) * 0.8,
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    height: displayHeight(context) * 0.75,
                                    width: displayWidth(context),
                                    child: _friendsListIsEmpty(false, false),
                                  ),
                                ),
                                SizedBox()
                              ],
                            ),
                          ),
                         SingleChildScrollView(
                         child: Column(
                             children: [
                               Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldQBK(
                                    width: displayWidth(context) * 0.6,
                                    validator: (value) => value.isEmpty
                                        ? 'Enter valid email'
                                        : null,
                                    controller: _controller,
                                    hintText: 'email',
                                    maxLines: 1,
                                  ),
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
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Container(
                                              color: Colors.grey,
                                              height:
                                                  displayHeight(context) *
                                                      0.3,
                                              width: displayWidth(context) *
                                                  0.9,
                                              child: FriendList(
                                                isCrewPage: false,
                                                searchingFriends: true,
                                                crewMember:
                                                    _controller.text,
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
                            //TODO: Make this widget bellow expansive, so when it's empty it contracts
                               Container(
                                 child: Text('Friend Requests', 
                                              style: kTextStyle(context),),
                               ),
                               Center(
                                  child: Container(
                                    height: displayHeight(context) * 0.35,
                                    width: displayWidth(context),
                                    child: FriendList(
                                              isCrewPage: false,
                                              searchingFriends: false,
                                              pending: true,
                                              waitingFriendsAnswer: false,
                                            ),
                                        ),
                                      ),
                                SizedBox(height: 20,),
                                Container(
                                 child: Text('Pending Responses', style: kTextStyle(context),),
                               ),
                               Center(
                                  child: Container(
                                    height: displayHeight(context) * 0.35,
                                    width: displayWidth(context),
                                    child: FriendList(
                                              isCrewPage: false,
                                              searchingFriends: false,
                                              pending: true,
                                              waitingFriendsAnswer: true,
                                            ),
                                        ),
                                      ),
                             ],
                           ),
                         ),
                            
                        ],
                      ),
                    )),
              );
            } else {
              return Container(
                child: Loading(),
                color: Colors.black,
              );
            }
          });
    } catch (e) {
       print(e);
      return Container(
        child: Loading(),
        color: Colors.black,
      );
    }
  }
}

//TODO: Refresh Page when delete friend
//TODO: Send Invitation and accept
