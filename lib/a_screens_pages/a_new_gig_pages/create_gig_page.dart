import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qbk_simple_app/a_screens_pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/a_screens_pages/load_page.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:intl/intl.dart';
import 'package:qbk_simple_app/ab_created_widgets/top_qbk.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/models/load.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';

import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';

import '../../ui/sizes-helpers.dart';
import 'copy_load_page.dart';
import 'crew_page.dart';

///Documentated

class CreateGigPage extends StatefulWidget {
  static const String id = 'create_gig_page';

  CreateGigPage({
    @required this.uidGig,
    this.nameGig,
    this.startDate,
    this.userUid,
  });

  final String nameGig;
  final String startDate;
  final String uidGig;
  final String userUid;

  @override
  _CreateGigPageState createState() => _CreateGigPageState();
}

class _CreateGigPageState extends State<CreateGigPage> {
  final _formKey = GlobalKey<FormState>();
  final dateTimeNow =
      DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa').format(DateTime.now());

  String nameLoad;
  String permission = 'Admin';
  int index = 1;
  List permissionAndIndex;
  var futurePermissionAndIndex;
  Future<NewGig> fetchedGig;
  NewGig gig;

  _setPermissionAndIndex() async {
    if (futurePermissionAndIndex != null) {
      permissionAndIndex = await futurePermissionAndIndex;
      permission = await permissionAndIndex[0];
      index = await permissionAndIndex[1];
    } else {
      permission = 'Admin';
      index = 1;
    }
    setState(() {});
  }

  _fetchGigFromFirebase() async {
    gig = await fetchedGig;
  }

  Color _gigColor() {
    // print(widget.calendarGig.color);
    if (gig.color == 'red') {
      return kredQBK;
    } else if (gig.color == 'blue') {
      return kblueQBK;
    } else if (gig.color == 'green') {
      return kgreenQBK;
    } else if (gig.color == 'purple') {
      return kpurpleQBK;
    } else if (gig.color == 'orange') {
      return Colors.orangeAccent.shade200;
    } else {
      return Colors.grey.shade50;
    }
  }

  @override
  void initState() {
    futurePermissionAndIndex =
        DatabaseService(crewMemberData: widget.userUid, uidGig: widget.uidGig)
            .getCrewPermission();
    _setPermissionAndIndex();

    fetchedGig = DatabaseService(uidGig: widget.uidGig).getGigOnce();
    _fetchGigFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<NewCrewMember>>(
        stream: DatabaseService(
                userUid: user.uid, uidGig: widget.uidGig, isCrewPage: true)
            .gigCrewMemberList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            List<NewCrewMember> newCrewMember = snapshot.data;

            _setGigAdministrator() async {
              print(user.name);
              await DatabaseService(
                userUid: user.uid,
                uidGig: widget.uidGig,
                uidCrewGig: user.uid,
                crewMemberData: user.uid,
                isCrewPage: true,
              ).gigSetCrewData(
                nameCrew: 'Admin',
                permission: 'Admin',
                index: 1,
              );
            }

            Widget _crewListIsEmpty(userPermission) {
              if (newCrewMember.length != 0) {
                return CrewMembersList(
                  uidGig: widget.uidGig,
                  userPermission: userPermission,
                );
              } else {
                _setGigAdministrator();
                return CrewMembersList(
                  uidGig: widget.uidGig,
                  userPermission: userPermission,
                );
                // return Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Center(
                //       child: Container(
                //         child: Text(
                //           'No Crew added yet !',
                //           style:
                //               kTextStyle(context).copyWith(color: Colors.black),
                //         ),
                //       ),
                //     ),
                //   ],
                // );
              }
            }

            return StreamBuilder<List<Load>>(
                stream: DatabaseService(
                  userUid: user.uid,
                  uidGig: widget.uidGig,
                ).loadListData,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }

                  if (snapshot.hasData) {
                    List<Load> loadList = snapshot.data;

                    Widget _loadListIsEmpty() {
                      if (loadList.length != 0) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: LoadList(
                                uidGig: widget.uidGig,
                                isCopyPage: false,
                                permission: permission,
                                index: index,
                              ),
                            ),
                            permission == "Admin"
                                ? Expanded(
                                    child: GestureDetector(
                                      child: Container(
                                          color: kredQBK,
                                          height: displayHeight(context) * 0.13,
                                          width: displayWidth(context) * 0.1,
                                          child: Icon(
                                              Icons.add_circle_outline_sharp)),
                                      onTap: () {
                                        if (loadList.length < 3) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Form(
                                                  key: _formKey,
                                                  child: Container(
                                                    height:
                                                        displayHeight(context) *
                                                            0.5,
                                                    width:
                                                        displayWidth(context) *
                                                            0.7,
                                                    child: AlertDialog(
                                                      title: Column(
                                                        children: <Widget>[
                                                          Center(
                                                              child: Text(
                                                            'New Load',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: kTextStyle(
                                                                    context)
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          )),
                                                          SizedBox(
                                                              height: 10.0),
                                                          TextFieldQBK(
                                                            maxLength: 6,
                                                            hintText:
                                                                'Name Load',
                                                            onChanged: (value) {
                                                              setState(() {
                                                                nameLoad =
                                                                    value;
                                                              });
                                                            },
                                                            validator:
                                                                (value) => value
                                                                        .isEmpty
                                                                    ? 'Type a valid Name'
                                                                    : null,
                                                          ),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: displayWidth(
                                                                      context) *
                                                                  0.35,
                                                              child:
                                                                  SelectionButton(
                                                                text: 'BACK',
                                                                color:
                                                                    kyellowQBK,
                                                                onPress: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: displayWidth(
                                                                      context) *
                                                                  0.06,
                                                            ),
                                                            Container(
                                                              width: displayWidth(
                                                                      context) *
                                                                  0.35,
                                                              child:
                                                                  SelectionButton(
                                                                text: 'SAVE',
                                                                color:
                                                                    kyellowQBK,
                                                                onPress:
                                                                    () async {
                                                                  if (_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    await DatabaseService(
                                                                            userUid:
                                                                                user.uid,
                                                                            uidGig: widget.uidGig,
                                                                            uidLoad: '${user.uid}${widget.uidGig}$nameLoad')
                                                                        .setLoadData(
                                                                      nameLoad:
                                                                          nameLoad,
                                                                    );
                                                                    await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return CreateLoadPage(
                                                                        uidGig:
                                                                            widget.uidGig,
                                                                        nameGig:
                                                                            widget.nameGig,
                                                                        nameLoad:
                                                                            nameLoad,
                                                                        uidLoad:
                                                                            '${user.uid}${widget.uidGig}$nameLoad',
                                                                      );
                                                                    }));
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
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
                                                          'You reached the max loads for this Gig',
                                                          style: kTextStyle(
                                                                  context)
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                child: Text(
                                  'No Loads added yet !',
                                  style: kTextStyle(context)
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                  color: kredQBK,
                                  height: displayHeight(context) * 0.13,
                                  width: displayWidth(context) * 0.2,
                                  child: Icon(Icons.add_circle_outline_sharp)),
                              onTap: () {
                                if (loadList.length < 3) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Form(
                                          key: _formKey,
                                          child: Container(
                                            height:
                                                displayHeight(context) * 0.5,
                                            width: displayWidth(context) * 0.7,
                                            child: AlertDialog(
                                              title: Column(
                                                children: <Widget>[
                                                  Center(
                                                      child: Text(
                                                    'New Load',
                                                    textAlign: TextAlign.center,
                                                    style: kTextStyle(context)
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  )),
                                                  SizedBox(height: 10.0),
                                                  TextFieldQBK(
                                                    maxLength: 6,
                                                    hintText: 'Name Load',
                                                    onChanged: (value) {
                                                      setState(() {
                                                        nameLoad = value;
                                                      });
                                                    },
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? 'Type a valid Name'
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: displayWidth(
                                                              context) *
                                                          0.35,
                                                      child: SelectionButton(
                                                        text: 'BACK',
                                                        color: kyellowQBK,
                                                        onPress: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: displayWidth(
                                                              context) *
                                                          0.06,
                                                    ),
                                                    Container(
                                                      width: displayWidth(
                                                              context) *
                                                          0.35,
                                                      child: SelectionButton(
                                                        text: 'SAVE',
                                                        color: kyellowQBK,
                                                        onPress: () async {
                                                          if (_formKey
                                                              .currentState
                                                              .validate()) {
                                                            await DatabaseService(
                                                                    userUid: user
                                                                        .uid,
                                                                    uidGig: widget
                                                                        .uidGig,
                                                                    uidLoad:
                                                                        '${user.uid}${widget.uidGig}$nameLoad')
                                                                .setLoadData(
                                                              nameLoad:
                                                                  nameLoad,
                                                            );
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return CreateLoadPage(
                                                                uidGig: widget
                                                                    .uidGig,
                                                                nameGig: widget
                                                                    .nameGig,
                                                                nameLoad:
                                                                    nameLoad,
                                                                uidLoad:
                                                                    '${user.uid}${widget.uidGig}$nameLoad',
                                                              );
                                                            }));
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
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
                                                  'You reached the max loads for this Gig',
                                                  style: kTextStyle(context),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              },
                            ),
                          ],
                        );
                      }
                    }

                    return Scaffold(
                      body: SingleChildScrollView(
                        child: SafeArea(
                          child: Center(
                            child: Container(
                              width: displayWidth(context) * 0.95,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TopQBK(
                                    nav: QBKHomePage.id,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          textColor: Colors.black,
                                          title: Row(
                                            children: [
                                              Icon(Icons.music_note_rounded),
                                              Text(
                                                widget.nameGig,
                                                style:
                                                    kButtonsTextStyle(context),
                                              )
                                            ],
                                          ),
                                          backgroundColor: kgreenQBK,
                                          collapsedBackgroundColor: kgreenQBK,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height:
                                                  displayHeight(context) * 0.3,
                                              color: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      displayWidth(context) *
                                                          0.05),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 13,
                                                        height: 13,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    _gigColor()),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      //TODO: CHANGE THIS TO COMPARE START AND END DATE
                                                      widget.startDate != null
                                                          ? Text(
                                                              widget.startDate,
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            )
                                                          : Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                    child: Text(
                                                                        'From: ${widget.startDate}')),
                                                                Container(
                                                                    child: Text(
                                                                        'To: ${gig.endDate}'))
                                                              ],
                                                            ),
                                                    ],
                                                  ),
                                                  Text(gig.location,
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Notes:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SingleChildScrollView(
                                                    child: Text(gig.notes),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: ExpansionTile(
                                          textColor: Colors.black,
                                          backgroundColor: kblueQBK,
                                          collapsedBackgroundColor: kblueQBK,
                                          title: Row(
                                            children: [
                                              Icon(Icons.person),
                                              Row(
                                                children: [
                                                  Text(
                                                    'CREW',
                                                    style: kButtonsTextStyle(
                                                        context),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      '(${newCrewMember.length} people)')
                                                ],
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: _crewListIsEmpty(
                                                        permission),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  permission == "Admin"
                                                      ? Center(
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                                color: kblueQBK,
                                                                height: displayHeight(
                                                                        context) *
                                                                    0.13,
                                                                width: displayWidth(
                                                                        context) *
                                                                    0.18,
                                                                child: Icon(Icons
                                                                    .add_circle_outline_sharp)),
                                                            onTap: () =>
                                                                Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => CrewQBK(
                                                                    userPermission:
                                                                        permission,
                                                                    uidGig: widget
                                                                        .uidGig,
                                                                    userUid: user
                                                                        .uid,
                                                                    crewNumber:
                                                                        newCrewMember
                                                                            .length),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          textColor: Colors.black,
                                          backgroundColor: kredQBK,
                                          collapsedBackgroundColor: kredQBK,
                                          title: Row(
                                            children: [
                                              Icon(Icons
                                                  .directions_bus_filled_outlined),
                                              Text(
                                                'LOADS',
                                                style:
                                                    kButtonsTextStyle(context),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(8),
                                              child: _loadListIsEmpty(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Loading();
                  }
                });
          } else {
            return Container(
              child: Loading(),
              color: Colors.black26,
            );
          }
        });
  }
}
