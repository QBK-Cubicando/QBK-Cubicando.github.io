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

ScrollController _gig_controller = ScrollController();

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

                  return Container(
                    color: Colors.white,
                    child: TableCalendar(
                      initialCalendarFormat: CalendarFormat.twoWeeks,
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
                        selectedColor: kgreenQBK,
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
                      onDaySelected: (date, _gigs, list2) {
                        print(list2.length);
                        int day = date.day.toInt();
                        double pos = (day / 20) * 100;

                        if (_gigs.isNotEmpty) {
                          setState(() {
                            // _gig_controller.jumpTo(pos);
                          });
                        }
                        //TODO: Scroll when select gig
                      },
                    ),
                  );
                }),
            SingleChildScrollView(
              child: Scrollbar(
                child: Container(
                    height: displayHeight(context) * 0.4,
                    width: displayWidth(context) * 0.9,
                    child: SelectedDayGigList(
                      selectedDay:
                          _calendarController.selectedDay ?? DateTime.now(),
                    )),
              ),
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
  final String location;
  final String color;
  final int crew;

  CalendarGig(
      {this.calendarGig,
      this.calendarGigName,
      this.uidGig,
      this.startDate,
      this.endDate,
      this.location,
      this.color,
      this.crew});

  @override
  _CalendarGigState createState() => _CalendarGigState();
}

class _CalendarGigState extends State<CalendarGig> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    String gigDate = DateFormat('dd-MM-yyyy')
        .format(widget.calendarGig.startDate)
        .toString();

    Color _gigColor() {
      // print(widget.calendarGig.color);
      if (widget.calendarGig.color == 'red') {
        return kredQBK;
      } else if (widget.calendarGig.color == 'blue') {
        return kblueQBK;
      } else if (widget.calendarGig.color == 'green') {
        return kgreenQBK;
      } else if (widget.calendarGig.color == 'purple') {
        return kpurpleQBK;
      } else if (widget.calendarGig.color == 'orange') {
        return Colors.orangeAccent.shade200;
      } else {
        return Colors.grey.shade50;
      }
    }
    

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: _gigColor()),
                )),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      widget.calendarGig.calendarGigName,
                      style: kTextStyle(context).copyWith(color: Colors.black),
                    ),
                  ),
                  Container(child: Text(gigDate)),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: displayWidth(context) * 0.23,
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Center(
                          child: Text(
                            widget.calendarGig.location,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: _gigColor(),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          Container(
                              child: Text('${widget.calendarGig.crew} CREW')),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CreateGigPage(
          nameGig: widget.calendarGig.calendarGigName,
          uidGig: widget.calendarGig.uidGig,
          userUid: user.uid,
          
          
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
                    controller: _gig_controller,
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
