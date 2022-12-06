import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:todo_3/Models/userModel.dart';

import '../functions/function.dart';
import 'AuthProvider.dart';

class UserProvider extends ChangeNotifier {
  late UserData users;
  XFile? imageFile;
  bool uploadingImage = false;
  List recommendedBio = [];
  TextEditingController lastNameController = TextEditingController();

  initRecommendedBio() async {
    if (users.data != null) {
      recommendedBio.clear();
      lastNameController.clear();
      recommendedBio
          .add(TextEditingController(text: users.data!.firstName ?? ''));
      recommendedBio
          .add(TextEditingController(text: users.data!.email ?? ''));
      recommendedBio
          .add(TextEditingController(text: users.data!.phone ?? ''));

      lastNameController.text = users.data!.lastName ?? '';
      notifyListeners();
    }
  }

  Future<void> updateImage() async {
    try {
      if (isOnline) {
        var url = 'App.baseUrl + App.updateProfileImage';
        var headers = {
          'Accept': '*/*',
          'Authorization': 'Bearer ${users.token}'
        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        uploadingImage = true;
        notifyListeners();
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', imageFile!.path));
        request.headers.addAll(headers);
        var res = await request.send();
        // print('res ------> $res');
        var responseData = await res.stream.toBytes();

        var result = String.fromCharCodes(responseData);

        if (res.statusCode == 200) {
          if (jsonDecode(result)['status'] == 200) {
            Provider.of<AuthProvider>(Get.context!, listen: false)
                .username
                .text = prefs.getString('username')!;
            Provider.of<AuthProvider>(Get.context!, listen: false)
                .passController
                .text = prefs.getString('password')!;
            await Provider.of<AuthProvider>(Get.context!, listen: false)
                .login();
          }
          Fluttertoast.showToast(msg: jsonDecode(result)['message']);
        }

        uploadingImage = false;
        notifyListeners();
      } else {
        showNetWorkToast(msg: 'You are offline. Please connect to network');
      }
    } catch (e) {
      print('e e e e e e e   e  ee e  e ---> $e');
    }

    uploadingImage = false;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    try {
      hoverLoadingDialog(true);
      if (isOnline) {
        var url = 'App.baseUrl + App.updateProfileInfo';
        var headers = {
          'Accept': '*/*',
          'Authorization': 'Bearer ${users.token}'
        };
        var body = {
          "user_id": users.data!.id.toString(),
          "email": recommendedBio[1].text,
          "first_name": recommendedBio[0].text,
          "last_name": lastNameController.text,
          "phone": recommendedBio[2].text,
          "address": recommendedBio[3].text
        };
        var res = await http.post(Uri.parse(url), headers: headers, body: body);
        if (res.statusCode == 200) {
          if (jsonDecode(res.body)['success'] == 200) {
            await initiateUserOffline();
          }
          Fluttertoast.showToast(msg: jsonDecode(res.body)['message']);
        }
      } else {
        showNetWorkToast(msg: 'You are offline. Please connect to network');
      }
    } catch (e) {
      print('e e e e e e e   e  ee e  e ---> $e');
    }
    hoverLoadingDialog(false);
  }
}
