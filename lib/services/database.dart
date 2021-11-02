import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/copy_load_page.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/crew_page.dart';

import 'package:qbk_simple_app/ab_created_widgets/calendar.dart';
import 'package:qbk_simple_app/models/BlocRow.dart';
import 'package:qbk_simple_app/models/flight_case.dart';
import 'package:qbk_simple_app/models/load.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/models/new_gig.dart';
import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/services/global_variables.dart';

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

  final bool isCrewPage;

  final bool searchingFriends;

  final bool pending;

  final bool waitingFriendsAnswer;

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
    this.isCrewPage,
    this.searchingFriends,
    this.pending,
    this.waitingFriendsAnswer,
    this.uidLoad,
    this.uidFlightCase,
    this.sharedGigs,
    this.dateGigForCalendar,
    this.uidMyCase,
  });

  ///Users Collection

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> setUserData(
    String name,
    DateTime dateOfBirth,
    String city,
    String phone,
    String speciality,
    Image profileImage,
    String email,
  ) async {
    return await usersCollection.doc(userUid).set({
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
    return await usersCollection.doc(userUid).update({
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
    var data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      uid: userUid,
      name: data['name'],
      dateOfBirth: DateFormat('yyyy-MM-dd').parse(data['dateOfBirth']),
      city: data['city'],
      phone: data['phone'] ?? '',
      speciality: data['speciality'],
      email: data['email'],
      //profileImage: ,
    );
  }

  //get user stream

  Stream<UserData> get userData {
    return usersCollection.doc(userUid).snapshots().map(_userInfoFromSnapshot);
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
    String color,
    int crew,
  }) async {
    return await FirebaseFirestore.instance.collection('gigs').doc(uidGig).set({
      'nameGig': nameGig,
      'userUid': userUid,
      'uidGig': uidGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'location': location,
      'notes': notes,
      'color': color,
      'crew': crew,
    });
  }

  //Update crew number Gig
  Future<void> updateCrewNumberCalendarGig({
    String user,
    int crew,
    String gig,
  }) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('calendarGigs')
        .doc(gig)
        .update({
      'crew': crew,
    });
  }

  Future<void> updateCrewNumberGig({
    int crew,
    String user,
  }) async {
    await updateCrewNumberCalendarGig(crew: crew, user: user, gig: uidGig);
    return await FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .update({
      'crew': crew,
    });
  }

  // update gig data
  Future<void> updateGigData({
    String nameGig,
    DateTime startDate,
    DateTime endDate,
    String location,
    String notes,
    String color,
    int crew,
  }) async {
    return await FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .update({
      'nameGig': nameGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'location': location,
      'notes': notes,
      'color': color,
      'crew': crew,
    });
  }

  //gig info from snapshot
  NewGig _gigInfoFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return NewGig(
      uidGig: snapshot.id,
      nameGig: data['nameGig'],
      startDate: DateFormat('yyyy-MM-dd').parse(data['startDate']),
      endDate: DateFormat('yyyy-MM-dd').parse(data['endDate']),
      location: data['location'],
      notes: data['notes'] ?? 'No notes',
      color: data['color'],
      crew: data['crew'] != null ? data['crew'] : 1,
    );
  }

  // get gigs info

  // Stream<NewGig> get gigInfo {
  //   return FirebaseFirestore.instance
  //       .collection('gigs')
  //       .doc(uidGig)
  //       .snapshots()
  //       .map(_gigInfoFromSnapshot);
  // }

  // list of gigs
  List<NewGig> _gigListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_gigInfoFromSnapshot).toList();
  }

  // get gigs stream
  Stream<List<NewGig>> get gigList {
    if (sharedGigs) {
      return FirebaseFirestore.instance
          .collection('gigs')
          .where(crewMemberData, isEqualTo: !pending)
          .snapshots()
          .map(_gigListFromSnapshot);
    } else {
      return FirebaseFirestore.instance
          .collection('gigs')
          .where('userUid', isEqualTo: userUid)
          .orderBy('startDate', descending: true)
          .snapshots()
          .map(_gigListFromSnapshot);
    }
  }

  // delete gig

  void deleteGig() async {
    String uidCreator;
    await FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .get()
        .then((val) {
      var v = val.data() as Map<String, dynamic>;
      var value = v['userUid'];
      uidCreator = value;
    });
    if (userUid == uidCreator) {
      ///Delete Gig Crew
      await FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .collection('crew')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      ///Delete Gig Loads
      await FirebaseFirestore.instance
          .collection('loads')
          .get()
          .then((snapshot) {
        List<DocumentSnapshot> allLoads = snapshot.docs;
        List<DocumentSnapshot> filteredLoads = allLoads.where((document) {
          var doc = document.data() as Map<String, dynamic>;
          return doc['uidGig'] == uidGig;
        }).toList();
        for (DocumentSnapshot ds in filteredLoads) {
          ds.reference.delete();
        }
      });

      ///Delete Gig
      await FirebaseFirestore.instance.collection('gigs').doc(uidGig).delete();

      /// Delete calendar gig
      await usersCollection
          .doc(userUid)
          .collection('calendarGigs')
          .doc(uidGig)
          .delete();
    } else {
      /// Delete calendar gig
      await usersCollection
          .doc(userUid)
          .collection('calendarGigs')
          .doc(uidGig)
          .delete();

      ///Delete crew name from gig
      await FirebaseFirestore.instance.collection('gigs').doc(uidGig).update({
        crewMemberData: FieldValue.delete(),
      });

      ///Delete crew name from crew gig
      await FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .collection('crew')
          .doc(crewMemberData)
          .delete();
    }
  }

  ///Calendar Data

  //set calendarGig data
  Future<void> setCalendarGigData({
    String uidGig,
    String nameGig,
    DateTime startDate,
    DateTime endDate,
    String location,
    String color,
    int crew,
  }) async {
    return await usersCollection
        .doc(userUid)
        .collection('calendarGigs')
        .doc(uidGig)
        .set({
      'uidGig': uidGig,
      'calendarGigName': nameGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'location': location,
      'color': color,
      'crew': crew,
    });
  }

  //update Calendar Gig Data
  Future<void> updateCalendarGigData({
    String uidGig,
    String nameGig,
    DateTime startDate,
    DateTime endDate,
    String location,
    String color,
    int crew,
  }) async {
    return await usersCollection
        .doc(userUid)
        .collection('calendarGigs')
        .doc(uidGig)
        .update({
      'uidGig': uidGig,
      'calendarGigName': nameGig,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'location': location,
      'color': color,
      'crew': crew,
    });
  }

  // Calendar gigs from snapshot
  CalendarGig _calendarGigInfoFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return CalendarGig(
      uidGig: data['uidGig'],
      calendarGigName: data['calendarGigName'],
      startDate: DateFormat('yyyy-MM-dd').parse(data['startDate']),
      endDate: DateFormat('yyyy-MM-dd').parse(data['endDate']),
      location: data['location'] != null ? data['location'] : 'Location',
      crew: data['crew'] != null ? data['crew'] : 1,
      color: data['color'],
    );
  }

  // gigs for calendar
  List<CalendarGig> _calendarGigListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_calendarGigInfoFromSnapshot).toList();
  }

  //stream gigs for calendar
  Stream<List<CalendarGig>> get gigListForCalendar {
    return usersCollection
        .doc(userUid)
        .collection('calendarGigs')
        .snapshots()
        .map(_calendarGigListFromSnapshot);
  }

  //stream gigs for list Calendar Gig
  Stream<List<CalendarGig>> get gigListForListCalendarsGig {
    // Set Date to first day of the month
    DateTime s = DateTime(dateGigForCalendar.year, dateGigForCalendar.month, 1);
    // Deal with December
    int mo = dateGigForCalendar.month == 12 ? 1 : dateGigForCalendar.month + 1;
    int ye = dateGigForCalendar.month == 12
        ? dateGigForCalendar.year + 1
        : dateGigForCalendar.year;
    // Set Date to first day of the next month
    DateTime e = DateTime(ye, mo, 1);

    return usersCollection
        .doc(userUid)
        .collection('calendarGigs')
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(s),
            isLessThan: DateFormat('yyyy-MM-dd').format(e))
        .snapshots()
        .map(_calendarGigListFromSnapshot);
  }

  /// Crew data for Gig

  //set crew data
  Future<void> gigSetCrewData({
    String nameCrew,
    String permission,
    String speciality,
    String city,
    int index,
  }) async {
    if (isCrewPage == true) {
      String uidCreator;
      await FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .get()
          .then((val) {
        var v = val.data() as Map<String, dynamic>;
        var value = v['userUid'];
        uidCreator = value;
      });

      CollectionReference crewCollection = FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .collection('crew');

      await crewCollection.doc(uidCrewGig).set({
        'uidGig': uidGig,
        'nameCrew': nameCrew,
        'permission': permission,
        'speciality': speciality,
        'city': city,
        'index': index,
      });

      ///Sets a field in the gig with crew members uid to search
      uidCreator != uidCrewGig
          ? await FirebaseFirestore.instance
              .collection('gigs')
              .doc(uidGig)
              .update({
              crewMemberData: false,
            })
          : null;
    } else {
      if (!pending) {
        CollectionReference friendCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('friends');

        await friendCollection.doc(crewMemberData).set({
          'name': nameCrew,
          'speciality': speciality,
          'friendUid': crewMemberData,
          'city': city,
          'userUid': userUid,
        });
        // DELETE PENDING
        FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('pending')
            .doc(crewMemberData)
            .delete();
      } else {
        CollectionReference pendingCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('pending');

        ///Set a "Pending Response" Friend
        await pendingCollection.doc(crewMemberData).set({
          'name': nameCrew,
          'speciality': speciality,
          'waitingFriendsAnswer': waitingFriendsAnswer,
          'friendUid': crewMemberData,
          'userUid': userUid,
          'city': city,
        });

        ///Set a "Friend Request" to a Friend
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .get()
            .then((val) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(crewMemberData)
              .collection('pending')
              .doc(userUid)
              .set({
            'name': val['name'],
            'speciality': val['speciality'],
            'waitingFriendsAnswer': false,
            'friendUid': userUid,
            'userUid': crewMemberData,
            'city': val['city'],
          });
        });
      }
    }
  }

  //Accept Friend
  Future<void> gigAddFriend({
    String name,
    String city,
    String speciality,
  }) async {
    ///Add Friend own
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends')
        .doc(crewMemberData)
        .set({
      'name': name,
      'city': city,
      'friendUid': crewMemberData,
      'useruid': userUid,
      'speciality': speciality,
    });

    ///Add Friend to Friend
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get()
        .then((val) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(crewMemberData)
          .collection('friends')
          .doc(userUid)
          .set({
        'name': val['name'],
        'city': val['city'],
        'friendUid': crewMemberData,
        'useruid': userUid,
        'speciality': val['speciality'],
      });
    });

    /// Delete Pending own
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('pending')
        .doc(crewMemberData)
        .delete();

    /// Delete Pending for Friend
    await FirebaseFirestore.instance
        .collection('users')
        .doc(crewMemberData)
        .collection('pending')
        .doc(userUid)
        .delete();
  }

  /// get crew permission for a gig
  getCrewPermission() async {
    String uidCreator;
    await FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .get()
        .then((val) {
      var v = val.data() as Map<String, dynamic>;
      var value = v['userUid'];
      uidCreator = value;
    });

    if (uidCreator != crewMemberData) {
      return FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .collection('crew')
          .doc(crewMemberData)
          .get()
          .then((val) {
        var v = val.data() as Map<String, dynamic>;
        var permission = v['permission'];
        var index = v['index'];

        return [permission, index];
      });
    } else {
      return ['Admin', 1];
    }
  }

  // get crew member data
  NewCrewMember _gigInfoNewCrewMemberFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return NewCrewMember(
      uidCrewMember: snapshot.id,
      nameCrew: data['nameCrew'],
      permission: data['permission'],
      index: data['index'],
      city: data['city'],
      speciality: data['speciality'] == null ? 'RANDOM' : data['speciality'],
    );
  }

  // get crew member stream
  Stream<NewCrewMember> get gigCrewMemberData {
    CollectionReference crewCollection = FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .collection('crew');

    return crewCollection
        .doc(uidCrewGig)
        .snapshots()
        .map(_gigInfoNewCrewMemberFromSnapshot);
  }

  // crew member list
  List<NewCrewMember> _gigListCrewMembers(QuerySnapshot snapshot) {
    return snapshot.docs.map(_gigInfoNewCrewMemberFromSnapshot).toList();
  }

  // get crew member list stream
  Stream<List<NewCrewMember>> get gigCrewMemberList {
    CollectionReference crewCollection = FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .collection('crew');

    return crewCollection.snapshots().map(_gigListCrewMembers);
  }

  // delete crew member
  void gigDeleteCrewMember() async {
    if (isCrewPage) {
      int crew;
      //Get creators uid
      String uidCreator;
      await FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .get()
          .then((val) {
        var v = val.data() as Map<String, dynamic>;
        var value = val['userUid'];
        uidCreator = value;
        crew = v['crew'];
      });

      //Substract one from crew
      updateCrewNumberGig(crew: crew - 1, user: userUid);

      CollectionReference crewCollection = FirebaseFirestore.instance
          .collection('gigs')
          .doc(uidGig)
          .collection('crew');

      if (uidCreator != uidCrewGig) {
        //Delete from Gig's Crew
        await crewCollection.doc(uidCrewGig).delete();
        //Delete from Gig
        await FirebaseFirestore.instance.collection('gigs').doc(uidGig).update({
          crewMemberData: FieldValue.delete(),
        });
        //Delete Calendar Gig for friend

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uidCrewGig)
            .collection('calendarGigs')
            .doc(uidGig)
            .delete();
      }
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('friends')
          .doc(crewMemberData)
          .delete();
    }
  }

  // check for Loader and refresh Loader from Gig
  checkForIsLoader() async {
    await FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .collection('crew')
        .where('permission', isEqualTo: 'Loader')
        .get()
        .then((val) async {
      if (val.docs.length > 0) {
        await FirebaseFirestore.instance.collection('gigs').doc(uidGig).update({
          'isLoader': true,
        });
      } else {
        await FirebaseFirestore.instance.collection('gigs').doc(uidGig).update({
          'isLoader': false,
        });
      }
    });
  }

  Future<bool> checkForLoaderToAdd() async {
    return await FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .collection('crew')
        .where('permission', isEqualTo: 'Loader')
        .get()
        .then((val) async {
      if (val.docs.length > 0) {
        return true;
      } else {
        return false;
      }
    });
  }

  /// Crew data for Friend

  //set friends list
  Future<void> setFriendsList({
    List friendsList,
  }) async {
    CollectionReference friendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends');

    if (friendsList.length > 1) {
      await friendsCollection.doc('friends').update({
        'friendsList': friendsList,
      });
    } else {
      await friendsCollection.doc('friends').set({
        'friendsList': friendsList,
      });
    }
  }

  // get crew member data
  NewFriend _infoNewCrewMemberFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return NewFriend(
      uid: snapshot.id,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      city: data['city'],
      speciality: data['speciality'],
    );
  }

  // list of crew friends
  List<NewFriend> _crewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_infoNewCrewMemberFromSnapshot).toList();
  }

  // get friends stream
  Stream<List<NewFriend>> get crewMemberList {
    if (isCrewPage == true) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('friends')
          .where('name', isGreaterThanOrEqualTo: crewMemberData)
          .snapshots()
          .map(_crewListFromSnapshot);
    } else {
      if (searchingFriends == false) {
        if (!pending) {
          CollectionReference friendsCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .collection('friends');

          return friendsCollection.snapshots().map(_crewListFromSnapshot);
        } else {
          return FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .collection('pending')
              .where('waitingFriendsAnswer', isEqualTo: waitingFriendsAnswer)
              .snapshots()
              .map(_crewListFromSnapshot);
        }
      } else {
        return FirebaseFirestore.instance
            .collection('users')
            .where('email', isGreaterThanOrEqualTo: crewMemberData)
            .snapshots()
            .map(_crewListFromSnapshot);
      }
    }
  }

  // get friends stream
  // Stream<List<NewFriend>> get searchCrewMemberList {
  //   if (crewMemberData != null) {
  //     return FirebaseFirestore.instance
  //         .collection('users')
  //         .where('email', isEqualTo: crewMemberData)
  //         .snapshots()
  //         .map(_crewListFromSnapshot);
  //   } else {
  //     //TODO: Find another way to return a "null" list
  //     return FirebaseFirestore.instance
  //         .collection('users')
  //         .where('userUid', isEqualTo: '1')
  //         .snapshots()
  //         .map(_crewListFromSnapshot);
  //   }
  // }

  ///List of FlightCases Created

  // Future<void> updateNewLoadListData({
  //   List<FlightCase> flightCasesOnList,
  //   int flightCasesLoaded,
  //   String loadName,
  // }) async {
  //   flightCasesToMap(FlightCase flightCaseForMap) {
  //     return {
  //       'index': flightCaseForMap.index,
  //       'name': flightCaseForMap.nameFlightCase,
  //       'quantity': flightCaseForMap.quantity,
  //       'type': flightCaseForMap.typeFlightCase,
  //       'loaded': flightCaseForMap.loaded,
  //       'stack': flightCaseForMap.stack,
  //       'wheels': flightCaseForMap.wheels,
  //       'tilt': flightCaseForMap.tilt,
  //       'color': flightCaseForMap.color
  //       //TODO: add 'category': flightCaseForMap.category,
  //     };
  //   }

  //   await FirebaseFirestore.instance.collection('loads').doc(uidLoad).update({
  //     'totalCases': flightCasesOnList.length,
  //     'loadedCases': flightCasesLoaded,
  //     'loadList': flightCasesOnList.map(flightCasesToMap).toList(),
  //   });
  // }

  ///Load List Data Fetch Once

  // Future<List<FlightCase>> getLoadListOnce() {
  //   try {
  //     return FirebaseFirestore.instance
  //         .collection('loads')
  //         .doc(uidLoad)
  //         .get()
  //         .then((data) async {
  //       List loadListOfMaps = data['loadList'];

  //       List<FlightCase> loadList = loadListOfMaps
  //           .map((element) => FlightCase(
  //                 index: element['index'],
  //                 nameFlightCase: element['name'],
  //                 quantity: element['quantity'],
  //                 typeFlightCase: element['type'],
  //                 loaded: element['loaded'],
  //                 stack: element['stack'],
  //                 wheels: element['wheels'],
  //                 tilt: element['tilt'],
  //                 color: element['color'],
  //                 //TODO: add category: data['category'],
  //               ))
  //           .toList();

  //       return loadList;
  //     });
  //   } catch (e) {
  //     return null;
  //   }
  // }

  ///List of FlightCases Created

  Future<void> updateNewLoadListData({
    Map<String, List<FlightCase>> mapOfFlightCasesOnList,
    List<BlocRow> listBlocRow,
    Map<String, dynamic> idAndBlockRow,
    int flightCasesLoaded,
    String loadName,
  }) async {
    int totalFlightCases = 0;
    Map testMap = {};

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

    blocRowToMap(BlocRow blocRowForMap) {
      return {
        'index': idAndBlockRow[blocRowForMap.id],
        'loaded': blocRowForMap.loaded,
        'id': blocRowForMap.id,
        'isCrica': blocRowForMap.isCrica,
        // 'stream': blocRowForMap.stream,
        'flightCaseList':
            blocRowForMap.flightCaseList.map(flightCasesToMap).toList(),
      };
    }

    mapOfFlightCasesOnList.forEach((key, value) {
      totalFlightCases += value.length;
      testMap[key] = value.map(flightCasesToMap).toList();
    });

    // Map test = listBlocRow.map(blocRowToMap).toList();

    // print(totalFlightCases);
    // print(mapOfFlightCasesOnList);

    await FirebaseFirestore.instance.collection('loads').doc(uidLoad).update({
      'totalCases': totalFlightCases,
      'loadedCases': flightCasesLoaded,
      'loadList': listBlocRow.map(blocRowToMap).toList(),
      'idAndBlocRow': idAndBlockRow,
    });
  }

  // Get Loaded Cases and Total Cases
  Future<List<int>> getTotalAndLoadedCases() {
    return FirebaseFirestore.instance
        .collection('loads')
        .doc(uidLoad)
        .get()
        .then((data) async {
      int loadedCases = data['loadedCases'];
      int totalCases = data['totalCases'];

      return [loadedCases, totalCases];
    });
  }

  ///Load List Data Fetch Once

  Future<List<BlocRow>> getLoadListOnce() {
    return FirebaseFirestore.instance
        .collection('loads')
        .doc(uidLoad)
        .get()
        .then((data) async {
      List loadListOfBlocRows = data['loadList'];
      idAndBlocRow = data['idAndBlocRow'];
      // int loadedCases = data['loadedCases'];
      // int totalCases = data['totalCases'];

      // Fetch Load List
      test(List<dynamic> list) {
        List<FlightCase> flightCaseList = list
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
                  //TODO: add category: data['category'],
                ))
            .toList();
        return flightCaseList;
      }

      // Fetch Bloc Row List

      if (idAndBlocRow != null) {
        List<BlocRow> loadBlocRowList = loadListOfBlocRows.map((element) {
          // totalFlightCaseLists[element['id']] = test(element['flightCaseList']);

          return BlocRow(
            index: element['index'],
            id: element['id'],
            loaded: element['loaded'],
            isCrica: element['isCrica'],
            isLoadPage: false,
            flightCaseList: test(element['flightCaseList']),
          );
        }).toList();

        return loadBlocRowList;
      } else {
        List<BlocRow> loadBlocRowList = [
          BlocRow(
            isCrica: false,
            isLoadPage: false,
            flightCaseList: test(data['loadList']),
            id: '01234',
            index: 1,
          )
        ];

        return loadBlocRowList;
      }
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
  //     //TODO: add category: data['category'],
  //   );
  // }

  /// Load data
  // set load data
  Future<void> setLoadData({
    String nameLoad,
  }) async {
    CollectionReference loadCollection =
        FirebaseFirestore.instance.collection('loads');

    await loadCollection.doc(uidLoad).set({
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
    var data = snapshot.data() as Map<String, dynamic>;
    return Load(
      uidLoad: snapshot.id,
      nameLoad: data['nameLoad'],
      index: data['index'],
    );
  }

  //get load stream
  Stream<Load> get loadData {
    CollectionReference loadCollection =
        FirebaseFirestore.instance.collection('loads');
    return loadCollection.doc(uidLoad).snapshots().map(_loadInfoFromSnapshot);
  }

  // load list data
  List<Load> _loadsList(QuerySnapshot snapshot) {
    return snapshot.docs.map(_loadInfoFromSnapshot).toList();
  }

  // get loads list stream

  Stream<List<Load>> get loadListData {
    return FirebaseFirestore.instance
        .collection('loads')
        .where('uidGig', isEqualTo: uidGig)
        .snapshots()
        .map(_loadsList);
  }

  // delete load
  void deleteLoad() async {
    CollectionReference loadCollection =
        FirebaseFirestore.instance.collection('loads');

    await loadCollection.doc(uidLoad).delete();
  }

  // Listen for a change in refresh

  Stream get refreshLoad {
    return FirebaseFirestore.instance
        .collection('loads')
        .doc(uidLoad)
        .snapshots();
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
    CollectionReference ownListCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('ownCases');

    await ownListCollection.doc().set({
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
    CollectionReference flightCaseCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('ownCases');
    await flightCaseCollection.doc(uidFlightCase).update({
      'nameFlightCase': nameFlightCase,
      'wheels': wheels,
      'tilt': tilt,
      'stack': stack,
      'color': color
    });
  }

  Stream<FlightCase> get ownCasesInfo {
    return FirebaseFirestore.instance
        .collection('gigs')
        .doc(uidGig)
        .snapshots()
        .map(_flightCaseInfoFromSnapshot);
  }

  // list of gigs
  List<FlightCase> _ownCasesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_flightCaseInfoFromSnapshot).toList();
  }

  //  get own case list data
  Stream<List<FlightCase>> get ownCaseListData {
    CollectionReference ownCaseCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('ownCases');

    return ownCaseCollection.snapshots().map(_ownCasesListFromSnapshot);
  }

  void deleteOwnCase(String uidOwnCase) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('ownCases')
        .doc(uidOwnCase)
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
  //   CollectionReference flightCaseCollection = FirebaseFirestore.instance
  //       .collection('loads')
  //       .doc(uidLoad)
  //       .collection('loadList');
  //   await flightCaseCollection.doc(uidFlightCase).set({
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
    var data = snapshot.data() as Map<String, dynamic>;
    return FlightCase(
        uidFlightCase: snapshot.id,
        nameFlightCase: data['nameFlightCase'],
        typeFlightCase: data['typeFlightCase'],
        quantity: data['quantity'],
        wheels: data['wheels'],
        tilt: data['tilt'],
        stack: data['stack'],
        index: data['index'],
        loaded: data['loaded'],
        color: data['color']);
  }

  // get flight case data
  // Stream<FlightCase> get flightCaseData {
  //   CollectionReference flightCaseCollection = FirebaseFirestore.instance
  //       .collection('loads')
  //       .doc(uidLoad)
  //       .collection('loadList');
  //
  //   return flightCaseCollection
  //       .doc(uidFlightCase)
  //       .snapshots()
  //       .map(_flightCaseInfoFromSnapshot);
  // }

  // flight case list data
  List<FlightCase> _flightCaseListData(QuerySnapshot snapshot) {
    return snapshot.docs.map(_flightCaseInfoFromSnapshot).toList();
  }

  //  get flight case list data
  Stream<List<FlightCase>> get flightCaseListData {
    CollectionReference flightCaseCollection = FirebaseFirestore.instance
        .collection('loads')
        .doc(uidLoad)
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
    CollectionReference flightCaseCollection = FirebaseFirestore.instance
        .collection('loads')
        .doc(uidLoad)
        .collection('loadList');

    await flightCaseCollection.doc(uidFlightCase).delete();
  }

  //replace index in all cases
  // Future<void> setIndex({int index}) async {
  //   CollectionReference flightCaseCollection = FirebaseFirestore.instance
  //       .collection('loads')
  //       .doc(uidLoad)
  //       .collection('loadList');
  //
  //   await flightCaseCollection
  //       .doc(uidFlightCase)
  //       .update({'index': index});
  // }

  // Future<void> setLoaded({bool loaded}) async {
  //   CollectionReference flightCaseCollection = FirebaseFirestore.instance
  //       .collection('loads')
  //       .doc(uidLoad)
  //       .collection('loadList');
  //
  //   await flightCaseCollection
  //       .doc(uidFlightCase)
  //       .update({'loaded': loaded});
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
  //       FirebaseFirestore.instance.collection('cases');
  //
  //   await myCaseCollection
  //       .doc('${userUid}Cases')
  //       .collection('cases')
  //       .doc()
  //       .set({
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
//    usersCollection.doc(userUid).collection('gigs')
//        .doc(uidGig).collection('loads').doc(uidLoad).collection('loadList');
//
//   await flightCaseCollection.get()
//       .then((snapshot) {
//         snapshot.docs.forEach((flightCase) {
//
//           int index = flightCase.data['quantity'];
//
//           flightCaseCollection.doc(flightCase.id)
//                 .update({'quantity' : 0});
//
//   }
//
//   );

//           for(final flightCase in snapshot.documents){
//
//               flightCaseCollection.doc(flightCase.id)
//                   .update({'quantity' : flightCase.data['quantity']});
//           }
//
//         }
//       );
//
//  }
}
