//
// Generated file. Do not edit.
//

import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:connectivity_for_web/connectivity_for_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FirestoreWeb.registerWith(registrar);
  ConnectivityPlugin.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
