import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staffapp/authentication/loginPage.dart';
import 'package:staffapp/data.dart';

class DrawerMenu extends StatelessWidget {
  final Restaurant restaurant;
  final String staffName;
  final String staffId;
  DrawerMenu({
    this.restaurant,
    this.staffName,
    this.staffId,
  });

  clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children: <Widget>[
              Text(restaurant.name),
              Text("Hey ! $staffName "),
            ],
          ),
        ),

        FlatButton(
          child: Center(
            child: Text('Assigned Tables'),
          ),
          onPressed: () {
//            Navigator.of(context).pop();
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => AssignedTables(
//                  restaurant: restaurant,
//                  staffId: staffId,
//                ),
//              ),
//            );
          },
        ),

        Divider(),

        FlatButton(
          child: Center(
            child: Text('Logout'),
          ),
          onPressed: () {
            clearData();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
        ///////////////////
      ],
    );
  }
}
