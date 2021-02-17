import 'dart:async';

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
  String _s = null;
  final api = Api();
  var _serviceOn = false;
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const _channel =
      const MethodChannel('com.example.methodchannel/interop');
  static const eventChannel =
      const EventChannel("samples.flutter.dev/bleStream");

  set s(String s) {
    setState(() {
      _s = _s ?? '' + s;
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

  bool _isListening = false;

  set isListening(bool v) {
    setState(() {
      _isListening = v;
    });
  }

  get isListening => _isListening;

  StreamSubscription _subscription;

  set subscription(StreamSubscription s) {
    print("start listenning");
    setState(() {
      _isListening = true;
      _subscription = s;
    });
  }

  get subscription => _subscription;

  Future<String> hijava() async {
    String msg;
    var fn = "peripheral";
    // fn = "getBatteryLevel";
    try {
      // final int result = await platform.invokeMethod('getBatteryLevel');

      // final result = await platform.invokeMethod(fn);
      var act = serviceOn ? "off" : "on";
      final String result = await platform.invokeMethod(fn, {"act": act});
      msg = '$fn result: $result';
      serviceOn = !serviceOn;
    } on PlatformException catch (e) {
      print(e);
      msg = "Failed to $fn: '${e.message}'.";
    } catch (e) {
      print(e);
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('abc'));
    var btn = TextButton(
      onPressed: () async {
        // var r = SearchRequest();

        // var o = await api.search(r);
        // var a = o.result;
        // s = o.result;
        // print("hi");
        // var a = await Future.delayed(Duration(seconds: 3), () => "abc");
        var a = await hijava();
        print("hi $a");
        s = a;
      },
      child: Text(
        serviceOn ? 'stop Service' : 'Start service',
        textScaleFactor: 2.4,
      ),
    );
    var btn2 = TextButton(
      onPressed: () async {
        if (isListening) {
          await subscription.cancel();
          isListening = false;
          print("stopped listening");
          return;
        }

        subscription = eventChannel.receiveBroadcastStream().listen((data) {
          print('get data: $data');
        }, onError: (e) {
          print("error $e");
        }, onDone: () {
          print("done");
        });
      },
      child: Text(isListening ? "stop listening" : "start listening",
          textScaleFactor: 2.0,
          style:
              TextStyle(backgroundColor: Colors.amber, color: Colors.purple)),
    );
    var msg = Text(
      s ?? "blank",
      textScaleFactor: 1.5,
    );
    var body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [btn, Divider(), msg, btn2],
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
