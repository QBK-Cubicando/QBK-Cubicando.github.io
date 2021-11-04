import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_gig_page.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/new_gig_page.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///READ But not Documentated
class EditGigPopup extends StatefulWidget {
  final String nameGig;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String notes;
  final String uidGig;
  final String color;
  final int crew;

  EditGigPopup(
      {this.nameGig,
      this.startDate,
      this.endDate,
      this.location,
      this.notes,
      this.uidGig,
      this.color,
      this.crew});

  @override
  _EditGigPopupState createState() => _EditGigPopupState();
}

class _EditGigPopupState extends State<EditGigPopup> {
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  String nameGig;
  DateTime startDate;
  DateTime endDate;
  String location;
  String notes;
  String uidGig;
  String selectedColor;

  ///Set Gig's Data from firebase
  @override
  void initState() {
    uidGig = widget.uidGig;
    nameGig = widget.nameGig;
    startDate = widget.startDate;
    endDate = widget.endDate;
    location = widget.location;
    notes = widget.notes;
    selectedColor = widget.color != null ? widget.color : 'green';
    print(selectedColor);

    super.initState();
  }

  List<bool> isSelected = [false, true, false, false, false];

  static final GlobalKey<FormState> _formKeyEditGig = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    List<ColorGig_QBK> _colors = [
      ColorGig_QBK(
        color: kredQBK,
        name: 'red',
        radius: displayWidth(context) * 0.045,
      ),
      ColorGig_QBK(
        color: kgreenQBK,
        name: 'green',
        radius: displayWidth(context) * 0.045,
      ),
      ColorGig_QBK(
        color: kpurpleQBK,
        name: 'purple',
        radius: displayWidth(context) * 0.045,
      ),
      ColorGig_QBK(
        color: kblueQBK,
        name: 'blue',
        radius: displayWidth(context) * 0.045,
      ),
      ColorGig_QBK(
        color: Colors.orangeAccent.shade200,
        name: 'orange',
        radius: displayWidth(context) * 0.045,
      ),
    ];

    void _deleteGig() async {
      DatabaseService(
              userUid: user.uid, uidGig: uidGig, crewMemberData: user.uid)
          .deleteGig();
      Navigator.pop(context);
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          return KeyboardAvoider(
            autoScroll: true,
            child: Center(
              child: SafeArea(
                child: AlertDialog(
                  content: Form(
                    key: _formKeyEditGig,
                    child: Container(
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.8,
                      child: Column(
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TextFieldQBK(
                                  validator: (value) => value.isEmpty
                                      ? 'Enter a Gig\'s Name'
                                      : null,
                                  initialValue: widget.nameGig,
                                  maxLength: 14,
                                  icon: Icons.accessibility_new,
                                  hintText: 'GIG',
                                  onChanged: (valueName) {
                                    nameGig = valueName;
                                  },
                                ), // Gig
                                GestureDetector(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: startDate,
                                      firstDate: DateTime(2019),
                                      lastDate: DateTime(2040),
                                    ).then((date) {
                                      setState(() {
                                        if (date != null) {
                                          _dateTimeNotifier.value = date;
                                          startDate = date;
                                        }
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: displayWidth(context) * 0.85,
                                    height: displayHeight(context) * 0.08,
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          size: displayWidth(context) * 0.04,
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.02,
                                        ),
                                        Center(
                                          child: Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(startDate),
                                            style: kTextStyle(context)
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ), // Initial Date
                                GestureDetector(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: _dateTimeNotifier.value,
                                      firstDate: _dateTimeNotifier.value,
                                      lastDate: DateTime(2040),
                                    ).then((date) {
                                      setState(() {
                                        date != null ? endDate = date : null;
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: displayWidth(context) * 0.85,
                                    height: displayHeight(context) * 0.08,
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          size: displayWidth(context) * 0.04,
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.02,
                                        ),
                                        Center(
                                          child: Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(endDate),
                                            style: kTextStyle(context)
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ), // End Date
                                TextFieldQBK(
                                  validator: (value) =>
                                      value.isEmpty ? 'Enter a Location' : null,
                                  initialValue: widget.location,
                                  icon: Icons.location_city,
                                  hintText: 'LOCATION',
                                  onChanged: (valueLocation) {
                                    location = valueLocation;
                                  },
                                ), // Location
                                SizedBox(
                                  height: 5.0,
                                ),
                                ToggleButtons(
                                  children: _colors,
                                  isSelected: isSelected,
                                  selectedBorderColor: Colors.white,
                                  borderWidth: 2,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int buttonIndex = 0;
                                          buttonIndex < isSelected.length;
                                          buttonIndex++) {
                                        if (buttonIndex == index) {
                                          isSelected[buttonIndex] = true;
                                        } else {
                                          isSelected[buttonIndex] = false;
                                        }
                                      }
                                      selectedColor = _colors[index].name;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),

                                TextFieldQBK(
                                  initialValue: widget.notes,
                                  icon: Icons.library_books,
                                  hintText: 'NOTES',
                                  maxLines: 8,
                                  onChanged: (valueNotes) {
                                    notes = valueNotes;
                                  },
                                ), // Notes
                                SizedBox(
                                  height: 8.0,
                                ), //Cancel
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
                                            'Are you sure you want to delete $nameGig?',
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
                                                _deleteGig();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ), //Delete Gig Button //Buttons
                              SizedBox(
                                height: 5.0,
                              ),

                              ///Popup that takes you to Gig Page
                              SelectionButton(
                                text: 'Edit',
                                width: displayWidth(context) * 0.3,
                                color: Colors.orangeAccent,
                                onPress: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CreateGigPage(
                                      uidGig: uidGig,
                                      nameGig: nameGig,
                                      userUid: user.uid,
                                      startDate: DateFormat('yyyy-MM-dd')
                                          .format(startDate),
                                    );
                                  }));
                                },
                              ), //Edit Gig Button
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          SelectionButton(
                            text: 'SAVE',
                            width: double.infinity,
                            color: kyellowQBK,
                            onPress: () async {
                              int crew;
                              await FirebaseFirestore.instance
                                  .collection('gigs')
                                  .doc(uidGig)
                                  .get()
                                  .then((val) {
                                var v = val.data() as Map<String, dynamic>;
                                crew = v['crew'];
                              });
                              if (_formKeyEditGig.currentState.validate()) {
                                ///Update Gig's Data
                                await DatabaseService(
                                        userUid: user.uid, uidGig: uidGig)
                                    .updateGigData(
                                  nameGig: nameGig,
                                  startDate: startDate,
                                  endDate: endDate,
                                  location: location,
                                  notes: notes ?? null,
                                  color: selectedColor,
                                  crew: crew,
                                );

                                ///Update CalendarGig's Data
                                DatabaseService(
                                  userUid: user.uid,
                                ).updateCalendarGigData(
                                  uidGig: uidGig,
                                  nameGig: nameGig,
                                  startDate: startDate,
                                  endDate: endDate,
                                  location: location,
                                  color: selectedColor,
                                  crew: crew,
                                );

                                Navigator.pop(context);
                              } else {}
                            },
                          ), //Update Gig Button
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
