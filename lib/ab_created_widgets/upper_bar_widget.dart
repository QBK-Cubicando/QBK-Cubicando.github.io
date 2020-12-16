import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

///Documentated
class UpperBar extends StatelessWidget {
  UpperBar({@required this.text, @required this.body, this.onBackGoTo});

  final String text;
  final Widget body;
  final Widget onBackGoTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // leadingWidth: displayWidth(context),
        centerTitle: true,
        automaticallyImplyLeading: false,
//TODO: Make a Nice arrow
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (onBackGoTo != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return onBackGoTo;
              }));
            } else {
              Navigator.pop(context);
            }
          },
        ),

//TODO: Fix the space before the text
        titleSpacing: 30.0,
        title: Text(
          text,
          style: kTitleTextStile(context),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Container(
        child: body,
        color: Colors.black,
      ),
    );
  }
}
