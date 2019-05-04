import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';

class OrderTile extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore
              .collection(ordersCollection)
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              int status = snapshot.data[orderStatusField];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Código do pedido:',
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        orderId,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Descrição:',
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _buildDescription(snapshot.data),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Economia de:'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'R\$ ${snapshot.data[orderDiscountField].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total:'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'R\$ ${snapshot.data[orderTotalField].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Status do pedido:',
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildProgressCircle(
                          context, '1', 'Preparação', status, 1),
                      _trackLine(),
                      _buildProgressCircle(
                          context, '2', 'Transporte', status, 2),
                      _trackLine(),
                      _buildProgressCircle(context, '3', 'Entrega', status, 3),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildDescription(DocumentSnapshot snapshot) {
    String desc = '- ';

    for (LinkedHashMap map in snapshot.data[orderProductsField]) {
      desc +=
          '${map[cartQuantityField]} X ${map[cartProductResumeField][productTitleField]}';
      desc +=
          ' (R\$ ${map[cartProductResumeField][productPriceField].toStringAsFixed(2)})';
    }

    return desc;
  }

  Widget _trackLine() {
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.blueGrey[500],
    );
  }

  Widget _buildProgressCircle(BuildContext context, String title,
      String subtitle, int status, int targetStatus) {
    Color back;
    Widget child;

    status++;

    if (status < targetStatus) {
      back = Colors.blueGrey[600];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == targetStatus) {
      back = Theme.of(context).accentColor;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      back = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: back,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
