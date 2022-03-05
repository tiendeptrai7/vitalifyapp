import 'dart:convert';

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'components/custom_button.dart';
import 'components/custom_formfield.dart';
import 'constants.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  //controller - TextField
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //Visible Password
  bool _passwordInvisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submitForm() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );*/
      // Toastr.error(
      //   context: context,
      //   child: const Text(
      //     "Vui lòng nhập đầy đủ thông tin",
      //     style: TextStyle(fontSize: 15, color: Colors.white),
      //   ),
      //   alignment: Alignment.topRight,
      // );
    } else {
      print('test Login');
      if (username == 'sss' && password == '123') {
        print('Successfull');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightOfStatusBar = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;
    IconData iconVisible =
        _passwordInvisible ? Icons.visibility_off : Icons.visibility;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              reverse: false,
              //physics: const NeverScrollableScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.redAccent,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          0, size.height * 0.022 + heightOfStatusBar, 0, 0),
                      height: size.height * 0.08,
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.1,
                    child: Container(
                      height: size.height * 0.90,
                      width: size.width,
                      decoration: const BoxDecoration(
                          color: AppColors.whiteShade,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.05),
                          Container(
                            height: size.height * 0.34,
                            width: size.width * 0.8,
                            margin: EdgeInsets.only(left: size.width * 0.09),
                            child: Image.asset("assets/images/download.png"),
                          ), //h200
                          SizedBox(height: size.height * 0.05),
                          SizedBox(
                            height: size.height * 0.42,
                            child: Column(
                              children: <Widget>[
                                CustomFormField(
                                  headingText: "Tên Đăng Nhập",
                                  hintText: "",
                                  obsecureText: false,
                                  //suffixIcon: const SizedBox(),
                                  controller: _usernameController,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  headingText: "Mật khẩu",
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  textInputType: TextInputType.text,
                                  hintText: "",
                                  obsecureText: !_passwordInvisible,
                                  suffixIcon: IconButton(
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      iconVisible,
                                      color: kPrimaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordInvisible =
                                            !_passwordInvisible;
                                      });
                                    },
                                  ),
                                  controller: _passwordController,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 24),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "Quên mật khẩu?",
                                          style: TextStyle(
                                              color: AppColors.blue
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //const SizedBox(height: 20),
                                AuthButton(
                                  onTap: _submitForm,
                                  text: 'Đăng nhập',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
