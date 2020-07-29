import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final Function onButtonPressed;
  final Color color;
  final EdgeInsets padding;
  final String label;
  final TextStyle labelStyle;

  CustomFlatButton(
      {this.label,
        this.labelStyle,
        this.color,
        this.padding,
        this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: padding,
      color: color,
      onPressed: () {
        onButtonPressed();
      },
      child: Text(
        label,
        style: labelStyle,
      ),
    );
  }
}