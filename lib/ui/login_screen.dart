
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vitalifyapp/components/custom_button.dart';
import 'package:vitalifyapp/components/custom_formfield.dart';
import 'package:vitalifyapp/data/network/graphqlclients.dart';
import 'package:vitalifyapp/data/network/query.dart';
import 'package:vitalifyapp/data/sharedpref/preferences.dart';
import 'package:vitalifyapp/data/sharedpref/shared_preference_helper.dart';

import '../app_colors.dart';
import '../constants.dart';
import 'home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'homeapp.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SharedPreferenceHelper prefs = SharedPreferenceHelper();
  bool islog = true;


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

  _submitForm() async {
    String email = _usernameController.text;
    String password = _passwordController.text;
    if (_formKey.currentState!.validate()) {
      QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(loginQuery),
        variables: {
          "input": {
            "vfaEmail": email,
            "password": password
          }
        },onCompleted: (dynamic resultData) {
        print(resultData);
        print(email);

      },
      ));
      if(result.data != null){


        final productlist = result.data?['login'];

        String? accesstoken = productlist['token'];



        prefs.set(Preferences.auth_token, accesstoken.toString());
        prefs.set(Preferences.is_logged_in, true);
        print('token'+  accesstoken!);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainScreen()));
      }

      else{

        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: 'Lỗi',
          desc:
          'Tài khoản hoặc mật khẩu không đúng',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
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
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
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
