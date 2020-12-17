import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:qbk_simple_app/ab_created_widgets/calendar.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/models/load.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';

class DatabaseService {
  final String userUid;

  /// For the FlightCases to show in order or backwards
  // final bool descending;

  final bool isLoadPage;

  /// For the FlightCases to show in LoadPage
  final bool loaded;

  ///Name and Start date of the gig
  final String uidGig;

  /// email or uid of crew member
  final String uidCrewGig;
  //TODO: Check This!

  /// email or uid of crew member
  final String uidCrewMember;

  /// Load + DateTime.now
  final String uidLoad;

  /// DateTime + Name Maybe Random
  final String uidFlightCase;

  /// Date of gig for Calendar
  final DateTime dateGigForCalendar;

  /// userUid + case
  final String uidMyCase;

  DatabaseService({
    this.userUid,
    // this.descending,
    this.isLoadPage,
    this.loaded,
    this.uidGig,
    this.uidCrewGig,
    this.uidCrewMember,
    this.uidLoad,
    this.uidFlightCase,
    this.dateGigForCalendar,
    this.uidMyCase,
  });

  ///Users Collection

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future<void> setUserData(
    String name,
    DateTime dateOfBirth,
    String city,
    String phone,
    String speciality,
    Image profileImage,
    String email,
  ) async {
    return await usersCollection.document(userUid).setData({
      'name': name,
      'userUid': userUid,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth),
      'city': city,
      'phone': phone,
      'speciality': speciality,
      'email': email,
    });
  }

  //update user data
  Future<void> updateUserData(
    String name,
    DateTime dateOfBirth,
    String city,
    String phone,
    String speciality,
    Image profileImage,
    String email,
  ) async {
    return await usersCollection.document(userUid).updateData({
      'name': name,
      'userUid': userUid,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth),
      'city': city,
      'phone': phone,
      'speciality': speciality,
      'email': email,
    });
  }

  //user info from snapshot

  UserData _userInfoFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: userUid,
      name: snapshot.data['name'],
      dateOfBirth: DateFormat('yyyy-MM-dd').parse(snapshot.data['dateOfBirth']),
      city: snapshot.data['city'],
      phone: snapshot.data['phone'] ?? '',
      speciality: snapshot.data['speciality'],
      email: snapshot.data['email'],
      //profileImage: ,
    );
  }

  //get user stream

  Stream<UserData> get userData {
    return usersCollection
        .document(userUid)
        .snapshots()
        .map(_userInfoFromSnapshot);
  }

  ///gigs data

  //set gig's data
  Future<void> setGigData({
    String userUid,
    String nameGig,
    DateTime startDate,
    DateTime endDate,
    String location,
    String notes,
  }) async {
    return await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .setData({
      'nameGig': nameGig,
      'userUid': userUid,
      'uidGig': uidGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'location': location,
      'notes': notes,
    });
  }

  // update gig data
  Future<void> updateGigData({
    String nameGig,
    DateTime startDate,
    DateTime endDate,
    String location,
    String notes,
  }) async {
    return await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .updateData({
      'nameGig': nameGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'location': location,
      'notes': notes,
    });
  }

  //gig info from snapshot
  NewGig _gigInfoFromSnapshot(DocumentSnapshot snapshot) {
    return NewGig(
      uidGig: snapshot.documentID,
      nameGig: snapshot.data['nameGig'],
      startDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['startDate']),
      endDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['endDate']),
      location: snapshot.data['location'],
      notes: snapshot.data['notes'] ?? 'No notes',
    );
  }

  // get gigs info

  Stream<NewGig> get gigInfo {
    return Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .snapshots()
        .map(_gigInfoFromSnapshot);
  }

  // list of gigs
  List<NewGig> _gigListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(_gigInfoFromSnapshot).toList();
  }

  // get gigs stream
  Stream<List<NewGig>> get gigList {
    return Firestore.instance
        .collection('gigs')
        .where('userUid', isEqualTo: userUid)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map(_gigListFromSnapshot);
  }

  // delete gig

  void deleteGig() async {
    await Firestore.instance.collection('gigs').document(uidGig).delete();
    // delete calendar gig
    await usersCollection
        .document(userUid)
        .collection('calendarGigs')
        .document(uidGig)
        .delete();

    //TODO: Create for loop to erase all loads for this gig
  }

  ///Calendar Data

  //set calendarGig data
  Future<void> setCalendarGigData({
    String uidGig,
    String nameGig,
    DateTime startDate,
    DateTime endDate,
  }) async {
    return await usersCollection
        .document(userUid)
        .collection('calendarGigs')
        .document(uidGig)
        .setData({
      'uidGig': uidGig,
      'calendarGigName': nameGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
    });
  }

  //update Calendar Gig Data
  Future<void> updateCalendarGigData({
    String uidGig,
    String nameGig,
    DateTime startDate,
    DateTime endDate,
  }) async {
    return await usersCollection
        .document(userUid)
        .collection('calendarGigs')
        .document(uidGig)
        .updateData({
      'uidGig': uidGig,
      'calendarGigName': nameGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
    });
  }

  // Calendar gigs from snapshot
  CalendarGig _calendarGigInfoFromSnapshot(DocumentSnapshot snapshot) {
    return CalendarGig(
      uidGig: snapshot.data['uidGig'],
      calendarGigName: snapshot.data['calendarGigName'],
      startDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['startDate']),
      endDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['endDate']),
    );
  }

  // gigs for calendar
  List<CalendarGig> _calendarGigListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(_calendarGigInfoFromSnapshot).toList();
  }

  //stream gigs for calendar
  Stream<List<CalendarGig>> get gigListForCalendar {
    return usersCollection
        .document(userUid)
        .collection('calendarGigs')
        .snapshots()
        .map(_calendarGigListFromSnapshot);
  }

  //stream gigs for list Calendar Gig
  Stream<List<CalendarGig>> get gigListForListCalendarsGig {
    return usersCollection
        .document(userUid)
        .collection('calendarGigs')
        .where('startDate',
            isEqualTo: DateFormat('yyyy-MM-dd').format(dateGigForCalendar))
        .snapshots()
        .map(_calendarGigListFromSnapshot);
  }

  /// Crew data for Gig

  //set crew data
  Future<void> gigSetCrewData({
    String nameCrew,
    String permission,
    int index,
  }) async {
    CollectionReference crewCollection = Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew');

    await crewCollection.document().setData({
      'uidGig': uidGig,
      'nameCrew': nameCrew,
      'permission': permission,
      'index': index,
    });
  }

  // get crew member data
  NewCrewMember _gigInfoNewCrewMemberFromSnapshot(DocumentSnapshot snapshot) {
    return NewCrewMember(
      uidCrewMember: snapshot.documentID,
      nameCrew: snapshot.data['nameCrew'],
      permission: snapshot.data['permission'],
      index: snapshot.data['index'],
    );
  }

  // get crew member stream
  Stream<NewCrewMember> get gigCrewMemberData {
    CollectionReference crewCollection = Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew');

    return crewCollection
        .document(uidCrewGig)
        .snapshots()
        .map(_gigInfoNewCrewMemberFromSnapshot);
  }

  // crew member list
  List<NewCrewMember> _gigListCrewMembers(QuerySnapshot snapshot) {
    return snapshot.documents.map(_gigInfoNewCrewMemberFromSnapshot).toList();
  }

  // get crew member list stream
  Stream<List<NewCrewMember>> get gigCrewMemberList {
    CollectionReference crewCollection = Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew');
    return crewCollection.snapshots().map(_gigListCrewMembers);
  }

  // delete crew member
  void gigDeleteCrewMember() async {
    CollectionReference crewCollection = Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew');

    await crewCollection.document(uidCrewGig).delete();
  }

  /// Crew data for Friend
  //
  // //set crew data
  // Future<void> setCrewData({
  //   String nameCrew,
  //   String permission,
  //   int index,
  // }) async {
  //   CollectionReference crewCollection = Firestore.instance
  //       .collection('gigs')
  //       .document(uidGig)
  //       .collection('crew');
  //
  //   await crewCollection.document().setData({
  //     'uidGig': uidGig,
  //     'nameCrew': nameCrew,
  //     'permission': permission,
  //     'index': index,
  //   });
  // }
  //
  // // get crew member data
  // NewCrewMember _infoNewCrewMemberFromSnapshot(DocumentSnapshot snapshot) {
  //   return NewCrewMember(
  //     uidCrewMember: snapshot.documentID,
  //     nameCrew: snapshot.data['nameCrew'],
  //     permission: snapshot.data['permission'],
  //     index: snapshot.data['index'],
  //   );
  // }
  //
  // // get crew member stream
  // Stream<NewCrewMember> get crewMemberData {
  //   CollectionReference crewCollection = Firestore.instance
  //       .collection('gigs')
  //       .document(uidGig)
  //       .collection('crew');
  //
  //   return crewCollection
  //       .document(uidCrewGig)
  //       .snapshots()
  //       .map(_gigInfoNewCrewMemberFromSnapshot);
  // }
  //
  // // crew member list
  // List<NewCrewMember> _listCrewMembers(QuerySnapshot snapshot) {
  //   return snapshot.documents.map(_gigInfoNewCrewMemberFromSnapshot).toList();
  // }
  //
  // // get crew member list stream
  // Stream<List<NewCrewMember>> get crewMemberList {
  //   CollectionReference crewCollection = Firestore.instance
  //       .collection('gigs')
  //       .where('userUid', isEqualTo: userUid)
  //       .collection('crew');
  //   return crewCollection.snapshots().map(_gigListCrewMembers);
  // }
  //
  // // delete crew member
  // void deleteCrewMember() async {
  //   CollectionReference crewCollection = Firestore.instance
  //       .collection('gigs')
  //       .document(uidGig)
  //       .collection('crew');
  //
  //   await crewCollection.document(uidCrewGig).delete();
  // }

  ///List of FlightCases Created

  Future<void> updateNewLoadListData({
    List<FlightCase> flightCasesOnList,
    String loadName,
  }) async {
    flightCasesToMap(FlightCase flightCaseForMap) {
      return {
        'index': flightCaseForMap.index,
        'name': flightCaseForMap.nameFlightCase,
        'quantity': flightCaseForMap.quantity,
        'type': flightCaseForMap.typeFlightCase,
        'loaded': flightCaseForMap.loaded,
        'stack': flightCaseForMap.stack,
        'wheels': flightCaseForMap.wheels,
        'tilt': flightCaseForMap.tilt,
        'color': flightCaseForMap.color
        //TODO: add 'category': flightCaseForMap.category,
      };
    }

    await Firestore.instance.collection('loads').document(uidLoad).updateData({
      'loadedCases': flightCasesOnList.length,
      'loadList': flightCasesOnList.map(flightCasesToMap).toList(),
    });
  }

  ///Load List Data Fetch Once

  Future<List<FlightCase>> getLoadListOnce() {
    return Firestore.instance
        .collection('loads')

        ///.where('userUid', isEqualTo: userUid)
        .document(uidLoad)
        .get()
        .then((data) async {
      List loadListOfMaps = data['loadList'];

      List<FlightCase> loadList = loadListOfMaps
          .map((element) => FlightCase(
                index: element['index'],
                nameFlightCase: element['name'],
                quantity: element['quantity'],
                typeFlightCase: element['type'],
                loaded: element['loaded'],
                stack: element['stack'],
                wheels: element['wheels'],
                tilt: element['tilt'],
                color: element['color'],
                //TODO: add category: snapshot.data['category'],
              ))
          .toList();

      return loadList;
    });

    //then(_loadListInfoFromSnapshot)
  }

  /// Load List Data

  // FlightCase _loadListInfoFromFirebase(Map element) {
  //   return FlightCase(
  //     index: element['index'],
  //     nameFlightCase: element['name'],
  //     quantity: element['quantity'],
  //     typeFlightCase: element['type'],
  //     loaded: element['loaded'],
  //     stack: element['stack'],
  //     wheels: element['wheels'],
  //     tilt: element['tilt'],
  //     //TODO: add category: snapshot.data['category'],
  //   );
  // }

  /// Load data
  // set load data
  Future<void> setLoadData({
    String nameLoad,
  }) async {
    CollectionReference loadCollection = Firestore.instance.collection('loads');

    await loadCollection.document(uidLoad).setData({
      'uidGig': uidGig,
      'userUid': userUid,
      'nameLoad': nameLoad,
      'refresh': false,

      ///Checks if a roadie refreshes the load page
    });
  }

  // load data from snapshot
  Load _loadInfoFromSnapshot(DocumentSnapshot snapshot) {
    return Load(
      uidLoad: snapshot.documentID,
      nameLoad: snapshot.data['nameLoad'],
      index: snapshot.data['index'],
    );
  }

  //get load stream
  Stream<Load> get loadData {
    CollectionReference loadCollection = Firestore.instance.collection('loads');
    return loadCollection
        .document(uidLoad)
        .snapshots()
        .map(_loadInfoFromSnapshot);
  }

  // load list data
  List<Load> _loadsList(QuerySnapshot snapshot) {
    return snapshot.documents.map(_loadInfoFromSnapshot).toList();
  }

  // get loads list stream

  Stream<List<Load>> get loadListData {
    return Firestore.instance
        .collection('loads')
        .where('uidGig', isEqualTo: uidGig)
        .snapshots()
        .map(_loadsList);
  }

  // delete load member
  void deleteLoad() async {
    CollectionReference loadCollection = Firestore.instance.collection('loads');

    await loadCollection.document(uidLoad).delete();
  }

  /// Own Flight Case Data
  //set Own Cases List
  Future<void> setOwnCaseData(
      {String nameFlightCase,
      String typeFlightCase,
      bool wheels,
      bool tilt,
      bool stack,
      String color}) async {
    CollectionReference ownListCollection = Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('ownCases');

    await ownListCollection.document().setData({
      'nameFlightCase': nameFlightCase,
      'typeFlightCase': typeFlightCase,
      'wheels': wheels,
      'tilt': tilt,
      'stack': stack,
      'color': color,
    });
  }

  // update flight case data
  Future<void> updateOwnCaseData({
    String nameFlightCase,
    String typeFlightCase,
    bool wheels,
    bool tilt,
    bool stack,
    String color,
  }) async {
    CollectionReference flightCaseCollection = Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('ownCases');
    await flightCaseCollection.document(uidFlightCase).updateData({
      'nameFlightCase': nameFlightCase,
      'wheels': wheels,
      'tilt': tilt,
      'stack': stack,
      'color': color
    });
  }

  Stream<FlightCase> get ownCasesInfo {
    return Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .snapshots()
        .map(_flightCaseInfoFromSnapshot);
  }

  // list of gigs
  List<FlightCase> _ownCasesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(_flightCaseInfoFromSnapshot).toList();
  }

  //  get own case list data
  Stream<List<FlightCase>> get ownCaseListData {
    CollectionReference ownCaseCollection = Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('ownCases');

    return ownCaseCollection.snapshots().map(_ownCasesListFromSnapshot);
  }

  void deleteOwnCase(String uidOwnCase) async {
    await Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('ownCases')
        .document(uidOwnCase)
        .delete();

    //TODO: Create for loop to erase all loads for this gig
  }

  /// New Flight Case data

  // set flight case data
  // Future<void> setFlightCaseData(
  //     {String nameFlightCase,
  //     String typeFlightCase,
  //     int quantity,
  //     bool wheels,
  //     bool tilt,
  //     bool stack,
  //     int index,
  //     bool loaded,
  //     String color}) async {
  //   //TODO: Maybe can delete uidFlightCase
  //   CollectionReference flightCaseCollection = Firestore.instance
  //       .collection('loads')
  //       .document(uidLoad)
  //       .collection('loadList');
  //   await flightCaseCollection.document(uidFlightCase).setData({
  //     'nameFlightCase': nameFlightCase,
  //     'typeFlightCase': typeFlightCase,
  //     'quantity': quantity,
  //     'wheels': wheels,
  //     'tilt': tilt,
  //     'stack': stack,
  //     'index': index,
  //     'loaded': loaded,
  //     'color': color
  //   });
  // }

  // flight case from snapshot
  FlightCase _flightCaseInfoFromSnapshot(DocumentSnapshot snapshot) {
    return FlightCase(
        uidFlightCase: snapshot.documentID,
        nameFlightCase: snapshot.data['nameFlightCase'],
        typeFlightCase: snapshot.data['typeFlightCase'],
        quantity: snapshot.data['quantity'],
        wheels: snapshot.data['wheels'],
        tilt: snapshot.data['tilt'],
        stack: snapshot.data['stack'],
        index: snapshot.data['index'],
        loaded: snapshot.data['loaded'],
        color: snapshot.data['color']);
  }

  // get flight case data
  // Stream<FlightCase> get flightCaseData {
  //   CollectionReference flightCaseCollection = Firestore.instance
  //       .collection('loads')
  //       .document(uidLoad)
  //       .collection('loadList');
  //
  //   return flightCaseCollection
  //       .document(uidFlightCase)
  //       .snapshots()
  //       .map(_flightCaseInfoFromSnapshot);
  // }

  // flight case list data
  List<FlightCase> _flightCaseListData(QuerySnapshot snapshot) {
    return snapshot.documents.map(_flightCaseInfoFromSnapshot).toList();
  }

  //  get flight case list data
  Stream<List<FlightCase>> get flightCaseListData {
    CollectionReference flightCaseCollection = Firestore.instance
        .collection('loads')
        .document(uidLoad)
        .collection('loadList');

    if (isLoadPage == false) {
      return flightCaseCollection.snapshots().map(_flightCaseListData);
    } else {
      if (loaded == true) {
        return flightCaseCollection
            .where('loaded', isEqualTo: true)
            .snapshots()
            .map(_flightCaseListData);
      } else {
        return flightCaseCollection
            .where('loaded', isEqualTo: false)
            .snapshots()
            .map(_flightCaseListData);
      }
    }
  }

  void deleteFlightCase() async {
    CollectionReference flightCaseCollection = Firestore.instance
        .collection('loads')
        .document(uidLoad)
        .collection('loadList');

    await flightCaseCollection.document(uidFlightCase).delete();
  }

  //replace index in all cases
  // Future<void> setIndex({int index}) async {
  //   CollectionReference flightCaseCollection = Firestore.instance
  //       .collection('loads')
  //       .document(uidLoad)
  //       .collection('loadList');
  //
  //   await flightCaseCollection
  //       .document(uidFlightCase)
  //       .updateData({'index': index});
  // }

  // Future<void> setLoaded({bool loaded}) async {
  //   CollectionReference flightCaseCollection = Firestore.instance
  //       .collection('loads')
  //       .document(uidLoad)
  //       .collection('loadList');
  //
  //   await flightCaseCollection
  //       .document(uidFlightCase)
  //       .updateData({'loaded': loaded});
  // }

  /// New My Case data

  // set flight case data
  // Future<void> setMyCaseData({
  //   String nameFlightCase,
  //   String typeFlightCase,
  //   bool wheels,
  //   bool tilt,
  //   bool stack,
  // }) async {
  //   CollectionReference myCaseCollection =
  //       Firestore.instance.collection('cases');
  //
  //   await myCaseCollection
  //       .document('${userUid}Cases')
  //       .collection('cases')
  //       .document()
  //       .setData({
  //     'nameFlightCase': nameFlightCase,
  //     'typeFlightCase': typeFlightCase,
  //     'wheels': wheels,
  //     'tilt': tilt,
  //     'stack': stack,
  //   });
  // }

// replace index in all cases
//  replaceIndexForward() async {
//    CollectionReference flightCaseCollection =
//    usersCollection.document(userUid).collection('gigs')
//        .document(uidGig).collection('loads').document(uidLoad).collection('loadList');
//
//   await flightCaseCollection.getDocuments()
//       .then((snapshot) {
//         snapshot.documents.forEach((flightCase) {
//
//           int index = flightCase.data['quantity'];
//
//           flightCaseCollection.document(flightCase.documentID)
//                 .updateData({'quantity' : 0});
//
//   }
//
//   );

//           for(final flightCase in snapshot.documents){
//
//               flightCaseCollection.document(flightCase.documentID)
//                   .updateData({'quantity' : flightCase.data['quantity']});
//           }
//
//         }
//       );
//
//  }
}
