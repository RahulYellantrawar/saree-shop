import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:p_sarees/providers/profile.dart';

class ProfileProvider with ChangeNotifier {
  List<Profile> _items = [];

  List<Profile> get items {
    return [..._items];
  }

  Profile findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProfile(Profile profile) async {
    const url =
        'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/profile.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'firstName': profile.firstName,
          'lastName': profile.lastName,
          'email': profile.email,
          'pImage': profile.pImage,
        }),
      );
      final newProfile = Profile(
        id: json.decode(response.body)['name'].toString(),
        firstName: profile.firstName,
        lastName: profile.lastName,
        email: profile.email,
        pImage: profile.pImage,
      );
      _items.insert(0, newProfile);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfile(String id, Profile newProfile) async {
    final profIndex = _items.indexWhere((prof) => prof.id == id);
    if (profIndex >= 0) {
      final url =
          'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/profile/$id.json';
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'firstName': newProfile.firstName,
          'lastName': newProfile.lastName,
          'email': newProfile.email,
          'pImage': newProfile.pImage,
        }),
      );
      final updatedProfile = Profile(
        id: newProfile.id,
        firstName: newProfile.firstName,
        lastName: newProfile.lastName,
        email: newProfile.email,
        pImage: newProfile.pImage,
      );

      _items[profIndex] = updatedProfile;
      notifyListeners();
    }
  }

  bool _isInitialized = false;

  Future<void> fetchAndSetProfile([bool filterByUser = false]) async {
    if (!_isInitialized) {
      var url =
          'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/profile.json';
      try {
        final response = await http.get(Uri.parse(url));
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>?;
        print(extractedData);
        if (extractedData == null) {
          return;
        }
        final List<Profile> loadedProfile = [];
        extractedData.forEach((profId, profData) {
          loadedProfile.insert(
            0,
            Profile(
              id: profId,
              firstName: profData['firstName'],
              lastName: profData['lastName'],
              email: profData['email'],
              pImage: profData['pImage'],
            ),
          );
        });
        _items = loadedProfile;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
    _isInitialized = true;
  }
}
