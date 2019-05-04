import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:flutter_e_commerce/screens/login_screen.dart';
import 'package:flutter_e_commerce/tiles/drawer_tile.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController _pageController;

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {
    Widget _builderBackground() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 121, 117, 210),
                Colors.white,
              ],
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _builderBackground(),
          ListView(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 16.0,
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.shopping_basket),
                          Container(
                            margin: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'L. J. Store',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Olá, ${model.isNotLoggedIn() ? '' : model.userData[userNameField]}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  model.isNotLoggedIn()
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()))
                                      : model.signOut();
                                },
                                child: Text(
                                  model.isLoggedIn()
                                      ? 'Sair'
                                      : 'Entre ou cadastre-se >',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', _pageController, 0),
              DrawerTile(Icons.list, 'Categorias', _pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', _pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, 'Meus Pedidos', _pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
