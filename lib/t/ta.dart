import 'package:flutter/material.dart';
import 'package:coal/java.dart';
import 'package:flutter/services.dart';

void ta() => runApp(_Ta());

class _Ta extends StatefulWidget {
  _Ta({Key key}) : super(key: key);

  @override
  __TaState createState() => __TaState();
}

class __TaState extends State<_Ta> {
  String _s = '';
  final api = Api();
  var _serviceOn = false;
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const _channel =
      const MethodChannel('com.example.methodchannel/interop');

  set s(String s) {
    setState(() {
      _s = _s + s;
    });
  }

  set serviceOn(bool status) {
    if (_serviceOn == status) return;
    setState(() {
      _serviceOn = status;
    });
  }

  get serviceOn => _serviceOn;

  get s => _s;

  Future<String> hijava() async {
    String batteryLevel;
    var fn = "peripheral";
    // fn = "getBatteryLevel";
    try {
      // final int result = await platform.invokeMethod('getBatteryLevel');

      // final result = await platform.invokeMethod(fn);
      var act = serviceOn ? "off" : "on";
      final String result = await platform.invokeMethod(fn, {"act": act});
      batteryLevel = '$fn result: $result';
      serviceOn = !serviceOn;
    } on PlatformException catch (e) {
      print(e);
      batteryLevel = "Failed to $fn: '${e.message}'.";
    }
    return batteryLevel;
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('abc'));
    var btn = TextButton(
      onPressed: () async {
        var r = SearchRequest();

        // var o = await api.search(r);
        // var a = o.result;
        // s = o.result;
        // print("hi");
        // var a = await Future.delayed(Duration(seconds: 3), () => "abc");
        var a = await hijava();
        print("hi $a");
        s = a;
      },
      child: Text('hi'),
    );
    var msg = Text(s);
    var body = Column(
      children: [btn, msg],
    );
    var home = Scaffold(
      appBar: appBar,
      body: body,
    );
    var app = MaterialApp(home: home);
    return app;
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    print(
        "message from native, ${call.method} -------------------------------------");
    switch (call.method) {
      case 'callMe':
        print(
            'call callMe **********************************: arguments = ${call.arguments}');
        return Future.value('called from platform!');
      //return Future.error('error message!!');
      default:
        print('Unknowm method ${call.method}!!!!!!!!!!!!!!!!!!!');
        throw MissingPluginException();
        break;
    }
  }

  @override
  initState() {
    super.initState();

    // Platforms -> Dart
    print("registered ---------------------------------");
    _channel.setMethodCallHandler(_platformCallHandler);
  }
}
