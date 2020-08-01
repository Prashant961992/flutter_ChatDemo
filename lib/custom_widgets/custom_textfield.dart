import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class CustomtextField extends StatefulWidget {
//   final String hinttext;
//   final FormFieldValidator<String> validator;
//   final TextEditingController controller;
//   final bool isSecuretext;
//   final TextInputType keyboardType;
//   final bool isShowsuffixIcon;
//   final bool enabled;
//   final String initvalue;
//   final TextInputAction textInputAction;
//   final VoidCallback onTap;
//   CustomtextField({
//   this.hinttext,
//   this.validator,
//   this.controller,
//   this.isSecuretext: false,
//   this.keyboardType : TextInputType.text,
//   this.isShowsuffixIcon = false,
//   this.onTap,
//   this.enabled = true,
//   this.initvalue,
//   this.textInputAction = TextInputAction.done
//   });
  
//   @override
//   _CustomtextFieldState createState() => _CustomtextFieldState();
// }

// class _CustomtextFieldState extends State<CustomtextField> {
  
//   @override
//   Widget build(BuildContext context) {
//     return new TextFormField(
//       controller: widget.controller,
//       keyboardType: widget.keyboardType,
//       autofocus: false,
//       obscureText: widget.isSecuretext,
//       onTap: widget.onTap,
//       validator: widget.validator,
//       autovalidate: false,
//       enabled: widget.enabled,
//       textInputAction: widget.textInputAction,
//       onChanged: (value) {
//         print('change');
//       },
//       initialValue: widget.initvalue,
//       // inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
//       decoration: InputDecoration(
//         hintText: widget.hinttext,
//         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//         // prefixIcon: Icon(Icons.mail_outline),
//         suffixIcon: widget.isShowsuffixIcon == true ? Icon(Icons.arrow_drop_down) : null,
//         // border: UnderlineInputBorder(),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//       ),
//     );
//   }
// }

class CustomtextField extends StatelessWidget {
  final String hinttext;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final bool isSecuretext;
  final TextInputType keyboardType;
  final bool isShowsuffixIcon;
  final bool enabled;
  final String initvalue;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final VoidCallback onTap;

  CustomtextField({
  this.hinttext,
  this.validator,
  this.controller,
  this.isSecuretext: false,
  this.keyboardType : TextInputType.text,
  this.isShowsuffixIcon = false,
  this.onTap,
  this.enabled = true,
  this.initvalue,
  this.textInputAction = TextInputAction.done,
  this.onFieldSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      autofocus: false,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isSecuretext,
      onTap: onTap,
      validator: validator,
      autovalidate: false,
      enabled: enabled,
      textInputAction: textInputAction,
      onChanged: (value) {
        print('change');
      },
      initialValue: initvalue,
      // inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: hinttext,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // prefixIcon: Icon(Icons.mail_outline),
        suffixIcon: isShowsuffixIcon == true ? Icon(Icons.arrow_drop_down) : null,
        // border: UnderlineInputBorder(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }
}