import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/Store/DataStore.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/home/TakeOrders/FoodOrder/restaurantMenu.dart';

class Billing extends StatelessWidget {
  final String tableId;
  List<TableOrder> itemsToBill = [];

  Billing({
    @required this.tableId,
  });

  getOrders(DataStore dataStore) {
    itemsToBill.clear();

    dataStore.completedOrders?.forEach((tableOrder) {
      print(tableOrder.tableId);
      if (tableOrder.tableId == tableId) {
        itemsToBill.add(tableOrder);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DataStore dataStore = Provider.of<DataStore>(context);
    getOrders(dataStore);
    print(tableId);
    print(dataStore.completedOrders);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kThemeColor,
          title: Text("Billing"),
          actions: <Widget>[
            FlatButton(
              child: Text("Bill"),
              onPressed: () {
                dataStore.billTheTable({"table_id": tableId});
                if(itemsToBill.length > 0){
                  Fluttertoast.showToast(msg: "Bill is sent to the customer",
                  backgroundColor: Colors.black);
                }
                else{
                  Fluttertoast.showToast(msg: "No items to bill",
                  backgroundColor: Colors.red);
                }
              },
            ),
          ],
        ),
        /*
        floatingActionButton: FloatingActionButton.extended(
//          icon: Icon(Icons.save),
          backgroundColor: kThemeColor,
          label: Text("Take Order"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantMenu(),
              ),
            );
          },
        ),
        */
        body: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: itemsToBill.length,
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
                            itemsToBill[index].table ?? " ",
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
                                  (itemsToBill[index].timeStamp),
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
                    itemCount: itemsToBill[index].orders.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index2) {
                      return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              itemsToBill[index].orders[index2].foodList.length,
                          itemBuilder: (context, index3) {
                            return Container(
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
                                            '${itemsToBill[index].orders[index2].foodList[index3].name} x ${itemsToBill[index].orders[index2].foodList[index3].quantity}' ??
                                                " ",
                                            style: kTitleStyle,
                                          ),
                                          dataStore
                                                      .completedOrders[index]
                                                      .orders[index2]
                                                      .foodList[index3]
                                                      .customization !=
                                                  null
                                              ? Text(dataStore
                                                  .completedOrders[index]
                                                  .orders[index2]
                                                  .foodList[index3]
                                                  .customization
                                                  .join(', '))
                                              : Container(),
                                          dataStore
                                                      .completedOrders[index]
                                                      .orders[index2]
                                                      .foodList[index3]
                                                      .instructions ==
                                                  null
                                              ? Container(width: 0, height: 0)
                                              : Text(
                                                  dataStore
                                                          .completedOrders[
                                                              index]
                                                          .orders[index2]
                                                          .foodList[index3]
                                                          .instructions ??
                                                      " ",
                                                  style: kSubTitleStyle,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
