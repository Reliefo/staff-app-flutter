import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/pop_up.dart';

class HomePage extends StatelessWidget {
  final List<NotificationData> notifications;
  final List<Map<String, String>> popUpDisp;
  HomePage({
    this.notifications,
    this.popUpDisp,
  });
  @override
  Widget build(BuildContext context) {
    return popUpDisp.length != 0
        ? Container(
            child: ListView.builder(
              itemCount: popUpDisp.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    color: Colors.green,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Order Update"),
                            Text("16:20"),
                          ],
                        ),
//                  Row(
//                    children: <Widget>[
//                      Text("body: ${notifications[index].body}"),
//                    ],
//                  ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return PopUp(
                            singlePopUpDisp: popUpDisp[index],
                          );
                        });
                  },
                );
              },
            ),
          )
        : Center(
            child: Container(
              child: Text("No Updates/Requests"),
            ),
          );
  }
}

//{notification: {title: Hey there I ma the TITLE, body: Hello. This is text message. Enjoy!},
//data: {food_id: 5e9ee817d1751625fc8514ca, type: cooking, table_order_id: 5e9ee8a2a3ead3148eece7d3,
//message: Sample message for Android endpoints, order_id: 5e9ee8a2a3ead3148eece7d2}}
