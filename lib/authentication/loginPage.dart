import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staffapp/authentication/connection.dart';
import 'package:staffapp/authentication/passwordChange.dart';
import 'package:staffapp/url.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _messaging = new FirebaseMessaging();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String username, password, deviceToken;
  String jwt, refreshToken, staffId, restaurantId;
  int responseCode;
  String responseFromBackend;
  getDeviceToken() {
    _messaging.getToken().then((token) {
      setState(() {
        deviceToken = token;
      });
      print("Device token:   $token");
    });
  }

  @override
  void initState() {
    getDeviceToken();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: responseCode == 201
          ? PasswordChange(
              username: username,
              password: password,
            )
          : responseCode == 200
              ? Connection(
                  jwt: jwt,
                  staffId: staffId,
                  restaurantId: restaurantId,
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text('Login'),
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(15.0),
                      child: Form(
                        key: _key,
                        autovalidate: _validate,
                        child: formUI(),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 150.0,
          child: Center(
              child: Text(
            'LiQR',
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
            ),
          )),

//          Image.network(
//            "http://pngimg.com/uploads/cannabis/cannabis_PNG75.png",
//            fit: BoxFit.contain,
//          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          maxLength: 32,
          validator: validateUsername,
          onSaved: (String val) {
            username = val;
          },
        ),
        SizedBox(height: 12),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          maxLength: 32,
          validator: validatePassword,
          onSaved: (String val) {
            password = val;
          },
        ),
        SizedBox(height: 15.0),
        responseFromBackend != null
            ? Text(responseFromBackend)
            : Container(
                height: 0,
                width: 0,
              ),
        SizedBox(height: 15.0),
        RaisedButton(
          onPressed: _sendToServer,
          child: Text('Login'),
        ),
      ],
    );
  }

  String validateUsername(String value) {
    String pattern = "^[a-zA-Z0-9]*\$";
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "Username is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Username must be a-z, A-Z and 0-9";
    }
    return null;
  }

  Future<void> _saveData() async {
    final data = await SharedPreferences.getInstance();
//    String jwtToSave = jwt.toString();
    String deviceTokenToSave = deviceToken.toString();
    String refreshTokenToSave = refreshToken.toString();
    String staffIdToSave = staffId.toString();
    String restaurantIdToSave = restaurantId.toString();
    //    await data.setString('jwt', jwtToSave);
    await data.setString('deviceToken', deviceTokenToSave);
    await data.setString('refreshToken', refreshTokenToSave);
    await data.setString('staffId', staffIdToSave);
    await data.setString('restaurantId', restaurantIdToSave);

    print("Saved tokens to storage");
  }

  String validatePassword(String value) {
    //  Minimum 1 Upper case
//  Minimum 1 lowercase
//  Minimum 1 Numeric Number
//  Minimum 1 Special Character
//  Common Allow Character ( ! @ # $ & * ~ )

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "Password is Required";
    }
//    else if (!regExp.hasMatch(value)) {
//      return "Invalid Password";
//    }
    else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("Username $username");
      print("Password $password");

      _makePostRequest(loginUrl, username, password);
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _makePostRequest(String url, username, String password) async {
//    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> data = {
      "username": username,
      "password": password,
      "device_token": deviceToken,
      "app": "staff",
    };
    // make POST request
    print("json $data");
    http.Response response = await http.post(url, body: data);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    var decoded = json.decode(response.body);
    print("status code");

    print(statusCode);

    if (statusCode == 200) {
      setState(() {
        jwt = decoded['jwt'];
        refreshToken = decoded['refresh_token'];
        staffId = decoded['object_id'];
        restaurantId = decoded['restaurant_id'];
      });

      _saveData();
    } else {
      setState(() {
        responseFromBackend = decoded["status"];
      });
    }
// 201 for temp password Matched successfully
    // 200 for original password Matched successfully
    // 403 for temp password Match failed.
    if (statusCode == 200 || statusCode == 201 || statusCode == 403) {
      setState(() {
        responseCode = statusCode;
      });
    }
  }
}
