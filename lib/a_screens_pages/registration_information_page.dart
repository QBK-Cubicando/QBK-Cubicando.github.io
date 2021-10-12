import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qbk_simple_app/ab_created_widgets/top_qbk.dart';
import 'package:qbk_simple_app/services/connection_check.dart';

import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/user.dart';

import '../ui/sizes-helpers.dart';
import '../ui/sizes-helpers.dart';
import 'a_new_gig_pages/new_gig_page.dart';
import 'home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

//TODO: Make a response if you can't enter or is taking too long. And finish the process

///Documentated
class RegistrationInformationPage extends StatefulWidget {
  static const String id = 'registration_information_page';

  RegistrationInformationPage({this.email});

  final String email;

  @override
  _RegistrationInformationPageState createState() =>
      _RegistrationInformationPageState();
}

class _RegistrationInformationPageState
    extends State<RegistrationInformationPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> speciality = [
    'Speciality',
    'Sound',
    'Light',
    'Video',
    'Production',
    'Stage Hand',
    'Truck Driver',
    'Other'
  ];
  String selectedSpeciality = 'Speciality';

  String _name;
  DateTime _dateOfBirth;
  String _city;
  String _phone;
  String _speciality;
  Image _profileImage;
  String _email;

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
    _email = widget.email;
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
              backgroundColor: Colors.black,
              body: ModalProgressHUD(
                inAsyncCall: _showSpinner,
                child: KeyboardAvoider(
                  autoScroll: true,
                  child: Center(
                    child: SafeArea(
                      child: Container(
                        width: displayWidth(context) * 0.85,
                        child: Form(
                          key: _formKey,
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
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now(),
                                      ).then((date) {
                                        setState(() {
                                          date != null
                                              ? _dateOfBirth = date
                                              : null;
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
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_dateOfBirth),
                                              style: kTextStyle(context)
                                                  .copyWith(
                                                      color: Colors.black,
                                                  fontSize: displayWidth(
                                                              context) *
                                                          0.045),
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
                                    validator: (value) => value.isEmpty
                                        ? 'Enter a Country'
                                        : null,
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
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
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
                                      await checkConnectivityToInternet();

                                      if (connectedToInternet == true) {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            _showSpinner = true;
                                          });

                                          try {
                                            ///Set user's Data to Firebase
                                            await DatabaseService(
                                                    userUid: user.uid)
                                                .updateUserData(
                                                    _name,
                                                    _dateOfBirth,
                                                    _city,
                                                    _phone,
                                                    _speciality,
                                                    _profileImage,
                                                    _email);

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
                              ), //Create Gig Button
                            ],
                          ),
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
