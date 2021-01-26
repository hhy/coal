// import 'package:coal/getOnVehicle.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

var dash = () => runApp(DashboardScreen());

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => _showAlert(context));
    final title = 'Hi Peer';

    var selectVehicleWidget = SmartSelect<String>.single(
      // The primary content of the widget.
      // Used in trigger widget and header option
      title: 'select a vehicle',

      // The text displayed when the value is null
      placeholder: 'Select one',

      // The current value of the single choice widget.
      // @required T value,
      value: '',

      // Called when single choice value changed
      // @required ValueChanged<S2SingleState<T>> onChange,
      onChange: (e) {
        // setState(() {});
      },

      // choice item list
      // List<S2Choice<T>> choiceItems,
      choiceItems: ['monday', 'tue', 'wed', 'thu'].map((e) {
        return S2Choice<String>(value: e, title: '${e}_$e');
      }).toList(),

      // other available configuration
      // explained below
    );
    var sel = selectVehicleWidget;
    // var body1 = Column(children: [sel, Divider(), vFeatures]);
    // var body1 = Column(children: [Text('fff'), Divider(), vFeatures]);
    // var body = Column(children: [sel, Divider()]);
    // var body = Column(children: [Divider(), vFeatures]);
    var body = Column(children: [sel, Divider()]);

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: body,
      ),
    );
  }
}

void _showAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: new Text("Alert Dialog title"),
            content: new Text("Alert Dialog body"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
}
