import 'dart:convert' as convert;

import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Price {
  String priceId;
  String cropId;
  String crop;
  String price;
  String unit;

  //Constructor
  Price(
      {this.priceId,
        this.cropId,
        this.crop,
        this.price,
        this.unit
        });

  factory Price.fromJson(Map<String, dynamic> json) {
    Price newPrice = Price(
        priceId: json['priceId'].toString(),
        cropId: json['cropId'].toString(),
        crop: json['crop'].toString(),
        price: json['price'].toString(),
        unit: json['unit'].toString()
        );


    return newPrice;
  }

  Map<String, dynamic> toJson() => {
    "priceId": priceId,
    "cropId": cropId,
    "crop": crop,
    "price": price,
    "unit": unit
  };

  //clone a Task or copy constructor

  factory Price.fromPrice(Price anotherPrice) {
    return Price(
        priceId: anotherPrice.priceId,
        cropId: anotherPrice.cropId,
        crop: anotherPrice.crop,
        price: anotherPrice.price,
        unit: anotherPrice.unit
    );
  }
}



Future<List<Price>> fetchPrices(
    http.Client client, SharedPreferences prefs) async {
  print(URL_LIST_PRICES);
  final response = await client.get(URL_LIST_PRICES);
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'ok') {
      final prices = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return prices.map<Price>((json) {
        return Price.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load prices');
  }
}