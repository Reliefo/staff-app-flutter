import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/authentication/loginPage.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/drawer/Cart/Cart.dart';
import 'package:staffapp/home/Tabs.dart';
import 'package:staffapp/url.dart';

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
  final AudioCache player = new AudioCache();
  String alarmAudioPath = "sound.mp3";
  bool endpointCheck = true;
//  JSSocketService jsSocket;
  String staffName;
  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};

  List<Map<String, dynamic>> notificationData = [];
  List<Map<String, dynamic>> history = [];

  List<TableOrder> queueOrders = [];
  List<TableOrder> cookingOrders = [];
  List<TableOrder> completedOrders = [];

  Restaurant restaurant = Restaurant();

  final FirebaseMessaging _messaging = new FirebaseMessaging();

  @override
  void initState() {
    manager = SocketIOManager();

    initSocket(uri);

//    initNewSocket();
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
    print("here");
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
//        if (i % 2 == 0) {
//        print('on message $message');
//        player.play(alarmAudioPath);

//        fetchRequests(message);
        // something else you wanna execute
//        }
//        i++;
      },
      onResume: (Map<String, dynamic> message) async {
//        if (i % 2 == 0) {
//        print('on resume $message');
//          player.play(alarmAudioPath);
//        fetchRequests(message);
//        }
//        i++;
      },
      onLaunch: (Map<String, dynamic> message) async {
//        print('on launch $message');
//        player.play(alarmAudioPath);
//        fetchRequests(message);
      },
    );
  }

//  initNewSocket() {
//    jsSocket = new JSSocketService();
//
//    JSSocketService.jsWebview.didReceiveMessage.listen((message) {
//      String eventName = message.data["eventName"]; // event name from server
//      String eventData = message.data["eventData"]; // event data from server
//
//      switch (eventName) {
//        case "ready_to_connect":
//          {
//            print('[socket] -> connecting with jwt..!');
//            jsSocket.socketEmit("connect",
//                jsonEncode({"naveen": widget.jwt, "socket_url": uri}));
//            break;
//          }
//
//        case "connect":
//          {
//            print('[socket] -> connected');
//
//            jsSocket.socketEmit("fetch_rest_manager",
//                jsonEncode({"restaurant_id": widget.restaurantId}));
//            break;
//          }
//        case "disconnect":
//          {
//            print('[socket] -> disconnect');
//            break;
//          }
//        case "reconnect_attempt":
//          {
//            print('[socket] -> reconnect_attempt');
//            break;
//          }
//        case "reconnect":
//          {
//            print('[socket] -> reconnect');
//            break;
//          }
//
//        case "logger":
//          {
//            print('[socket] -> logger');
//            pprint(eventData);
//            break;
//          }
//
//        case "restaurant_object":
//          {
//            print('[socket] -> restaurant object');
//            updateRestaurant(eventData);
//            break;
//          }
//
//        case "staff_details":
//          {
//            print('[socket] -> staff details');
//            fetchInitialData(eventData);
//            break;
//          }
//        case "requests_queue":
//          {
//            print('[socket] -> requests queue');
//            fetchRequestQueue(eventData);
//            break;
//          }
//        case "assist":
//          {
//            print('[socket] -> assist');
//            fetchRequestStatus(eventData);
//            break;
//          }
//
//        case "order_updates":
//          {
//            print('[socket] -> order updates');
//            fetchRequestStatus(eventData);
//            break;
//          }
//
//        case "endpoint_check":
//          {
//            print('[socket] -> endpoint check');
//            checkEndpoint(eventData);
//            break;
//          }
//      }
//    });
//  }

  initSocket(uri) async {
    print('hey');
//    print(loginSession.jwt);
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

      socket.emit("check_endpoint", [
        jsonEncode({"staff_id": widget.staffId})
      ]);

      socket.emit("check_logger", [" sending........."]);
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
    });
    socket.on("logger", (data) {
      print("From logger :  $data");
    });

    socket.on("restaurant_object", (data) => updateRestaurant(data));
    socket.on("staff_details", (data) => fetchInitialData(data));
    socket.on("requests_queue", (data) => fetchRequestQueue(data));
    socket.on("assist", (data) => fetchRequestStatus(data));
    socket.on("order_updates", (data) => fetchRequestStatus(data));
    socket.on("endpoint_check", (data) => checkEndpoint(data));

    ////////////

    socket.on("order_lists", (data) => fetchInitialLists(data));
    socket.on("new_orders", (data) => fetchNewOrders(data));

    ////////////////

    socket.connect();
    sockets[identifier] = socket;
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

  checkEndpoint(data) {
    if (data is Map) {
      data = json.encode(data);
    }
    var decoded = jsonDecode(data);
    print("inside check");
    print(data);
    print(decoded["status"]);
    if (decoded["status"] == "damaged") {
      setState(() {
        endpointCheck = false;
      });
    }
    //working or damaged
  }

  fetchInitialData(data) {
    setState(() {
//    (_id, name, requests_queue, ..., order_history, rej_order_history)
      if (data is Map) {
        data = json.encode(data);
      }

      print("initial decoded data");

      var decoded = jsonDecode(data);

      staffName = decoded['name'];

      print(decoded.keys.toList());
      print(decoded);

      decoded['requests_history'].forEach((v) {
        print("accepted requests");
        print(v);
        fetchHistory(v);
      });

      decoded['rej_requests_history'].forEach((v) {
//        print("rejected requests");
//        print(v);
        fetchHistory(v);
      });
    });
  }

  fetchInitialLists(data) {
    print("fetching initial lists");
    print(data);
    ////// should be added to staff data ///////

//    print("her inside fegtch initla lists");
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      queueOrders.clear();
      cookingOrders.clear();
      completedOrders.clear();

      var decoded = jsonDecode(data);
      decoded["queue"].forEach((item) {
        print(item);
        TableOrder order = TableOrder.fromJson(item);

        queueOrders.add(order);
      });
      decoded["cooking"].forEach((item) {
        TableOrder order = TableOrder.fromJson(item);

        cookingOrders.add(order);
      });
      decoded["completed"].forEach((item) {
        TableOrder ord = TableOrder.fromJson(item);

        completedOrders.add(ord);
      });
    });
  }

  fetchNewOrders(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      print("New orders have come to the Queue");
      print(jsonDecode(data));

      TableOrder order = TableOrder.fromJson(jsonDecode(data));

      queueOrders.add(order);
    });
  }

  fetchRequestQueue(data) {
    print("fetchRequestQueue");

    if (data is Map) {
      data = json.encode(data);
    }

    setState(() {
      var decoded = jsonDecode(data);

      if (decoded['requests_queue'].isNotEmpty) {
        print("request queqe");
        print(decoded['requests_queue']);
        notificationData.clear();
        decoded['requests_queue'].forEach((v) {
          fetchRequests({"data": v});
        });
      }
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

  fetchRequestStatus(data) {
    if (data is Map) {
      data = json.encode(data);
    }

    print("updated status");

    print(data);

    var decoded = jsonDecode(data);
    print(decoded);

    if (decoded["request_type"] == "pickup_request") {
      if (decoded["status"] == "pending") {
        setState(() {
          notificationData.add(decoded);
        });
      } else {
        notificationData.forEach((notification) {
          if (notification["request_type"] == "pickup_request") {
            if (decoded["order_id"] == notification["order_id"] &&
                decoded["food_id"] == notification["food_id"]) {
              setState(() {
                if (decoded['staff_id'] != widget.staffId) {
                  print("diffrent staff");
                  decoded["status"] = "accepted by someone";
                }
                history.add(decoded);
                notificationData.remove(notification);
              });
            }
          }
        });
      }
    }
    if (decoded["request_type"] == "assistance_request") {
      if (decoded["status"] == "pending") {
        setState(() {
          notificationData.add(decoded);
          print("adding to noti   assistance_request ");
        });
      } else {
        notificationData.forEach((notification) {
          if (notification["request_type"] == "assistance_request") {
            if (decoded["assistance_req_id"] ==
                notification["assistance_req_id"]) {
              setState(() {
                print("history   assistance_request ");
                if (decoded['accepted_by']['staff_id'] != widget.staffId) {
                  print("diffrent staff");
                  decoded["status"] = "accepted by someone";
                }
                history.add(decoded);
                notificationData.remove(notification);
              });
            }
          }
        });
      }
    }
  }

  requestStatusUpdate(localData) {
    var encode;
    String restaurantId = restaurant.restaurantId;

    localData["data"]["restaurant_id"] = restaurantId;
    localData["data"]["staff_id"] = widget.staffId;
    localData["data"]["status"] = localData["status"];
    encode = jsonEncode(localData["data"]);

    print("sending to backend :  $encode");
    sockets['working'].emit('staff_acceptance', [encode]);
  }

  updateRestaurant(data) {
    print("restaurant fetch");
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      var decoded = jsonDecode(data);
      print(decoded);
      restaurant = Restaurant.fromJson(decoded);
    });
  }

//  {notification: {title: Assistance Request from table8, body: Someone asked for help from table8},
//  data: {assistance_req_id: 5eafa9c7f179757a61077d87, table_id: 5ead65c8e1823a4f2132579c,
//  user_id: 5eaf03840e993a2a64fcdf95, timestamp: 2020-05-04 11:06:07.148809,
//  click_action: FLUTTER_NOTIFICATION_CLICK, request_type: assistance_request, assistance_type: help}}
  @override
  Widget build(BuildContext context) {
//    print(widget.staffId);

    return endpointCheck == true
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider<CartData>.value(
                value: CartData(),
              ),
            ],
            child: Tabs(
              notificationData: notificationData,
              history: history,
              queueOrders: queueOrders,
              requestStatusUpdate: requestStatusUpdate,
              staffId: widget.staffId,
              restaurant: restaurant,
            ),
//            MaterialApp(
//              debugShowCheckedModeBanner: false,
//              home: SafeArea(
//                child: Scaffold(
////                  drawer: Drawer(
////                    child: DrawerMenu(
////                      staffId: widget.staffId,
////                      staffName: staffName,
////                      restaurant: restaurant,
////                    ),
////                  ),
//                  body:
//
//                  Tabs(
//                    notificationData: notificationData,
//                    history: history,
//                    requestStatusUpdate: requestStatusUpdate,
//                    staffId: widget.staffId,
//                    restaurant: restaurant,
//                  ),
//
////                      HomePage(
////                    notificationData: notificationData,
////                    history: history,
////                    requestStatusUpdate: requestStatusUpdate,
////                  ),
//                ),
//              ),
//            ),
          )
        : LoginPage();
  }
}
