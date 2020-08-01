import 'package:flutter/material.dart';

class CustomRaisedButton extends StatefulWidget {
  final String text;
  final Color buttonColor;
  final Color disabledButtonColor = Colors.grey;
  final Color textColor;
  final Color disabledTextColor = Colors.black;
  final double borderRadius;
  final double fontSize;
  final VoidNavigate onCustomButtonPressed;
  final Function onPressed;
  final BuildContext context;
  final double padding = 8.0;

  CustomRaisedButton({
    this.text,
    this.buttonColor,
    this.textColor,
    this.borderRadius = 10,
    this.fontSize,
    this.onCustomButtonPressed,
    this.context,
    this.onPressed
  });

  @override
  _CustomRaisedButton createState() => new _CustomRaisedButton();
}

typedef VoidNavigate = void Function(BuildContext context);

class _CustomRaisedButton extends State<CustomRaisedButton> {

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      disabledColor: widget.disabledButtonColor,
      disabledTextColor: widget.disabledTextColor,
      color: widget.buttonColor,
      onPressed: widget.onPressed,
      child: new Text(
        '${widget.text}',
        style: new TextStyle(
          color: widget.textColor,
          fontWeight: FontWeight.bold,
          fontSize: widget.fontSize,
//          fontFamily: 'Roboto',
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(widget.borderRadius),
      ),
      padding: EdgeInsets.all(widget.padding),
    );
  }
}
