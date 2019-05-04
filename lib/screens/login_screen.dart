import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:flutter_e_commerce/screens/recover_password_screen.dart';
import 'package:flutter_e_commerce/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text(
              'CRIAR CONTA',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen())),
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: 'E-mail'),
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@'))
                      return 'E-mail inválido';
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Senha'),
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return 'Senha inválida';
                  },
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RecoverPasswordScreen())),
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    elevation: 4.0,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        model.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                            success: _onSuccess,
                            fail: _onFail);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.input,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'LOGIN',
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
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
        content: Text('Falha ao realizar o login!'),
      ),
    );
  }
}
