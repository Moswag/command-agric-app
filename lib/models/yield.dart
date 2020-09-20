import 'dart:convert' as convert;

import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Yield {
  String farmerId;
  String crop;
  String quantity;
  String date;

  //Constructor
  Yield(
      {
        this.farmerId,
        this.crop,
        this.quantity,
        this.date,
      });

  factory Yield.fromJson(Map<String, dynamic> json) {
    Yield newYield = Yield(
        farmerId: json['farmerId'].toString(),
        crop: json['crop'].toString(),
        quantity: json['quantity'].toString(),
        date: json['date'].toString()
    );

    return newYield;
  }

  Map<String, dynamic> toJson() => {
    "farmerId": farmerId,
    "crop": crop,
    "quantity": quantity,
    "date": date
  };

  //clone a Task or copy constructor

  factory Yield.fromPrice(Yield anotherPrice) {
    return Yield(
        farmerId: anotherPrice.farmerId,
        crop: anotherPrice.crop,
        quantity: anotherPrice.quantity,
        date: anotherPrice.date
    );
  }
}

//save a user
//Future<bool> saveYield(http.Client client, Map<String, dynamic> params,
//    SharedPreferences prefs) async {
//  print(params.toString());
//  final response = await client.post(URL_SAVE_YIELD, body: params);
//  print('response22=$response');
//  if (response.statusCode == 200) {
//    var responseBody = await convert.jsonDecode(response.body);
//    var mapResponse = int.parse(responseBody['status'].toString());
//    if (mapResponse == 200) {
//      print('The response is: '+mapResponse.toString());
//      prefs.setString(
//          PrefConstants.SERVER_RESPONSE,'Yield successfully added');
//      return true;
//    } else {
//      print('Response ikuti ' + mapResponse.toString());
//      prefs.setString(
//          PrefConstants.SERVER_RESPONSE,responseBody['message']);
//      return false;
//    }
//  } else {
//    throw Exception('Failed to add yield . Error: ${response.toString()}');
//  }
//}
//save a user
Future<bool> saveYield(http.Client client, Map<String, dynamic> params,
    SharedPreferences prefs) async {
  print(params.toString());
  final response = await client.post(URL_YIELD, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == 'success') {
      print('Response ikuti ' + responseBody[0]['message']);
      prefs.setString(
          PrefConstants.SERVER_RESPONSE, responseBody[0]['message']);
      return true;
    } else {
      print('Response ikuti ' + responseBody[0]['message']);
      prefs.setString(
          PrefConstants.SERVER_RESPONSE, responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to add user . Error: ${response.toString()}');
  }
}

//Future<List<Yield>> fetchYields(
//    http.Client client, SharedPreferences prefs) async {
//  print(URL_YIELD+"/"+prefs.getString(PrefConstants.LOGGED_EMAIL));
//  final response = await client.get(URL_YIELD+'/'+prefs.getString(PrefConstants.LOGGED_EMAIL));
//  if (response.statusCode == 200) {
//    var responseBody =convert.jsonDecode(response.body);
//    print(responseBody);
//    final yields = responseBody['result'].cast<Map<String, dynamic>>();
//    return yields.map<Yield>((json) {
//      print(json);
//      return Yield.fromJson(json);
//    }).toList();
//
//  } else {
//    throw Exception('Failed to load yields');
//  }
//}

Future<List<Yield>> fetchYields(
    http.Client client, SharedPreferences prefs) async {
  print(URL_YIELD+"/"+prefs.getString(PrefConstants.LOGGED_EMAIL));
  final response = await client.get(URL_YIELD+'/'+prefs.getString(PrefConstants.LOGGED_EMAIL));
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'ok') {
      final yields = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return yields.map<Yield>((json) {
        return Yield.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load yields');
  }
}