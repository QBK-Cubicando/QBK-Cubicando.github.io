import 'dart:async';
import 'package:connectivity/connectivity.dart';

///Documentated
class ConnectionCheck {
  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
//I am not connected to Internet
      return false;
    } else {
      return true;
// I am connected to Internet.
    }
  }
}
