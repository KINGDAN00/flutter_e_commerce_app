import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/datas/cart_product.dart';
import 'package:flutter_e_commerce/datas/product_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:flutter_e_commerce/screens/cart_screen.dart';
import 'package:flutter_e_commerce/screens/login_screen.dart';

class ProductsScreen extends StatefulWidget {
  final ProductData _product;

  ProductsScreen(this._product);

  @override
  _ProductsScreenState createState() => _ProductsScreenState(_product);
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductData _product;

  String selectedSize;

  _ProductsScreenState(this._product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColorDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _product.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: _product.images.map((url) => NetworkImage(url)).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Color.fromRGBO(
                  primaryColor.red, primaryColor.green, primaryColor.blue, 0.5),
              dotColor: Colors.white,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _product.title,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'R\$ ${_product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 40.0,
                        child: GridView(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.5,
                          ),
                          children: _product.sizes.map((size) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize == size
                                      ? selectedSize = null
                                      : selectedSize = size;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                    width: 3.0,
                                    color: size == selectedSize
                                        ? primaryColor
                                        : Colors.blueGrey[200],
                                  ),
                                ),
                                width: 50.0,
                                alignment: Alignment.center,
                                child: Text(
                                  size,
                                  style: TextStyle(
                                      color: size == selectedSize
                                          ? primaryColor
                                          : Colors.blueGrey[200]),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: selectedSize != null
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct cartProduct = CartProduct(
                                  selectedSize,
                                  1,
                                  _product.id,
                                  _product.category,
                                  _product);

                              CartModel.of(context).addCartItem(cartProduct);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? 'ADICIONAR AO CARRINHO'
                          : 'FAÇA LOGIN PAR CONTINUAR',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _product.description,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
