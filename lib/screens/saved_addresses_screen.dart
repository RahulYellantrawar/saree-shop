import 'package:flutter/material.dart';
import 'package:p_sarees/constants/colors.dart';

import '../widgets/saved_address_widget.dart';

class SavedAddresses extends StatelessWidget {
  static const routeName = '/savedAdd';

  const SavedAddresses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Saved Addresses',
          style: TextStyle(
            fontFamily: 'Exo_2',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.start,
        ),
        foregroundColor: Colors.black,
        backgroundColor: bgColor,
      ),
      body: const SavedAddressWidget(),
    );
  }
}
