import 'package:flutter/material.dart';
import 'package:p_sarees/constants/colors.dart';

import '../widgets/add_address_widget.dart';

class AddAddressScreen extends StatelessWidget {
  static const routeName = '/addAddress';

  const AddAddressScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: bgColor,
        title: const Text('Add Address', style: TextStyle(
          fontFamily: 'Exo_2',
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),),
      ),
      body: const AddAddressWidget(),
    );
  }
}