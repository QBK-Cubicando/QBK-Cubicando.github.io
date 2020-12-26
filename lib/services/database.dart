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

  /// name, email or uid of crew member
  final String crewMemberData;

  /// list of uid friends
  final List friendsList;

  final bool isCrewPage;

  final bool searchingFriends;

  /// Load + DateTime.now
  final String uidLoad;

  /// DateTime + Name Maybe Random
  final String uidFlightCase;

  /// Checks if you're looking for shared gigs
  final bool sharedGigs;

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
    this.crewMemberData,
    this.friendsList,
    this.isCrewPage,
    this.searchingFriends,
    this.uidLoad,
    this.uidFlightCase,
    this.sharedGigs,
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

  // Stream<NewGig> get gigInfo {
  //   return Firestore.instance
  //       .collection('gigs')
  //       .document(uidGig)
  //       .snapshots()
  //       .map(_gigInfoFromSnapshot);
  // }

  // list of gigs
  List<NewGig> _gigListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(_gigInfoFromSnapshot).toList();
  }

  // get gigs stream
  Stream<List<NewGig>> get gigList {
    if (sharedGigs) {
      // return Firestore.instance
      //     .collection('gigs')
      //     .where(
      //         Firestore.instance
      //             .collection('gigs')
      //             .document()
      //             .collection('crew'),
      //         isEqualTo: userUid)
      //     .orderBy('startDate', descending: true)
      //     .snapshots()
      //     .map(_gigListFromSnapshot);

      return Firestore.instance
          .collection('gigs')
          .where(crewMemberData, isEqualTo: true)
          .snapshots()
          .map(_gigListFromSnapshot);
    } else {
      return Firestore.instance
          .collection('gigs')
          .where('userUid', isEqualTo: userUid)
          .orderBy('startDate', descending: true)
          .snapshots()
          .map(_gigListFromSnapshot);
    }
  }

  // delete gig

  void deleteGig() async {
    ///Delete Gig Crew
    await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    ///Delete Gig Loads
    await Firestore.instance
        .collection('loads')
        .getDocuments()
        .then((snapshot) {
      List<DocumentSnapshot> allLoads = snapshot.documents;
      List<DocumentSnapshot> filteredLoads = allLoads
          .where((document) => document.data['uidGig'] == uidGig)
          .toList();
      for (DocumentSnapshot ds in filteredLoads) {
        ds.reference.delete();
      }
    });

    ///Delete Gig
    await Firestore.instance.collection('gigs').document(uidGig).delete();

    /// Delete calendar gig
    await usersCollection
        .document(userUid)
        .collection('calendarGigs')
        .document(uidGig)
        .delete();
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
    String uidCreator;
    await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .get()
        .then((val) {
      var value = val.data['userUid'];
      uidCreator = value;
    });

    CollectionReference crewCollection = Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew');

    await crewCollection.document(uidCrewGig).setData({
      'uidGig': uidGig,
      'nameCrew': nameCrew,
      'permission': permission,
      'index': index,
    });

    ///Sets a field in the gig with crew members uid to search
    uidCreator != uidCrewGig
        ? await Firestore.instance
            .collection('gigs')
            .document(uidGig)
            .updateData({
            crewMemberData: true,
          })
        : null;
  }

  /// get crew permission for a gig
  getCrewPermission() async {
    String uidCreator;
    await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .get()
        .then((val) {
      var value = val.data['userUid'];
      uidCreator = value;
    });

    if (uidCreator != crewMemberData) {
      return Firestore.instance
          .collection('gigs')
          .document(uidGig)
          .collection('crew')
          .document(crewMemberData)
          .get()
          .then((val) {
        var permission = val.data['permission'];

        return permission;
      });
    } else {
      return 'Admin';
    }
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
    String uidCreator;
    await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .get()
        .then((val) {
      var value = val.data['userUid'];
      uidCreator = value;
    });

    CollectionReference crewCollection = Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew');

    if (uidCreator != uidCrewGig) {
      await crewCollection.document(uidCrewGig).delete();

      await Firestore.instance.collection('gigs').document(uidGig).updateData({
        crewMemberData: FieldValue.delete(),
      });
    }
  }

  /// Crew data for Friend

  //set friends list
  Future<void> setFriendsList({
    List friendsList,
  }) async {
    CollectionReference friendsCollection = Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('friends');

    if (friendsList.length > 1) {
      await friendsCollection.document('friends').updateData({
        'friendsList': friendsList,
      });
    } else {
      await friendsCollection.document('friends').setData({
        'friendsList': friendsList,
      });
    }
  }

  // get crew member data
  NewFriend _infoNewCrewMemberFromSnapshot(DocumentSnapshot snapshot) {
    return NewFriend(
      uid: snapshot.documentID,
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      phone: snapshot.data['phone'],
      city: snapshot.data['city'],
      speciality: snapshot.data['speciality'],
    );
  }

  // list of crew friends
  List<NewFriend> _crewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(_infoNewCrewMemberFromSnapshot).toList();
  }

  // get list of friends uid
  getFriendsListOnce() {
    return Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('friends')
        .getDocuments()
        .then((val) {
      if (val.documents.length > 0) {
        var friendsList = val.documents[0].data['friendsList'];
        return friendsList;
      } else {
        return [];
      }
    });

    //then(_loadListInfoFromSnapshot)
  }

  // get friends stream
  Stream<List<NewFriend>> get crewMemberList {
    if (isCrewPage == true) {
      return Firestore.instance
          .collection('users')
          .where('userUid', whereIn: friendsList)
          .where('name', isEqualTo: crewMemberData)
          .snapshots()
          .map(_crewListFromSnapshot);
    } else {
      if (searchingFriends == false) {
        if (friendsList.length > 0 || friendsList == null) {
          return Firestore.instance
              .collection('users')
              .where('userUid', whereIn: friendsList)
              .orderBy('name', descending: true)
              .snapshots()
              .map(_crewListFromSnapshot);
        } else {
          //TODO: Find another way to return a "null" list
          return Firestore.instance
              .collection('users')
              .where('userUid', isEqualTo: '1')
              .snapshots()
              .map(_crewListFromSnapshot);
        }
      } else {
        return Firestore.instance
            .collection('users')
            .where('email', isEqualTo: crewMemberData)
            .snapshots()
            .map(_crewListFromSnapshot);
      }
    }
  }

  // get friends stream
  Stream<List<NewFriend>> get searchCrewMemberList {
    if (crewMemberData != null) {
      return Firestore.instance
          .collection('users')
          .where('email', isEqualTo: crewMemberData)
          .snapshots()
          .map(_crewListFromSnapshot);
    } else {
      //TODO: Find another way to return a "null" list
      return Firestore.instance
          .collection('users')
          .where('userUid', isEqualTo: '1')
          .snapshots()
          .map(_crewListFromSnapshot);
    }
  }

  ///List of FlightCases Created

  Future<void> updateNewLoadListData({
    List<FlightCase> flightCasesOnList,
    int flightCasesLoaded,
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
      'totalCases': flightCasesOnList.length,
      'loadedCases': flightCasesLoaded,
      'loadList': flightCasesOnList.map(flightCasesToMap).toList(),
    });
  }

  ///Load List Data Fetch Once

  Future<List<FlightCase>> getLoadListOnce() {
    return Firestore.instance
        .collection('loads')
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
      'uidLoad': uidLoad,

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

  // Listen for a change in refresh

  Stream get refreshLoad {
    return Firestore.instance.collection('loads').document(uidLoad).snapshots();
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
