import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vitalifyapp/data/network/graphqlclients.dart';
import 'package:vitalifyapp/data/network/query.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import '../constants.dart';
import 'hometodo.dart';
import 'my_time_line_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  DateFormat dateFormat = DateFormat("EEEE, dd MMMM yyyy");
  DateTime now = DateTime.now();
  late String today = dateFormat.format(now);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius(20.0, 20.0, 0.0, 0.0),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              _buildTextApp(),
              const SizedBox(
                height: 20,
              ),
              _buildTextTime(),
              const SizedBox(
                height: 10,
              ),
              _buildBody(),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FabCircularMenu(
            key: fabKey,
            // Cannot be Alignment.center
            alignment: Alignment.bottomRight,
            ringColor: Colors.white.withAlpha(25),
            ringDiameter: 500.0,
            ringWidth: 150.0,
            fabSize: 64.0,
            fabElevation: 8.0,
            fabIconBorder: const CircleBorder(),
            fabColor: Colors.white,
            fabOpenIcon: Icon(Icons.menu, color: primaryColor2),
            fabCloseIcon: Icon(Icons.close, color: primaryColor2),
            fabMargin: const EdgeInsets.all(16.0),
            animationDuration: const Duration(milliseconds: 800),
            animationCurve: Curves.easeInOutCirc,
            onDisplayChange: (isOpen) {
              _showSnackBar(
                  context, "The menu is ${isOpen ? "open" : "closed"}");
            },
            children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context, "You pressed 1");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const MyTimeLineScreen()));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: const Icon(Icons.menu, color: Colors.cyan),
              ),
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context, "You pressed 2");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const TodoScreen()));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: const Icon(Icons.menu, color: Colors.cyan),
              ),
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context, "You pressed 3");
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: const Icon(Icons.menu, color: Colors.cyan),
              ),
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context,
                      "You pressed 4. This one closes the menu on tap");
                  fabKey.currentState!.close();
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: const Icon(Icons.menu, color: Colors.cyan),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.cyan,
          content: Text(message),
          duration: const Duration(milliseconds: 1000),
        )
    );
  }
  //build text time
  Widget _buildTextTime() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      alignment: Alignment.center,
      child: Text(
        'Today is $today',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextApp() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      alignment: Alignment.center,
      child: const Text(
        'Vitalyfy App',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //build body
  Widget _buildBody() {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(15),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 2,
      children: <Widget>[
        _buildItem(
          onTap: () async {
            QueryResult result = await clientAll.value.mutate(MutationOptions(
              document: gql(checkQuery),
              variables: {
                "input": {"activityTypes": "CHECK_IN"}
              },
              onCompleted: (dynamic resultData) {},
            ));
            final productlist = result.data?['createActivity'];
            String? mess = productlist['message'];
            if (result.data != null) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'CHECK IN ',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          color: Colors.green.withOpacity(0.5),
          borderRadius: borderRadius(20.0, 20.0, 0.0, 20.0),
          iconData: AntDesign.checkcircle,
          title: 'Check in',
        ),
        _buildItem(
          onTap: () async {
            QueryResult result = await clientAll.value.mutate(MutationOptions(
              document: gql(checkQuery),
              variables: {
                "input": {"activityTypes": "CHECK_OUT"}
              },
              onCompleted: (dynamic resultData) {},
            ));
            final productlist = result.data?['createActivity'];
            String? mess = productlist['message'];
            if (result.data != null) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'CHECK OUT',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          color: Colors.pinkAccent.withOpacity(0.9),
          borderRadius: borderRadius(20.0, 20.0, 20.0, 0.0),
          iconData: AntDesign.logout,
          title: 'Check out',
          textColor: Colors.white,
        ),
        _buildItem(
          onTap: () async {
            QueryResult result = await clientAll.value.mutate(MutationOptions(
              document: gql(checkQuery),
              variables: {
                "input": {"activityTypes": "GO_OUT"}
              },
              onCompleted: (dynamic resultData) {
                print(resultData);
              },
            ));
            final productlist = result.data?['createActivity'];
            String? mess = productlist['message'];
            if (result.data != null) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'GO OUT',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          color: Colors.deepOrange.withOpacity(0.7),
          borderRadius: borderRadius(20.0, 0.0, 20.0, 20.0),
          iconData: Icons.subdirectory_arrow_left,
          title: 'Go out',
          textColor: Colors.white,
        ),
        _buildItem(
          onTap: () async {
            QueryResult result = await clientAll.value.mutate(MutationOptions(
              document: gql(checkQuery),
              variables: {
                "input": {"activityTypes": "COME_BACK"}
              },
              onCompleted: (dynamic resultData) {
                print(resultData);
              },
            ));
            final productlist = result.data?['createActivity'];
            String? mess = productlist['message'];
            print('messsss' + mess!);
            if (result.data != null) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'COME BACK',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc: mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          color: Colors.grey.withOpacity(0.5),
          borderRadius: borderRadius(0.0, 20.0, 20.0, 20.0),
          iconData: Icons.subdirectory_arrow_right,
          title: 'Come back',
        ),
      ],
    );
  }

  //
  Widget _buildItem({
    required Function()? onTap,
    required Color color,
    required BorderRadius borderRadius,
    required IconData iconData,
    required String title,
    Color? textColor,
    double? iconsize,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: textColor ?? Colors.black.withOpacity(0.8),
              size: iconsize ?? 20,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor ?? Colors.black.withOpacity(0.8),
              ),
            )
          ],
        ),
      ),
    );
  }

  //
  BorderRadius borderRadius(
      double topLeft, double topRight, double bottomRight, double bottomLeft) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomRight: Radius.circular(bottomRight),
      bottomLeft: Radius.circular(bottomLeft),
    );
  }
}
