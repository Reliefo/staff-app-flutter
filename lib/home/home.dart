import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/history.dart';
import 'package:staffapp/pop_up.dart';

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
      appBar: AppBar(
        title: Text("Home"),
      ),
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
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                    child: Text("No Updates/Requests"),
                  ),
                ),

          ////////////////////////////////// for past requests//////////////////////////////////
          History(
            history: history,
          ),
        ],
      ),
    );
  }
}
