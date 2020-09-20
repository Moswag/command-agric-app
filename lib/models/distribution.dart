import 'dart:convert' as convert;

import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Distribution {
  String id;
  String district;
  String date;
  String status;


  //Constructor
  Distribution(
      {
        this.id,
        this.district,
        this.date,
        this.status,
      });

  factory Distribution.fromJson(Map<String, dynamic> json) {
    Distribution newPrice = Distribution(
        id: json['id'].toString(),
        district: json['district'].toString(),
        date: json['date'].toString(),
        status: json['status'].toString()
    );


    return newPrice;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "district": district,
    "date": date,
    "status": status
  };

  //clone a Task or copy constructor

  factory Distribution.fromPrice(Distribution anotherPrice) {
    return Distribution(
        id: anotherPrice.id,
        district: anotherPrice.district,
        date: anotherPrice.date,
        status: anotherPrice.status
    );
  }
}


//Future<List<Distribution>> fetchDistributions(
//    http.Client client, SharedPreferences prefs) async {
//  print(URL_LIST_DISTRIBUTIONS+prefs.getString(PrefConstants.LOGGED_EMAIL));
//  final response = await client.get(URL_LIST_DISTRIBUTIONS+prefs.getString(PrefConstants.LOGGED_EMAIL));
//  if (response.statusCode == 200) {
//    var responseBody =convert.jsonDecode(response.body);
//    print(responseBody);
//    final distributions = responseBody['result'].cast<Map<String, dynamic>>();
//    return distributions.map<Distribution>((json) {
//      print(json);
//      return Distribution.fromJson(json);
//    }).toList();
//
//  } else {
//    throw Exception('Failed to load Distributions');
//  }
//}

Future<List<Distribution>> fetchDistributions(
    http.Client client, SharedPreferences prefs) async {
  print(URL_LIST_DISTRIBUTIONS+prefs.getString(PrefConstants.LOGGED_EMAIL));
  final response = await client.get(URL_LIST_DISTRIBUTIONS+prefs.getString(PrefConstants.LOGGED_EMAIL));
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'ok') {
      final distributions = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return distributions.map<Distribution>((json) {
        return Distribution.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load distributions');
  }
}