import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_gig_page.dart';
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

  EditGigPopup(
      {this.nameGig,
      this.startDate,
      this.endDate,
      this.location,
      this.notes,
      this.uidGig});

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

  ///Set Gig's Data from firebase
  @override
  void initState() {
    uidGig = widget.uidGig;
    nameGig = widget.nameGig;
    startDate = widget.startDate;
    endDate = widget.endDate;
    location = widget.location;
    notes = widget.notes;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    final _formKeyEditGig = GlobalKey<FormState>();

    void _deleteGig() async {
      DatabaseService(
        userUid: user.uid, 
        uidGig: uidGig, 
        crewMemberData: user.uid).deleteGig();
      Navigator.pop(context);
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          return KeyboardAvoider(
            autoScroll: true,
            child: Center(
              child: SafeArea(
                child: Material(
                  color: Colors.black45,
                  child: Form(
                    key: _formKeyEditGig,
                    child: Container(
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.9,
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
                                    height: displayHeight(context) * 0.1,
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
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
                                    height: displayHeight(context) * 0.1,
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
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
                                text: 'OK',
                                width: displayWidth(context) * 0.4,
                                color: Colors.green,
                                onPress: () async {
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
                                    );

                                    ///Update CalendarGig's Data
                                    DatabaseService(
                                      userUid: user.uid,
                                    ).updateCalendarGigData(
                                      uidGig: uidGig,
                                      nameGig: nameGig,
                                      startDate: startDate,
                                      endDate: endDate,
                                    );

                                    Navigator.pop(context);
                                  } else {}
                                },
                              ), //Update Gig Button
                              SizedBox(
                                height: 5.0,
                              ),

                              ///Popup that takes you to Gig Page
                              SelectionButton(
                                text: 'Edit Gig',
                                width: displayWidth(context) * 0.4,
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
                            text: 'Delete',
                            width: displayWidth(context) * 0.85,
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
                                          onPress: () => Navigator.pop(context),
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
