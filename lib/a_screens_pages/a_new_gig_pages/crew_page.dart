// TODO: Document and check for optimization

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbk_simple_app/models/user.dart';
import 'package:qbk_simple_app/services/database.dart';

import 'package:qbk_simple_app/ab_created_widgets/text_field-widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/upper_bar_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_button_widget.dart';
import 'package:qbk_simple_app/ab_created_widgets/a_buttons/selection_menu_button.dart';

import 'package:qbk_simple_app/models/new_crew_member.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

//TODO: fix arrow back from phone not to erase everything

//TODO: problem with permission dropdown, not reset

class CrewQBK extends StatefulWidget {
  static const String id = 'crew_page';

  CrewQBK({this.uidGig});

  final String uidGig;

  @override
  CrewQBKState createState() => CrewQBKState();
}

String selectedPermission = 'Please Select Permission';

class CrewQBKState extends State<CrewQBK> {
  final _formKey = GlobalKey<FormState>();

  int indexOfParticipant;
  TextEditingController _controller = TextEditingController();

  List<String> permissions = ['Please Select Permission', 'Admin', 'Just Read'];

  void _reset() {
    if (selectedPermission != 'Please Select Permission') {
      _controller.clear();
    }
    selectedPermission = 'Please Select Permission';
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return StreamBuilder<List<NewCrewMember>>(
        stream: DatabaseService(userUid: user.uid, uidGig: widget.uidGig)
            .gigCrewMemberList,
        builder: (context, snapshot) {
          return UpperBar(
            text: 'Crew',
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25),
                      width: displayWidth(context) * 0.85,
                      height: displayHeight(context) * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedPermission,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedPermission = newValue;
                          });
                        },
                        items: permissions.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == 'Please Select Permission'
                                ? 'Please Select Permission'
                                : null,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
//TODO: When you select the participant it will show your contacts (you must sync your contacts), and if not you search by name
                    TextFieldQBK(
                      validator: (value) => value.isEmpty ? 'Enter name' : null,
                      controller: _controller,
                      hintText: 'Name',
                      maxLines: 1,
                    ), //Name of the participant
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SelectionMenuButton(
                          text: 'Add Roadie',
                          onPress: () {
                            setState(() async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  await DatabaseService(
                                    userUid: user.uid,
                                    uidGig: widget.uidGig,
                                  ).gigSetCrewData(
                                    nameCrew: _controller
                                        .text, //TODO: use persons email or uid
                                    permission: selectedPermission,
                                    index: indexOfParticipant,
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                              _reset();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
//TODO: Do a scrollable page to the right so you can see all your participants and your participants
                    Container(
                        padding: EdgeInsets.all(8),
                        width: displayWidth(context) * 0.85,
                        height: displayHeight(context) * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
//TODO: Create a list which shows all the loads in the Gig
                        child: CrewMembersList(
                          uidGig: widget.uidGig,
                        )), //Where all the participants go
                    SizedBox(
                      height: 15,
                    ),
                    SelectionButton(
                      text: 'I\'ve got my Crew',
                      width: displayWidth(context) * 0.85,
                      color: Colors.green,
                      onPress: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
