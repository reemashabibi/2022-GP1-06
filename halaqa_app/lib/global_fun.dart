import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GlobalFun{


  ///this function show time in chat
  static realTime(Timestamp t) {
    DateTime currentTime = t.toDate();
    final f =  DateFormat('hh:mm a');
    String myDate = f.format(currentTime);
    return myDate;
  }

  ///this function show date in chat
  static realDate (String date) {
    String day = "${DateFormat('y').format(DateTime.parse(date))},${DateFormat('d').format(DateTime.parse(date))} ${DateFormat('MMM').format(DateTime.parse(date))}";
    return day;
  }

}