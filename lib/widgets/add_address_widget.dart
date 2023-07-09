import 'package:flutter/material.dart';
import 'package:p_sarees/providers/address.dart';
import 'package:p_sarees/providers/address_provider.dart';
import 'package:provider/provider.dart';

class AddAddressWidget extends StatefulWidget {
  const AddAddressWidget({
    super.key,
  });

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _pincodeController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _houseNoController;
  late TextEditingController _roadNameController;
  final _form = GlobalKey<FormState>();

  var _editedAddress = Address(
    id: '',
    fullName: '',
    phone: '',
    altPhone: '',
    pincode: '',
    state: '',
    city: '',
    houseNo: '',
    roadName: '',
  );

  var _inItValues = {
    'fullName': '',
    'phone': '',
    'altPhone': '',
    'pinCode': '',
    'state': '',
    'city': '',
    'houseNo': '',
    'roadName': '',
  };

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final addressId = ModalRoute.of(context)!.settings.arguments?.toString();
      if (addressId != null) {
        _editedAddress = Provider.of<AddressProvider>(context, listen: false).findById(addressId);
        _inItValues = {
          'fullName': _editedAddress.fullName,
          'phone': _editedAddress.phone,
          'altPhone': _editedAddress.altPhone,
          'pinCode': _editedAddress.pincode,
          'state': _editedAddress.state,
          'city': _editedAddress.city,
          'houseNo': _editedAddress.houseNo,
          'roadName': _editedAddress.roadName,
        };
      }
      _fullNameController = TextEditingController(text: _inItValues['fullName']);
      _phoneController = TextEditingController(text: _inItValues['phone']);
      _altPhoneController = TextEditingController(text: _inItValues['altPhone']);
      _pincodeController = TextEditingController(text: _inItValues['pinCode']);
      _stateController = TextEditingController(text: _inItValues['state']);
      _cityController = TextEditingController(text: _inItValues['city']);
      _houseNoController = TextEditingController(text: _inItValues['houseNo']);
      _roadNameController = TextEditingController(text: _inItValues['roadName']);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _houseNoController.dispose();
    _roadNameController.dispose();
    super.dispose();
  }

  void _saveForm() async{
    _editedAddress = Address(
      id: _editedAddress.id,
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      altPhone: _altPhoneController.text,
      pincode: _pincodeController.text,
      state: _stateController.text,
      city: _cityController.text,
      houseNo: _houseNoController.text,
      roadName: _roadNameController.text,
    );

    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _form.currentState?.save();
    setState(() {
    });

    if (_editedAddress.id != '') {
      await Provider.of<AddressProvider>(context, listen: false).updateAddress(_editedAddress.id, _editedAddress);
    } else {
      try {
        await Provider.of<AddressProvider>(context, listen: false).addAddress(_editedAddress);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: const Text('An error occured!'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                    const Text('Okay'),
                  ),
                ],
              ),
        );
      }
    }
    setState(() {
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add address',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Full Name (Required)*'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Full Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    label: Text('Phone Number (Required)*'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Add Alternative Phone Number (Optional)',
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _altPhoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    label: Text('Alternate Phone Number'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: TextFormField(
                        controller: _pincodeController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          label: Text('Pincode (Required)*'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Pincode';
                          }
                          if (value.length < 6 || value.length < 6) {
                            return 'Please enter the Correct Pincode';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      fit: FlexFit.loose,
                      child: TextFormField(
                        controller: _stateController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: Text('State (Required)*'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your State';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: TextFormField(
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('City (Required)*'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the City';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _houseNoController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('House No, Building Name (Required)*'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the House No, Building Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _roadNameController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Road name, Area, Colony (Required)*'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Road name, Area, Colony';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Save Address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
