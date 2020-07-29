import 'package:flutter/material.dart';

Future<DateTime> showDatePickerView(
    BuildContext context, DateTime initialDate) async {
  final DateTime selectedDateTime = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2120));
  return selectedDateTime;
}

Future<TimeOfDay> showTimePickerView(
    BuildContext context, TimeOfDay initialTime) async {
  Future<TimeOfDay> selectedTime = showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
  );

  return selectedTime;
}
