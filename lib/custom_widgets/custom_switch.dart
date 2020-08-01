import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final Function onSwitchToggle;
  bool isSwitchOn;

  CustomSwitch({this.isSwitchOn, this.onSwitchToggle});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
//  bool _isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: widget.isSwitchOn,
      onChanged: (bool value) {
        setState(() {
          widget.isSwitchOn = value;
          widget.onSwitchToggle(value);
        });
      },
    );
  }
}