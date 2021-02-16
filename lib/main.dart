import 'package:coal/t/t_bloc.dart';
import 'package:coal/t/t_color.dart';
import 'package:coal/t/t_mnav.dart';
import 'package:coal/t/t_nav.dart';
import 'package:flutter/material.dart';
import 'excavator.dart';
import 'login.dart';
import 'dashboard.dart';
import 't/ta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // runApp(MyApp());
  // login();
  // dash();
  // selectscreen_();
  //navBloc();
  // t_bloc();
  // t_nav();
  // mNavRun();
  // runColor();
  // _runApp();
  // runDash();
  // blePeripheral();
  ta();
}

void _runApp() => runApp(CoalApp());

class User {
  final String name;
  final String phone;
  User({this.name, this.phone});
}

enum VehicleType { Excavator, Truck }

class Vehicle {
  final VehicleType vehicleType;
  final String plateNum;
  Vehicle(this.vehicleType, this.plateNum);
}

typedef Login = Future<String> Function(String username, String password);

class CoalApp extends StatefulWidget {
  static final pLogin = '/login';
  static final pHome = '/dashboard';
  // static final pSelectVehicle = '/selectvehicle';

  CoalApp({Key key}) : super(key: key);

  @override
  _CoalAppState createState() => _CoalAppState();
}

class _CoalAppState extends State<CoalApp> {
  final List<User> _user = <User>[null];
  User get user => _user[0];
  set user(User u) => _user[0] = u;
  _CoalAppState();
  @override
  Widget build(BuildContext context) {
    Login login = (name, passwd) {
      var ss = Future.delayed(Duration(seconds: 1), () {
        if (name.startsWith('good') || name.startsWith("admin"))
          user = (User(name: name, phone: '3232233'));
        else
          user = null;
        return user == null ? 'bad user' : '';
      });
      return ss;
    };
    RouteFactory routesConfig = (settings) {
      print('${settings.arguments.runtimeType}');
      var name = settings.name;

      if (user == null || name == CoalApp.pLogin) {
        return MaterialPageRoute(builder: (ctx) => LoginScreen(login));
      }

      var m = {
        CoalApp.pHome: (ctx) => DashboardScreen(user: user),
      };

      return MaterialPageRoute(builder: m[name]);
    };
    var app = MaterialApp(
      onGenerateRoute: routesConfig,
      // home: Text('abc')
    );
    return app;
  }
}
