import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  late String pImage;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.pImage = '',
  });
}
