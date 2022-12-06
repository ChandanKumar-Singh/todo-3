import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Providers/authServices.dart';
import '../homeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameCont = TextEditingController();

  TextEditingController passCont = TextEditingController();

  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    return Consumer<AuthServices>(builder: (context, as, _) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: s.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.1),
                  Image.asset('assets/notebook.png'),
                  // Text(
                  //   'Login',
                  //   style: theme.textTheme.headline4!
                  //       .copyWith(fontWeight: FontWeight.w600),
                  // ),
                  SizedBox(height: Get.height * 0.1),
                  TextFormField(
                    controller: nameCont,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextFormField(
                    controller: passCont,
                    obscureText: !showPass,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: Icon(!showPass
                                ? Icons.visibility_off
                                : Icons.visibility))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text('Forgot Password?'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // var user = await as.login(
                          //     email: nameCont.text, password: passCont.text);
                          // if (user != null) {
                          //   Get.offAll(const HomePage());
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(content: Text('Login failed')));
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff58aef1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 38.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     InkWell(
                  //         onTap: () async {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => RegistrationScreen(),
                  //             ),
                  //           );
                  //         },
                  //         child: const Text('Don\'t have an account? Sign Up')),
                  //   ],
                  // ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var user = await as.signInWithGoogle();
                          if (user != null) {
                            await as
                                .register(Get.context!, user: user)
                                .then((value) => Get.offAll(const HomePage()));
                          } else {
                            print('Not Sign in yet');
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/big_google.png',
                                  ),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      // const SizedBox(width: 100),
                      // GestureDetector(
                      //   onTap: () async {
                      //     // await AuthServices().facebookLogin();
                      //   },
                      //   child: Container(
                      //     height: 45,
                      //     width: 45,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         image: const DecorationImage(
                      //             image: AssetImage(
                      //               'assets/facebook-sign-in-button.png',
                      //             ),
                      //             fit: BoxFit.fill)),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  if (as.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);
  static const String route = '/registration';

  TextEditingController nameCont = TextEditingController();
  TextEditingController contactCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: s.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registration',
                style: theme.textTheme.headline4!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              TextFormField(
                controller: nameCont,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: contactCont,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
              ),
              TextFormField(
                controller: emailCont,
                decoration: const InputDecoration(labelText: 'Email Id'),
              ),
              TextFormField(
                controller: passCont,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                controller: confirmPassCont,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // await controller
                      //     .registrationFromEmail(
                      //     name: nameCont.text,
                      //     userName: emailCont.text,
                      //     contact: contactCont.text,
                      //     password: confirmPassCont.text)
                      //     .then(
                      //       (value) => Navigator.pushReplacement(
                      //     context,
                      //     ThisIsFadeRoute(
                      //       route: const UploadProfilePicPage(),
                      //     ),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38.0),
                      child: Text('Create Account'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Already have an account? Sign In')),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var user = await AuthServices().signInWithGoogle();
                      if (user != null) {
                        Get.offAll(const HomePage());
                      } else {
                        print('Not SIgn in yet');
                      }
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage(
                                'assets/Google_Icons-09.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  const SizedBox(width: 100),
                  GestureDetector(
                    onTap: () async {},
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage(
                                'assets/facebook-sign-in-button.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
