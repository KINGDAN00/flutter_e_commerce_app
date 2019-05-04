import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/cart_model.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:flutter_e_commerce/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(Setup());

class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'L. J. Store',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 54, 47, 216),
                  primaryColorDark: Colors.deepPurple,
                  primaryColorLight: Color.fromARGB(255, 121, 117, 210),
                  fontFamily: 'Raleway'),
              home: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
