import 'package:flutter/material.dart';
import 'package:vitalifyapp/data/sharedpref/preferences.dart';
import 'package:vitalifyapp/ui/homeapp.dart';
import 'package:vitalifyapp/ui/login_screen.dart';

import 'data/sharedpref/shared_preference_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final SharedPreferenceHelper prefs = SharedPreferenceHelper();
  bool isRememberLogin = false;
  _getStatusRemember() async {
    isRememberLogin = await prefs.get(Preferences.is_logged_in) ?? false;
    print('Remember Login: ' + isRememberLogin.toString());
  }

  @override
  void initState() {
    _getStatusRemember();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isRememberLogin == true
          ? const MainScreen()
          : const LoginScreen(),



    );
  }

}

