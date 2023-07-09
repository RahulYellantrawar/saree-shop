import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:p_sarees/providers/auth_provider.dart';
import 'package:p_sarees/providers/profile_provider.dart';
import 'package:p_sarees/screens/profile_settings.dart';
import 'package:p_sarees/screens/saved_addresses_screen.dart';
import 'package:p_sarees/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../providers/profile.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  Profile? initialProfile;

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
      Provider.of<ProfileProvider>(context).fetchAndSetProfile().then((_) {
        setState(() {
        });
      });
    }_isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'My Account',
                style: TextStyle(
                  fontFamily: 'Exo_2',
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    image: profile.items.isNotEmpty ? DecorationImage(
                      image: NetworkImage(profile.items[0].pImage),
                      fit: BoxFit.fitHeight,
                    ) : const DecorationImage(
                      image: AssetImage('assets/images/profile_img.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Text(
                  profile.items.isNotEmpty ? '${profile.items[0].firstName} ${profile.items[0].lastName}' : 'User Name' ,
                  style: const TextStyle(
                    fontFamily: 'Open_Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            AccountCardList(
              leadingIcon: CupertinoIcons.profile_circled,
              title: 'Profile Settings',
              trailingIcon: Icons.chevron_right,
              onTap: () {
                if (profile.items.isNotEmpty) {
                  Navigator.of(context).pushNamed(ProfileSettings.routeName, arguments: profile.items[0].id);
                } else {
                  Navigator.of(context).pushNamed(ProfileSettings.routeName,);
                }
              },
            ),
            AccountCardList(
              leadingIcon: Icons.location_on_sharp,
              title: 'Saved Addresses',
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.of(context).pushNamed(SavedAddresses.routeName);
              },
            ),
            AccountCardList(
              leadingIcon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
                Provider.of<AuthProvider>(context, listen: false).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccountCardList extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  const AccountCardList({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.trailingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: ListTile(
                visualDensity: VisualDensity.standard,
                leading: Icon(leadingIcon),
                title: Text(title),
                trailing: Icon(trailingIcon),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
