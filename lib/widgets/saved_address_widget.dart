import 'package:flutter/material.dart';
import 'package:p_sarees/providers/address_provider.dart';
import 'package:provider/provider.dart';

import '../screens/add_address_screen.dart';

enum MoreOptions {
  edit,
  delete,
}

class SavedAddressWidget extends StatefulWidget {
  const SavedAddressWidget({
    super.key,
  });

  @override
  State<SavedAddressWidget> createState() => _SavedAddressWidgetState();
}

class _SavedAddressWidgetState extends State<SavedAddressWidget> {
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
      });
      Provider.of<AddressProvider>(context).fetchAndSetAddress().then((_) {
        setState(() {
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    final addressData = Provider.of<AddressProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.white,
          child: InkWell(
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AddAddressScreen.routeName);
              },
              icon: const Icon(
                Icons.add,
                size: 25,
              ),
              label: const Text(
                'Add a new address',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Saved Addresses'),
        ),
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: addressData.items.length,
            itemBuilder: (_, i) => Stack(
              children: [
                Card(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        addressData.items[i].fullName,
                        style: const TextStyle(fontWeight: FontWeight.w200),
                      ),
                    ),
                    subtitle: Text(
                      '${addressData.items[i].houseNo}, '
                      '${addressData.items[i].roadName}, '
                      '${addressData.items[i].city}, '
                      '${addressData.items[i].state}, '
                      '${addressData.items[i].pincode}.\n'
                      'Mobile no: ${addressData.items[i].phone}',
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: MoreOptions.edit,
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: MoreOptions.delete,
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (MoreOptions selectedValue) async {
                      setState(() {
                        if (selectedValue == MoreOptions.edit) {
                          Navigator.of(context).pushNamed(
                              AddAddressScreen.routeName,
                              arguments: addressData.items[i].id);
                        } else {
                          try {
                            Provider.of<AddressProvider>(context, listen: false)
                                .deleteAddress(addressData.items[i].id);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Deleting Failed', textAlign: TextAlign.center,),
                              ),
                            );
                          }
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
