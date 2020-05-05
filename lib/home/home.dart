import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/pop_up.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> notificationData;
  final requestStatusUpdate;
  HomePage({
    this.notificationData,
    this.requestStatusUpdate,
  });

  showPopup(context, index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopUp(
            notificationData: notificationData[index],
            requestStatusUpdate: requestStatusUpdate,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return notificationData.length != 0
        ? Container(
            child: ListView.builder(
              itemCount: notificationData.length,
//        itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.lightGreen,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        notificationData[index]["request_type"] ==
                                "pickup_request"
                            ? Text("Order Update")
                            : Text("Assistance Request"),
                        Text(
                          '${formatDate(
                                (DateTime.parse(
                                  notificationData[index]["timestamp"],
                                )),
                                [HH, ':', nn],
                              )}' ??
                              " ",
                        ),
                      ],
                    ),
                    onTap: () {
                      showPopup(context, index);
                    },
                  ),
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
