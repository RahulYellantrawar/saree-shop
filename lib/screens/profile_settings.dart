import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:p_sarees/providers/profile.dart';
import 'package:p_sarees/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileSettings extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  final _form = GlobalKey<FormState>();

  var _editedProfile = Profile(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    pImage: '',
  );

  var _initValues = {
    'firstName': '',
    'lastName': '',
    'email': '',
  };

  @override
  void initState() {
    super.initState();
  }

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final profileId = ModalRoute.of(context)!.settings.arguments?.toString();
      if (profileId != null) {
        _editedProfile = Provider.of<ProfileProvider>(context, listen: false)
            .findById(profileId);
        _initValues = {
          'firstName': _editedProfile.firstName,
          'lastName': _editedProfile.lastName,
          'email': _editedProfile.email,
        };
        _loadImages();
      }
      _firstNameController =
          TextEditingController(text: _initValues['firstName']);
      _lastNameController =
          TextEditingController(text: _initValues['lastName']);
      _emailController = TextEditingController(text: _initValues['email']);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _loadImages() {
    _pickedImage = XFile(_editedProfile.pImage);
  }

  void _saveForm() async {
    _editedProfile = Profile(
      id: _editedProfile.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      pImage: _editedProfile.pImage,
    );
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _form.currentState?.save();

    if (_pickedImage != null) {
      await _saveImage();
    }
    try {
      if (_editedProfile.id.isNotEmpty) {
        await Provider.of<ProfileProvider>(context, listen: false)
            .updateProfile(_editedProfile.id, _editedProfile);
      } else {
        await Provider.of<ProfileProvider>(context, listen: false)
            .addProfile(_editedProfile);
      }
    } catch (error) {
      rethrow;
    }
  }

  final ImagePicker imagePicker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<void> _saveImage() async {
    final String imageId = const Uuid().v4().toString();
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$imageId.jpg');

    if (_pickedImage != null) {
      final UploadTask uploadTask =
          storageRef.putFile(File(_pickedImage!.path));
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      try {
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();
        _editedProfile.pImage = imageUrl;
      } catch (error) {
        return;
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Exo_2',
            fontWeight: FontWeight.bold,
            fontSize: 35,
            // color: Colors.black
          ),
        ),
        foregroundColor: Colors.black,
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pickedImage != null
                        ? Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              image: _pickedImage == null ? DecorationImage(
                                  image: NetworkImage(_pickedImage!.path),
                                  fit: BoxFit.fitHeight) : DecorationImage(
                                  image: FileImage(File(_pickedImage!.path)),
                                  fit: BoxFit.fitHeight),
                            ),
                          )
                        : Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/profile_img.png'),
                                  fit: BoxFit.fitHeight),
                            ),
                          ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Select Photo'),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: Text('First Name (Required)*'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the First Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: Text('Last Name (Required)*'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Last Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text('Email ID (Optional)'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: const Text('Save'),
                      ),
                    ],
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
