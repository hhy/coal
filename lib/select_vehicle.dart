import 'package:coal/main.dart';
import 'package:flutter/material.dart';

class SelectVehicle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('select a vehicle'));
    var weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    var items = weekdays.map((e) {
      var vt = e.length % 2 == 0 ? VehicleType.Excavator : VehicleType.Truck;
      var icon = Icon(vt == VehicleType.Excavator
          ? Icons.local_taxi_rounded
          : Icons.train_rounded);
      var v = Vehicle(vt, e);
      var t = ListTile(
        leading: icon,
        title: Text(e),
        onTap: () {
          Navigator.of(context).pop(v);
        },
      );
      // return Text(e);
      return t;
    }).toList();
    var body = ListView(
      children: items,
    );
    var page = Scaffold(
      appBar: appBar,
      body: body,
    );

    return page;
  }
}
