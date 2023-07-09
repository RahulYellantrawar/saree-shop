import 'package:flutter/material.dart';
import 'package:p_sarees/screens/favourites_screen.dart';
import 'package:p_sarees/screens/home_screen.dart';
import 'package:p_sarees/screens/myAccount_screen.dart';

import 'orders_screen.dart';

class BottomBar extends StatefulWidget {
  static const routeName = '/bottom';

  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int pageIndex = 0;

  final List _tabList = [
    const HomeScreen(),
    Favourites(),
    OrdersScreen(),
    const MyAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabList[pageIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          backgroundColor: Colors.black,
          currentIndex: pageIndex,
          onTap: (int index) {
            setState(() {
              pageIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites',),
            BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'My Orders',),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account',),
          ],
        ),
      ),
    );
  }
}
