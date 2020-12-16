import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/user.dart';

import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/models/load.dart';
import 'package:qbk_simple_app/utilities/loading_widget.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class PopupLoadsOfGig extends StatelessWidget {
  final String uidGig;
  final bool isCopyPage;
  final String uidThisGig;

  /// JUST FOR COPY LOAD SCREEN

  PopupLoadsOfGig({this.uidGig, this.isCopyPage, this.uidThisGig});

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<Load>>(
        stream: DatabaseService(userUid: user.uid, uidGig: uidGig).loadListData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            List<Load> loadList = snapshot.data;

            Widget _loadListIsEmpty() {
              if (loadList.length != 0) {
                return LoadList(
                  uidGig: uidGig,
                  isCopyPage: isCopyPage,
                  uidThisGig: uidThisGig,
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Text(
                          'No Loads added yet !',
                          style:
                              kTextStyle(context).copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }

            return AlertDialog(
              content: Container(
                padding: EdgeInsets.all(8),
                height: 100.0,
                width: 370.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: _loadListIsEmpty(),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
