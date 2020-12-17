import 'package:flutter/material.dart';

///Documentated
class UserData {
  final String uid;
  final String name;
  final DateTime dateOfBirth;
  final String city;
  final String phone;
  final String speciality;
  final Image profileImage;
  final String email;

  UserData(
      {this.uid,
      this.name,
      this.dateOfBirth,
      this.city,
      this.phone,
      this.speciality,
      this.profileImage,
      this.email});
}
