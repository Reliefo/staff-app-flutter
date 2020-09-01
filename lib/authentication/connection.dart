import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/authentication/loginPage.dart';
import 'package:staffapp/data.dart';
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
  List<FoodItem> cartItems;

  final List<TableOrder> queueOrders = [];
  final List<TableOrder> cookingOrders = [];
  final List<TableOrder> completedOrders = [];

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
    socket.on("order_updates", (data) => fetchOrderStatus(data));
    socket.on("endpoint_check", (data) => checkEndpoint(data));

    ////////////

    socket.on("order_lists", (data) => fetchInitialLists(data));
    socket.on("new_orders", (data) => fetchNewOrders(data));
    socket.on("billing", (data) => fetchBilled(data));
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

    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }

      queueOrders.clear();
      cookingOrders.clear();
//      completedOrders.clear();

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
//      decoded["completed"].forEach((item) {
//        TableOrder ord = TableOrder.fromJson(item);
//
//        completedOrders.add(ord);
//      });
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

  fetchBilled(data) {
    print("inside billing");
    print(data);
//    print(data["order_history"].keys.toList());
//todo: implement billing when requested from customer app
    if (data["status"] == "billed") {
      setState(() {
        /////////////////////// add bill to history ///////////////////
//        RestaurantOrderHistory history =
//        RestaurantOrderHistory.fromJson(data["order_history"]);
//
//        restaurant.orderHistory?.add(history);

        ///////////////////////  remove and clean ////////////////////
        queueOrders?.removeWhere((order) => order.tableId == data["table_id"]);

        cookingOrders
            ?.removeWhere((order) => order.tableId == data["table_id"]);
        completedOrders
            ?.removeWhere((order) => order.tableId == data["table_id"]);
        restaurant.assistanceRequests
            ?.removeWhere((request) => request.tableId == data["table_id"]);

        Tables billedTable;
        restaurant.tables?.forEach((table) {
          if (table.oid == data["table_id"]) {
            print("table found");
            billedTable = table;
          }
        });

        print("for each complete");
        billedTable?.users?.clear();
        print("user cleared");
        billedTable?.queueCount = 0;
        billedTable?.cookingCount = 0;
        billedTable?.completedCount = 0;
      });
    }
    print("table comp");
  }

  fetchRequestStatus(data) {
    print("updated Request status");
    if (data is Map) {
      data = json.encode(data);
    }

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

  fetchOrderStatus(data) {
    print("updated Order status");

    if (data is Map) {
      data = json.encode(data);
    }

    var decoded = jsonDecode(data);
    print(decoded);

//      {"table_order_id":"5f0bdbf8ba93618ef437a89d","status":"rejected","order_id":"5f0bdbf8ba93618ef437a89c",
////    "food_id":"5f05aff101a3fd27419a425a","staff_id":"5f057719f3930ad304099843","table":"Table 1",
////    "table_id":"5f0347b4cfb1be420f5827ba","user":"naveen Mac","timestamp":"2020-07-13 09:56:54.860707",
////    "food_name":"Veg & Chicken"}

    queueOrders.forEach((tableorder) {
      print(tableorder.oId);
      if (tableorder.oId == decoded['table_order_id']) {
        print('table id  matched${decoded['food_id']}');
        tableorder.orders.forEach((order) {
          if (order.oId == decoded['order_id']) {
            print('order id  matched${decoded['food_id']}');
            order.foodList.forEach((fooditem) {
              if (fooditem.foodId == decoded['food_id']) {
                print('food id  matched${decoded['food_id']}');
                fooditem.status = decoded['type'];
//                   push to cooking and completed orders
                pushTo(tableorder, order, fooditem, decoded['type']);
                print('coming here at leastsadf');

                order.removeFoodItem(decoded['food_id']);
                print('coming here at least');
                tableorder.cleanOrders(order.oId);
                if (tableorder.selfDestruct()) {
                  print('self destruct');

                  queueOrders.removeWhere(
                      (taborder) => taborder.oId == tableorder.oId);
                }
              }
            });
          }
        });
      }
    });
  }

  pushTo(table_order, order, food_item, type) {
    setState(() {
      var foundTable = false;
      var foundOrder = false;
      var pushingTo;
      if (type == "cooking") {
        pushingTo = cookingOrders;
      } else if (type == "completed") {
        pushingTo = completedOrders;
      } else {
        pushingTo = completedOrders;
      }

      if (pushingTo.length == 0) {
        TableOrder tableOrder = TableOrder.fromJsonNew(table_order.toJson());
        Order currOrder = Order.fromJsonNew(order.toJson());
        currOrder.addFirstFood(food_item);

        tableOrder.addFirstOrder(currOrder);
        print(tableOrder.orders[0].foodList[0].name);
        pushingTo.add(tableOrder);
      } else {
        pushingTo.forEach((tableOrder) {
          if (table_order.oId == tableOrder.oId) {
            foundTable = true;
            tableOrder.orders.forEach((currOrder) {
              if (order.oId == currOrder.oId) {
                foundOrder = true;
                currOrder.addFood(food_item);
              }
            });
            if (!foundOrder) {
              Order currOrder = Order.fromJsonNew(order.toJson());
              currOrder.addFirstFood(food_item);

              tableOrder.addOrder(currOrder);
            }
          }
        });
        if (!foundTable) {
          TableOrder tableOrder = TableOrder.fromJsonNew(table_order.toJson());
          Order currOrder = Order.fromJsonNew(order.toJson());
          currOrder.addFirstFood(food_item);

          tableOrder.addFirstOrder(currOrder);
          print(tableOrder.orders[0].foodList[0].name);
          pushingTo.add(tableOrder);
        }
      }
    });
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

    if (data is Map) {
      data = json.encode(data);
    }

    var decoded = jsonDecode(data);
    print(decoded);
    setState(() {
      restaurant = Restaurant.fromJson(decoded);
    });

    ////// add not billed items //////
    completedOrders.clear();
    List allottedTables = [];
    decoded['tables']?.forEach((table) {
      table['staff']?.forEach((staff) {
        if (staff["\$oid"] == widget.staffId) {
          allottedTables.add(table);
        }
      });
    });

    allottedTables?.forEach((table) {
      table['table_orders']?.forEach((tableOrder) {
        List ordersToRemove = [];
        tableOrder['orders']?.forEach((order) {
          List foodToRemove = [];
          order['food_list']?.forEach((food) {
            if (food['status'] == 'queued') {
              foodToRemove.add(food);
            }
          });
          foodToRemove?.forEach((food) {
            order['food_list']?.removeWhere((element) => element == food);
          });
          if (order['food_list'].length == 0) {
            ordersToRemove.add(order);
          }
        });
        ordersToRemove?.forEach((ord) {
          tableOrder['orders']?.removeWhere((element) => element == ord);
        });
        setState(() {
          if (tableOrder['orders'].isNotEmpty) {
            completedOrders.add(new TableOrder.fromJson(tableOrder));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(restaurant);
    print(completedOrders);
    return endpointCheck == true
        ? Tabs(
            sockets: sockets,
            notificationData: notificationData,
            history: history,
            queueOrders: queueOrders,
            completedOrders: completedOrders,
            requestStatusUpdate: requestStatusUpdate,
            staffId: widget.staffId,
            restaurant: restaurant,
            cartItems: cartItems,
            staffName: staffName
          )
        : LoginPage();
  }
}
