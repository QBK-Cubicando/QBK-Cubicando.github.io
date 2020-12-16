import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_gig_page.dart';

import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:table_calendar/table_calendar.dart';

///Documentated
class QBKCalendar extends StatefulWidget {
  @override
  _QBKCalendarState createState() => _QBKCalendarState();
}

class _QBKCalendarState extends State<QBKCalendar> {
  // TextEditingController _textController;

  Map<DateTime, List<dynamic>> _gigs;
  //List<dynamic> _selectedGigs;

  Map<DateTime, List<dynamic>> _groupGigs(List<CalendarGig> calendarGigs) {
    Map<DateTime, List<dynamic>> data = {};

    calendarGigs.forEach((calendarGig) {
      DateTime date = calendarGig.startDate;

      if (data[date] == null) data[date] = [];

      data[date].add(calendarGig);
    });
    return data;
  }

  //AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    // _textController = TextEditingController();

    _gigs = {};
    //_selectedGigs = [];
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    // _showAddDialog() {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       content: TextField(
    //         controller: _textController,
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text('Save'),
    //           onPressed: () async {
    //             if (_textController.text.isEmpty) return;
    //             if (_calendarController.selectedDay != null) {
    //               await DatabaseService(
    //                 userUid: user.uid,
    //               ).setCalendarGigData(
    //                 nameGig: _textController.text,
    //                 startDate: _calendarController.selectedDay,
    //                 endDate: _calendarController.selectedDay,
    //               );
    //             }
    //
    //             _textController.clear();
    //             Navigator.pop(context);
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<List<CalendarGig>>(
                stream: DatabaseService(userUid: user.uid).gigListForCalendar,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CalendarGig> _allGigs = snapshot.data;

                    if (_allGigs.isNotEmpty) {
                      _gigs = _groupGigs(_allGigs);
                    }
                  }

                  return TableCalendar(
                    headerStyle: HeaderStyle(
                      titleTextStyle: kTextStyle(context).copyWith(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.04),
                      formatButtonTextStyle: kTextStyle(context).copyWith(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.025),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: kTextStyle(context).copyWith(
                            color: Colors.black,
                            fontSize: displayWidth(context) * 0.03),
                        weekendStyle: kTextStyle(context).copyWith(
                            color: Colors.red,
                            fontSize: displayWidth(context) * 0.032)),
                    calendarController: _calendarController,
                    initialSelectedDay: DateTime.now(),
                    startDay: DateTime(2020),
                    endDay: DateTime(2050),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      weekendStyle: kTextStyle(context).copyWith(
                          color: Colors.red,
                          fontSize: displayWidth(context) * 0.03),
                      weekdayStyle: kTextStyle(context).copyWith(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.03),
                      todayColor: Colors.lightBlueAccent,
                      selectedColor: Colors.green,
                      todayStyle: kTextStyle(context).copyWith(
                        color: Colors.black,
                        fontSize: displayWidth(context) * 0.037,
                      ),
                      selectedStyle: kTextStyle(context).copyWith(
                        color: Colors.black,
                        fontSize: displayWidth(context) * 0.037,
                      ),
                    ),
                    events: _gigs,
                    onDaySelected: (date, list1, list2) {
                      setState(() {});
                    },
                  );
                }),
            SingleChildScrollView(
              child: Container(
                  height: displayHeight(context) * 0.2,
                  width: displayWidth(context) * 0.7,
                  child: SelectedDayGigList(
                    selectedDay:
                        _calendarController.selectedDay ?? DateTime.now(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

///Class that saves Gig's Data to show it on calendar
class CalendarGig extends StatefulWidget {
  final CalendarGig calendarGig;
  final String calendarGigName;
  final String uidGig;
  final DateTime startDate;
  final DateTime endDate;

  CalendarGig(
      {this.calendarGig,
      this.calendarGigName,
      this.uidGig,
      this.startDate,
      this.endDate});

  @override
  _CalendarGigState createState() => _CalendarGigState();
}

class _CalendarGigState extends State<CalendarGig> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.calendarGig.calendarGigName,
        style: kTextStyle(context)
            .copyWith(color: Colors.black), //TODO: Reducir Font
      ),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        //TODO: THIS Scrolls back , fix it
        return CreateGigPage(
          nameGig: widget.calendarGig.calendarGigName,
          uidGig: widget.calendarGig.uidGig,
          startDate:
              DateFormat('dd-MM-yyyy').format(widget.calendarGig.startDate),
          //startDate: widget.calendarGig.startDate,
        );
      })),
    );
  }
}

///List of Gigs that are showed when selecting a day in calendar with gigs
class SelectedDayGigList extends StatefulWidget {
  final DateTime selectedDay;

  SelectedDayGigList({this.selectedDay});

  @override
  _SelectedDayGigListState createState() => _SelectedDayGigListState();
}

class _SelectedDayGigListState extends State<SelectedDayGigList> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<CalendarGig>>(
        stream: DatabaseService(
                userUid: user.uid, dateGigForCalendar: widget.selectedDay)
            .gigListForListCalendarsGig,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            List<CalendarGig> _selectedDayGigs = snapshot.data;

            return _selectedDayGigs.length != 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _selectedDayGigs.length,
                    itemBuilder: (context, index) {
                      return CalendarGig(
                        calendarGig: _selectedDayGigs[index],
                      );
                    })
                : Container();
          } else {
            return Loading();
          }
        });
  }
}
