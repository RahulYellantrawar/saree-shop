import 'package:flutter/material.dart';

class Address with ChangeNotifier {
  final String id;
  final String fullName;
  final String phone;
  final String altPhone;
  final String pincode;
  final String state;
  final String city;
  final String houseNo;
  final String roadName;

  Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.altPhone,
    required this.pincode,
    required this.state,
    required this.city,
    required this.houseNo,
    required this.roadName,
  });
}
