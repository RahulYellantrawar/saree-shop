import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'address.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _items = [
    Address(
      id: 'a1',
      fullName: 'Rahul',
      phone: '1234567890',
      altPhone: '987456123',
      pincode: '504123',
      state: 'Hyderabad',
      city: 'Delhi',
      houseNo: '7-8/23',
      roadName: 'Ring road',
    )
  ];

  List<Address> get items {
    return [..._items];
  }

  Address findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addAddress(Address address) async {
    const url =
        'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/address.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'fullName': address.fullName,
          'phone': address.phone,
          'altPhone': address.altPhone,
          'pinCode': address.pincode,
          'state': address.state,
          'city': address.city,
          'houseNo': address.houseNo,
          'roadName': address.roadName,
        }),
      );
      final newAddress = Address(
        id: json.decode(response.body)['name'].toString(),
        fullName: address.fullName,
        phone: address.phone,
        altPhone: address.altPhone,
        pincode: address.pincode,
        state: address.state,
        city: address.city,
        houseNo: address.houseNo,
        roadName: address.roadName,
      );
      _items.insert(0, newAddress);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateAddress(String id, Address newAddress) async {
    final addressIndex = _items.indexWhere((add) => add.id == id);
    if (addressIndex >= 0) {
      final url =
          'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/address/$id.json';

      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'fullName': newAddress.fullName,
          'phone': newAddress.phone,
          'altPhone': newAddress.altPhone,
          'pinCode': newAddress.pincode,
          'state': newAddress.state,
          'city': newAddress.city,
          'houseNo': newAddress.houseNo,
          'roadName': newAddress.roadName,
        }),
      );
      final updatedAddress = Address(
        id: newAddress.id,
        fullName: newAddress.fullName,
        phone: newAddress.phone,
        altPhone: newAddress.altPhone,
        pincode: newAddress.pincode,
        state: newAddress.state,
        city: newAddress.city,
        houseNo: newAddress.houseNo,
        roadName: newAddress.roadName,
      );
      _items[addressIndex] = updatedAddress;
      notifyListeners();
    }
  }


  Future<void> fetchAndSetAddress([bool filterByUser = false]) async {
    var url =
        'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/address.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Address> loadedAddress = [];
      extractedData.forEach((addId, addData) {
        loadedAddress.insert(
          0,
          Address(
            id: addId,
            fullName: addData['fullName'],
            phone: addData['phone'],
            altPhone: addData['altPhone'],
            pincode: addData['pinCode'],
            state: addData['state'],
            city: addData['city'],
            houseNo: addData['houseNo'],
            roadName: addData['roadName'],
          ),
        );
      });
      _items = loadedAddress;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    final url = 'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/address/$id.json';
    final existingAddressIndex = _items.indexWhere((add) => add.id == id);
    Address? existingAddress = _items[existingAddressIndex];
    _items.removeAt(existingAddressIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if(response.statusCode >= 400) {
      _items.insert(existingAddressIndex, existingAddress);
      notifyListeners();
    }
  }
}
