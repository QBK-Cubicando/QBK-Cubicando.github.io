import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/new_gig_page.dart';
import 'package:qbk_simple_app/ab_created_widgets/top_qbk.dart';

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
  String _email;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    _email = user.email;

    return StreamBuilder<UserData>(
        stream: DatabaseService(userUid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Scaffold(
              body: KeyboardAvoider(
                autoScroll: true,
                child: Center(
                  child: SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        width: displayWidth(context) * 0.85,
                        child: Column(
                          children: <Widget>[
                            Top_QBK(),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PreForm_QBK(
                                  title: 'Name:',
                                ),
                                TextFieldQBK(
                                  width: displayWidth(context) * 0.6,
                                  initialValue: userData.name,
                                  validator: (value) =>
                                      value.isEmpty ? 'Enter a Name' : null,
                                  maxLength: 10,
                                  icon: Icons.accessibility_new,
                                  hintText: 'Name',
                                  onChanged: (value) {
                                    _name = value;
                                  },
                                ),
                              ],
                            ),
                            //Name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PreForm_QBK(
                                  title: 'Birth:',
                                ),
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
                                    width: displayWidth(context) * 0.6,
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
                                            DateFormat('yyyy-MM-dd').format(
                                                _dateOfBirth ??
                                                    userData.dateOfBirth),
                                            style: kTextStyle(context)
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ), //Birth
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PreForm_QBK(
                                  title: 'City:',
                                ),
                                TextFieldQBK(
                                  width: displayWidth(context) * 0.6,
                                  initialValue: userData.city,
                                  validator: (value) =>
                                      value.isEmpty ? 'Enter a Country' : null,
                                  maxLines: 1,
                                  icon: Icons.location_city,
                                  hintText: 'City',
                                  onChanged: (value) {
                                    _city = value;
                                  },
                                ),
                              ],
                            ),
                            //Country
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PreForm_QBK(
                                  title: 'Phone:',
                                ),
                                TextFieldQBK(
                                  width: displayWidth(context) * 0.6,
                                  initialValue: userData.phone,
                                  maxLines: 1,
                                  icon: Icons.phone_android,
                                  hintText: 'Phone (optional)',
                                  onChanged: (value) {
                                    _phone = value;
                                  },
                                ),
                              ],
                            ),
                            //Phone
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PreForm_QBK(
                                  title: 'Sector:',
                                ),
                                Container(
                                  width: displayWidth(context) * 0.6,
                                  height: displayHeight(context) * 0.08,
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
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
                                ),
                              ],
                            ), //Speciality
                            SizedBox(
                              height: 15.0,
                            ),
                            //TODO: image selector
                            Align(
                              alignment: Alignment.centerRight,
                              child: SelectionButton(
                                  text: 'SAVE',
                                  width: displayWidth(context) * 0.4,
                                  color: kyellowQBK,
                                  onPress: () async {
                                    if (_formKey.currentState.validate()) {
                                      try {
                                        ///Update User's Data
                                        await DatabaseService(
                                                userUid: userData.uid)
                                            .updateUserData(
                                                _name ?? userData.name,
                                                _dateOfBirth ??
                                                    userData.dateOfBirth,
                                                _city ?? userData.city,
                                                _phone ?? userData.phone,
                                                _speciality ??
                                                    userData.speciality,
                                                _profileImage ??
                                                    userData.profileImage,
                                                _email ?? userData.email);

                                        Navigator.pushNamed(
                                            context, QBKHomePage.id);
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  }),
                            ), //Create Gig Button
                          ],
                        ),
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
