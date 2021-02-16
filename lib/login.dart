import 'package:coal/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// var login = () => runApp(MaterialApp(home: LoginScreen()));

// const users = const {'admin': 'admin', 'good': 'good', 'bad': 'bad'};

class LoginScreen extends StatelessWidget {
  final Login _login;
  LoginScreen(this._login);

  Duration get loginTime => Duration(seconds: 1);

  Future<String> _recoverPassword(String name) {
    return Future.delayed(
        loginTime, () => 'recovery password is not implemented yet');
  }

  Future<String> _signUp(LoginData data) {
    return Future.delayed(loginTime, () => 'signup is not implemented yet');
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      messages: LoginMessages(usernameHint: 'user name'),
      title: 'Coal Mine',
      logo: 'images/login.jpeg',
      emailValidator: (e) {
        var r = RegExp(r'^[a-z]+$').hasMatch(e ?? '')
            ? null
            : ' _user name is invalidated';
        print('$r');
        return r;
      },
      // onLogin: _authUser,
      onLogin: (loginData) => _login(loginData.name, loginData.password),
      onSignup: _signUp,
      onSubmitAnimationCompleted: () {
        print('navigating to home');
        Navigator.of(context)
            .pushReplacementNamed(CoalApp.pHome, arguments: null);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
