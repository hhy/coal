import 'package:flutter/material.dart';

void mNavRun() => runApp(_App());
// void mNavRun() => runApp(MaterialApp(home: _MHome()));

class _App extends StatelessWidget {
  const _App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      '/': (ctx) => _First(Colors.green, '/red'),
      '/red': (ctx) => _First(Colors.red, '/blue'),
      '/blue': (ctx) => _First(Colors.blue, '/orange'),
      '/orange': (ctx) => _First(Colors.orange, '/'),
    };
    // var m = MaterialApp(routes: routes);
    var m = MaterialApp(
      onGenerateRoute: (settings) {
        var p = settings.name;
        print('parent: navigate get path $p');
        return MaterialPageRoute(builder: (ctx) {
          print('parent: navigate to $p');
          return routes[p](ctx);
        });
      },
    );
    return m;
  }
}

class _First extends StatelessWidget {
  final MaterialColor fromC;
  final String toC;
  _First(this.fromC, this.toC);
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('m nav'));
    var home = Scaffold(
      appBar: appBar,
      body: Column(children: [
        Text('body'),
        RaisedButton(
            child: Text(
              '[$fromC] click me from parent',
            ),
            color: fromC,
            onPressed: () {
              print("clicked");
              Navigator.of(context).pushNamed(toC);
            }),
        Divider(
          color: Colors.green,
        ),
        // _Second(Colors.purple, '/red'),
        Expanded(child: _AppC()),
      ]),
    );
    return home;
  }
}

class _AppC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      '/': (ctx) => _Second(Colors.green, '/red'),
      '/red': (ctx) => _Second(Colors.red, '/blue'),
      '/blue': (ctx) => _Second(Colors.blue, '/orange'),
      '/orange': (ctx) => _Second(Colors.orange, '/'),
    };

    var navigator = Navigator(
      // key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        var p = settings.name;
        print('child navigate get path $p');
        return MaterialPageRoute(builder: (ctx) {
          // return routes[p](ctx);
          print('child navigate to $p');
          return routes[p](ctx);
          // return Expanded(child: Text('---------'));
          // return Text('---------');
        });
      },
    );
    return navigator;
  }
}

class _Second extends StatelessWidget {
  final Color c;
  final String p;
  _Second(this.c, this.p);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('child 1'),
        RaisedButton(
            child: Text(
              'child button',
            ),
            color: c,
            onPressed: () {
              Navigator.of(context).pushNamed(p);
            }),
      ],
    );
  }
}
