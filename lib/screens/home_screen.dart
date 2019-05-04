import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/tabs/categories_tab.dart';
import 'package:flutter_e_commerce/tabs/home_tab.dart';
import 'package:flutter_e_commerce/tabs/orders_tab.dart';
import 'package:flutter_e_commerce/tabs/places_tab.dart';
import 'package:flutter_e_commerce/widgets/cart_button.dart';
import 'package:flutter_e_commerce/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Categorias',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: CategoriesTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Lojas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: CustomDrawer(_pageController),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Meus pedidos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: CustomDrawer(_pageController),
          body: OrdersTab(),
        ),
      ],
    );
  }
}
