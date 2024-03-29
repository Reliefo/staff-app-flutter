import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/Store/DataStore.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/home/TakeOrders/FoodOrder/foodItems.dart';

class RestaurantMenu extends StatefulWidget {
  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DataStore dataStore = Provider.of<DataStore>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xffF3F3F3),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                color: Colors.white,
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  labelPadding: EdgeInsets.all(0),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: kThemeColor,
                  ),
                  tabs: [
                    Tab(
                      child: Text(
                        "Food Menu",
                        style: kTitleTabStyle,
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Bar Menu",
                        style: kTitleTabStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FoodItemList(
                        menu: dataStore.restaurant.foodMenu,
                      ),
                      FoodItemList(
                        menu: dataStore.restaurant.barMenu,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
