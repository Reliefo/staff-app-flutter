import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/Store/DataStore.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/home/AssistanceRequest/AssistanceRequest.dart';
import 'package:staffapp/home/ReceivedOrders/ReceivedOrders.dart';
import 'package:staffapp/home/TakeOrders/AssignedTables.dart';

class Tabs extends StatelessWidget {
  final Map<String, SocketIO> sockets;
  final List<Map<String, dynamic>> notificationData;
  final List<Map<String, dynamic>> history;
  final List<TableOrder> queueOrders;
  final String staffId;
  final Restaurant restaurant;
  final requestStatusUpdate;

  Tabs({
    this.sockets,
    this.notificationData,
    this.history,
    this.queueOrders,
    this.staffId,
    this.restaurant,
    this.requestStatusUpdate,
  });
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
            staffId: staffId,
          ),
        ),
      ],
      child: MaterialApp(
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
