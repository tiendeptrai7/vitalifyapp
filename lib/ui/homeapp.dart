import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vitalifyapp/data/network/graphqlclients.dart';
import 'package:vitalifyapp/data/network/query.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateFormat dateFormat = DateFormat("EEEE, dd MMMM yyyy");
  DateTime now = DateTime.now();
  late String today = dateFormat.format(now);



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          body: Container(
            child: Container(
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
          )),
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
              onCompleted: (dynamic resultData) {
                print(resultData);
              },
            ));
            final productlist = result.data?['createActivity'];
            String? mess = productlist['message'];
            if(result.data != null){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'CHECK IN SUCCES',
                desc:
                mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();

            }else{
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc:
                mess,
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
              onCompleted: (dynamic resultData) {
                print(resultData);
              },
            ));
            final productlist = result.data?['createActivity'];
            String? mess = productlist['message'];
            if(result.data != null){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'CHECK OUT SUCCES',
                desc:
                mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();

            }else{

              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc:
                mess,
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
            if(result.data != null){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'GO OUT SUCCES',
                desc:
                mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();

            }else{
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc:
                mess,
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
            print('messsss'+mess!);
            if(result.data != null){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'COME BACK SUCCES',
                desc:
                mess,
                btnOkOnPress: () {},
                btnOkColor: Colors.green,
              ).show();

            }else{
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'ERROR',
                desc:
                mess,
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
