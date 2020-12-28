import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/a_screens_pages/a_new_gig_pages/create_load_page.dart';
import 'package:qbk_simple_app/a_screens_pages/load_screen.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

import 'package:qbk_simple_app/utilities/constants.dart';

import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';

///Documentated
class Load {
  final String uidLoad;
  final String nameLoad;
  final int index;

  Load({this.uidLoad, this.nameLoad, this.index});
}

//TODO:CHECK IS YOU CAN DELETE IN THE PAGE OR NOT

class LoadOnList extends StatelessWidget {
  final String userUid;
  final String uidGig;
  final String nameLoad;
  final Load loadOnList;
  final bool isCopyPage;
  final String uidThisGig;
  final String permission;
  final int index;

  /// JUST FOR COPY LOAD SCREEN
  LoadOnList(
      {this.userUid,
      this.uidGig,
      this.nameLoad,
      this.loadOnList,
      this.isCopyPage,
      this.uidThisGig,
      this.permission,
      this.index});

  @override
  Widget build(BuildContext context) {
    ///Delete a load from Firebase
    void _deleteLoad() {
      DatabaseService(
              userUid: userUid, uidGig: uidGig, uidLoad: loadOnList.uidLoad)
          .deleteLoad();
    }

    return isCopyPage == false
        ?

        ///Load NO CopyPage
        GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoadPage(
                  userUid: userUid,
                  uidGig: uidGig,
                  uidLoad: loadOnList.uidLoad,
                  permission: permission,
                  index: index,
                );
              }));
            },
            onLongPress: () {
              if (permission == 'Admin') {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                            child: Text(
                          'Are you sure you want to delete ${loadOnList.nameLoad}?',
                          style:
                              kTextStyle(context).copyWith(color: Colors.black),
                        )),
                        actions: <Widget>[
                          SelectionButton(
                            text: 'Cancel',
                            color: Colors.blueAccent,
                            onPress: () => Navigator.pop(context),
                          ),
                          SelectionButton(
                              text: 'Edit',
                              color: Colors.orangeAccent,
                              onPress: () async {
                                await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CreateLoadPage(
                                    uidGig: uidGig,
                                    uidLoad: loadOnList.uidLoad,
                                    nameGig: 'Edit Load',
                                    nameLoad: loadOnList.nameLoad,
                                  );
                                }));
                                Navigator.pop(context);
                              }),
                          SelectionButton(
                            text: 'Delete',
                            color: Colors.redAccent,
                            onPress: () {
                              Navigator.pop(context);
                              _deleteLoad();
                            },
                          ),
                        ],
                      );
                    });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 4),
                  content: Text(
                    'Only Admin Crew can Edit the Gig',
                    style: kTextStyle(context)
                        .copyWith(color: Colors.redAccent.shade100),
                  ),
                ));
              }
            },
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade400,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.directions_bus,
                      size: displayWidth(context) * 0.07,
                    ),
                    Card(
                      color: Colors.orangeAccent,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          loadOnList.nameLoad,
                          style:
                              TextStyle(fontSize: displayWidth(context) * 0.04),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        :

        ///Load CopyPage
        GestureDetector(
            //TODO: Activate AlertDialogCopyLoad
            // onTap: () {
            //   showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialogCopyLoad(
            //           uidCopiedGig: uidGig,
            //           uidCopiedLoad: loadOnList.uidLoad,
            //           uidThisGig: uidThisGig,
            //         );
            //       });
            // },
            child: Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade400,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.train,
                    size: 40.0,
                  ),
                  Card(
                    color: Colors.orangeAccent,
                    child: Text(
                      loadOnList.nameLoad,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class LoadList extends StatefulWidget {
  final String uidGig;
  final String nameLoad;
  final bool isCopyPage;
  final String uidThisGig;
  final String permission;
  final int index;

  LoadList(
      {this.uidGig,
      this.nameLoad,
      this.isCopyPage,
      this.uidThisGig,
      this.permission,
      this.index});

  @override
  _LoadListState createState() => _LoadListState();
}

class _LoadListState extends State<LoadList> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<Load>>(
        stream: DatabaseService(userUid: user.uid, uidGig: widget.uidGig)
            .loadListData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            List<Load> loadList = snapshot.data;

            return GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: loadList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return LoadOnList(
                    loadOnList: loadList[index],
                    userUid: user.uid,
                    uidGig: widget.uidGig,
                    nameLoad: widget.nameLoad,
                    isCopyPage: widget.isCopyPage,
                    uidThisGig: widget.uidThisGig,
                    permission: widget.permission,
                    index: widget.index,
                  );
                });
          } else {
            return Loading(
              size: displayHeight(context) * 0.09,
            );
          }
        });
  }
}
