import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myplans/pages/detail_page.dart';
import 'package:myplans/pages/signup_page.dart';
import 'package:myplans/services/prefs_service.dart';

import 'pages/home_page.dart';
import 'pages/signin_page.dart';

void main()async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  _startPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        DetailPage.id: (context) => const DetailPage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id:( context) => const SignUpPage(),
      },
    );
  }
}
Widget _startPage(){
  return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          Prefs.saveUserId(snapshot.data!.uid);
          return const HomePage();
        }else{
          Prefs.removeUserId();
          return const SignInPage();
        }
      });
}
