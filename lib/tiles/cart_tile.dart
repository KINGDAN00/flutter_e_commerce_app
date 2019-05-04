import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/datas/cart_product.dart';
import 'package:flutter_e_commerce/datas/product_data.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';

class CartTile extends StatelessWidget {

  final Firestore firestore = Firestore.instance;

  CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).update();

      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'R\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: cartProduct.hasLessOne() ? Colors.red : Colors.grey[300],
                          ),
                          onPressed: cartProduct.hasLessOne() ? () {
                            CartModel.of(context).lessOne(cartProduct);
                          } : null),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () {CartModel.of(context).plusOne(cartProduct);}),
                      FlatButton(
                          child: Text('REMOVER'),
                          textColor: Colors.blueGrey[500],
                          onPressed: () {
                            CartModel.of(context).removeCartItem(cartProduct);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: firestore
                  .collection(categoriesCollection)
                  .document(cartProduct.category)
                  .collection(productsCollection)
                  .document(cartProduct.productId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cartProduct.productData =
                      ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    alignment: Alignment.center,
                    height: 70.0,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
