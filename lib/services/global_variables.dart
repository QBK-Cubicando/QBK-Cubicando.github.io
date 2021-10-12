import 'dart:async';

import 'package:qbk_simple_app/models/flight_case.dart';

Map<String, dynamic> idAndBlocRow;
Map<String, List<FlightCase>> totalFlightCaseLists;

StreamController<Map<FlightCase, bool>> streamControllerFlightCase =
    StreamController<Map<FlightCase, bool>>.broadcast();

StreamController<int> streamControllerBlocRow =
    StreamController<int>.broadcast();
String selectedBlocRowId;
int selectedBlockRowIndex;
