import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  final Map<String, String> singlePopUpDisp;
  final requestStatusUpdate;
  PopUp({
    this.singlePopUpDisp,
    this.requestStatusUpdate,
  });

  sendStatus(status) {
    requestStatusUpdate({"status": status, "data": singlePopUpDisp});
  }

  @override
  Widget build(BuildContext context) {
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
          child: singlePopUpDisp["request_type"] == "pickup_request"
              ? Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      "Order Update",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      singlePopUpDisp['food'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " to",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          " Varun",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "In  ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          " Table - ${singlePopUpDisp['table']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Collecting Counter :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "  Counter 2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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
                            sendStatus("rejected");
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
                            sendStatus("accepted");
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ),
                      ],
                    )
                  ],
                )

              /////////////////////////////////for assistance request///////////////////////////
              : Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      "Assistance Request",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      singlePopUpDisp['assistance_type'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " to",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          " Varun",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "In  ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          singlePopUpDisp['table'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Collecting Counter :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "  Counter 2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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
                            sendStatus("rejected");
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
                            sendStatus("accepted");
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

//Center(
//child: RaisedButton(
//onPressed: () {
//showDialog(
//context: context,
//builder: (BuildContext context) {
//return Dialog(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(20),
//),
//elevation: 0.0,
//backgroundColor: Colors.transparent,
//child: Container(
//padding: EdgeInsets.all(20),
//margin: EdgeInsets.only(top: 10),
//decoration: new BoxDecoration(
//color: Colors.white,
//shape: BoxShape.rectangle,
//borderRadius: BorderRadius.circular(12),
//boxShadow: [
//BoxShadow(
//color: Colors.black26,
//blurRadius: 10.0,
//offset: const Offset(0.0, 10.0),
//),
//],
//),
//child: Column(
//mainAxisSize:
//MainAxisSize.min, // To make the card compact
//children: <Widget>[
//Text(
//"Order Request",
//style: TextStyle(
//fontSize: 24.0,
//fontWeight: FontWeight.w700,
//),
//),
//SizedBox(height: 16.0),
//Text(
//"Some food item for table #3",
//textAlign: TextAlign.center,
//style: TextStyle(
//fontSize: 16.0,
//),
//),
//SizedBox(height: 24.0),
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceAround,
//children: <Widget>[
//FlatButton(
//onPressed: () {
//Navigator.of(context)
//    .pop(); // To close the dialog
//},
//child: Text(
//"Accept",
//style: TextStyle(color: Colors.green),
//),
//),
//FlatButton(
//onPressed: () {
//Navigator.of(context)
//    .pop(); // To close the dialog
//},
//child: Text(
//"Reject",
//style: TextStyle(color: Colors.red),
//),
//),
//],
//)
//],
//),
//),
//);
//});
//},
//child: Text("Open Popup"),
//),
//)
