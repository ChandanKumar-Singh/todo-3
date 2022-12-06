// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_3/UI/screens/homeScreen.dart';

import '../../Providers/authServices.dart';
import '../../functions/function.dart';
import 'auth/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkLogin() async {
    var user = auth.currentUser;
    var prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    if (user != null && email != null) {
      print('user --> check login $user');

      print('email --> $email');
      await Provider.of<AuthServices>(Get.context!, listen: false)
          .register(context, email: email);
      Timer(const Duration(seconds: 3), () {
        Get.offAll(const HomePage());
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.offAll(LoginScreen());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.35),
            Image.asset('assets/notebook.png'),
            const Spacer(),
            const CircularProgressIndicator(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
