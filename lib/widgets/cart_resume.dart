import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartResume extends StatelessWidget {
  final VoidCallback buy;

  CartResume(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do Pedido'.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Sub-total',
                      style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$ ${model.subTotal().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Desconto',
                      style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$ ${model.hasCoupon() ? '-' : ''}${model.discountApplied().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: model.hasCoupon()
                            ? Colors.green
                            : Colors.blueGrey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
// TODO NÃO ESTÁ FUNCIONANDO O CALCULO DE FRETE
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Entrega',
                      style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.shipPrice() == 0
                          ? 'Grátis'
                          : 'R\$ +${model.shipPrice().toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            model.shipPrice() == 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total'.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$ ${model.total().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.check,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Finalizar Pedido'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  onPressed: buy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
