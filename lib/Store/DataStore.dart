import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';

class DataStore extends ChangeNotifier {
  final Restaurant restaurant;
  final sockets;
  final String staffId;
  final List<Map<String, dynamic>> notificationData;
  final List<Map<String, dynamic>> history;
  final List<TableOrder> queueOrders;
  final List<TableOrder> completedOrders;

  DataStore({
    @required this.completedOrders,
    @required this.restaurant,
    @required this.sockets,
    @required this.staffId,
    @required this.notificationData,
    @required this.history,
    @required this.queueOrders,
  });

  requestStatusUpdate(localData) {
    var encode;
    localData["data"]["restaurant_id"] = restaurant.restaurantId;
    localData["data"]["staff_id"] = staffId;
    localData["data"]["status"] = localData["status"];
    encode = jsonEncode(localData["data"]);

    print("sending to backend :  $encode");
    sockets['liqr'].emit('staff_acceptance', encode);
  }

  orderAcceptanceUpdate(Map<String, dynamic> localData) {
    localData["restaurant_id"] = restaurant.restaurantId;
    localData["staff_id"] = staffId;

    var encode = jsonEncode(localData);

    print("sending to backend :  $encode");
    sockets['liqr'].emit('order_acceptance', encode);
  }

  billTheTable(localData) {
    localData["restaurant_id"] = restaurant.restaurantId;
    var encode;
    print("test sending");
    encode = jsonEncode(localData);
    print(encode);
    sockets['liqr'].emit('bill_the_table', encode);
  }
}
