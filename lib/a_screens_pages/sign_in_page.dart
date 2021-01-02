import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/services/connection_check.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'registration_page.dart';
import 'home_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/services/auth.dart';

//TODO: error when writes with keyboard of the computer on the phone

///Documentated

class SignInPage extends StatefulWidget {
  static const String id = 'sign_in_page';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKeyResetPassword = GlobalKey<FormState>();

  String email;
  String recoveryEmail;
  String password;
  String error = '';

  bool _loading = false;

  bool connectedToInternet = true;

  ///Cheks if you're connected to Internet
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
    try {
      return _loading
          ? Hero(tag: 'loading', child: Loading())
          : Container(
              color: Colors.black,
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.black54,
                body: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Hero(
                                    tag: 'logo',
                                    child: Container(
                                      child: Image.asset(
                                          'images/logoQBK_fondotransparente.png'),
                                      height: displayHeight(context) * 0.25,
                                    ),
                                  ),
//TODO: Here goes the animation
//                TypewriterAnimatedTextKit(
//                  text: ['QBK-Cubicando'],
//                  textStyle: TextStyle(
//                    fontSize: 45.0,
//                    fontWeight: FontWeight.w900,
//                  ),
//                ),
                                ],
                              ),
                              SizedBox(
                                height: 68.0,
                              ),
                              //TODO: make that if there's a space after the mail the app ignores it
                              TextFieldQBK(
                                validator: (value) =>
                                    value.isEmpty ? 'Enter an email' : null,
                                hintText: 'Enter your email',
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFieldQBK(
                                //TODO: change the validatos so it shows 'incorrect email or password' when the password is wrong
                                validator: (value) =>
                                    value.isEmpty ? 'Enter a password' : null,
                                hintText: 'Password',
                                obscureText: true,
                                maxLines: 1,
                                onChanged: (value) {
                                  password = value;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                child: Text(
                                  '... Forgot Password',
                                  style: kTextStyle(context)
                                      .copyWith(color: Colors.blueAccent),
                                  textAlign: TextAlign.right,
                                ),
                                onTap: () {
                                  showDialog(
                                    context: _scaffoldKey.currentContext,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey.shade300,
                                        content: SingleChildScrollView(
                                          child: Form(
                                            key: _formKeyResetPassword,
                                            child: Container(
                                              height:
                                                  displayHeight(context) * 0.6,
                                              width:
                                                  displayWidth(context) * 0.7,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height:
                                                        displayHeight(context) *
                                                            0.2,
                                                    child: Text(
                                                      'Enter recovery email',
                                                      style: kTextStyle(context)
                                                          .copyWith(
                                                        color: Colors.black,
                                                      ), //TODO:Reducir Font
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFieldQBK(
                                                    validator: (value) {
                                                      if (value.isEmpty ||
                                                          !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                              .hasMatch(
                                                                  value)) {
                                                        return 'Enter a correct email';
                                                      }
                                                    },
                                                    maxLines: 1,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    icon: Icons
                                                        .email, //TODO: select an icon for speciality
                                                    hintText: 'email',

                                                    onChanged: (value) {
                                                      recoveryEmail = value;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                  ),
                                                  SelectionButton(
                                                      text: 'Send email',
                                                      color: Colors.green,
                                                      height: displayHeight(
                                                              context) *
                                                          0.1,
                                                      onPress: () async {
                                                        if (_formKeyResetPassword
                                                            .currentState
                                                            .validate()) {
                                                          FirebaseAuth.instance
                                                              .sendPasswordResetEmail(
                                                                  email:
                                                                      recoveryEmail);
                                                          Navigator.pop(
                                                              context);
                                                        } else {}
                                                      })
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              SelectionButton(
                                  text: 'Sign In',
                                  width: displayWidth(context) * 0.85,
                                  color: Colors.green,
                                  onPress: () async {
                                    await checkConnectivityToInternet();

                                    if (connectedToInternet == true) {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => _loading = true);

                                        ///Sign In
                                        dynamic user = await _auth
                                            .signInWithEmailAndPassword(
                                                email, password);

                                        if (user != null) {
                                          Navigator.pushNamed(
                                              context, QBKHomePage.id);
                                        } else {
                                          setState(() {
                                            error = 'invalid email or password';
                                            _loading = false;
                                          });
                                          setState(() => _loading = false);
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        error = 'not connected to internet';
                                        _loading = false;
                                      });
                                    }
                                  }),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: InkWell(
                                  child: Text(
                                    '... or Register',
                                    style: kTextStyle(context)
                                        .copyWith(color: Colors.blueAccent),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RegistrationPage.id);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              Center(
                                  child: Text(
                                error,
                                style: kButtonsTextStyle(context)
                                    .copyWith(color: Colors.red),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
    } catch (e) {
      print(e);
      return Loading();
    }
  }
}
