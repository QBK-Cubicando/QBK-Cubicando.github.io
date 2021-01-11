import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';

class NotificationStack extends StatefulWidget {
  final String userUid;
  final Widget icon;
  final String notificationType;

  const NotificationStack(
      {Key key,
      this.userUid,
      this.icon,
      this.notificationType,
      })
      : super(key: key);

  @override
  _NotificationStackState createState() => _NotificationStackState();
}

class _NotificationStackState extends State<NotificationStack> {
  int badgeCount;
  int friendPendingCount = 0;
  int gigPendingCount = 0;

  @override
  Widget build(BuildContext context) {
    Widget badge(int count) => Positioned(
          right: 0,
          top: 0,
          child: new Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(7.5),
            ),
            constraints: BoxConstraints(
              minWidth: 15,
              minHeight: 15,
            ),
            child: Text(
              count.toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );

    try {
      return StreamBuilder<List<NewFriend>>(
          stream: DatabaseService(
                  userUid: widget.userUid,
                  isCrewPage: false,
                  searchingFriends: false,
                  pending: true,
                  waitingFriendsAnswer: false)
              .crewMemberList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              friendPendingCount = snapshot.data.length;
              return StreamBuilder<List<NewGig>>(
                  stream: DatabaseService(
                          userUid: widget.userUid,
                          sharedGigs: true,
                          crewMemberData: widget.userUid,
                          pending: true)
                      .gigList,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      gigPendingCount = snapshot.data.length;
                      if (widget.notificationType == 'friends') {
                        badgeCount = friendPendingCount;
                      } else if (widget.notificationType == 'gigs') {
                        badgeCount = gigPendingCount;
                      } else {
                        badgeCount = friendPendingCount + gigPendingCount;
                      }

                      

                      return Stack(
                        children: [
                          widget.icon,
                          if (badgeCount > 0) badge(badgeCount)
                        ],
                      );
                    } else {
                      return widget.icon;
                    }
                  });
            } else {
              return widget.icon;
            }
          });
    } catch (e) {
      print(e);
      return widget.icon;
    }
  }
}
