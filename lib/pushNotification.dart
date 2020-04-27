//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:staffapp/data.dart';
//
//class PushNotificationsManager {
//  final FirebaseMessaging _messaging = new FirebaseMessaging();
//  List<NotificationData> notifications = [];
//
//  printToken() {
//    _messaging.getToken().then((token) {
//      print("token:   $token");
//    });
//  }
//
//  configureFirebaseListeners() {
//    _messaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('on message $message');
//        notifications.add(NotificationData.fromJson(message));
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('on launch $message');
//      },
//    );
//  }
//}
