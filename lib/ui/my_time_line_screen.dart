
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vitalifyapp/components/CustomTextField.dart';
import 'package:vitalifyapp/data/network/graphqlclients.dart';
import 'package:vitalifyapp/data/network/query.dart';
import 'package:vitalifyapp/model/collection.dart';
import 'package:vitalifyapp/model/timeline.dart';
import 'package:vitalifyapp/ui/homeapp.dart';
import 'package:vitalifyapp/utils/format.dart';


class MyTimeLineScreen extends StatefulWidget {
  const MyTimeLineScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyTimeLineScreenState();
}

class _MyTimeLineScreenState extends State<MyTimeLineScreen> {
  late Future<List<MyTimeline>> timelineListFT;
  late List<MyTimeline> timelineList;
  Map<String, bool> map = {};

  //ScrollController _scrollController = ScrollController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  //datetime - picker
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().year}-${picked.toLocal().month}-${picked.toLocal().day}";
        controller.text = date;

        //Check distance between 2 date
        DateTime sDate =
            DateFormat("yyyy-MM-dd").parse(_startDateController.text);
        DateTime eDate =
            DateFormat("yyyy-MM-dd").parse(_endDateController.text);
        final difference = sDate.difference(eDate).inDays;
        print(difference);
        print(_startDateController.text);
        print(_endDateController.text);
        timelineListFT = getTimeline(
            startDate: _startDateController.text,
            endDate: _endDateController.text);
      });
    }
  }

  //FormatDate: yyyy-MM-dd
  Future<List<MyTimeline>> getTimeline(
      {required String startDate, required String endDate}) async {
    await Future.delayed(const Duration(seconds: 1));
    QueryResult result = await clientAll.value.mutate(MutationOptions(
      document: gql(myTimeLine),
      variables: {
        "input": {"startDate": startDate, "endDate": endDate}
      },
      onCompleted: (dynamic resultData) {},
    ));
    if (result.data!['myTimeLine']['error']['requestResolved'] == false) {
      return [];
    } else {
      List<dynamic> responseList = result.data!['myTimeLine']['response'];
      if (responseList.isEmpty) {
        return [];
      } else {
        List<MyTimeline> timelineList = [];
        for (int i = 0; i < responseList.length; i++) {
          timelineList.add(MyTimeline.fromJson(responseList[i]));
        }
        return timelineList;
      }
    }
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime newDate = DateTime(now.year, now.month - 1, now.day);
    _startDateController.text = DateFormat("yyyy-MM-dd").format(newDate);
    _endDateController.text = DateFormat("yyyy-MM-dd").format(now);
    timelineListFT = getTimeline(
        startDate: _startDateController.text, endDate: _endDateController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getTimeline();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
          title: const Text('My Time Line'),
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainScreen())),
          )),
      body: FutureBuilder<List<MyTimeline>>(
        future: timelineListFT,
        builder: (context, AsyncSnapshot<List<MyTimeline>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Colors.grey.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              timelineList = snapshot.data ?? [];
              if (timelineList.isEmpty) {
                return const Center(child: Text('Nothing'));
              } else {
                return Container(
                  color: Colors.blue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(20.0, 20.0, 0.0, 0.0),
                    ),
                    child: SingleChildScrollView(
                      primary: true,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
                            child: _buildChooseDate(),
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: timelineList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return _buildItemTimeLine(
                                index: index,
                                timelineList: timelineList,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
          }
          return Container();
        },
      ),
    );
  }

  ///Pick date
  _buildChooseDate() {
    return Row(
      children: <Widget>[
        Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, _startDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _startDateController,
                title: 'From',
                isImportant: true,
                hintText: 'Choose',
                textInputType: TextInputType.datetime,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, _endDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _endDateController,
                title: 'To',
                isImportant: true,
                hintText: 'Choose',
                textInputType: TextInputType.datetime,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }



  ///build item timeline
  _buildItemTimeLine(
      {required int index, required List<MyTimeline> timelineList}) {

    return GestureDetector(
      onTap: () {
        setState(() {
          // isExpanded = !isExpanded;
        });
      },
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 70,
                color: Colors.white,
                child: Center(
                  child:Text(timelineList[index].groupDate!,
                    style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold )),
                )
              ),
            ),
          ),
          const SizedBox(height: 10),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, i) {
                    return const Divider();
                  },
                  itemBuilder: (context, i) {
                    return _buildItemCollection(
                        col: timelineList[index].collections, index: i);
                  },
                  itemCount: timelineList[index].collections!.length),
        ],
      ),
    );
  }


  ///show item
  _buildItemCollection({required List? col, required int index}) {
    Collection collection = Collection.fromJson(col![index]);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(collection.activityTypes ?? 'TYPE',style: const TextStyle(color: Colors.cyan),),
                    Text(collection.activityDescription ?? 'Description',
                        style: const TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//

}
