import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

runColor() => runApp(_App());

class _App extends StatelessWidget {
  const _App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _PageA(Tab.red));
  }
}

enum Tab {
  red,
  green,
  blue,
}

class _PageA extends StatelessWidget {
  // const _PageA({Key key}) : super(key: key);
  final Tab t;
  _PageA(this.t);

  @override
  Widget build(BuildContext context) {
    var body = Text('');
    var appBar = AppBar(title: Text('hello'));
    var bottomNav =
        BottomNavigationBar(backgroundColor: Colors.blueGrey.shade100, items: [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.circle,
          color: Colors.red,
        ),
        label: 'red',
        backgroundColor: Colors.red,
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.accessible_forward_sharp,
            color: Colors.green,
          ),
          label: 'green',
          backgroundColor: Colors.green),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.work_off,
            color: Colors.blue,
          ),
          label: 'blue',
          backgroundColor: Colors.blue),
    ]);
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNav,
    );
  }
}
