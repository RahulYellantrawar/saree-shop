import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:p_sarees/providers/address_provider.dart';
import 'package:p_sarees/providers/auth_provider.dart';
import 'package:p_sarees/providers/cart.dart';
import 'package:p_sarees/providers/orders.dart';
import 'package:p_sarees/providers/products.dart';
import 'package:p_sarees/providers/profile_provider.dart';
import 'package:p_sarees/screens/add_address_screen.dart';
import 'package:p_sarees/screens/bottom_bar.dart';
import 'package:p_sarees/screens/cart_screen.dart';
import 'package:p_sarees/screens/orders_screen.dart';
import 'package:p_sarees/screens/product_detail_screen.dart';
import 'package:p_sarees/screens/profile_settings.dart';
import 'package:p_sarees/screens/register_screen.dart';
import 'package:p_sarees/screens/saved_addresses_screen.dart';
import 'package:p_sarees/screens/search_screen.dart';
import 'package:p_sarees/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: bgColor,
    // statusBarBrightness: Brightness.dark,
  ));
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pochampally Sarees',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isSignedIn) {
              return const BottomBar();
            } else {
              return const WelcomeScreen();
            }
          },
        ),

        routes: {
          BottomBar.routeName: (ctx) => const BottomBar(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          ProfileSettings.routeName: (ctx) => const ProfileSettings(),
          SavedAddresses.routeName: (ctx) => const SavedAddresses(),
          AddAddressScreen.routeName: (ctx) => const AddAddressScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          RegisterScreen.routeName: (ctx) => const RegisterScreen(),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
        },
      ),
    );
  }
}
