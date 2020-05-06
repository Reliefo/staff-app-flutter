import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  History({
    this.history,
  });
  @override
  Widget build(BuildContext context) {
//    print(history[1]);
    return history.length != 0
        ? ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Card(
                color: history[index]["status"] == "accepted"
                    ? Colors.greenAccent
                    : Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: history[index]["request_type"] == "pickup_request"
                      ? ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Order Pickup"),
                              Text(
                                '${formatDate(
                                      (DateTime.parse(
                                        history[index]["timestamp"],
                                      )),
                                      [HH, ':', nn],
                                    )}' ??
                                    " ",
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 6),
                              Text("Table : ${history[index]["table"]}"),
                              SizedBox(height: 4),
                              Text("Food : ${history[index]["food_name"]}"),
                              SizedBox(height: 4),
                              Text("Status : ${history[index]["status"]}"),
                            ],
                          ),
                        )
                      : ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Assistance Request"),
                              Text(
                                '${formatDate(
                                      (DateTime.parse(
                                        history[index]["timestamp"],
                                      )),
                                      [HH, ':', nn],
                                    )}' ??
                                    " ",
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 6),
                              Text("Table : ${history[index]["table"]}"),
                              SizedBox(height: 4),
                              Text(
                                  "Type : ${history[index]["assistance_type"]}"),
                              SizedBox(height: 4),
                              Text("Status : ${history[index]["status"]}"),
                            ],
                          ),
                        ),
                ),
              );
            },
          )
        : Center(
            child: Container(
              child: Text("No History"),
            ),
          );
  }
}
