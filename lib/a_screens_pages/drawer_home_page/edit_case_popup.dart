import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_gig_page.dart';
import 'package:qbk_simple_app/ab_created_widgets/popup_load_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///READ But not Documentated
class EditCasePopup extends StatefulWidget {
  final FlightCase flightCase;

  EditCasePopup({this.flightCase});

  @override
  _EditCasePopupState createState() => _EditCasePopupState();
}

class _EditCasePopupState extends State<EditCasePopup> {
  FlightCase flightCase;
  String flightCaseName;
  bool wheels;
  bool tilt;
  bool stack;
  String color;

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

  ///Set Gig's Data from firebase
  @override
  void initState() {
    flightCase = widget.flightCase;
    flightCaseName = flightCase.nameFlightCase;
    wheels = flightCase.wheels;
    tilt = flightCase.tilt;
    stack = flightCase.stack;
    color = flightCase.color;
    print(flightCase.color);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    final _formKeyEditOwnCase = GlobalKey<FormState>();

    void _deleteOwnCase() async {
      DatabaseService(userUid: user.uid)
          .deleteOwnCase(flightCase.uidFlightCase);
      Navigator.pop(context);
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          return KeyboardAvoider(
            autoScroll: true,
            child: SafeArea(
              child: AlertDialog(
                content: Container(
                  height: displayHeight(context) * 0.8,
                  width: displayWidth(context) * 0.7,
                  child: Form(
                    key: _formKeyEditOwnCase,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextFieldQBK(
                                validator: (value) => value.isEmpty
                                    ? 'Enter a Case\'s Name'
                                    : null,
                                initialValue: flightCaseName,
                                maxLength: 10,
                                hintText: 'Flight Case Name',
                                onChanged: (valueName) {
                                  flightCaseName = valueName;
                                },
                              ), // Gig
                              SizedBox(
                                height: 8.0,
                              ), // End Date
                              Container(
                                color: Colors.white70,
                                width: displayWidth(context),
                                height: displayHeight(context) * 0.45,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
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
                                            wheels == true
                                                ? wheels = false
                                                : null;
                                            setState(() => tilt = value);
                                          }), //Tilt
                                      CheckBoxCreateLoad(
                                        text: 'Stakable',
                                        icon: Icons.category,
                                        checkboxValue: stack,
                                        onChanged: (value) {
                                          wheels == true
                                              ? wheels = false
                                              : null;
                                          setState(() => stack = value);
                                        },
                                      ),
                                      SizedBox(
                                        height: displayHeight(context) * 0.03,
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
                                        items: <String>[
                                          'Red',
                                          'Blue',
                                          'Green',
                                          'Purple',
                                          'Orange'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                              width:
                                                  displayWidth(context) * 0.3,
                                              height:
                                                  displayHeight(context) * 0.05,
                                              child: Center(
                                                  child: Text(
                                                value,
                                                style: kTextStyle(context)
                                                    .copyWith(
                                                        color: Colors.black),
                                              )),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _flightCaseColor(value),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                              ), // Location
                             
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SelectionButton(
                              text: 'Delete',
                              width: displayWidth(context) * 0.3,
                              color: Colors.redAccent,
                              onPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Center(
                                            child: Text(
                                          'Are you sure you want to delete $flightCaseName?',
                                          style: kTextStyle(context)
                                              .copyWith(color: Colors.black),
                                        )),
                                        actions: <Widget>[
                                          SelectionButton(
                                            text: 'Cancel',
                                            color: Colors.blueAccent,
                                            onPress: () =>
                                                Navigator.pop(context),
                                          ),
                                          SelectionButton(
                                            text: 'Delete',
                                            color: Colors.redAccent,
                                            onPress: () {
                                              Navigator.pop(context);
                                              _deleteOwnCase();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                            
                            SelectionButton(
                              width: displayWidth(context) * 0.3,
                              text: 'Cancel',
                              color: Colors.blueAccent,
                              onPress: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        SelectionButton(
                          text: 'SAVE',
                          color: kyellowQBK,
                          width: double.infinity,
                          onPress: () async {
                            if (_formKeyEditOwnCase.currentState.validate()) {
                              ///Update Gig's Data
                              await DatabaseService(
                                      userUid: user.uid,
                                      uidFlightCase: flightCase.uidFlightCase)
                                  .updateOwnCaseData(
                                      nameFlightCase: flightCaseName,
                                      wheels: wheels,
                                      tilt: tilt,
                                      stack: stack,
                                      color: color);

                              Navigator.pop(context);
                            } else {}
                          },
                        ), //Update Gig Button
                        //Delete Gig Button //Buttons
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
