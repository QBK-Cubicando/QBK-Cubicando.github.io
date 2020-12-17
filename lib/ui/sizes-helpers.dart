import 'package:flutter/cupertino.dart';

Size displaySize(BuildContext context) {
  // debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  // debugPrint('Height = ' + displaySize(context).height.toString());
  double height = displaySize(context).height;

  if (height > 800) {
    height = 800;
    return height;
  }
  if (height < 500) {
    height = 500;
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
  if (width < 400) {
    width = 400;
    return width;
  }
  return width;
}
