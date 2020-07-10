import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/Store/DataStore.dart';
import 'package:staffapp/constants.dart';

class ReceivedOrders extends StatefulWidget {
  @override
  _ReceivedOrdersState createState() => _ReceivedOrdersState();
}

class _ReceivedOrdersState extends State<ReceivedOrders> {
  @override
  Widget build(BuildContext context) {
    final DataStore dataStore = Provider.of<DataStore>(context);
    return SafeArea(
      child: Scaffold(
        body: dataStore.queueOrders.length > 0
            ? ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: dataStore.queueOrders.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF5DEB5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  dataStore.queueOrders[index].table ?? " ",
                                  style: kHeaderStyleSmall,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
//
                                  formatDate(
                                        (dataStore
                                            .queueOrders[index].timeStamp),
                                        [HH, ':', nn],
                                      ) ??
                                      " ",
                                  style: kHeaderStyleSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          primary: false,
                          itemCount: dataStore.queueOrders[index].orders.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index2) {
                            return ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: dataStore.queueOrders[index]
                                    .orders[index2].foodList.length,
                                itemBuilder: (context, index3) {
                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    key: Key(dataStore
                                        .queueOrders[index]
                                        .orders[index2]
                                        .foodList[index3]
                                        .foodId),
                                    onDismissed: (direction) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${dataStore.queueOrders[index].orders[index2].foodList[index3].name} Removed"),
                                        ),
                                      );
                                      Map<String, dynamic> localData = {
                                        "table_order_id":
                                            dataStore.queueOrders[index].oId,
                                        "order_id": dataStore.queueOrders[index]
                                            .orders[index2].oId,
                                        "food_id": dataStore
                                            .queueOrders[index]
                                            .orders[index2]
                                            .foodList[index3]
                                            .foodId,
                                        "status": "rejected",
                                      };

                                      dataStore
                                          .orderAcceptanceUpdate(localData);

                                      setState(() {
                                        dataStore.queueOrders[index]
                                            .orders[index2].foodList
                                            .removeAt(index3);
                                      });
                                    },
                                    background: Container(color: Colors.red),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffEFEEEF),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          left: 8, top: 8, right: 0, bottom: 2),
                                      margin: EdgeInsets.all(4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '${dataStore.queueOrders[index].orders[index2].foodList[index3].name} x ${dataStore.queueOrders[index].orders[index2].foodList[index3].quantity}' ??
                                                        " ",
                                                    style: kTitleStyle,
                                                  ),
                                                  dataStore
                                                              .queueOrders[
                                                                  index]
                                                              .orders[index2]
                                                              .foodList[index3]
                                                              .customization !=
                                                          null
                                                      ? Text(dataStore
                                                          .queueOrders[index]
                                                          .orders[index2]
                                                          .foodList[index3]
                                                          .customization
                                                          .join(', '))
                                                      : Container(),
                                                  dataStore
                                                              .queueOrders[
                                                                  index]
                                                              .orders[index2]
                                                              .foodList[index3]
                                                              .instructions ==
                                                          null
                                                      ? Container(
                                                          width: 0, height: 0)
                                                      : Text(
                                                          dataStore
                                                                  .queueOrders[
                                                                      index]
                                                                  .orders[
                                                                      index2]
                                                                  .foodList[
                                                                      index3]
                                                                  .instructions ??
                                                              " ",
                                                          style: kSubTitleStyle,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 8),
                                            child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                Map<String, dynamic> localData =
                                                    {
                                                  "table_order_id": dataStore
                                                      .queueOrders[index].oId,
                                                  "order_id": dataStore
                                                      .queueOrders[index]
                                                      .orders[index2]
                                                      .oId,
                                                  "food_id": dataStore
                                                      .queueOrders[index]
                                                      .orders[index2]
                                                      .foodList[index3]
                                                      .foodId,
                                                  "status": "accepted",
                                                };

                                                dataStore.orderAcceptanceUpdate(
                                                    localData);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Center(
                  child: Text(
                    "No Orders",
                    style: kHeaderStyleSmall,
                  ),
                ),
              ),
      ),
    );
  }
}
