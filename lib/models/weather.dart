import 'dart:convert' as convert;

import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Weather {
  String id;
  String notification;
  String district;


  //Constructor
  Weather(
      {this.id,
        this.notification,
        this.district,
      });

  factory Weather.fromJson(Map<String, dynamic> json) {
    Weather newPrice = Weather(
        id: json['id'].toString(),
        notification: json['notification'].toString(),
        district: json['district'].toString(),

    );


    return newPrice;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "notification": notification,
    "district": district,
  };

  //clone a Task or copy constructor

  factory Weather.fromPrice(Weather anotherPrice) {
    return Weather(
        id: anotherPrice.id,
        notification: anotherPrice.notification,
        district: anotherPrice.district,
    );
  }
}


Future<List<Weather>> fetchWeatherNotifications(
    http.Client client, SharedPreferences prefs) async {
  print(URL_WEATHER_NOTIFICATIONS+"/"+prefs.getString(PrefConstants.LOGGED_EMAIL));
  final response = await client.get(URL_WEATHER_NOTIFICATIONS+'/'+prefs.getString(PrefConstants.LOGGED_EMAIL));
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'ok') {
      final yields = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return yields.map<Weather>((json) {
        return Weather.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load yields');
  }
}