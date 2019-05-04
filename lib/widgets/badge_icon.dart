import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';

class BadgeIcon extends StatefulWidget {
  @override
  _BadgeIconState createState() => _BadgeIconState();
}

class _BadgeIconState extends State<BadgeIcon> {
  @override
  Widget build(BuildContext context) {
    int counter = CartModel.of(context).getCountProducts();
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Center(
            child: Icon(Icons.shopping_cart),
          ),
        ),
        Positioned(
          right: 3.0,
          top: 10.0,
          child: Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
            ),
            constraints: BoxConstraints(
              minWidth: 15.0,
              minHeight: 15.0,
            ),
            child: Text(
              '$counter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
