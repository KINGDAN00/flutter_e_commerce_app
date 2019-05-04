import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';

class DiscountCard extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto'.toUpperCase(),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(
          Icons.card_giftcard,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Theme.of(context).primaryColor,
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.go,
              textCapitalization: TextCapitalization.characters,
              initialValue: CartModel.of(context).couponCode ?? '',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Informe o cupom',
              ),
              onFieldSubmitted: (text) {
                firestore
                    .collection(couponsCollection)
                    .document(text)
                    .get()
                    .then((doc) {
                  bool exists = doc.data != null;

                  exists
                      ? CartModel.of(context)
                          .applyCoupon(text, doc.data[couponPercent])
                      : CartModel.of(context).removeCoupon();

                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(
                        seconds: 5,
                      ),
                      backgroundColor: exists ? Colors.green : Colors.red,
                      content: Text(exists
                          ? 'Desconto de ${doc.data[couponPercent]}% aplicado!'
                          : 'Cupom inválido!'),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
