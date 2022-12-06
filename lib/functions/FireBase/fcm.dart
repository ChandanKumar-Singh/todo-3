import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

String fcmToken = '';

Future<void> getFcmToken() async {
  await messaging.getToken().then((value) {
    fcmToken = value!;
    debugPrint('My FCM TOKEN IS ___> $fcmToken');
  }).onError((error, stackTrace) {
    Fluttertoast.showToast(msg: 'FCM TOKEN GENERATION ERROR ___> $error');
    return Future(() => null);
  });
}
