import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:qbk_simple_app/a_screens_pages/registration_information_page.dart';
import 'package:qbk_simple_app/a_screens_pages/sign_in_page.dart';
import 'package:qbk_simple_app/services/auth.dart';
import 'package:qbk_simple_app/services/connection_check.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';

//TODO: print errors and figure out what they are, and inform the user about the error

///Documentated
class RegistrationPage extends StatefulWidget {
  static const String id = 'registration_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String error = '';

  bool _loading = false;

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
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Container(
            color: Colors.black,
            child: Scaffold(
              backgroundColor: Colors.black54,
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
                          Hero(
                            tag: 'logo',
                            child: Container(
                              child: Image.asset(
                                  'images/logoQBK_fondotransparente.png'),
                              height: displayHeight(context) * 0.2,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //TODO: Make this textfield minusculas
                          TextFieldQBK(
                            validator: (value) {
                              if (value.isEmpty ||
                                  !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value)) {
                                return 'Enter a correct email';
                              }
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            icon: Icons
                                .email, //TODO: select an icon for speciality
                            hintText: 'email',

                            onChanged: (value) {
                              email = value;
                            },
                          ), //email
                          TextFieldQBK(
                            validator: (value) => value.length < 6
                                ? 'Enter a password 6 + chars long'
                                : null,
                            hintText: 'Password',
                            obscureText: true,
                            maxLines: 1,
                            onChanged: (value) {
                              password = value;
                            },
                          ), //password
                          //TODO: create a repeat password and validator
                          TextFieldQBK(
                            hintText: 'Repeat Password',
                            obscureText: true,
                            maxLines: 1,
                            validator: (String value) {
                              return password != value
                                  ? 'Passwords must coincide'
                                  : null;
                            },
                          ), // Repeat password
                          Center(
                            child: InkWell(
                              child: Text(
                                '... or Sign In',
                                style: kTextStyle(context)
                                    .copyWith(color: Colors.blueAccent),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, SignInPage.id);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            error,
                            style: kButtonsTextStyle(context)
                                .copyWith(color: Colors.red),
                          ),
                          //TODO: image selector
                          SelectionButton(
                            text: 'Register',
                            width: displayWidth(context) * 0.85,
                            color: Colors.green,
                            onPress: () async {
                              await checkConnectivityToInternet();

                              ///Create user on Firebase
                              if (connectedToInternet == true) {
                                if (_formKey.currentState.validate()) {
                                  setState(() => _loading = true);
                                  try {
                                    dynamic newUser = await _auth
                                        .createUserWithEmailAndPassword(
                                            email, password);

                                    await DatabaseService(userUid: newUser.uid)
                                        .setUserData('Name', DateTime.now(),
                                            'City', null, "Other", null, email);

                                    if (newUser != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationInformationPage(
                                                  email: email,
                                                )),
                                      );
                                    } else {
                                      setState(() {
                                        error = 'please supply a valid email';
                                        _loading = false;
                                      });
                                    }

                                    setState(() {
                                      _loading = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              } else {
                                setState(() {
                                  error = 'not connected to internet';
                                  _loading = false;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
