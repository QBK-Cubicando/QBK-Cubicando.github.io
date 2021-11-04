import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';

class TopQBK extends StatelessWidget {
  final nav;
  const TopQBK({Key key, this.nav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 100,
            height: 50,
            child: Image.asset('images/letras_qbk.png'),
          ),
        ),
        GestureDetector(
          onTap: () {
            nav != null
                ? Navigator.pushNamed(context, nav)
                : Navigator.pop(context);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: displayWidth(context) * 0.12,
              height: displayHeight(context) * 0.07,
              color: kyellowQBK,
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
      ],
    );
  }
}
