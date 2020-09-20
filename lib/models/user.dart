import 'dart:convert' as convert;

import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/constants/url_constants.dart';
import 'package:CommandAgric/constants/app_constants.dart';
import 'package:CommandAgric/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class User {
  String id;
  String name;
  String surname;
  String email;
  String password;

  //Constructor
  User(
      {this.id,
      this.name,
      this.surname,
        this.email,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    User newUser = User(
        id: json['id'].toString(),
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        password: json['password']);

    return newUser;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "password": password
      };

  //clone a Task or copy constructor

  factory User.fromUser(User anotherUser) {
    return User(
        id: anotherUser.id,
        name: anotherUser.name,
        surname: anotherUser.surname,
        email: anotherUser.email);
  }
}

//save a user
Future<bool> saveUser(http.Client client, Map<String, dynamic> params,
    SharedPreferences prefs) async {
  print(params.toString());
  final response = await client.post(URL_SAVE_USER, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == 'success') {
      print('Response ikuti ' + responseBody[0]['message']);
      prefs.setString(
          PrefConstants.LOGGED_EMAIL, responseBody[0]['email']);
      prefs.setString(PrefConstants.LOGGED_NAME, responseBody[0]['name']);
      prefs.setBool(PrefConstants.ISLOGGEDIN, true);
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

//update a task
Future<bool> loginUser(http.Client client, SharedPreferences prefs,
    Map<String, dynamic> params) async {
  print(params.toString());
  final response = await client.post(URL_LOGIN, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == AppConstants.RESPONSE_SUCCESS) {
      prefs.setString(PrefConstants.LOGGED_NAME, responseBody[0]['name']);
      return true;
    } else {
      print('Response ikuti ' + responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}

Future<List<User>> fetchUsers(
    http.Client client, SharedPreferences prefs) async {
  print(URL_LIST_PRICES);
  final response = await client.get(URL_LIST_PRICES);
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
      final receipts = mapResponse['users'].cast<Map<String, dynamic>>();
      return receipts.map<User>((json) {
        return User.fromJson(json);
      }).toList();

  } else {
    throw Exception('Failed to load users');
  }
}

