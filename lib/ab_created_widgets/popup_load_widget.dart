import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/load_selection_button_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';

import 'a_buttons/selection_button_widget.dart';

///Documentated
class PopupCreateLoad extends StatefulWidget {
  PopupCreateLoad({
    @required this.title,
    @required this.uidGig,
    @required this.uidLoad,
    this.flightCaseList,
  });
  final String title;
  final String uidGig;
  final String uidLoad;
  final List<FlightCase> flightCaseList;

  @override
  _PopupCreateLoadState createState() => _PopupCreateLoadState();
}

class _PopupCreateLoadState extends State<PopupCreateLoad> {
  final _formKey = GlobalKey<FormState>();

  final dateTimeNow =
      DateFormat('yyyyy.MMMMM.dd GGG hh:mm:ss aaa').format(DateTime.now());

  String nameFlightCase;
  int quantity = 1;
  bool wheels = false;
  bool tilt = true;
  bool stack = true;
  List<FlightCase> flightCaseListUpdated;
  String color = 'Blue';

  //TODO: fix this
  ///Prevents the quantity of flightCases to go under 1 and over 100
  void stopQuantity() {
    quantity <= 0 ? quantity = 1 : null;
    quantity >= 100 ? quantity = 100 : null;
  }

  addFlightCaseToList() {
    flightCaseListUpdated.add(FlightCase(
      nameFlightCase: nameFlightCase,
      typeFlightCase: widget.title,
      quantity: quantity,
      wheels: wheels,
      tilt: tilt,
      stack: stack,
      loaded: false,
      index: flightCaseListUpdated.length + 1,
      color: color,
    ));
  }

  addCaseToOwnList(String userUid) {
    DatabaseService(userUid: userUid).setOwnCaseData(
        nameFlightCase: nameFlightCase,
        typeFlightCase: widget.title,
        wheels: wheels,
        tilt: tilt,
        stack: stack,
        color: color);
  }

  Color _flightCaseColor(String color) {
    if (color == 'Red') {
      return kredQBK;
    } else if (color == 'Blue') {
      return kblueQBK;
    } else if (color == 'Green') {
      return kgreenQBK;
    } else if (color == 'Purple') {
      return kpurpleQBK;
    } else if (color == 'Orange') {
      return Colors.orangeAccent.shade100;
    } else {
      return Colors.grey;
    }
  }

  @override
  void initState() {
    flightCaseListUpdated = widget.flightCaseList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return AlertDialog(
      backgroundColor: Colors.grey.shade300,
      content: Container(
        height: displayHeight(context) * 0.8,
        width: displayWidth(context) * 0.7,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFieldQBK(
                  maxLength: 10,
                  hintText: 'Name',
                  onChanged: (value) => setState(() => nameFlightCase = value),
                  validator: (value) => value.isEmpty ? 'Provide a name' : null,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        child: TextField(
                          maxLines: 1,
                          maxLength: 3,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          controller:
                              TextEditingController(text: quantity.toString()),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 4, bottom: 25),
                        color: Colors.grey.shade500,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4, bottom: 25),
                        color: Colors.grey.shade500,
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => setState(() {
                            quantity--;
                            stopQuantity();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                CheckBoxCreateLoad(
                  text: 'Wheels',
                  icon: Icons.blur_circular,
                  checkboxValue: wheels,
                  onChanged: (value) {
                    tilt == true ? tilt = false : null;
                    stack == true ? stack = false : null;
                    setState(() => wheels = value);
                  },
                ), //Wheels
                CheckBoxCreateLoad(
                    text: 'Tiltable',
                    icon: Icons.file_upload,
                    checkboxValue: tilt,
                    onChanged: (value) {
                      wheels == true ? wheels = false : null;
                      setState(() => tilt = value);
                    }), //Tilt
                CheckBoxCreateLoad(
                  text: 'Stakable',
                  icon: Icons.category,
                  checkboxValue: stack,
                  onChanged: (value) {
                    wheels == true ? wheels = false : null;
                    setState(() => stack = value);
                  },
                ), //Stack
                SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: color,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  onChanged: (String newValue) {
                    setState(() {
                      color = newValue;
                    });
                  },
                  items: <String>['Red', 'Blue', 'Green', 'Purple', 'Orange']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        child: Center(
                            child: Text(
                          value,
                          style:
                              kTextStyle(context).copyWith(color: Colors.black),
                        )),
                        decoration: BoxDecoration(
                            color: _flightCaseColor(value),
                            borderRadius: BorderRadius.circular(8)),
                        height: displayHeight(context) * 0.05,
                        width: displayWidth(context) * 0.3,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SelectionButton(
                      width: displayWidth(context) * 0.3,
                      text: 'BACK', //TODO: Reducir Font
                      color: kyellowQBK,
                      onPress: () {
                        Navigator.pop(context, flightCaseListUpdated);
                      },
                      ),

                    //Cancel
                    SelectionButton(
                      width: displayWidth(context) * 0.3,
                      text: 'SAVE',
                      color: kyellowQBK,
                      onPress: () {
                        if (_formKey.currentState.validate()) {
                          for (int i = 1; i < quantity + 1; i++) {
                            addFlightCaseToList();
                          }
                        }
                        addCaseToOwnList(user.uid);

                        Navigator.pop(context, flightCaseListUpdated);
                      },
                      ),

                    //OK
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///CheckBok for PopupCreateLoad
class CheckBoxCreateLoad extends StatefulWidget {
  CheckBoxCreateLoad(
      {@required this.text,
      this.icon,
      @required this.checkboxValue,
      this.onChanged});
  final String text;
  final icon;
  final bool checkboxValue;
  final Function onChanged;

  @override
  _CheckBoxCreateLoadState createState() => _CheckBoxCreateLoadState();
}

class _CheckBoxCreateLoadState extends State<CheckBoxCreateLoad> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          widget.icon,
          size: displayWidth(context) * 0.07,
        ),
        SizedBox(width: 15.0),
        Container(
          child: Text(
            widget.text,
            style: kTextStyle(context).copyWith(
                fontSize: displayWidth(context) * 0.04, color: Colors.black),
          ),
        ),
        SizedBox(width: 15.0),
        Container(
          child: Checkbox(
            value: widget.checkboxValue,
            activeColor: Colors.black,
            checkColor: kyellowQBK,
            onChanged: widget.onChanged,
          ),
        ),
        Container(
          width: displayWidth(context) * 0.2,
        )
      ],
    );
  }
}

///Popup Onw Cases
class PopupOwnCases extends StatefulWidget {
  PopupOwnCases({
    @required this.flightCase,
    @required this.title,
    @required this.uidGig,
    @required this.uidLoad,
    this.flightCaseList,
  });
  final FlightCase flightCase;
  final String title;
  final String uidGig;
  final String uidLoad;
  final List<FlightCase> flightCaseList;

  @override
  _PopupOwnCasesState createState() => _PopupOwnCasesState();
}

class _PopupOwnCasesState extends State<PopupOwnCases> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final dateTimeNow =
      DateFormat('yyyyy.MMMMM.dd GGG hh:mm:ss aaa').format(DateTime.now());

  FlightCase flightCase;
  int quantity = 1;
  bool wheels;
  bool tilt;
  bool stack;
  String color;
  List<FlightCase> flightCaseListUpdated;

  ///Prevents the quantity of flightCases to go under 1 and over 100
  void stopQuantity() {
    quantity <= 0 ? quantity = 1 : null;
    quantity >= 100 ? quantity = 100 : null;
  }

  addFlightCaseToList() {
    flightCaseListUpdated.add(FlightCase(
      nameFlightCase: flightCase.nameFlightCase,
      typeFlightCase: "Own",
      quantity: quantity,
      wheels: wheels,
      tilt: tilt,
      stack: stack,
      loaded: false,
      index: flightCaseListUpdated.length + 1,
      color: color,
    ));
  }

  @override
  void initState() {
    flightCase = widget.flightCase;
    wheels = flightCase.wheels;
    tilt = flightCase.tilt;
    stack = flightCase.stack;
    color = flightCase.color;
    flightCaseListUpdated = widget.flightCaseList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // UserData user = Provider.of<UserData>(context);

    return AlertDialog(
      backgroundColor: Colors.grey.shade300,
      content: Container(
        // height: displayHeight(context) * 0.7,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    widget.title,
                    style: kTextStyle(context).copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: displayWidth(context) * 0.2,
                        child: TextField(
                          style: kTextStyle(context).copyWith(
                              color: Colors.black,
                              fontSize: displayWidth(context) * 0.035),
                          maxLines: 1,
                          maxLength: 3,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          controller:
                              TextEditingController(text: quantity.toString()),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 4, bottom: 25),
                        color: Colors.grey.shade500,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4, bottom: 25),
                        color: Colors.grey.shade500,
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => setState(() {
                            quantity--;
                            stopQuantity();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CheckBoxCreateLoad(
                  text: 'Wheels',
                  icon: Icons.blur_circular,
                  checkboxValue: wheels,
                  onChanged: (value) {
                    tilt == true ? tilt = false : null;
                    stack == true ? stack = false : null;
                    setState(() => wheels = value);
                  },
                ), //Wheels
                CheckBoxCreateLoad(
                  text: 'Tiltable',
                  icon: Icons.file_upload,
                  checkboxValue: tilt,
                  onChanged: (value) {
                    wheels == true ? wheels = false : null;
                    setState(() => tilt = value);
                  },
                ), //Tilt
                CheckBoxCreateLoad(
                  text: 'Stakable',
                  icon: Icons.category,
                  checkboxValue: stack,
                  onChanged: (value) {
                    wheels == true ? wheels = false : null;
                    setState(() => stack = value);
                  },
                ),
                //Stack
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SelectionButton(
                      text: 'BACK',
                      color: kyellowQBK,
                      onPress: () {
                        Navigator.pop(context, true);
                      }, 
                      ),

                    //Cancel
                    SelectionButton(
                      text: 'SAVE',
                      color: kyellowQBK,
                      onPress: () {
                        if (_formKey.currentState.validate()) {
                          for (int i = 1; i < quantity + 1; i++) {
                            addFlightCaseToList();
                          }
                        }

                        Navigator.pop(context, true);
                      },
                      ),

                    //OK
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
