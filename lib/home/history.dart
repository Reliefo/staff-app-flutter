import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:staffapp/constants.dart';

class History extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final requestStatusUpdate;
  History({
    this.history,
    this.requestStatusUpdate,
  });

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  showPopup(context, index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 10),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      "Want to Reject ?",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Really you want to reject ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "Reject",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            sendStatus("accepted_rejected", index);
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
//                            sendStatus("accepted");
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ),
                      ],
                    )
                  ],
                ),

                /////////////////////////////////for assistance request///////////////////////////
              ),
            ),
          );
        });
  }

  sendStatus(status, ind) {
    widget.requestStatusUpdate({"status": status, "data": widget.history[ind]});
    setState(() {
      widget.history[ind]['status'] = "rejected";
    });
  }

  @override
  Widget build(BuildContext context) {
//    print(history[1]);
    return widget.history.length != 0
        ? ListView.builder(
            reverse: true,
            shrinkWrap: true,
            primary: false,
            itemCount: widget.history.length,
            itemBuilder: (context, index) {
              return Card(
                color: widget.history[index]["status"] == "accepted"
                    ? Color(0xffEDFBF0)
                    : Color(0xffF8ECEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: widget.history[index]["request_type"] ==
                          "pickup_request"
                      ? ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Order Pickup",
                                style: kTitleStyle,
                              ),
                              Text(
                                '${formatDate(
                                      (DateTime.parse(
                                        widget.history[index]["timestamp"],
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
                                "Table : ${widget.history[index]["table"]}",
                                style: kSubTitleStyle,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Food : ${widget.history[index]["food_name"]}",
                                style: kSubTitleStyle,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Status : ${widget.history[index]["status"]}",
                                style: kSubTitleStyle,
                              ),
                            ],
                          ),
                          onTap: () {
                            if (widget.history[index]["status"] == "accepted") {
                              showPopup(context, index);
                            }
                          },
                        )
                      : ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Assistance Request",
                                style: kTitleStyle,
                              ),
                              Text(
                                '${formatDate(
                                      (DateTime.parse(
                                        widget.history[index]["timestamp"],
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
                                "Table : ${widget.history[index]["table"]}",
                                style: kSubTitleStyle,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Type : ${widget.history[index]["assistance_type"]}",
                                style: kSubTitleStyle,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Status : ${widget.history[index]["status"]}",
                                style: kSubTitleStyle,
                              ),
                            ],
                          ),
                          onTap: () {
                            if (widget.history[index]["status"] == "accepted") {
                              showPopup(context, index);
                            }
                          },
                        ),
                ),
              );
            },
          )
        : Center(
            child: Container(
              child: Text(" "),
            ),
          );
  }
}
