import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/home/history.dart';
import 'package:staffapp/home/pop_up.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> notificationData;
  final List<Map<String, dynamic>> history;
  final requestStatusUpdate;
  HomePage({
    this.notificationData,
    this.history,
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
    return Scaffold(
//      drawer: Drawer(
//        child: Text("data"),
//      ),
      appBar: AppBar(
        backgroundColor: kThemeColor,
        title: Text(
          "Home",
          style: kHeaderStyle,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ////////////////////////////////// for current requests//////////////////////////////////
          notificationData.length != 0
//              ? ListView.builder(
//                  shrinkWrap: true,
//                  primary: false,
//                  itemCount: notificationData.length,
//                  itemBuilder: (context, index) {
//                    return Card(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(10.0),
//                      ),
//                      color: Colors.lightGreen,
//                      child: ListTile(
//                        title: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            notificationData[index]["request_type"] ==
//                                    "pickup_request"
//                                ? Text("Order Update")
//                                : Text("Assistance Request"),
//                            Text(
//                              '${formatDate(
//                                    (DateTime.parse(
//                                      notificationData[index]["timestamp"],
//                                    )),
//                                    [HH, ':', nn],
//                                  )}' ??
//                                  " ",
//                            ),
//                          ],
//                        ),
//
//                      ),
//                    );
//                  },
//                )
              ? ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: notificationData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color(0xffEFEFEF),
//                color:
//                notificationData[index]["status"] == "accepted"
//                    ? Colors.greenAccent
//                    : Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: notificationData[index]["request_type"] ==
                                "pickup_request"
                            ? ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Order Pickup", style: kTitleStyle),
                                    Text(
                                      '${formatDate(
                                            (DateTime.parse(
                                              notificationData[index]
                                                  ["timestamp"],
                                            )),
                                            [HH, ':', nn],
                                          )}' ??
                                          " ",
                                      style: kTitleStyle,
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 6),
                                    Text(
                                        "Table : ${notificationData[index]["table"]}"),
                                    SizedBox(height: 4),
                                    Text(
                                        "Food : ${notificationData[index]["food_name"]}"),
                                    SizedBox(height: 4),
//                                    Text(
//                                        "Status : ${notificationData[index]["status"]}"),
                                  ],
                                ),
                                onTap: () {
                                  showPopup(context, index);
                                },
                              )
                            : ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Assistance Request",
                                        style: kTitleStyle),
                                    Text(
                                      '${formatDate(
                                            (DateTime.parse(
                                              notificationData[index]
                                                  ["timestamp"],
                                            )),
                                            [HH, ':', nn],
                                          )}' ??
                                          " ",
                                      style: kTitleStyle,
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 6),
                                    Text(
                                        "Table : ${notificationData[index]["table"]}"),
                                    SizedBox(height: 4),
                                    Text(
                                        "Type : ${notificationData[index]["assistance_type"]}"),
                                    SizedBox(height: 4),
//                                    Text(
//                                        "Status : ${notificationData[index]["status"]}"),
                                  ],
                                ),
                                onTap: () {
                                  showPopup(context, index);
                                },
                              ),
                      ),
                    );
                  },
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                    child: Text("No Updates/Requests"),
                  ),
                ),

          Row(children: <Widget>[
            Expanded(
              child: Divider(
                height: 30,
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Text("History"),
            Expanded(
              child: Divider(
                height: 30,
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
            ),
          ]),

          ////////////////////////////////// for past requests//////////////////////////////////

          History(
            history: history,
            requestStatusUpdate: requestStatusUpdate,
          ),
        ],
      ),
    );
  }
}
