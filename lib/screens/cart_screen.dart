import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:flutter_e_commerce/screens/login_screen.dart';
import 'package:flutter_e_commerce/screens/order_confirmed_screen.dart';
import 'package:flutter_e_commerce/tiles/cart_tile.dart';
import 'package:flutter_e_commerce/widgets/badge_icon.dart';
import 'package:flutter_e_commerce/widgets/cart_resume.dart';
import 'package:flutter_e_commerce/widgets/discount_card.dart';
import 'package:flutter_e_commerce/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                return BadgeIcon();
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn())
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (UserModel.of(context).isNotLoggedIn())
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'FAÇA O LOGIN PARA CONTINUAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColorDark,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  ),
                ],
              ),
            );
          else if (model.products == null || model.isEmpty())
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'CARRINHO VAZIO!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          else
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCard(),
// TODO NÃO ESTÁ FUNCIONANDO O CALCULO DE FRETE
                ShipCard(),
                CartResume(() async {
                  String orderId = await model.finishOrder();

                  if (orderId != null)
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrderConfirmedScreen(orderId)));
                }),
              ],
            );
        },
      ),
    );
  }
}
