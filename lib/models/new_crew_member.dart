import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

import 'package:qbk_simple_app/utilities/constants.dart';

///READ but not Documentated

class NewFriend {
  final String uid;
  final String name;
  final String email;
  final String city;
  final String speciality;
  final phone;

  NewFriend(
      {this.uid,
      this.name,
      this.email,
      this.city,
      this.speciality,
      this.phone});
}

class NewCrewMember {
  //TODO: get the email or uid so you can delete with no error
  final String uidCrewMember;
  final String nameCrew;
  final String permission;
  final int index; //TODO: erase index

  NewCrewMember(
      {this.uidCrewMember, this.nameCrew, this.permission, this.index});
}

class NewCrewMemberOnList extends StatelessWidget {
  NewCrewMemberOnList(
      {this.newCrewMember, this.uidGig, this.userUid, this.userPermission});

  final NewCrewMember newCrewMember;
  final String userUid;
  final String uidGig;
  final String userPermission;

  ///This is the permission of the person interacting
  ///in the Create Gig Page
  //TODO: Add picture of Crew Member

  Color _colorCrewMember(String permission) {
    if (permission == 'Admin') {
      return Colors.green;
    } else if (permission == 'Just Read') {
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _deleteCrewMember() {
      DatabaseService(
              userUid: userUid,
              uidGig: uidGig,
              uidCrewGig: newCrewMember.uidCrewMember,
              crewMemberData: newCrewMember.uidCrewMember)
          .gigDeleteCrewMember();
    }

    return Container(
      child: GestureDetector(
        onLongPress: () {
          if (userPermission == 'Admin') {
            showDialog(
                context: context,
                builder: (context) {
                  return Container(
                    height: displayHeight(context) * 0.6,
                    width: displayWidth(context) * 0.8,
                    child: AlertDialog(
                      title: Center(
                          child: Text(
                        'Are you sure you want to delete ${newCrewMember.nameCrew}?',
                        style: kTextStyle(context).copyWith(
                            color: Colors.black,
                            fontSize: displayWidth(context) * 0.05),
                      )),
                      actions: <Widget>[
                        SelectionButton(
                          text: 'Cancel',
                          color: Colors.blueAccent,
                          onPress: () => Navigator.pop(context),
                        ),
                        SelectionButton(
                          text: 'Delete',
                          color: Colors.redAccent,
                          onPress: () {
                            Navigator.pop(context);
                            _deleteCrewMember();
                          },
                        ),
                      ],
                    ),
                  );
                });
          }
        },
        child: Column(
          children: <Widget>[
            Icon(
              Icons.accessibility_new,
              size: 40.0,
            ),
            Container(
              color: _colorCrewMember(newCrewMember.permission),
              //TODO: Give a font and size
              child: Center(
                child: Text(
                  newCrewMember.nameCrew.substring(0, 5),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CrewMembersList extends StatefulWidget {
  final String uidGig;
  final String userPermission;

  ///This is the permission of the person interacting
  ///in the Create Gig Page

  CrewMembersList({this.uidGig, this.userPermission});

  @override
  _CrewMembersListState createState() => _CrewMembersListState();
}

class _CrewMembersListState extends State<CrewMembersList> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<NewCrewMember>>(
        stream: DatabaseService(userUid: user.uid, uidGig: widget.uidGig)
            .gigCrewMemberList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            List<NewCrewMember> crewMember = snapshot.data;

            return GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: crewMember.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return NewCrewMemberOnList(
                    newCrewMember: crewMember[index],
                    userUid: user.uid,
                    uidGig: widget.uidGig,
                    userPermission: widget.userPermission,
                  );
                });
          } else {
            return Loading();
          }
        });
  }
}

/// ------------------------------------------////

class FriendList extends StatefulWidget {
  final List friendsList;
  final bool isCrewPage;
  final bool searchingFriends;
  final String crewMember;
  final String userUid;
  final String uidGig;
  final String permission;
  final int indexOfCrew;

  FriendList(
      {this.friendsList,
      this.isCrewPage,
      this.searchingFriends,
      this.crewMember,
      this.userUid,
      this.uidGig,
      this.permission,
      this.indexOfCrew});

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<NewFriend>>(
        stream: DatabaseService(
                userUid: user.uid,
                friendsList: widget.friendsList,
                isCrewPage: widget.isCrewPage,
                crewMemberData: widget.crewMember,
                searchingFriends: widget.searchingFriends)
            .crewMemberList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            List<NewFriend> friends = snapshot.data;

            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return NewFriendTile(
                  friend: friends[index],
                  isCrewPage: widget.isCrewPage,
                  searchingFriends: widget.searchingFriends,
                  userUid: user.uid,
                  uidGig: widget.uidGig,
                  permission: widget.permission,
                  indexOfCrew: widget.indexOfCrew,
                  friendsList: widget.friendsList,
                );
              },
            );
          } else {
            return Loading();
          }
        });
  }
}

class NewFriendTile extends StatelessWidget {
  final NewFriend friend;
  // final bool isCopyPage;
  final bool isCrewPage;
  final bool searchingFriends;
  final String userUid;
  final String uidGig;
  final String permission;
  final int indexOfCrew;
  final List friendsList;

  NewFriendTile(
      {this.friend,
      this.isCrewPage,
      this.searchingFriends,
      this.userUid,
      this.uidGig,
      this.permission,
      this.indexOfCrew,
      this.friendsList});

  @override
  Widget build(BuildContext context) {
    void _deleteFriend() {
      friendsList.remove(friend.uid);
      DatabaseService(userUid: userUid)
          .setFriendsList(friendsList: friendsList);
      DatabaseService(userUid: userUid, uidGig: uidGig, uidCrewGig: friend.uid)
          .gigDeleteCrewMember();
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),

        child: ListTile(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: displayHeight(context) * 0.6,
                      width: displayWidth(context) * 0.8,
                      child: AlertDialog(
                        title: Center(
                            child: Text(
                          'Are you sure you want to delete ${friend.name}?',
                          style: kTextStyle(context).copyWith(
                              color: Colors.black,
                              fontSize: displayWidth(context) * 0.05),
                        )),
                        actions: <Widget>[
                          SelectionButton(
                            text: 'Cancel',
                            color: Colors.blueAccent,
                            onPress: () => Navigator.pop(context),
                          ),
                          SelectionButton(
                            text: 'Delete',
                            color: Colors.redAccent,
                            onPress: () {
                              Navigator.pop(context);
                              _deleteFriend();
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
            onTap: () {
              try {
                if (isCrewPage) {
                  DatabaseService(
                    userUid: userUid,
                    uidGig: uidGig,
                    uidCrewGig: friend.uid,
                    crewMemberData: friend.uid,
                  ).gigSetCrewData(
                    nameCrew: friend.name,
                    permission: permission,
                    index: indexOfCrew,
                  );
                  Navigator.pop(context, friend);
                } else {
                  if (searchingFriends == true) {
                    friendsList.add(friend.uid);
                    DatabaseService(userUid: userUid)
                        .setFriendsList(friendsList: friendsList);
                    Navigator.pop(context);
                  }
                }
              } catch (e) {
                print(e);
              }
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  friend.name,
                  style: kTextStyle(context).copyWith(color: Colors.black),
                ),
                Text(
                  friend.speciality,
                  style: kTextStyle(context)
                      .copyWith(color: Colors.black), //Todo:Reducir Font
                ),
              ],
            ),
            subtitle: Text(
              friend.city,
              style: kTextStyle(context)
                  .copyWith(color: Colors.black), //Todo:Reducir Font
            )),

        /// NewGigTile for Copy
      ),
    );
  }
}
