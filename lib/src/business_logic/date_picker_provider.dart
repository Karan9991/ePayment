import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerProvider extends ChangeNotifier{
  TextEditingController dateInputStart = TextEditingController();
  TextEditingController dateInputEnd = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  pickStartDate(context)async{
    DateTime? pickedDate = await showDatePicker(

        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950), lastDate: DateTime(2100));

    if (pickedDate != null) {
       startDate = pickedDate;
      dateInputStart.text =DateFormat('yyyy-MM-dd').format( startDate!);
      notifyListeners();
    } else {}
  }
  pickEndDate(context)async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950), lastDate: DateTime(2100));

    if (pickedDate != null) {
      endDate =pickedDate;
      dateInputEnd.text =  DateFormat('yyyy-MM-dd').format(endDate!);
      notifyListeners();
    } else {}
  }
}