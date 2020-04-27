import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/home/home.dart';
import 'package:staffapp/session.dart';

class Connection extends StatefulWidget {
  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  String uri =
      "http://ec2-13-232-202-63.ap-south-1.compute.amazonaws.com:5050/";
  Session loginSession;
  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};

  List<Map<String, String>> popUpDisp = [];

  List<NotificationData> notifications = [];
  Restaurant restaurant = Restaurant();
  final FirebaseMessaging _messaging = new FirebaseMessaging();

  @override
  void initState() {
    manager = SocketIOManager();
    loginSession = new Session();
    login();
    printToken();
    configureFirebaseListeners();
    super.initState();
  }

  printToken() {
    _messaging.getToken().then((token) {
      print("token:   $token");
    });
  }

  static int i = 0;

  configureFirebaseListeners() {
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (i % 2 == 0) {
          print('on message $message');
          fetchOrderUpdates(message);
          // something else you wanna execute
        }
        i++;

//        setState(() {
//          notifications.add(NotificationData.fromJson(message));
//        });
      },
      onResume: (Map<String, dynamic> message) async {
        if (i % 2 == 0) {
          print('on resume $message');
          fetchOrderUpdates(message);
        }
        i++;
//        setState(() {
//          notifications.add(NotificationData.fromJson(message));
//        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        fetchOrderUpdates(message);
//        setState(() {
//          notifications.add(NotificationData.fromJson(message));
//        });
      },
    );
  }

  login() async {
    var output = await loginSession.post(
        "http://ec2-13-232-202-63.ap-south-1.compute.amazonaws.com:5050/login",
        {"username": "SID001", "password": "password123"});
    print("I am loggin in ");
    initSocket(uri);
    print(output);
  }

  initSocket(uri) async {
    print('hey');
    print(loginSession.jwt);
    print(sockets.length);
    var identifier = 'working';
    SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
        uri,
        nameSpace: "/reliefo",
        //Query params - can be used for authentication
        query: {
          "jwt": loginSession.jwt,
//          "username": loginSession.username,
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
//          Transports.POLLING
        ] //Enable required transport

        ));
    socket.onConnect((data) {
      pprint({"Status": "connected..."});
//      pprint(data);
//      sendMessage("DEFAULT");
      socket.emit("fetch_handshake", ["Hello world!"]);
      socket.emit("rest_with_id", ["BNGHSR0001"]);
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect((data) {
      print('object disconnnecgts');
//      disconnect('working');
    });
    socket.on("fetch", (data) => pprint(data));
    socket.on("hand_shake", (data) => shakeHands(data));
//    socket.on("order_updates", (data) => fetchOrderUpdates(data));
    socket.on("restaurant_object", (data) => updateRestaurant(data));

    socket.connect();
    sockets[identifier] = socket;
  }

  shakeHands(data) {
    print("HEREREHRAFNDOKSVOD");
    if (data is Map) {
      data = json.encode(data);
    }

    sockets['working'].emit('hand_shook', ["arg"]);
  }

  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      print(data);
    });
  }

  fetchOrderUpdates(data) {
    print("inside fetchOrderUpdates");
    var updateData = data['data'];

    print(updateData);

//        {notification: {}, data: {collapse_key: com.example.staffapp, google.original_priority: high,
//    google.sent_time: 1587890037700,google.delivered_priority: high, google.ttl: 2419200, from: 363424798383,
//    food_id: 5ea3150b6ce5015a86cff2fa,type: completed, click_action: FLUTTER_NOTIFICATION_CLICK,
//    google.message_id: 0:1587890037712163%b2999812b2999812,
//    order_id: 5ea5263a17290a2f0c8ef83a, table_order_id: 5ea5263a17290a2f0c8ef83b}}
    String table;
    String foodName;

    if (updateData['type'] == "completed") {
      restaurant.tableOrders.forEach((tableOrder) {
        if (tableOrder.oId == updateData['table_order_id']) {
          table = tableOrder.table;
          tableOrder.orders.forEach((order) {
            if (updateData['order_id'] == order.oId) {
              order.foodList.forEach((food) {
                if (updateData['food_id'] == food.foodId) {
                  foodName = food.name;

                  setState(() {
                    popUpDisp.add({
                      "table": table,
                      "food": foodName,
                    });
                  });
                }
              });
            }
          });
        }
      });
    }
  }

  updateRestaurant(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      var decoded = jsonDecode(data);

      restaurant = Restaurant.fromJson(decoded);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("jhksjdksjdls");
    print(popUpDisp);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: HomePage(
            notifications: notifications,
            popUpDisp: popUpDisp,
          ),
        ),
      ),
    );
  }
}
