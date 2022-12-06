import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../functions/function.dart';

class Utils{
  static void showNetWorkToast({String? msg}) {
    Fluttertoast.showToast(
        msg: msg ??
            " ${isOnline ? "👍" : "🤦‍♂️"} You are  ${isOnline ? "Online back" : "Offline now"}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: isOnline
            ? Colors.green.withOpacity(0.5)
            : Colors.red.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0);
  }

}