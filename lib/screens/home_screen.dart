import 'dart:async';

import 'package:flutter/material.dart';
import 'package:p_sarees/screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/products.dart';
import '../widgets/cart_button.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    super.initState();
    // _fetchProducts();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragCancel: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: SafeArea(
                  child: Container(
                    height: screenHeight,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pochampally\nSarees',
                              style: TextStyle(
                                fontFamily: 'Exo_2',
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.06,
                                  width: screenWidth * 0.75,
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Search'),
                                            Icon(Icons.search),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        SearchScreen.routeName,
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications,
                                    size: 30,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ProductsGrid(_showOnlyFavorites, ''),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
          child: const CartButton(),
        ),
      ),
    );
  }
}
