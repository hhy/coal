import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

// var selectscreen_ = () => runApp(SelectVehicleScreen());

class SelectVehicleScreen extends StatefulWidget {
  SelectVehicleScreen({Key? key}) : super(key: key);

  @override
  _SelectVehicleScreenState createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    var sel = SmartSelect<String>.single(
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
        setState(() {});
      },

      // choice item list
      // List<S2Choice<T>> choiceItems,
      choiceItems: ['monday', 'tue', 'wed', 'thu'].map((e) {
        return S2Choice<String>(value: e, title: '${e}_$e');
      }).toList(),

      // other available configuration
      // explained below
    );

    return sel;
  }
}
