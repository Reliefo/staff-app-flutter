import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/Store/DataStore.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/drawer/Cart/Cart.dart';
import 'package:staffapp/home/AssistanceRequest/AssistanceRequest.dart';
import 'package:staffapp/home/ReceivedOrders/ReceivedOrders.dart';
import 'package:staffapp/home/TakeOrders/AssignedTables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Tabs extends StatelessWidget {
  Map<String, IO.Socket> sockets = {};
  final List<Map<String, dynamic>> notificationData;
  final List<Map<String, dynamic>> history;
  final List<TableOrder> queueOrders;
  final List<TableOrder> completedOrders;
  final String staffId;
  final Restaurant restaurant;
  final requestStatusUpdate;
  final List<FoodItem> cartItems;

  Tabs(
      {this.sockets,
      this.notificationData,
      this.history,
      this.queueOrders,
      this.completedOrders,
      this.staffId,
      this.restaurant,
      this.requestStatusUpdate,
      this.cartItems});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataStore>.value(
          value: DataStore(
            restaurant: restaurant,
            sockets: sockets,
            notificationData: notificationData,
            history: history,
            queueOrders: queueOrders,
            completedOrders: completedOrders,
            staffId: staffId,
          ),
        ),
        ChangeNotifierProvider<CartData>.value(
          value: CartData(cartItems: cartItems),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
            body: TabBarView(
              children: [
                ReceivedOrders(),
                AssistanceRequestScreen(
                  requestStatusUpdate: requestStatusUpdate,
                ),
                AssignedTables(),
              ],
            ),
            bottomNavigationBar: Container(
              color: kThemeColor,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.error),
                    text: 'Orders',
                  ),
                  Tab(
                    icon: Icon(Icons.assistant),
                    text: 'Assistance',
                  ),
                  Tab(
                    icon: Icon(Icons.touch_app),
                    text: 'Take',
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
