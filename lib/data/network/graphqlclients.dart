import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vitalifyapp/data/sharedpref/preferences.dart';
import 'package:vitalifyapp/data/sharedpref/shared_preference_helper.dart';

final box = GetStorage();
final HttpLink httpLink = HttpLink(
  'http://54.255.247.6:3001/graphql',
);

final SharedPreferenceHelper prefs = SharedPreferenceHelper();




ValueNotifier<GraphQLClient> clientAll = ValueNotifier(
  GraphQLClient(
    cache: GraphQLCache(
      store: InMemoryStore(),
    ),
    link: AuthLink(getToken: () async {
      String token = await prefs.get(Preferences.auth_token);
      print(token);
      return "Bearer $token";
    }).concat(httpLink),
  ),
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(
      store: InMemoryStore(),
    ),
  ),
);
