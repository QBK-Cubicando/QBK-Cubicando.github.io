import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qbk_simple_app/a_screens_pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:intl/intl.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/models/load.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';

import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';

import '../../ui/sizes-helpers.dart';
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

  @override
  void initState() {
    futurePermissionAndIndex =
        DatabaseService(crewMemberData: widget.userUid, uidGig: widget.uidGig)
            .getCrewPermission();
    _setPermissionAndIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<NewCrewMember>>(
        stream: DatabaseService(
          userUid: user.uid, 
          uidGig: widget.uidGig,
          isCrewPage: true)
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
                        return LoadList(
                          uidGig: widget.uidGig,
                          isCopyPage: false,
                          permission: permission,
                          index: index,
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
                          ],
                        );
                      }
                    }

                    return permission == 'Admin'
                        ? UpperBar(
                            text: 'Create Gig',
                            onBackGoTo: QBKHomePage(),
                            body: Center(
                              child: Container(
                                width: displayWidth(context),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            widget.nameGig.length > 10
                                                ? widget.nameGig
                                                    .substring(0, 10)
                                                : widget.nameGig,
                                            style: kTextStyle(context),
                                          ),
                                        ), //Gig's Name
                                        Container(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            widget.startDate,
                                            style: kTextStyle(context),
                                          ),
                                        ), // Gig's Date
                                      ],
                                    ), //Name and Day of the Gig
                                    Column(
                                      children: <Widget>[
                                        SelectionButton(
                                          text: 'New Roadie',
                                          color: Colors.orange,
                                          width: displayWidth(context) * 0.6,
                                          onPress: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CrewQBK(
                                                  userPermission: permission,
                                                  uidGig: widget.uidGig,
                                                  userUid: user.uid),
                                            ),
                                          ),
                                        ), //New Participant
                                        SizedBox(
                                          height: 25.0,
                                        ),
                                        SelectionButton(
                                            //TODO:Limit Loads
                                            text: 'Create Load',
                                            width: displayWidth(context) * 0.6,
                                            color: Colors.green,
                                            onPress: () {
                                              if (loadList.length < 4) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Form(
                                                        key: _formKey,
                                                        child: Container(
                                                          height: displayHeight(
                                                                  context) *
                                                              0.5,
                                                          width: displayWidth(
                                                                  context) *
                                                              0.7,
                                                          child: AlertDialog(
                                                            title: Column(
                                                              children: <
                                                                  Widget>[
                                                                Center(
                                                                    child: Text(
                                                                  'Name your new Load',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: kTextStyle(
                                                                          context)
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                )),
                                                                SizedBox(
                                                                    height:
                                                                        10.0),
                                                                TextFieldQBK(
                                                                  maxLength: 6,
                                                                  hintText:
                                                                      'Name Load',
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      nameLoad =
                                                                          value;
                                                                    });
                                                                  },
                                                                  validator: (value) =>
                                                                      value.isEmpty
                                                                          ? 'Type a valid Name'
                                                                          : null,
                                                                ),
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              SelectionButton(
                                                                text: 'Cancel',
                                                                color: Colors
                                                                    .redAccent,
                                                                onPress: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                              SelectionButton(
                                                                text: 'Create',
                                                                color: Colors
                                                                    .green,
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
                                                                style:
                                                                    kTextStyle(
                                                                        context),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            }), //Create Load
                                        SizedBox(
                                          height: 25.0,
                                        ),
//                          SelectionButton(
//                            text: 'Copy Load',
//                            color: Colors.yellow,
//                            height: 50.0,
//                            width: 300.0,
//                            onPress: (){
//                              Navigator.push(context, MaterialPageRoute(
//                                builder: (context){
//                                  return CopyLoadPage(uidThisGig: widget.uidGig,);
//                                }
//                              ));
//                            },
//                          ),//Copy Load
                                      ],
                                    ), //Buttons
                                    SizedBox(
                                      height: 15.0,
                                    ),

                                    Container(
                                      width: displayWidth(context) * 0.85,
                                      height: displayHeight(context) * 0.18,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
//TODO: Create a list which shows all the loads in the Gig
                                      child: _loadListIsEmpty(),
                                    ), //Where all the loads go
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      width: displayWidth(context) * 0.85,
                                      height: displayHeight(context) * 0.18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: _crewListIsEmpty('Admin'),
                                    ), //Where all the participants go
                                    SelectionButton(
                                      text: 'I\'m Ready !',
                                      width: displayWidth(context) * 0.85,
                                      color: Colors.green,
                                      onPress: () {
                                        Navigator.pushNamed(
                                            context, QBKHomePage.id);
                                      },
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : UpperBar(
                            text: 'Create Gig',
                            onBackGoTo: QBKHomePage(),
                            body: Center(
                              child: Container(
                                width: displayWidth(context),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            widget.nameGig.length > 10
                                                ? widget.nameGig
                                                    .substring(0, 10)
                                                : widget.nameGig,
                                            style: kTextStyle(context),
                                          ),
                                        ), //Gig's Name
                                        Container(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            widget.startDate,
                                            style: kTextStyle(context),
                                          ),
                                        ), // Gig's Date
                                      ],
                                    ), //Name and Day of the Gig//Buttons
                                    SizedBox(
                                      height: 15.0,
                                    ),

                                    Container(
                                      width: displayWidth(context) * 0.85,
                                      height: displayHeight(context) * 0.18,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
//TODO: Create a list which shows all the loads in the Gig
                                      child: _loadListIsEmpty(),
                                    ), //Where all the loads go
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      width: displayWidth(context) * 0.85,
                                      height: displayHeight(context) * 0.18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: _crewListIsEmpty('Just Read'),
                                    ), //Where all the participants go
                                    SelectionButton(
                                      text: 'I\'m Ready !',
                                      width: displayWidth(context) * 0.85,
                                      color: Colors.green,
                                      onPress: () {
                                        Navigator.pushNamed(
                                            context, QBKHomePage.id);
                                      },
                                    ),
                                    SizedBox(
                                      height: 5.0,
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
          } else {
            return Container(
              child: Loading(),
              color: Colors.black26,
            );
          }
        });
  }
}
