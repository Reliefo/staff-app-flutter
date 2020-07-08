//class NotificationData {
//  List<PickupNotification> pickupNotification;
//  List<AssistanceNotification> assistanceNotification;
//
//  NotificationData({
//    this.pickupNotification,
//    this.assistanceNotification,
//  });
//
//  NotificationData.fromJson(Map<String, dynamic> json) {
//    print("here reciving data");
//    print(json);
//
//    pickupNotification = json["notification"]["title"];
//
//    assistanceNotification = json["notification"]["body"];
//  }
//}
//
////"table": tableName,
////"food": foodName,
////"timestamp": updateData["timestamp"],
////"request_type": updateData["request_type"],
////"food_id": updateData["food_id"],
////"type": updateData["type"],
////"order_id": updateData["order_id"],
////"table_order_id": updateData["table_order_id"],
//class PickupNotification {
//  String foodName;
//  String table;
//  String pickupItem;
//  String collectingCounter;
//  String orderedBy;
//  String timestamp;
//  String requestType;
//}

class Restaurant {
  String oid;
  String name;
  String restaurantId;
  String address;
  List<Category> foodMenu;
  List<Category> barMenu;
  List<Tables> tables;
  List<Staff> staff;
  List<TableOrder> tableOrders;
  List<AssistanceRequest> assistanceRequests;

  Restaurant({
    this.oid,
    this.name,
    this.restaurantId,
    this.address,
    this.foodMenu,
    this.barMenu,
    this.tables,
    this.staff,
    this.tableOrders,
    this.assistanceRequests,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }
//    address = json['address'];
    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['restaurant_id'] != null) {
      restaurantId = json['restaurant_id'];
    }

    //todo: add restaurant address if present

    print("hhjhk");
    if (json['food_menu'].isNotEmpty) {
      foodMenu = new List<Category>();
      json['food_menu'].forEach((v) {
        foodMenu.add(new Category.fromJson(v));
      });
    }
//    print(json['bar_menu']);
    if (json['bar_menu'].isNotEmpty) {
      barMenu = new List<Category>();
      json['bar_menu'].forEach((v) {
        barMenu.add(new Category.fromJson(v));
      });
    }
    print("hhjhk 333");

    if (json['staff'].isNotEmpty) {
      staff = new List<Staff>();
      json['staff'].forEach((v) {
        staff.add(new Staff.fromJson(v));
      });
    }

    if (json['tables'].isNotEmpty) {
      tables = new List<Tables>();

      json['tables'].forEach((table) {
        tables.add(
          new Tables.fromRestJson(table, this.staff),
        );
      });
    }
    print("hhjhk klk");

    if (json['table_orders'].isNotEmpty) {
      tableOrders = new List<TableOrder>();
      json['table_orders'].forEach((v) {
        tableOrders.add(new TableOrder.fromJson(v));
      });
    }
    print("hhjhk dffg");

    if (json['assistance_reqs'].isNotEmpty) {
      assistanceRequests = new List<AssistanceRequest>();
      json['assistance_reqs'].forEach((v) {
        assistanceRequests.add(new AssistanceRequest.fromJson(v));
      });
    }
  }
  addTableDetails(data) {
    if (this.tables == null) {
      this.tables = new List<Tables>();
    }

    data.forEach((v) {
      this.tables.add(new Tables.add(v));
    });
  }

  addStaffDetails(data) {
    if (this.staff == null) {
//      print('here');
      this.staff = new List<Staff>();
    }
    data.forEach((v) {
//      print(v);
      this.staff.add(new Staff.addConfig(v));
    });
  }

  addFoodMenuCategory(category) {
    if (this.foodMenu == null) {
      this.foodMenu = new List<Category>();
    }
    this.foodMenu.add(new Category.addConfig(category));
  }

  addBarMenuCategory(category) {
    if (this.barMenu == null) {
      this.barMenu = new List<Category>();
    }
    this.barMenu.add(new Category.addConfig(category));
  }
}

class Tables {
  String oid;
  String name;
  String seats;
  List<Staff> staff;
  List<String> users; //todo: add scanned user details to table object

  List<TableOrder> tableOrders;
  List<AssistanceRequest> tableAssistanceRequest;

//  List<TableOrder> tableQueuedOrders = [];
//  List<TableOrder> tableCookingOrders = [];
//  List<TableOrder> tableCompletedOrders = [];
  int queueCount = 0;
  int cookingCount = 0;
  int completedCount = 0;

  Tables({
    this.oid,
    this.name,
    this.seats,
    this.staff,
    this.users,
    this.tableOrders,
    this.tableAssistanceRequest,
//    this.tableQueuedOrders,
//    this.tableCookingOrders,
//    this.tableCompletedOrders,
    this.queueCount,
    this.cookingCount,
    this.completedCount,
  });

  Tables.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }

    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['seats'] != null) {
      seats = json['seats'].toString();
    }

    if (json['staff'].isNotEmpty) {
      staff = new List<Staff>();
      json['staff'].forEach((v) {
        staff.add(v['\$oid']);
      });
    }

    if (json['users'].isNotEmpty) {
      users = new List<String>();
      json['users'].forEach((v) {
        users.add(v['\$oid']);
      });
    }

    if (json['table_orders'].isNotEmpty) {
      tableOrders = new List<TableOrder>();
      json['table_orders'].forEach((v) {
        tableOrders.add(new TableOrder.fromJson(v));
      });
    }

    if (json['assistance_reqs'].isNotEmpty) {
      tableAssistanceRequest = new List<AssistanceRequest>();
      json['assistance_reqs'].forEach((v) {
        tableAssistanceRequest.add(new AssistanceRequest.fromJson(v));
      });
    }
//    tableQueuedOrders = new List<TableOrder>();
//    json['qd_tableorders'].forEach((v) {
//      tableQueuedOrders.add(new TableOrder.fromJson(v));
//    });
//
//    tableCookingOrders = new List<TableOrder>();
//    json['cook_tableorders'].forEach((v) {
//      tableCookingOrders.add(new TableOrder.fromJson(v));
//    });
//
//    tableCompletedOrders = new List<TableOrder>();
//    json['com_tableorders'].forEach((v) {
//      tableCompletedOrders.add(new TableOrder.fromJson(v));
//    });
  }

  Tables.fromRestJson(Map<String, dynamic> json, List<Staff> listStaff) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }

    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['seats'] != null) {
      seats = json['seats'].toString();
    }

    if (json['staff'].isNotEmpty) {
      staff = new List<Staff>();
      json['staff'].forEach((tableStaffId) {
        listStaff.forEach((restStaff) {
          if (restStaff.oid == tableStaffId["\$oid"]) {
            staff.add(restStaff);
          }
        });
      });
    }

    if (json['users'].isNotEmpty) {
      users = new List<String>();
      json['users'].forEach((v) {
        users.add(v['\$oid']);
      });
    }

    if (json['table_orders'].isNotEmpty) {
      tableOrders = new List<TableOrder>();
      json['table_orders'].forEach((v) {
        tableOrders.add(new TableOrder.fromJson(v));
      });
    }

    if (json['assistance_reqs'].isNotEmpty) {
      tableAssistanceRequest = new List<AssistanceRequest>();
      json['assistance_reqs'].forEach((v) {
        tableAssistanceRequest.add(new AssistanceRequest.fromJson(v));
      });
    }
//    tableQueuedOrders = new List<TableOrder>();
//    json['qd_tableorders'].forEach((v) {
//      tableQueuedOrders.add(new TableOrder.fromJson(v));
//    });
//
//    tableCookingOrders = new List<TableOrder>();
//    json['cook_tableorders'].forEach((v) {
//      tableCookingOrders.add(new TableOrder.fromJson(v));
//    });
//
//    tableCompletedOrders = new List<TableOrder>();
//    json['com_tableorders'].forEach((v) {
//      tableCompletedOrders.add(new TableOrder.fromJson(v));
//    });
  }

  addTableStaff(Staff selectedStaff) {
    print(selectedStaff);
    if (this.staff == null) {
      this.staff = new List<Staff>();
    }
    this.staff.add(selectedStaff);
  }

  Tables.add(table) {
    oid = table['table_id'];
    name = table['name'];
    seats = table['seats'];
  }

  updateOrderCount(queue, cooking, completed) {
//    print("from update count");
//    print(queue);
//    print(cooking);
//    print(completed);
    this.queueCount = this.queueCount + queue;
    this.cookingCount = this.cookingCount + cooking;
    this.completedCount = this.completedCount + completed;
  }
}

//I/flutter ( 4158): _id
//I/flutter ( 4158): name
//I/flutter ( 4158): requests_queue
//I/flutter ( 4158): assistance_history
//I/flutter ( 4158): rej_assistance_history
//I/flutter ( 4158): order_history
//I/flutter ( 4158): rej_order_history

class Staff {
  String oid;
  String name;
  var requestsQueue;
  List<AssistanceRequest> assistanceHistory;
  List<AssistanceRequest> rejAssistanceHistory;
  List<OrderHistory> orderHistory;
  List<OrderHistory> rejOrderHistory;

  Staff({
    this.name,
    this.oid,
    this.assistanceHistory,
    this.orderHistory,
    this.rejAssistanceHistory,
    this.rejOrderHistory,
  });

  Staff.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }

    if (json['name'] != null) {
      name = json['name'];
    }

//    if (json['assistance_history'].isNotEmpty) {
//      //todo:check
//      assistanceHistory = new List<AssistanceRequest>();
//      json['assistance_history'].forEach((v) {
//        assistanceHistory.add(new AssistanceRequest.fromJson(v));
//      });
//    }
//    if (json['rej_assistance_history'].isNotEmpty) {
//      //todo:check
//      rejAssistanceHistory = new List<AssistanceRequest>();
//      json['rej_assistance_history'].forEach((v) {
//        rejAssistanceHistory.add(new AssistanceRequest.fromJson(v));
//      });
//    }
//    if (json['order_history'] != null) {
//      //todo:check
//      orderHistory = new List<OrderHistory>();
//      json['order_history'].forEach((v) {
//        orderHistory.add(new OrderHistory.fromJson(v));
//      });
//    }
//
//    if (json['rej_order_history'] != null) {
//      //todo:check
//      rejOrderHistory = new List<OrderHistory>();
//      json['rej_order_history'].forEach((v) {
//        rejOrderHistory.add(new OrderHistory.fromJson(v));
//      });
//    }
  }

  addStaff(staff) {
//    print(staff.oid);
//    print('ading staff f');
    oid = staff.oid;
    name = staff.name;
  }

  Staff.addConfig(staff) {
    oid = staff['staff_id'];
    name = staff['name'];
  }
}

class Category {
  String oid;
  String name;
  String description;
  List<MenuFoodItem> foodList;

  Category({
    this.oid,
    this.name,
    this.description,
    this.foodList,
  });

  Category.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['description'] != null) {
      description = json['description'];
    }

    if (json['food_list'] != null) {
      foodList = new List<MenuFoodItem>();
      json['food_list'].forEach((v) {
        foodList.add(new MenuFoodItem.fromJson(v));
      });
    }
  }
  Category.addConfig(category) {
    oid = category['category_id'];
    name = category['name'];
    description = category['description'];

    print('added to category');
  }

  addFoodItem(foodItem) {
    if (this.foodList == null) {
      this.foodList = new List<MenuFoodItem>();
    }

    this.foodList.add(MenuFoodItem.addFood(foodItem));
  }

//
//      food_dict: {name: new food, description: tyukk, price: 45p, food_options: {options: {},
//      choices: []}, food_id: 5e949ed8fe4ce65500586c29}

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['description'] = this.description;
//    if (this.food_list != null) {
//      data['food_list'] = this.foodlist.map((v) => v.toJson()).toList();
//    }
//    data['name'] = this.name;
//
//    return data;
//  }
}

class MenuFoodItem {
  String oid;
  String name;
  String description;
  String price;
  List<String> tags;
  FoodOption foodOption;

  MenuFoodItem({
    this.oid,
    this.name,
    this.description,
    this.price,
    this.tags,
    this.foodOption,
  });

  MenuFoodItem.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }

    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['description'] != null) {
      description = json['description'];
    }

    if (json['price'] != null) {
      price = json['price'];
    }

    if (json['tags'] != null) {
      tags = new List<String>();
      json['tags'].forEach((v) {
        tags.add(v);
      });
    }

    if (json['food_options'] != null) {
      foodOption = new FoodOption.fromJson(json['food_options']);
    }
  }

  MenuFoodItem.addFood(food) {
    this.oid = food['food_id'];
    this.name = food['name'];
    this.description = food['description'];
    this.price = food['price'];
    this.foodOption = new FoodOption.fromJson(food['food_options']);
    print('food item added');
  }
}

class FoodOption {
  List<Map<String, dynamic>> options;
  List<String> choices;

  FoodOption({
    this.options,
    this.choices,
  });

  FoodOption.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      options = new List<Map<String, dynamic>>();
      json['options'].forEach((option) {
        options.add(option);
      });
      //Todo: check
    }

    if (json['choices'] != null) {
      choices = new List<String>();
      json['choices'].forEach((v) {
        choices.add(v);
      });
    }
  }
}

class TableOrder {
  String oId;
  String table;
  String tableId;
  List<Order> orders;
  String status = 'queued';

  DateTime timeStamp;

  TableOrder({
    this.oId,
    this.table,
    this.tableId,
    this.orders,
    this.status,
    this.timeStamp,
  });

  TableOrder.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oId = json['_id']['\$oid'];
    }

    if (json['table'] != null) {
      table = json['table'];
    }

    if (json['table_id'] != null) {
      tableId = json['table_id'];
    }

    if (json['orders'] != null) {
      orders = new List<Order>();
      json['orders'].forEach((v) {
        orders.add(new Order.fromJson(v));
      });
    }

    if (json['timestamp'] != null) {
      timeStamp = DateTime.parse(json['timestamp']);
    }
  }

  TableOrder.fromJsonNew(Map<String, dynamic> json) {
    oId = json['oId'];

    table = json['table'];
    tableId = json['table_id'];
    status = json['status'];
    timeStamp = json['timestamp'];
  }
  addFirstOrder(Order order) {
    this.orders = new List<Order>();
    this.orders.add(order);
  }

  addOrder(Order order) {
    this.orders.add(order);
  }

  cleanOrders(String orderId) {
    var delete = false;
    this.orders.forEach((order) {
      if (order.oId == orderId) {
        if (order.foodList.length == 0) delete = true;
      }
    });
    if (delete) this.orders.removeWhere((order) => order.oId == orderId);
  }

  bool selfDestruct() {
    return this.orders.isEmpty;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oId'] = this.oId;
    data['table'] = this.table;
    data['status'] = this.status;
    data['timestamp'] = this.timeStamp;
    return data;
  }
}

class Order {
  String oId;
  String placedBy;
  List<FoodItem> foodList;
  String status;

  Order({
    this.oId,
    this.placedBy,
    this.foodList,
    this.status,
  });

  Order.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oId = json['_id']['\$oid'];
    }

    if (json['placed_by']['\$oid'] != null) {
      placedBy = json['placed_by']['\$oid'];
    }

    if (json['food_list'] != null) {
      foodList = new List<FoodItem>();
      json['food_list'].forEach((v) {
        foodList.add(FoodItem.fromJson(v));
      });
    }

    if (json['status'] != null) {
      placedBy = json['placed_by']['\$oid'];
    }
  }

  Order.fromJsonNew(Map<String, dynamic> json) {
    placedBy = json['placed_by'];
    oId = json['oId'];
    status = json['status'];
  }
  addFirstFood(FoodItem food) {
    this.foodList = new List<FoodItem>();
    this.foodList.add(food);
  }

  addFood(FoodItem food) {
    this.foodList.add(food);
  }

  removeFoodItem(String foodId) {
    this.foodList.removeWhere((food) => food.foodId == foodId);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oId'] = this.oId;
    data['placed_by'] = this.placedBy;
    data['status'] = this.status;
    return data;
  }
}

class FoodItem {
  String foodId;
  String name;
  String description;
  String price;
  String instructions;
  int quantity;
  String status;
  List<String> customization;

  FoodItem(
      {this.foodId,
      this.name,
      this.description,
      this.price,
      this.instructions,
      this.quantity,
      this.status,
      this.customization});

  FoodItem.fromJson(Map<String, dynamic> json) {
    if (json['food_id'] != null) {
      foodId = json['food_id'];
    }

    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['description'] != null) {
      description = json['description'];
    }

    if (json['price'] != null) {
      price = json['price'];
    }

    if (json['instructions'] != null) {
      instructions = json['instructions'];
    }

    if (json['quantity'] != null) {
      quantity = json['quantity'];
    }

    if (json['status'] != null) {
      status = json['status'];
    }

    if (json['customization'] != null) {
      customization = new List<String>();
      json['customization']?.forEach((custom) {
        if (custom['customization_type'] == 'choices') {
          custom['list_of_options']?.forEach((choice) {
            customization.add(choice);
          });
        }
        if (custom['customization_type'] == 'options') {
          print("hey");
        }
        if (custom['customization_type'] == 'add_ons') {
          custom['list_of_options']?.forEach((addOn) {
            customization.add(addOn['name']);
          });
        }
      });
    }
  }

  FoodItem.addMenuFoodItem(MenuFoodItem foodItem) {
    //todo: take instruction and quantity

    this.foodId = foodItem.oid;
    this.name = foodItem.name;
    this.description = foodItem.description;
    this.price = foodItem.price;
    this.quantity = 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['name'] = this.name;
    data['price'] = this.price;
    data['food_id'] = this.foodId;
    data['quantity'] = this.quantity;
    data['instructions'] = this.instructions;
    return data;
  }
}

// class for assistance requests

class AssistanceRequest {
  String table;
  String tableId;
  String assistanceType;
  DateTime timeStamp;
  Map<String, String> acceptedBy;
  String userId;
  String user;
  String assistanceReqId;
  String requestType;
  String status;

  AssistanceRequest({
    this.table,
    this.tableId,
    this.assistanceType,
    this.timeStamp,
    this.acceptedBy,
    this.userId,
    this.user,
    this.assistanceReqId,
    this.requestType,
    this.status,
  });

  AssistanceRequest.fromJson(Map<String, dynamic> json) {
    if (json['table'] != null) {
      table = json['table'];
    }
    if (json['table_id'] != null) {
      tableId = json['table_id'];
    }
    if (json['assistance_type'] != null) {
      assistanceType = json['assistance_type'];
    }
    if (json['timestamp'] != null) {
      timeStamp = DateTime.parse(json['timestamp']);
    }
//    print("while adding");
    if (json['accepted_by'].isNotEmpty) {
      acceptedBy = {
        "staff_name": json['accepted_by']['staff_name'],
        "staff_id": json['accepted_by']['staff_id']
      };
    }
//    print("while adding 1");
    if (json['user_id'] != null) {
      userId = json['user_id'];
    }
    if (json['user'] != null) {
      user = json['user'];
    }
    if (json['assistance_req_id'] != null) {
      assistanceReqId = json['assistance_req_id'];
    }
    if (json['request_type'] != null) {
      requestType = json['request_type'];
    }
    if (json['status'] != null) {
      status = json['status'];
    }
  }
}

class OrderHistory {
  String tableOrderId;
  String orderId;
  String foodId;
  DateTime timeStamp;

  OrderHistory({
    this.tableOrderId,
    this.orderId,
    this.foodId,
    this.timeStamp,
  });

  OrderHistory.fromJson(Map<String, dynamic> json) {
    print("order history");
    if (json['table_order_id'] != null) {
      tableOrderId = json['table_order_id'];
    }
    if (json['order_id'] != null) {
      orderId = json['order_id'];
    }

    if (json['food_id'] != null) {
      foodId = json['food_id'];
    }
    if (json['timestamp'] != null) {
      timeStamp = DateTime.parse(json['timestamp']);
    }
  }
}
