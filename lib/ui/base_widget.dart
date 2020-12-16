// import 'package:flutter/material.dart';
// import 'package:qbk_simple_app/ui/sizing_information.dart';
// import 'package:qbk_simple_app/ui/ui_utils.dart';
//
// class BaseWidget extends StatelessWidget {
//   final Widget Function(
//       BuildContext context, SizingInformation sizingInformation) builder;
//
//   const BaseWidget({Key key, this.builder}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//
//     return LayoutBuilder(builder: (context, boxConstraints) {
//       var sizingInformation = SizingInformation(
//           orientation: mediaQuery.orientation,
//           deviceScreenType: getDeviceType(mediaQuery),
//           screenSize: mediaQuery.size,
//           localWidgetSize:
//               Size(boxConstraints.maxWidth, boxConstraints.maxHeight));
//
//       return builder(context, sizingInformation);
//     });
//   }
// }
