import 'package:coal/select_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

enum BleMsgType { newPeripheral, request, response }

class BleMsg {
  final String username;
  final String plateNum;
  final String id;
  BleMsgType mt;
  BleMsg({this.username, this.plateNum, this.id, this.mt});
}

class BleCubit extends Cubit<BleMsg> {
  BleCubit(BleMsg state) : super(state);
  Stream<BleMsg> peripheralFound(String username, String plateNum) async* {
    var msg = BleMsg(
        username: username,
        plateNum: plateNum,
        mt: BleMsgType.newPeripheral,
        id: '');
    yield msg;
  }
}

var runDash = () => runApp(MaterialApp(
    home: DashboardScreen(user: User(name: 'good', phone: '232434'))));

class DashboardScreen extends StatefulWidget {
  final User user;
  DashboardScreen({Key key, this.user}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState(user);
}

class _DashboardScreenState extends State<DashboardScreen> {
  final User user;

  final _vehicle = <Vehicle>[
    null,
  ];
  final _isDriving = <bool>[false];
  _DashboardScreenState(this.user);

  Vehicle get vehicle => _vehicle[0];
  set vehicle(Vehicle v) => setState(() {
        _vehicle[0] = v;
      });

  bool get isDriving => _isDriving[0];
  set isDriving(bool b) => setState(() {
        _isDriving[0] = b;
      });

  void startScanning() async {
    BleManager bleManager = BleManager();
    await bleManager.createClient(); //ready to go!
    bleManager.startPeripheralScan();
    // your peripheral logic
    bleManager.destroyClient();
  }

  void startPeripheral() async {
    BleManager bleManager = BleManager();
    await bleManager.createClient(); //ready to go!
    // bleManager
    // your peripheral logic
    bleManager.destroyClient();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => _showAlert(context));
    final title = 'Hi ${user.name}';

    var btn = TextButton(
        child: Text(
            vehicle == null ? 'Please select vehicle' : '${vehicle.plateNum}'),
        onPressed: () async {
          var car = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => SelectVehicle()));
          var c = car ?? car as Vehicle;
          vehicle = c;
        });
    var icon = Icon(vehicle == null
        ? Icons.device_unknown
        : (vehicle.vehicleType == VehicleType.Excavator
            ? Icons.train
            : Icons.local_taxi));
    var ra = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [icon, btn],
    );
    var rb = Row(
      children: [
        Text(isDriving ? 'Stop Driving' : 'Start Drive'),
        Switch(
            value: isDriving,
            onChanged: (v) {
              isDriving = v;
            }),
      ],
    );

    var r = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [ra, rb],
    );
    BleCubit bc = BleCubit(null);
    var msgs = <BleMsg>[];
    var devs = BlocBuilder<BleCubit, BleMsg>(
        cubit: bc,
        builder: (ctx, msg) {
          msgs.add(msg);
          return ListView(
            children: [
              Text('abc'),
              ...msgs.where((e) => e != null).map((e) {
                return ListTile(
                  title: Text('${e.plateNum}[${e.username}] '),
                );
              }).toList()
            ],
          );
        });
    var body = Column(children: [r, Divider(), Expanded(child: devs)]);
    // var body = Text('hello');
    var bottomItems = user.name.startsWith('admin')
        ? [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Users"),
            BottomNavigationBarItem(
                icon: Icon(Icons.taxi_alert), label: "Vehicles"),
          ]
        : [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.table_chart), label: 'Records'),
            BottomNavigationBarItem(
                icon: Icon(Icons.cloud), label: 'Communication')
          ];
    var home = Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(CoalApp.pLogin);
              }),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(items: bottomItems),
    );

    return home;
  }
}
