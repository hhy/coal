import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

t_nav() => runApp(_App());

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/a': (ctx) => _Pa('aa'),
      '/b': (ctx) => _Pa('bb'),
    };

    final RouteFactory ff = (setting) {
      final args = setting.arguments;
      var n = setting.name;
      print('name: $n, args: $args');
      Route r = MaterialPageRoute(builder: (ctx) {
        return _Pa('dynamicRouter');
      });
      return r;
    };

    var app = MaterialApp(
      home: _Pa('home'),
      routes: routes,
      initialRoute: "/",
      onGenerateRoute: ff,
    );
    return app;
  }
}

class _NavCubit extends Cubit<String> {
  _NavCubit(String state) : super('/');
  void nextPage(String fromPage) {}
}

class _Pa extends StatelessWidget {
  final String s;
  _Pa(this.s);
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('abc title $s'));
    var body = Center(
      child: Text('abc $s'),
    );
    var btn = RaisedButton(
        child: Text('press me'),
        color: Colors.green,
        onPressed: () {
          print("i am pressed from $s");
          var n = (s == 'home')
              ? '/a'
              : (s == 'aa'
                  ? '/b'
                  : (s.startsWith('dynamic') ? '/' : '/dynnnnnn'));
          Navigator.of(context).pushNamed('$n', arguments: '3233');
        });
    var home = Scaffold(appBar: appBar, body: body, floatingActionButton: btn);
    return home;
  }
}
