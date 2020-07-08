import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/home/history.dart';
import 'package:staffapp/home/pop_up.dart';

class AssistanceRequestScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notificationData;
  final List<Map<String, dynamic>> history;
  final requestStatusUpdate;
  AssistanceRequestScreen({
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

  sendStatus(status, selectedNotification) {
    requestStatusUpdate({"status": status, "data": selectedNotification});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ////////////////////////////////// for current requests//////////////////////////////////
            notificationData.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: notificationData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color(0xffEFEFEF),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 6),
                                      Text(
                                        "Table : ${notificationData[index]["table"]}",
                                        style: kSubTitleStyle,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Food : ${notificationData[index]["food_name"]}",
                                        style: kSubTitleStyle,
                                      ),
                                      SizedBox(height: 4),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 6),
                                      Text(
                                        "Table : ${notificationData[index]["table"]}",
                                        style: kSubTitleStyle,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Type : ${notificationData[index]["assistance_type"]}",
                                        style: kSubTitleStyle,
                                      ),
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
      ),
    );
  }
}
