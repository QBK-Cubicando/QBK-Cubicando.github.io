import 'package:flutter/cupertino.dart';

Size displaySize(BuildContext context) {
  // debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  // debugPrint('Height = ' + displaySize(context).height.toString());
  double height = displaySize(context).height;

  if (height > 600) {
    height = 600;
    return height;
  }
  if (height < 350) {
    height = 350;
    return height;
  }

  return height;
}

double displayWidth(BuildContext context) {
  // debugPrint('Width = ' + displaySize(context).width.toString());
  double width = displaySize(context).width;

  if (width > 600) {
    width = 600;
    return width;
  }
  if (width < 350) {
    width = 350;
    return width;
  }
  return width;
}
