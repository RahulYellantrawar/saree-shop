import 'package:flutter/material.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentPage = 0;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productId =
        ModalRoute.of(context)!.settings.arguments as String?; // is the id
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId ?? '');
    final product = loadedProduct;
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              expandedHeight: size.height * 0.69,
              backgroundColor: bgColor,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: loadedProduct.id,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      right: size.width * 0.025,
                      top: size.width * 0.1,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 18,
                          child: SizedBox(
                            height: size.height * 0.62,
                            child: PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: loadedProduct.images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                  child: Material(
                                    shadowColor: Colors.grey,
                                    elevation: size.width * 0.05,
                                    borderRadius: BorderRadius.circular(size.width * 0.035),
                                    child: GestureDetector(
                                      child: Image.network(
                                        loadedProduct.images[index],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return Material(
                                                color: bgColor,
                                                child: Scaffold(
                                                  appBar: AppBar(
                                                    backgroundColor: bgColor,
                                                    iconTheme: const IconThemeData(
                                                        color: Colors.black),
                                                  ),
                                                  body: Hero(
                                                    tag: 'imageHero',
                                                    child: PageView.builder(
                                                      itemCount: loadedProduct
                                                          .images.length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return PhotoView(
                                                          backgroundDecoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .transparent),
                                                          imageProvider:
                                                              NetworkImage(
                                                            loadedProduct
                                                                .images[index],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.009),
                          child: PageViewDotIndicator(
                            count: loadedProduct.images.length,
                            currentItem: currentPage,
                            unselectedColor: Colors.grey,
                            selectedColor: Colors.blue,
                            unselectedSize: Size(size.width * 0.018, size.width * 0.018),
                            duration: const Duration(milliseconds: 200),
                            size: Size(size.width * 0.022, size.width * 0.022),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                    ),
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loadedProduct.title,
                          style: TextStyle(
                            fontFamily: 'Exo_2',
                            fontSize: size.width * 0.08,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.001,
                        ),
                        Text(
                          '\u{20B9}${(loadedProduct.price)}',
                          style: TextStyle(
                            fontFamily: 'Open_Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.015),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.height * 0.015, vertical: size.width * 0.02),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.grey,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          width: size.width * 0.005,
                        ),
                        borderRadius: BorderRadius.circular(size.width * 0.05),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saree Details:',
                            style: TextStyle(
                              fontSize: size.width * 0.058,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open_Sans',
                            ),
                            textAlign: TextAlign.start,
                            softWrap: true,
                          ),
                          SizedBox(
                            height: size.height * 0.003,
                          ),
                          Text(
                            'Category: ${loadedProduct.category}\n'
                            'Colour: ${loadedProduct.color}\n'
                            'Fabric Type: ${loadedProduct.fabricType}\n'
                            'Saree Style: ${loadedProduct.sareeStyle}\n'
                            'Pattern: ${loadedProduct.pattern}\n'
                            'Blouse Piece: ${loadedProduct.blousePiece}\n'
                            'Saree Length: ${loadedProduct.sareeLength}\n'
                            'Blouse Length: ${loadedProduct.blouseLength}',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontFamily: 'Open_Sans',
                            ),
                            textAlign: TextAlign.start,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(size.width * 0.01),
        child: FloatingActionButton.extended(
          extendedPadding: EdgeInsets.all(size.width * 0.08),
          backgroundColor: Colors.yellowAccent.shade700,
          foregroundColor: Colors.black,
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Added item to cart!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Go to Cart',
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                    // cart.removeSingleItem(product.id);
                  },
                ),
              ),
            );
          },
          label: Text(
            'Add to Cart',
            style: TextStyle(
                fontSize: size.width * 0.065, fontFamily: 'Exo_2', fontWeight: FontWeight.bold),
          ),
          icon: Icon(
            Icons.shopping_cart,
            size: size.width * 0.065,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
