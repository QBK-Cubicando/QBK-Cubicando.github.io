import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String uidCrewMember;
  final String nameCrew;
  final String permission;
  final String city;
  final String speciality;
  final NewFriend crew;
  final int index; //TODO: erase index

  NewCrewMember(
      {this.uidCrewMember,
      this.nameCrew,
      this.permission,
      this.index,
      this.city,
      this.speciality,
      this.crew});
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
      return kgreenQBK;
    } else if (permission == 'Just Read') {
      return kredQBK;
    } else if (permission == 'Loader') {
      return kyellowQBK;
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
              crewMemberData: newCrewMember.uidCrewMember,
              isCrewPage: true)
          .gigDeleteCrewMember();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey.shade200,
      width: double.infinity,
      height: displayHeight(context) * 0.11,
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
                          onPress: () async {
                            Navigator.pop(context);
                            _deleteCrewMember();
                            if (newCrewMember.permission == 'Loader') {
                              await Firestore.instance
                                  .collection('gigs')
                                  .document(uidGig)
                                  .updateData({
                                'isLoader': false,
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  );
                });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                'Only Admin Crew can Edit the Gig',
                style: kTextStyle(context)
                    .copyWith(color: Colors.redAccent.shade100),
              ),
            ));
          }
        },
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 30.0,
                    color: _colorCrewMember(newCrewMember.permission),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          newCrewMember.nameCrew,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Text(newCrewMember.speciality)
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    newCrewMember.permission,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
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

    try {
      return StreamBuilder<List<NewCrewMember>>(
          stream: DatabaseService(
                  userUid: user.uid, uidGig: widget.uidGig, isCrewPage: true)
              .gigCrewMemberList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData) {
              List<NewCrewMember> crewMember = snapshot.data;

              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: crewMember.length,
                  itemBuilder: (context, index) {
                    return NewCrewMemberOnList(
                      newCrewMember: crewMember[index],
                      userUid: user.uid,
                      uidGig: widget.uidGig,
                      userPermission: widget.userPermission,
                    );
                  });
            } else {
              return Loading(
                size: displayHeight(context) * 0.09,
              );
            }
          });
    } catch (e) {
      print(e);
      return Loading(
        size: displayHeight(context) * 0.09,
      );
    }
  }
}

/// ------------------------------------------////

class FriendList extends StatefulWidget {
  final bool isCrewPage;
  final bool searchingFriends;
  final String crewMember;
  final String userUid;
  final String uidGig;
  final String permission;
  final int indexOfCrew;
  final bool isLoader;
  final bool pending;
  final bool waitingFriendsAnswer;
  final int lengthCrew;
  final List<String> listCrew;

  FriendList(
      {this.isCrewPage,
      this.searchingFriends,
      this.crewMember,
      this.userUid,
      this.uidGig,
      this.permission,
      this.indexOfCrew,
      this.isLoader,
      this.pending,
      this.waitingFriendsAnswer,
      this.lengthCrew,
      this.listCrew});

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
          isCrewPage: widget.isCrewPage,
          crewMemberData: widget.crewMember,
          searchingFriends: widget.searchingFriends,
          pending: widget.pending,
          waitingFriendsAnswer: widget.waitingFriendsAnswer,
        ).crewMemberList,
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
                  isLoader: widget.isLoader,
                  pending: widget.pending,
                  waitingFriendsAnswer: widget.waitingFriendsAnswer,
                  lengthCrew: widget.lengthCrew,
                  listCrew: widget.listCrew,
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
  final bool isLoader;
  final bool pending;
  final bool waitingFriendsAnswer;
  final int lengthCrew;
  final List<String> listCrew;

  NewFriendTile(
      {this.friend,
      this.isCrewPage,
      this.searchingFriends,
      this.userUid,
      this.uidGig,
      this.permission,
      this.indexOfCrew,
      this.isLoader,
      this.pending,
      this.waitingFriendsAnswer,
      this.lengthCrew,
      this.listCrew});

  @override
  Widget build(BuildContext context) {
    void _deleteFriend(bool isCrew) async {
      ///Delete friend for you
      DatabaseService(
              userUid: userUid,
              uidGig: uidGig,
              uidCrewGig: friend.uid,
              isCrewPage: isCrew,
              crewMemberData: friend.uid)
          .gigDeleteCrewMember();

      ///Delete friend for your friend
      DatabaseService(
              userUid: friend.uid, isCrewPage: false, crewMemberData: userUid)
          .gigDeleteCrewMember();
      if (isCrew) {
        DatabaseService(uidGig: uidGig).checkForIsLoader();
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),

        child: GestureDetector(
          onLongPress: () {
            if (!isCrewPage && !pending) {
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
                              _deleteFriend(false);
                            },
                          ),
                        ],
                      ),
                    );
                  });
            }
            if (!isCrewPage && pending) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: displayHeight(context) * 0.6,
                      width: displayWidth(context) * 0.8,
                      child: AlertDialog(
                        title: Center(
                            child: Text(
                          'Are you sure you want to delete this request?',
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
                            onPress: () async {
                              ///Delete pending for you
                              await Firestore.instance
                                  .collection('users')
                                  .document(userUid)
                                  .collection('pending')
                                  .document(friend.uid)
                                  .delete();

                              ///Delete pending for your friend
                              await Firestore.instance
                                  .collection('users')
                                  .document(friend.uid)
                                  .collection('pending')
                                  .document(userUid)
                                  .delete();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
          onTap: () async {
            try {
              if (isLoader == true && permission == 'Loader') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Just one Loader allowed',
                    style: kTextStyle(context)
                        .copyWith(color: Colors.redAccent.shade100),
                  ),
                ));
              }
              if (isCrewPage) {
                await DatabaseService(
                  userUid: userUid,
                  uidGig: uidGig,
                  uidCrewGig: friend.uid,
                  crewMemberData: friend.uid,
                  isCrewPage: true,
                ).gigSetCrewData(
                  nameCrew: friend.name,
                  permission: isLoader == true && permission == 'Loader'
                      ? 'Just Read'
                      : permission,
                  speciality: friend.speciality,
                  city: friend.city,
                  index: indexOfCrew,
                );
                DatabaseService(uidGig: uidGig).checkForIsLoader();
                DatabaseService(uidGig: uidGig).updateCrewNumberGig(
                    crew: listCrew.contains(friend.uid)
                        ? lengthCrew
                        : lengthCrew + 1,
                    user: userUid);
                Navigator.pop(context, friend);
              } else {
                if (searchingFriends == true) {
                  if (userUid != friend.uid) {
                    DatabaseService(
                            userUid: userUid,
                            isCrewPage: false,
                            crewMemberData: friend.uid,
                            pending: true,
                            waitingFriendsAnswer: true)
                        .gigSetCrewData(
                      nameCrew: friend.name,
                      speciality: friend.speciality,
                      city: friend.city,
                    );
                  }
                  Navigator.pop(context);
                }
                if (pending && !waitingFriendsAnswer) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: displayHeight(context) * 0.6,
                          width: displayWidth(context) * 0.8,
                          child: AlertDialog(
                            title: Center(
                                child: Text(
                              'Accept ${friend.name} friend request?',
                              style: kTextStyle(context).copyWith(
                                  color: Colors.black,
                                  fontSize: displayWidth(context) * 0.05),
                            )),
                            actions: <Widget>[
                              SelectionButton(
                                text: 'No',
                                color: Colors.redAccent,
                                onPress: () async {
                                  ///Delete pending for you
                                  await Firestore.instance
                                      .collection('users')
                                      .document(userUid)
                                      .collection('pending')
                                      .document(friend.uid)
                                      .delete();

                                  ///Delete pending for your friend
                                  await Firestore.instance
                                      .collection('users')
                                      .document(friend.uid)
                                      .collection('pending')
                                      .document(userUid)
                                      .delete();
                                  Navigator.pop(context);
                                },
                              ),
                              SelectionButton(
                                text: 'Yes',
                                color: Colors.greenAccent,
                                onPress: () async {
                                  DatabaseService(
                                          userUid: userUid,
                                          crewMemberData: friend.uid)
                                      .gigAddFriend(
                                    name: friend.name,
                                    city: friend.city,
                                    speciality: friend.speciality,
                                  );

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                }
              }
            } catch (e) {
              print(e);
            }
          },
          child: Container(
            height: displayHeight(context) * 0.11,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 30.0,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            friend.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        friend.speciality,
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      friend.city,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        /// NewGigTile for Copy
      ),
    );
  }
}
