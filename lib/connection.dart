import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/authentication/session.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/drawer/drawerMenu.dart';
import 'package:staffapp/home/home.dart';

class Connection extends StatefulWidget {
  final String jwt;
  final String staffId;
  final String restaurantId;
  Connection({
    this.jwt,
    this.staffId,
    this.restaurantId,
  });
  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  String uri = "http://192.168.0.9:5050/";
  String loginUri = "http://192.168.0.9:5050/login";

//  String uri =
//      "http://ec2-13-232-202-63.ap-south-1.compute.amazonaws.com:5050/";
//  String loginUri =
//      "http://ec2-13-232-202-63.ap-south-1.compute.amazonaws.com:5050/login";
  Session loginSession;
  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};

  List<Map<String, dynamic>> notificationData = [];
  List<Map<String, dynamic>> history = [];

  Restaurant restaurant = Restaurant();
  final FirebaseMessaging _messaging = new FirebaseMessaging();

  @override
  void initState() {
    manager = SocketIOManager();
    loginSession = new Session();
//    login();
    initSocket(uri);
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
          fetchRequests(message);
          // something else you wanna execute
        }
        i++;
      },
      onResume: (Map<String, dynamic> message) async {
        if (i % 2 == 0) {
          print('on resume $message');
          fetchRequests(message);
        }
        i++;
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        fetchRequests(message);
      },
    );
  }

//  login() async {
//    var output = await loginSession
//        .post(loginUri, {"username": "SID001", "password": "password123"});
//    print("I am loggin in ");
//    initSocket(uri);
//    print(output);
//  }

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
          "jwt": widget.jwt,
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

      socket.emit("fetch_staff_details", [
        jsonEncode(
            {"staff_id": widget.staffId, "restaurant_id": widget.restaurantId})
      ]);
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

    socket.on("restaurant_object", (data) => updateRestaurant(data));
    socket.on("staff_details", (data) => fetchInitialData(data));
    socket.on("assist", (data) => fetchRequestStatus(data));
    socket.on("order_updates", (data) => fetchRequestStatus(data));

//    ""

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

      print("prksnk");
      print(data);
    });
  }

  fetchInitialData(data) {
//    (_id, name, requests_queue, ..., order_history, rej_order_history)
    if (data is Map) {
      data = json.encode(data);
    }

    print("initial decoded data");
//I/flutter ( 4158): _id
//I/flutter ( 4158): name
//I/flutter ( 4158): requests_queue
//I/flutter ( 4158): assistance_history
//I/flutter ( 4158): rej_assistance_history
//I/flutter ( 4158): order_history
//I/flutter ( 4158): rej_order_history
    var decoded = jsonDecode(data);
    decoded['requests_queue'].forEach((v) {
      fetchRequests({"data": v});
    });

    decoded['assistance_history'].forEach((v) {
      print("assistance_history");
      print(v);
      fetchHistory(v);
    });

    decoded['rej_assistance_history'].forEach((v) {
      print("rej_assistance_history");
      print(v);
      fetchHistory(v);
    });
    decoded['order_history'].forEach((v) {
      print("order_history");
      print(v);
      fetchHistory(v);
    });
    decoded['rej_order_history'].forEach((v) {
      print("rej_order_history");
      print(v);
      fetchHistory(v);
    });
  }

  fetchHistory(data) {
//    print("inside History");

    Map<String, dynamic> updateData = {};

    data.forEach((k, v) => updateData[k.toString()] = v);

//    print(updateData);

    setState(() {
      history.add(updateData);
    });
  }

  fetchRequests(data) {
    print("inside fetchOrderUpdates");

    Map<String, dynamic> updateData = {};

    data['data'].forEach((k, v) => updateData[k.toString()] = v);

    print(updateData);

    setState(() {
      notificationData.add(updateData);
    });
  }
//  fetchOrderUpdates(data) {
//    print("inside fetchOrderUpdates");
//    print(data['data'].runtimeType);
//    Map<String, dynamic> updateData = {};
////    var decoded = jsonDecode(data['data']);
////    print("decoded $decoded");
//    data['data'].forEach((k, v) => updateData[k.toString()] = v);
//
//    String tableName;
//    String foodName;
////    print(updateData);
//
//    if (updateData['request_type'] == "pickup_request") {
//      print("here compl");
//      restaurant.tableOrders.forEach((tableOrder) {
//        if (tableOrder.oId == updateData['table_order_id']) {
//          print(tableOrder.oId);
//          tableName = tableOrder.table;
//          tableOrder.orders.forEach((order) {
//            if (updateData['order_id'] == order.oId) {
//              order.foodList.forEach((food) {
//                if (updateData['food_id'] == food.foodId) {
//                  foodName = food.name;
//                  print("here");
//
//                  updateData["table"] = tableName;
//                  updateData["food"] = foodName;
//                  setState(() {
//                    notificationData.add(updateData);
//                  });
//                }
//              });
//            }
//          });
//        }
//      });
//    }
////    {assistance_req_id: 5eafa7a301ccfd3da8c6c1ff, table_id: 5ead65c8e1823a4f2132579c,
////    user_id: 5eaf03840e993a2a64fcdf95, timestamp: 2020-05-04 10:56:59.773610,
////    click_action: FLUTTER_NOTIFICATION_CLICK, request_type: assistance_request,
////    assistance_type: ketchup}
//    if (updateData["request_type"] == "assistance_request") {
//      print("comingj");
//      restaurant.tables.forEach((table) {
//        print("coming here");
//        if (table.oid == updateData["table_id"]) {
//          tableName = table.name;
//          print("coming here $tableName");
//          updateData["table"] = tableName;
//          print("fddfd");
//          print(updateData);
//          setState(() {
//            notificationData.add(updateData);
//          });
//        }
//      });
//    }
//  }

  fetchRequestStatus(data) {
    if (data is Map) {
      data = json.encode(data);
    }

    print("updated status");

    var decoded = jsonDecode(data);
    print(decoded);

    if (decoded["request_type"] == "pickup_request") {
      notificationData.forEach((notification) {
        if (notification["request_type"] == "pickup_request") {
          if (decoded["order_id"] == notification["order_id"] &&
              decoded["food_id"] == notification["food_id"]) {
            setState(() {
              history.add(notification);
              notificationData.remove(notification);
            });
          }
        }
      });
    }
    if (decoded["request_type"] == "assistance_request") {
      notificationData.forEach((notification) {
        if (notification["request_type"] == "assistance_request") {
          if (decoded["assistance_req_id"] ==
              notification["assistance_req_id"]) {
            setState(() {
              history.add(notification);
              notificationData.remove(notification);
            });
          }
        }
      });
    }
  }

  requestStatusUpdate(localData) {
    var encode;
    String restaurantId = restaurant.restaurantId;

    localData["data"]["restaurant_id"] = restaurantId;
    localData["data"]["staff_id"] = restaurant.staff[2].oid;
    localData["data"]["status"] = localData["status"];
    encode = jsonEncode(localData["data"]);
    sockets['working'].emit('staff_acceptance', [encode]);
  }

  updateRestaurant(data) {
    print("restaurant fetch");
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      var decoded = jsonDecode(data);
//      print(decoded);
      restaurant = Restaurant.fromJson(decoded);
    });
  }

//  {notification: {title: Assistance Request from table8, body: Someone asked for help from table8},
//  data: {assistance_req_id: 5eafa9c7f179757a61077d87, table_id: 5ead65c8e1823a4f2132579c,
//  user_id: 5eaf03840e993a2a64fcdf95, timestamp: 2020-05-04 11:06:07.148809,
//  click_action: FLUTTER_NOTIFICATION_CLICK, request_type: assistance_request, assistance_type: help}}
  @override
  Widget build(BuildContext context) {
    print("conn page");
    print(widget.restaurantId);
    print(widget.staffId);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: DrawerMenu(
              restaurant: restaurant,
            ),
          ),
          body:
//          PageView(
//            children: <Widget>[
              HomePage(
            notificationData: notificationData,
            history: history,
            requestStatusUpdate: requestStatusUpdate,
          ),
//              HistoryPage(),
//            ],
//          ),
        ),
      ),
    );
  }
}
