import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qbk_simple_app/services/connection_check.dart';

import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/user.dart';

import 'home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

//TODO: Make a response if you can't enter or is taking too long. And finish the process

///Documentated
class RegistrationInformationPage extends StatefulWidget {
  static const String id = 'registration_information_page';

  @override
  _RegistrationInformationPageState createState() =>
      _RegistrationInformationPageState();
}

class _RegistrationInformationPageState
    extends State<RegistrationInformationPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> speciality = [
    'Please Select Speciality',
    'Sound',
    'Light',
    'Video',
    'Production',
    'Stage Hand',
    'Truck Driver',
    'Other'
  ];
  String selectedSpeciality = 'Please Select Speciality';

  String _name;
  DateTime _dateOfBirth;
  String _city;
  String _phone;
  String _speciality;
  Image _profileImage;

  bool _showSpinner = false;

  bool connectedToInternet = true;

  ///Checks if you're connected to internet
  checkConnectivityToInternet() async {
    Future<bool> connectedToInternetFuture =
        ConnectionCheck().checkConnection();

    if (await connectedToInternetFuture == true) {
      setState(() {
        connectedToInternet = true;
      });
    } else {
      setState(() {
        connectedToInternet = false;
      });
    }
  }

  @override
  void initState() {
    _dateOfBirth = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return _showSpinner
        ? Loading()
        : Container(
            color: Colors.black,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey.shade700,
              ),
              backgroundColor: Colors.black,
              body: ModalProgressHUD(
                inAsyncCall: _showSpinner,
                child: KeyboardAvoider(
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
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                ).then((date) {
                                  setState(() {
                                    date != null ? _dateOfBirth = date : null;
                                  });
                                });
                              },
                              child: Container(
                                width: double.infinity,
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
                                      size: displayWidth(context) * 0.04,
                                    ),
                                    SizedBox(
                                      width: displayWidth(context) * 0.02,
                                    ),
                                    Center(
                                      child: Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(_dateOfBirth),
                                        style: kTextStyle(context).copyWith(
                                            color: Colors.black,
                                            fontSize:
                                                displayWidth(context) * 0.045),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ), //Birth

                            TextFieldQBK(
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
                                value: selectedSpeciality,
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
                                text: 'Register',
                                width: double.infinity,
                                color: Colors.green,
                                onPress: () async {
                                  await checkConnectivityToInternet();

                                  if (connectedToInternet == true) {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _showSpinner = true;
                                      });

                                      try {
                                        ///Set user's Data to Firebase
                                        await DatabaseService(userUid: user.uid)
                                            .setUserData(
                                                _name,
                                                _dateOfBirth,
                                                _city,
                                                _phone,
                                                _speciality,
                                                _profileImage);

                                        Navigator.pushNamed(
                                            context, QBKHomePage.id);

                                        setState(() {
                                          _showSpinner = false;
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  }
                                }),
                            //Create Gig Button
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
