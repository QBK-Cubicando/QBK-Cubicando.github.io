import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';
import 'package:qbk_simple_app/utilities/constants.dart';
import 'package:responsive_builder/responsive_builder.dart';

///Docunmentated
class TextFieldQBK extends StatelessWidget {
  TextFieldQBK(
      {this.icon,
      this.hintText,
      this.maxLines,
      this.controller,
      this.onChanged,
      this.validator,
      this.maxLength,
      this.obscureText,
      this.keyboardType,
      this.initialValue});

  final String initialValue;
  final keyboardType;
  final bool obscureText;
  final int maxLength;
  final TextEditingController controller;
  final int maxLines;
  final String hintText;
  final IconData icon;
  final Function onChanged;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displayWidth(context) * 0.85,
      height: displayHeight(context) * 0.12,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType == null ? TextInputType.text : keyboardType,
        obscureText: obscureText == true ? obscureText : false,
        maxLength: maxLength,
        controller: controller,
        maxLines: maxLines == null ? 1 : maxLines,
        textAlignVertical: TextAlignVertical.top,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        style: kTextStyle(context).copyWith(
            color: Colors.black, fontSize: displayWidth(context) * 0.045),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          filled: true,
          fillColor: Colors.grey.shade300,
          hintText: this.hintText,
          prefixIcon: Icon(
            this.icon,
            size: displayWidth(context) * 0.04,
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

// class TextFormFieldChild extends StatelessWidget {
//   const TextFormFieldChild({
//     Key key,
//     @required this.width,
//     @required this.height,
//     @required this.initialValue,
//     @required this.keyboardType,
//     @required this.obscureText,
//     @required this.maxLength,
//     @required this.controller,
//     @required this.maxLines,
//     @required this.hintText,
//     @required this.icon,
//     @required this.onChanged,
//     @required this.validator,
//   }) : super(key: key);
//
//   final double width;
//   final double height;
//   final String initialValue;
//   final keyboardType;
//   final bool obscureText;
//   final int maxLength;
//   final TextEditingController controller;
//   final int maxLines;
//   final String hintText;
//   final IconData icon;
//   final Function onChanged;
//   final String Function(String) validator;
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }

// return ResponsiveBuilder(
// builder: (context, sizingInformation) {
// double height = sizingInformation.screenSize.height;
// double width = sizingInformation.screenSize.width;
// // Check the sizing information here and return your UI
// if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
// return TextFormFieldChild(
// width: 500,
// initialValue: initialValue,
// keyboardType: keyboardType,
// obscureText: obscureText,
// maxLength: maxLength,
// controller: controller,
// maxLines: maxLines,
// hintText: hintText,
// icon: icon,
// onChanged: onChanged,
// validator: validator);
// }
//
// if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
// return TextFormFieldChild(
// width: width * 0.85,
// initialValue: initialValue,
// keyboardType: keyboardType,
// obscureText: obscureText,
// maxLength: maxLength,
// controller: controller,
// maxLines: maxLines,
// hintText: hintText,
// icon: icon,
// onChanged: onChanged,
// validator: validator);
// }
//
// if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
// return TextFormFieldChild(
// width: width,
// initialValue: initialValue,
// keyboardType: keyboardType,
// obscureText: obscureText,
// maxLength: maxLength,
// controller: controller,
// maxLines: maxLines,
// hintText: hintText,
// icon: icon,
// onChanged: onChanged,
// validator: validator);
// }
//
// return TextFormFieldChild(
// width: width * 0.85,
// initialValue: initialValue,
// keyboardType: keyboardType,
// obscureText: obscureText,
// maxLength: maxLength,
// controller: controller,
// maxLines: maxLines,
// hintText: hintText,
// icon: icon,
// onChanged: onChanged,
// validator: validator);
// ;
// },
// );
