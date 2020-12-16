import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/models/user.dart';

import 'package:qbk_simple_app/a_screens_pages/home_page.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';

//TODO: Create a change password option

///READ but not Documentated
class SettingsPage extends StatefulWidget {
  static const String id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> speciality = [
    'Sound',
    'Light',
    'Video',
    'Production',
    'Stage Hand',
    'Truck Driver',
    'Other'
  ];

  //FirebaseUser loggedInUser;

  String _name;
  DateTime _dateOfBirth;
  String _city;
  String _phone;
  String _speciality;
  Image _profileImage;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return UpperBar(
              text: 'User Info',
              body: KeyboardAvoider(
                autoScroll: true,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFieldQBK(
                            initialValue: userData.name,
                            validator: (value) =>
                                value.isEmpty ? 'Enter a Name' : null,
                            maxLength: 10,
                            icon: Icons.accessibility_new,
                            hintText: 'Name',
                            onChanged: (value) {
                              _name = value;
                            },
                          ), //Name
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now(), //userData.dateOfBirth
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              ).then((date) {
                                setState(() {
                                  _dateOfBirth = date;
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
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
                                    size: displayWidth(context) * 0.04,
                                  ),
                                  SizedBox(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  Center(
                                    child: Text(
                                      DateFormat('yyyy-MM-dd').format(
                                          _dateOfBirth ?? userData.dateOfBirth),
                                      style: kTextStyle(context)
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ), //Birth
                          TextFieldQBK(
                            initialValue: userData.city,
                            validator: (value) =>
                                value.isEmpty ? 'Enter a Country' : null,
                            maxLines: 1,
                            icon: Icons.location_city,
                            hintText: 'City',
                            onChanged: (value) {
                              _city = value;
                            },
                          ), //Country
                          TextFieldQBK(
                            initialValue: userData.phone,
                            maxLines: 1,
                            icon: Icons.phone_android,
                            hintText: 'Phone (optional)',
                            onChanged: (value) {
                              _phone = value;
                            },
                          ), //Phone
                          Container(
                            width: double.infinity,
                            height: displayHeight(context) * 0.08,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: DropdownButtonFormField(
                              value: userData.speciality,
                              items: speciality.map((speciality) {
                                return DropdownMenuItem(
                                  value: speciality,
                                  child: Text(
                                    speciality,
                                    style: kTextStyle(context)
                                        .copyWith(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _speciality = value),
                              iconSize: displayWidth(context) * 0.08,
                            ),
                          ), //Speciality
                          SizedBox(
                            height: 15.0,
                          ),
                          //TODO: image selector
                          SelectionButton(
                              text: 'Done',
                              width: double.infinity,
                              color: Colors.green,
                              onPress: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    ///Update User's Data
                                    await DatabaseService(userUid: userData.uid)
                                        .updateUserData(
                                      _name ?? userData.name,
                                      _dateOfBirth ?? userData.dateOfBirth,
                                      _city ?? userData.city,
                                      _phone ?? userData.phone,
                                      _speciality ?? userData.speciality,
                                      _profileImage ?? userData.profileImage,
                                    );

                                    Navigator.pushNamed(
                                        context, QBKHomePage.id);
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              }), //Create Gig Button
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
  }
}
