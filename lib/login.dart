import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dashboard.dart';

var login = () => runApp(MaterialApp(home: LoginScreen()));

const users = const {'admin': 'admin', 'good': 'good', 'bad': 'bad'};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return "";
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return "";
    });
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
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
