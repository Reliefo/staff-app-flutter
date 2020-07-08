import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/drawer/Cart/Cart.dart';

class FoodItemList extends StatelessWidget {
  final menu;
  FoodItemList({
    this.menu,
  });

  Widget initialAddButton(CartData cartData, MenuFoodItem foodItem) {
    return RawMaterialButton(
      onPressed: () {
        cartData.addItemToCart(foodItem);
//                              showModalBottomSheet(
////                                  isScrollControlled: true,
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.only(
//                                      topLeft: Radius.circular(16.0),
//                                      topRight: Radius.circular(16.0)),
//                                ),
//                                context: context,
//                                builder: (context) => CustomizeFood(),
//                              );
      },
      fillColor: kThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      constraints: BoxConstraints(
        minHeight: 30,
        minWidth: 90,
      ),
      padding: EdgeInsets.all(2.0),
      child: Text("Add"),
    );
  }

  Widget addButton(CartData cartData, MenuFoodItem foodItem) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: kThemeColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      height: 30,
      width: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.remove,
            size: 20,
            color: kThemeColor,
          ),
          Text("1"),
          Icon(
            Icons.add,
            size: 20,
            color: kThemeColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartData cartData = Provider.of<CartData>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: menu.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                menu[index].name,
                style: kHeaderStyleSmall,
              ),
            ),
            Container(
              child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: menu[index].foodList.length,
                  itemBuilder: (context, index2) {
                    return Container(
                      height: 95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  menu[index].foodList[index2].name,
                                  style: kTitleStyle,
                                ),
                                Text(
                                  menu[index].foodList[index2]?.description ??
                                      " ",
                                  style: kSubTitleStyleMenu,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "₹ ${menu[index].foodList[index2].price}",
                                  style: kTitleStyle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          // todo: add button

                          initialAddButton(
                              cartData, menu[index].foodList[index2]),

//                          addButton(cartData, menu[index].foodList[index2]),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
