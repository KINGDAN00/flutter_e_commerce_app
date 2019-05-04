import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _emailController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Recuperar senha',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: 'E-mail'),
              ),
              SizedBox(
                height: 16.0,
              ),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  elevation: 4.0,
                  onPressed: () async {
                    if (_emailController.text.isEmpty)
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                          content: Text(
                              'Informe o e-mail para recuperação de senha'),
                        ),
                      );
                    else {
                      model.recoverPassword(_emailController.text);
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                          content: Text('Confira seu e-mail'),
                        ),
                      );

                      await Future.delayed(Duration(seconds: 3));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.fast_rewind,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'RECUPERAR',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
