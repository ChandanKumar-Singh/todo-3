import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_3/functions/function.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/userModel.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  late SharedPreferences prefs;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String TAG = 'AuthServices';
  User? user;
  UserData? userData;

  Future<User?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        uid = userCredential.user!.uid;
        print(uid);
        _isLoading = false;
        notifyListeners();
        return user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          print(e.code);
          _isLoading = false;
          notifyListeners();
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          print(e.code);
        }
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        print('from cache $e');
        _isLoading = false;
        notifyListeners();
        // handle the error here
      }
    }
    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<void> facebookLogin() async {
    var facebookLoginResult = await facebookAuth.login();

    print('facebookLoginResult---> $facebookLoginResult');
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    userData = null;
    prefs.clear();
    print('Current user ---> ${auth.currentUser}');
  }

  Future<void> register(BuildContext context,
      {User? user, String? email}) async {
    _isLoading = true;
    notifyListeners();
    var url = 'https://fftindia.in/global_pro_cio/public/api/v1/register';
    print(user);

    final headers = {
      // 'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    Map<String, dynamic> body;
    if (user != null) {
      var type;
      if (user.providerData.first.providerId.contains('google')) {
        type = 'Google';
      }
      body = {
        "name": user.displayName ?? '',
        "email": user.email,
        "phone": user.phoneNumber ?? '',
        "profile_pic": user.photoURL ?? '',
        "reg_type": "$type"
      };
    } else {
      body = {"name": '', "email": email, "phone": '', "reg_type": ""};
    }

    print('This is from refresh loading $email $body  ');
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      // log("$TAG Response : $responseData");
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          var result = responseData['results'];
          print('result --> ${result['data']}');

          try {
            prefs = await SharedPreferences.getInstance();

            userData = UserData.fromJson(result);
            await prefs.setString('email', userData!.data!.email!);
            notifyListeners();
          } catch (e) {
            print('login error --> $e');
          }
        }
        // notifyListeners();
        // }

        _isLoading = false;
        if (_isLoading == false) {
          Get.back();
        }
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw HttpException('Auth Failed  ${response.statusCode}');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<UserData?> login(
      {required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    var url =
        'https://fftindia.in/global_pro_cio/public/api/v1/login?debug=true';
    print(user);

    final headers = {
      // 'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    Map<String, dynamic> body = {"email": email, "password": password};

    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      // log("$TAG Response : $responseData");
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          var result = responseData['results'];
          print('result --> ${result['data']}');

          try {
            prefs = await SharedPreferences.getInstance();

            userData = UserData.fromJson(result);
            await prefs.setString('email', userData!.data!.email!);
            notifyListeners();
          } catch (e) {
            print('login error --> $e');
          }
        }
        // notifyListeners();
        // }

        _isLoading = false;
        if (_isLoading == false) {
          Get.back();
        }
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw HttpException('Auth Failed  ${response.statusCode}');
      }
      return userData;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
