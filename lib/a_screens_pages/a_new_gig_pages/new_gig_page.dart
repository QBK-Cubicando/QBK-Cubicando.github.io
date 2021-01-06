import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:provider/provider.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_gig_page.dart';
import 'package:qbk_simple_app/a_screens_pages/home_page.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

//TODO: Choose a color for calendar

///Documentated
class NewGigPage extends StatefulWidget {
  static const String id = 'new_gig_page';

  String userName;

  NewGigPage({this.userName});

  @override
  _NewGigPageState createState() => _NewGigPageState();
}

class _NewGigPageState extends State<NewGigPage> {
  final _formKey = GlobalKey<FormState>();

  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  String nameGig;
  DateTime startDate;
  DateTime endDate;
  String location;
  String notes;

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    startDate = DateTime.now();
    endDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          return UpperBar(
            text: 'New Gig',
            onBackGoTo: QBKHomePage(),
            body: KeyboardAvoider(
              autoScroll: true,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFieldQBK(
                          validator: (value) =>
                              value.isEmpty ? 'Enter a Gig\'s Name' : null,
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
                              initialDate: _dateTimeNotifier.value,
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
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  size: displayWidth(context) * 0.05,
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.02,
                                ),
                                Center(
                                  child: Text(
                                    DateFormat('dd-MM-yyyy').format(startDate),
                                    style: kTextStyle(context).copyWith(
                                        color: Colors.black,
                                        fontSize: displayWidth(context) * 0.05),
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
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  size: displayWidth(context) * 0.05,
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.02,
                                ),
                                Center(
                                  child: Text(
                                    DateFormat('dd-MM-yyyy').format(endDate),
                                    style: kTextStyle(context).copyWith(
                                        color: Colors.black,
                                        fontSize: displayWidth(context) * 0.05),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: displayHeight(context) * 0.03,
                        ), // End Date
                        TextFieldQBK(
                          validator: (value) =>
                              value.isEmpty ? 'Enter a Location' : null,
                          icon: Icons.location_city,
                          hintText: 'LOCATION',
                          onChanged: (valueLocation) {
                            location = valueLocation;
                          },
                        ), // Location
                        SizedBox(
                          height: displayHeight(context) * 0.03,
                        ),
                        TextFieldQBK(
                          height: displayHeight(context) * 0.3,
                          icon: Icons.library_books,
                          hintText: 'NOTES',
                          maxLines: 8,
                          onChanged: (valueNotes) {
                            notes = valueNotes;
                          },
                        ), // Notes
                        SizedBox(
                          height: 15.0,
                        ),
                        SelectionButton(
                          text: 'Create Gig',
                          width: displayWidth(context) * 0.85,
                          color: Colors.green,
                          onPress: () async {
                            if (_formKey.currentState.validate()) {
                              ///Set the Gig info to Firebase
                              await DatabaseService(
                                userUid: user.uid,
                                uidGig: '${user.uid}$nameGig$startDate',
                              ).setGigData(
                                userUid: user.uid,
                                nameGig: nameGig,
                                startDate: startDate,
                                endDate: endDate.isAfter(startDate)
                                    ? endDate
                                    : startDate,
                                location: location,
                                notes: notes ?? null,
                              );

                              ///Set admin to Gig
                              await DatabaseService(
                                userUid: user.uid,
                                uidGig: '${user.uid}$nameGig$startDate',
                                uidCrewGig: user.uid,
                                crewMemberData: user.uid,
                                isCrewPage: true,
                              ).gigSetCrewData(
                                nameCrew: widget.userName,
                                permission: 'Admin',
                                index: 1,
                              );

                              ///Set the CalendarGig info to firebase
                              await DatabaseService(
                                userUid: user.uid,
                              ).setCalendarGigData(
                                uidGig: '${user.uid}$nameGig$startDate',
                                nameGig: nameGig,
                                startDate: startDate,
                                endDate: endDate.isAfter(startDate)
                                    ? endDate
                                    : startDate,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CreateGigPage(
                                    uidGig: '${user.uid}$nameGig$startDate',
                                    nameGig: nameGig,
                                    userUid: user.uid,
                                    startDate: DateFormat('yyyy-MM-dd')
                                        .format(startDate),
                                  );
                                }),
                              );
                            } else {
                              //TODO:ELSE WHAT
                            }
                          },
                        ), //Create Gig Button
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

//TODO: Make an notes available with images
