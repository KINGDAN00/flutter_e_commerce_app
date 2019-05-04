import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';

class ShipCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ExpansionTile(
        title: Text(
          'Calcular frete',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(
          Icons.local_shipping,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Theme.of(context).primaryColor,
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: '',
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Informe o CEP'),
              onFieldSubmitted: (text) {
              },
            ),
          )
        ],
      ),
    );
  }
}
