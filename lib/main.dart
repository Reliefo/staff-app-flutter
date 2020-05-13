import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staffapp/authentication/connection.dart';
import 'package:staffapp/authentication/loadingPage.dart';
import 'package:staffapp/authentication/loginPage.dart';
import 'package:staffapp/url.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  String refreshUrl = "http://192.168.0.9:5050/refresh";
  bool authentication = false;
  bool showLoading = true;
  String accessToken;
  String restaurantId;
  String staffId;
  Future<Map<String, dynamic>> _getSavedData() async {
    print("getData");

    final credentials = await SharedPreferences.getInstance();

    final restaurantId = credentials.getString('restaurantId');
    final staffId = credentials.getString('staffId');
    final refreshToken = credentials.getString('refreshToken');

    Map<String, dynamic> savedData = {
      "restaurantId": restaurantId,
      "staffId": staffId,
//      "jwt": jwt,
      "refreshToken": refreshToken
    };

    print(savedData);

    return savedData;
  }

  refresh(url) async {
    var savedData = await _getSavedData();

    setState(() {
      restaurantId = savedData["restaurantId"];
      staffId = savedData["staffId"];
    });

    Map<String, String> headers = {
      "Authorization": "Bearer ${savedData["refreshToken"]}"
    };
    print("headers $headers");
    http.Response response = await http.post(url, headers: headers);

    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    var decoded = json.decode(response.body);
    print("status in main page code");
    print(decoded);
    print(statusCode);
    if (statusCode == 200) {
      setState(() {
        accessToken = decoded["access_token"];
        showLoading = false;
        authentication = true;
      });
    } else {
      setState(() {
        authentication = false;
        showLoading = false;
      });
    }
  }

  @override
  void initState() {
    refresh(refreshUrl);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("here build method");
    print(refreshUrl);
    return showLoading == true
        ? LoadingPage()
        : authentication == true
            ? Connection(
                jwt: accessToken,
                staffId: staffId,
                restaurantId: restaurantId,
              )
            : LoginPage();
  }
}
