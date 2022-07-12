import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myplans/pages/home_page.dart';
import 'package:myplans/pages/signup_page.dart';
import 'package:myplans/services/auth_service.dart';
import 'package:myplans/services/prefs_service.dart';

import '../utils/utils.dart';

class SignInPage extends StatefulWidget {
  static const String id = '/sign_in_page';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _doLogin() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((user)  {
          _getFireBaseUser(user);
        });
  }

  void _getFireBaseUser(User? user) {
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      Prefs.saveUserId(user.uid).then((value) {
        Navigator.pushReplacementNamed(context, HomePage.id);
      });
    } else {
      Utils.fireToast('Check your email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    height: 45,
                    onPressed: () {
                      _doLogin();
                    },
                    color: Colors.black,
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, SignUpPage.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
