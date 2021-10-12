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
    String color,
    int crew,
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
    return await Firestore.instance
        .collection('users')
        .document(user)
        .collection('calendarGigs')
        .document(gig)
        .updateData({
      'crew': crew,
    });
  }

  Future<void> updateCrewNumberGig({
    int crew,
    String user,
  }) async {
    await updateCrewNumberCalendarGig(crew: crew, user: user, gig: uidGig);
    return await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .updateData({
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
    return await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .updateData({
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
    return NewGig(
      uidGig: snapshot.documentID,
      nameGig: snapshot.data['nameGig'],
      startDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['startDate']),
      endDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['endDate']),
      location: snapshot.data['location'],
      notes: snapshot.data['notes'] ?? 'No notes',
      color: snapshot.data['color'],
      crew: snapshot.data['crew'] != null ? snapshot.data['crew'] : 1,
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
      return Firestore.instance
          .collection('gigs')
          .where(crewMemberData, isEqualTo: !pending)
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
    String uidCreator;
    await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .get()
        .then((val) {
      var value = val.data['userUid'];
      uidCreator = value;
    });
    if (userUid == uidCreator) {
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
    } else {
      /// Delete calendar gig
      await usersCollection
          .document(userUid)
          .collection('calendarGigs')
          .document(uidGig)
          .delete();

      ///Delete crew name from gig
      await Firestore.instance.collection('gigs').document(uidGig).updateData({
        crewMemberData: FieldValue.delete(),
      });

      ///Delete crew name from crew gig
      await Firestore.instance
          .collection('gigs')
          .document(uidGig)
          .collection('crew')
          .document(crewMemberData)
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
        .document(userUid)
        .collection('calendarGigs')
        .document(uidGig)
        .setData({
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
        .document(userUid)
        .collection('calendarGigs')
        .document(uidGig)
        .updateData({
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
    return CalendarGig(
      uidGig: snapshot.data['uidGig'],
      calendarGigName: snapshot.data['calendarGigName'],
      startDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['startDate']),
      endDate: DateFormat('yyyy-MM-dd').parse(snapshot.data['endDate']),
      location: snapshot.data['location'] != null
          ? snapshot.data['location']
          : 'Location',
      crew: snapshot.data['crew'] != null ? snapshot.data['crew'] : 1,
      color: snapshot.data['color'],
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
        .document(userUid)
        .collection('calendarGigs')
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(s),
            isLessThan: DateFormat('yyyy-MM-dd').format(e))
        .snapshots()
        .map(_calendarGigListFromSnapshot);
  }

  // /// Get Crew Number Once
  // Future totalCrewOnce(gigUid) async {
  //   var respectsQuery = Firestore.instance
  //       .collection('gig')
  //       .document(gigUid)
  //       .collection('crew');
  //   var querySnapshot = await respectsQuery.getDocuments();
  //   var totalEquals = querySnapshot.documents.length;
  //   return totalEquals;
  // }

  ///Crew List Data Fetch Once

  // Future getCrewListOnce({
  //   String uidGig,
  // }) async {
  //   try {
  //     final QuerySnapshot qSnap = await Firestore.instance
  //         .collection('gigs')
  //         .document(uidGig)
  //         .collection('crew')
  //         .getDocuments();
  //     final int documents = qSnap.documents.length;

  //     return documents;
  //   } catch (e) {
  //     return null;
  //   }
  // }

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
        'speciality': speciality,
        'city': city,
        'index': index,
      });

      ///Sets a field in the gig with crew members uid to search
      uidCreator != uidCrewGig
          ? await Firestore.instance
              .collection('gigs')
              .document(uidGig)
              .updateData({
              crewMemberData: false,
            })
          : null;
    } else {
      if (!pending) {
        CollectionReference friendCollection = Firestore.instance
            .collection('users')
            .document(userUid)
            .collection('friends');

        await friendCollection.document(crewMemberData).setData({
          'name': nameCrew,
          'speciality': speciality,
          'friendUid': crewMemberData,
          'city': city,
          'userUid': userUid,
        });
        // DELETE PENDING
        Firestore.instance
            .collection('users')
            .document(userUid)
            .collection('pending')
            .document(crewMemberData)
            .delete();
      } else {
        CollectionReference pendingCollection = Firestore.instance
            .collection('users')
            .document(userUid)
            .collection('pending');

        ///Set a "Pending Response" Friend
        await pendingCollection.document(crewMemberData).setData({
          'name': nameCrew,
          'speciality': speciality,
          'waitingFriendsAnswer': waitingFriendsAnswer,
          'friendUid': crewMemberData,
          'userUid': userUid,
          'city': city,
        });

        ///Set a "Friend Request" to a Friend
        await Firestore.instance
            .collection('users')
            .document(userUid)
            .get()
            .then((val) async {
          await Firestore.instance
              .collection('users')
              .document(crewMemberData)
              .collection('pending')
              .document(userUid)
              .setData({
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
    await Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('friends')
        .document(crewMemberData)
        .setData({
      'name': name,
      'city': city,
      'friendUid': crewMemberData,
      'useruid': userUid,
      'speciality': speciality,
    });

    ///Add Friend to Friend
    await Firestore.instance
        .collection('users')
        .document(userUid)
        .get()
        .then((val) async {
      await Firestore.instance
          .collection('users')
          .document(crewMemberData)
          .collection('friends')
          .document(userUid)
          .setData({
        'name': val['name'],
        'city': val['city'],
        'friendUid': crewMemberData,
        'useruid': userUid,
        'speciality': val['speciality'],
      });
    });

    /// Delete Pending own
    await Firestore.instance
        .collection('users')
        .document(userUid)
        .collection('pending')
        .document(crewMemberData)
        .delete();

    /// Delete Pending for Friend
    await Firestore.instance
        .collection('users')
        .document(crewMemberData)
        .collection('pending')
        .document(userUid)
        .delete();
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
        var index = val.data['index'];

        return [permission, index];
      });
    } else {
      return ['Admin', 1];
    }
  }

  // get crew member data
  NewCrewMember _gigInfoNewCrewMemberFromSnapshot(DocumentSnapshot snapshot) {
    return NewCrewMember(
      uidCrewMember: snapshot.documentID,
      nameCrew: snapshot.data['nameCrew'],
      permission: snapshot.data['permission'],
      index: snapshot.data['index'],
      city: snapshot.data['city'],
      speciality: snapshot.data['speciality'] == null
          ? 'RANDOM'
          : snapshot.data['speciality'],
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
    if (isCrewPage) {
      int crew;
      //Get creators uid
      String uidCreator;
      await Firestore.instance
          .collection('gigs')
          .document(uidGig)
          .get()
          .then((val) {
        var value = val.data['userUid'];
        uidCreator = value;
        crew = val.data['crew'];
      });

      //Substract one from crew
      updateCrewNumberGig(crew: crew - 1, user: userUid);

      CollectionReference crewCollection = Firestore.instance
          .collection('gigs')
          .document(uidGig)
          .collection('crew');

      if (uidCreator != uidCrewGig) {
        //Delete from Gig's Crew
        await crewCollection.document(uidCrewGig).delete();
        //Delete from Gig
        await Firestore.instance
            .collection('gigs')
            .document(uidGig)
            .updateData({
          crewMemberData: FieldValue.delete(),
        });
        //Delete Calendar Gig for friend

        await Firestore.instance
            .collection('users')
            .document(uidCrewGig)
            .collection('calendarGigs')
            .document(uidGig)
            .delete();
      }
    } else {
      Firestore.instance
          .collection('users')
          .document(userUid)
          .collection('friends')
          .document(crewMemberData)
          .delete();
    }
  }

  // check for Loader and refresh Loader from Gig
  checkForIsLoader() async {
    await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew')
        .where('permission', isEqualTo: 'Loader')
        .getDocuments()
        .then((val) async {
      if (val.documents.length > 0) {
        await Firestore.instance
            .collection('gigs')
            .document(uidGig)
            .updateData({
          'isLoader': true,
        });
      } else {
        await Firestore.instance
            .collection('gigs')
            .document(uidGig)
            .updateData({
          'isLoader': false,
        });
      }
    });
  }

  Future<bool> checkForLoaderToAdd() async {
    return await Firestore.instance
        .collection('gigs')
        .document(uidGig)
        .collection('crew')
        .where('permission', isEqualTo: 'Loader')
        .getDocuments()
        .then((val) async {
      if (val.documents.length > 0) {
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

  // get friends stream
  Stream<List<NewFriend>> get crewMemberList {
    if (isCrewPage == true) {
      return Firestore.instance
          .collection('users')
          .document(userUid)
          .collection('friends')
          .where('name', isGreaterThanOrEqualTo: crewMemberData)
          .snapshots()
          .map(_crewListFromSnapshot);
    } else {
      if (searchingFriends == false) {
        if (!pending) {
          CollectionReference friendsCollection = Firestore.instance
              .collection('users')
              .document(userUid)
              .collection('friends');

          return friendsCollection.snapshots().map(_crewListFromSnapshot);
        } else {
          return Firestore.instance
              .collection('users')
              .document(userUid)
              .collection('pending')
              .where('waitingFriendsAnswer', isEqualTo: waitingFriendsAnswer)
              .snapshots()
              .map(_crewListFromSnapshot);
        }
      } else {
        return Firestore.instance
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
  //     return Firestore.instance
  //         .collection('users')
  //         .where('email', isEqualTo: crewMemberData)
  //         .snapshots()
  //         .map(_crewListFromSnapshot);
  //   } else {
  //     //TODO: Find another way to return a "null" list
  //     return Firestore.instance
  //         .collection('users')
  //         .where('userUid', isEqualTo: '1')
  //         .snapshots()
  //         .map(_crewListFromSnapshot);
  //   }
  // }

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
    try {
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
    } catch (e) {
      return null;
    }
  }

  ///List of FlightCases Created

  Future<void> updateNewLoadListDataPRUEBA({
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

    await Firestore.instance.collection('loads').document(uidLoad).updateData({
      'totalCases': totalFlightCases,
      'loadedCases': flightCasesLoaded,
      'loadList': listBlocRow.map(blocRowToMap).toList(),
      'idAndBlocRow': idAndBlockRow,
    });
  }

  // Get Loaded Cases and Total Cases
  Future<List<int>> getTotalAndLoadedCasesPRUEBA() {
    return Firestore.instance
        .collection('loads')
        .document(uidLoad)
        .get()
        .then((data) async {
      int loadedCases = data['loadedCases'];
      int totalCases = data['totalCases'];

      return [loadedCases, totalCases];
    });
  }

  ///Load List Data Fetch Once

  Future<List<BlocRow>> getLoadListOncePRUEBA() {
    return Firestore.instance
        .collection('loads')
        .document(uidLoad)
        .get()
        .then((data) async {
      List loadListOfBlocRows = data['loadList'];
      idAndBlocRow = data['idAndBlocRow'];
      int loadedCases = data['loadedcases'];
      int totalCases = data['totalCases'];

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
                  //TODO: add category: snapshot.data['category'],
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

  // delete load
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
