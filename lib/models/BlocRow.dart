import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';
import 'package:qbk_simple_app/services/global_variables.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:reorderables/reorderables.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/copy_load_page.dart';

import 'flight_case.dart';

class BlocRow extends StatefulWidget {
  BlocRow({
    this.index,
    @required this.isCrica,
    @required this.flightCaseList,
    // this.onSelected,
    @required this.id,
    // this.headerColor,
    this.stream,
    @required this.isLoadPage,
    this.loaded,
  });
  final int index;
  final bool isCrica;
  List<FlightCase> flightCaseList;
  // final Function onSelected;
  final String id;
  // Color headerColor;
  Stream<int> stream;
  bool isLoadPage;
  bool loaded;

  @override
  _BlocRowState createState() => _BlocRowState();
}

class _BlocRowState extends State<BlocRow> {
  bool isCrica;
  List<FlightCase> flightCaseCreateList;
  Color headerColor;
  String id;
  Function onSelected;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    isCrica = widget.isCrica;
    flightCaseCreateList = widget.flightCaseList;
    id = widget.id;

    widget.stream.listen((event) {
      mySetState(event);
    });

    headerColor =
        widget.index % 2 == 0 ? Colors.grey.shade500 : Colors.grey.shade600;
    super.initState();
  }

  void mySetState(int selectedIndex) {
    if (mounted) {
      setState(() {
        if (widget.isCrica == true &&
            selectedIndex == 999 &&
            selectedBlocRowId == widget.id.split('').reversed.join('')) {
          widget.loaded = !widget.loaded;
        }

        if (!widget.isLoadPage && widget.isCrica == false) {
          if (selectedIndex == widget.index) {
            headerColor = Colors.grey.shade100;
          } else {
            headerColor = widget.index % 2 == 0
                ? Colors.grey.shade500
                : Colors.grey.shade600;
          }
        }
      });
    }
  }

  int _numberDivisibleBy4(int i) {
    while (i % 4 != 0) {
      i++;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    return isCrica
        ? !widget.isLoadPage
            ? Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                    child: Text(
                  'Crica',
                  style: TextStyle(fontSize: 20),
                )),
                width: displayWidth(context),
                height: displayHeight(context) * 0.05,
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBlocRowId = widget.id;

                    widget.loaded = !widget.loaded;

                    streamControllerFlightCase.add(null);
                  });
                },
                child: Container(
                  color: widget.loaded ? Colors.red : Colors.grey.shade200,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                      child: Text(
                    'Crica',
                    style: TextStyle(fontSize: 20),
                  )),
                  width: displayWidth(context),
                  height: displayHeight(context) * 0.05,
                ),
              )
        : !widget.isLoadPage
            ? GestureDetector(
                child: Container(
                  width: displayWidth(context),
                  color:
                      headerColor == null ? Colors.grey.shade500 : headerColor,
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'Block Row ${widget.index}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ReorderableWrap(
                        spacing: 4,
                        runSpacing: 4,
                        onReorderStarted: (index) {
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 30),
                            content: BinForFlightCases(
                              list: flightCaseCreateList,
                            ),
                          ));
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          try {
                            setState(() {
                              FlightCase row =
                                  flightCaseCreateList.removeAt(oldIndex);
                              flightCaseCreateList.insert(newIndex, row);
                            });
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          } catch (e) {}
                        },
                        onNoReorder: (index) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          setState(() {});
                        },
                        children: List.generate(
                            flightCaseCreateList.length,
                            (index) => FlightCaseOnList(
                                  blocRowId: widget.id,
                                  flightCaseList: flightCaseCreateList,
                                  flightCase: flightCaseCreateList[index],
                                  index: index + 1,
                                  isLoadPage: widget.isLoadPage,
                                )),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (widget.isLoadPage == false) {
                    setState(() {
                      selectedBlocRowId = widget.id;
                      selectedBlockRowIndex = widget.index;
                      streamControllerBlocRow.add(widget.index);
                    });
                  }
                },
              )
            : GestureDetector(
                onTap: () {
                  if (selectedBlocRowId ==
                      widget.id.split('').reversed.join('')) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }
                },
                child: Container(
                  width: displayWidth(context),
                  color:
                      headerColor == null ? Colors.grey.shade500 : headerColor,
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'Block Row ${widget.index}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: displayWidth(context),
                        height: flightCaseCreateList.length == 0
                            ? 1
                            : flightCaseCreateList.length > 4
                                ? (_numberDivisibleBy4(
                                            flightCaseCreateList.length) /
                                        4) *
                                    displayHeight(context) *
                                    0.14
                                : displayHeight(context) * 0.14,
                        child: GridView.count(
                          crossAxisCount: 4,
                          // controller: _scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          primary: true,
                          children: List.generate(
                              flightCaseCreateList.length,
                              (index) => FlightCaseOnList(
                                    blocRowId: widget.id,
                                    flightCaseList: flightCaseCreateList,
                                    flightCase: flightCaseCreateList[index],
                                    index: index + 1,
                                    isLoadPage: widget.isLoadPage,
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
              );
  }
}

///The DragTarget for the cases that are meant to be erased
class BinForFlightCases extends StatefulWidget {
  final List<FlightCase> list;

  BinForFlightCases({this.list});

  @override
  _BinForFlightCasesState createState() => _BinForFlightCasesState();
}

class _BinForFlightCasesState extends State<BinForFlightCases> {
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, List<int> data, rj) {
        bool _isDeletingCase = false;

        data.isNotEmpty ? _isDeletingCase = true : _isDeletingCase = false;

        return Container(
          color:
              _isDeletingCase == true ? Colors.red : Colors.redAccent.shade100,
          height: 50,
          width: 10,
          child: Icon(
            Icons.delete_forever,
            size: 50,
          ),
        );
      },
      onAccept: (data) {
        try {
          widget.list.removeAt(data);
        } catch (e) {}

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    );
  }
}
