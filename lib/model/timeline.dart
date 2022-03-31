class MyTimeline {
  String? groupDate;
  List<dynamic>? collections;

  MyTimeline({this.groupDate, this.collections});

  factory MyTimeline.fromJson(Map<String, dynamic> jsonMap) => MyTimeline(
        groupDate: jsonMap['groupDate'].toString(),
        collections: jsonMap['collections'],
      );
}
