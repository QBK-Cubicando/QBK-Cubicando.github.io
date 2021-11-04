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
  List<bool> isSelected = [false, true, false, false, false];
  String selectedColor = 'green';

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

    List<ColorGig_QBK> _colors = [
      ColorGig_QBK(color: kredQBK, name: 'red'),
      ColorGig_QBK(color: kgreenQBK, name: 'green'),
      ColorGig_QBK(color: kpurpleQBK, name: 'purple'),
      ColorGig_QBK(color: kblueQBK, name: 'blue'),
      ColorGig_QBK(color: Colors.orangeAccent.shade200, name: 'orange'),
    ];

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          return Scaffold(
            body: KeyboardAvoider(
              autoScroll: true,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      width: displayWidth(context) * 0.85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            color: kgreenQBK,
                            width: displayWidth(context) * 0.85,
                            height: displayHeight(context) * 0.08,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.music_note),
                                ),
                                Text(
                                  'NEW GIG',
                                  style: kTitleTextStile(context)
                                      .copyWith(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PreForm_QBK(
                                title: 'Name:',
                              ),
                              TextFieldQBK(
                                validator: (value) => value.isEmpty
                                    ? 'Enter a Gig\'s Name'
                                    : null,
                                maxLength: 14,
                                width: displayWidth(context) * 0.6,
                                hintText: 'GIG\'s Name',
                                onChanged: (valueName) {
                                  nameGig = valueName;
                                },
                              ),
                            ],
                          ), // Gig

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: displayHeight(context) * 0.05,
                                  child: PreForm_QBK(title: 'From:')),
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
                                  width: displayWidth(context) * 0.6,
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
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
                                          DateFormat('dd-MM-yyyy')
                                              .format(startDate),
                                          style: kTextStyle(context).copyWith(
                                              color: Colors.black,
                                              fontSize:
                                                  displayWidth(context) * 0.05),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ), // Initial Date
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: displayHeight(context) * 0.05,
                                child: PreForm_QBK(
                                  title: 'To:',
                                ),
                              ),
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
                                  width: displayWidth(context) * 0.6,
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
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
                                          DateFormat('dd-MM-yyyy')
                                              .format(endDate),
                                          style: kTextStyle(context).copyWith(
                                              color: Colors.black,
                                              fontSize:
                                                  displayWidth(context) * 0.05),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.03,
                          ), // End Date
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PreForm_QBK(
                                title: 'Loc:',
                              ),
                              TextFieldQBK(
                                width: displayWidth(context) * 0.6,
                                validator: (value) =>
                                    value.isEmpty ? 'Enter a Location' : null,
                                icon: Icons.location_city,
                                hintText: 'LOCATION',
                                onChanged: (valueLocation) {
                                  location = valueLocation;
                                },
                              ),
                            ],
                          ), // Location
                          Container(
                            
                            // color: Colors.white,
                            child: ToggleButtons(
                              children: _colors,
                              isSelected: isSelected,
                              selectedBorderColor: Colors.white,
                              borderWidth: 2,

                              // fillColor: Colors.grey.shade100,
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
                                  // print(selectedColor);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.03,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PreForm_QBK(
                                title: 'Notes:',
                              ),
                              TextFieldQBK(
                                width: displayWidth(context) * 0.6,
                                height: displayHeight(context) * 0.2,
                                icon: Icons.library_books,
                                hintText: 'NOTES',
                                maxLines: 8,
                                onChanged: (valueNotes) {
                                  notes = valueNotes;
                                },
                              ),
                            ],
                          ), // Notes
                          SizedBox(
                            height: 15.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SelectionButton(
                              text: 'SAVE',
                              color: kyellowQBK,
                              onPress: () async {
                                try {
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
                                        color: selectedColor,
                                        crew: 1);

                                  

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
                                      speciality: 'Admin',
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
                                        location: location,
                                        color: selectedColor,
                                        crew: 1);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return CreateGigPage(
                                          uidGig:
                                              '${user.uid}$nameGig$startDate',
                                          nameGig: nameGig,
                                          userUid: user.uid,
                                          startDate: DateFormat('yyyy-MM-dd')
                                              .format(startDate),
                                        );
                                      }),
                                    );
                                  } else {
                                    print('Not working');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ), //Create Gig Button
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

class ColorGig_QBK extends StatelessWidget {
  const ColorGig_QBK({Key key, @required this.color, this.name, this.radius})
      : super(key: key);

  final Color color;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.005),
      padding: radius != null ? EdgeInsets.all(radius) : EdgeInsets.all(25),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class PreForm_QBK extends StatelessWidget {
  const PreForm_QBK({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: displayWidth(context) * 0.02),
      color: Colors.grey.shade300,
      width: displayWidth(context) * 0.23,
      height: displayHeight(context) * 0.08,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            title,
            style: kTextStyle(context).copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

//TODO: Make an notes available with images
