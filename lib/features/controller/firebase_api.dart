import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final navigatorKey = GlobalKey<NavigatorState>();
final localNotification  = FlutterLocalNotificationsPlugin();
final androidChannel = AndroidNotificationChannel("high_importance_channel", "high importance notification",description:"This notification for imaportant" ,importance: Importance.defaultImportance);


class FirebaseApi{


  final firebaseMessaging = FirebaseMessaging.instance;
  Future<void>initialNotification()async{
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print(fcmToken);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    fireStore
        .collection('deviceList').doc(iosInfo.identifierForVendor).set({
      "deviceName":iosInfo.model,
      'fcmToken':fcmToken
    });
    // initLocalNotification();
    initPushNotification();
  }





}

void handleMessage(RemoteMessage? message){
  if(message == null) return;

}

Future initPushNotification()async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
  FirebaseMessaging.onMessage.listen((message) {
    final notification  = message.notification;
    if(notification == null ) return;
    // iosCheckOut(notification.hashCode.toString(), 'high_importance_channel', notification.title.toString(), notification.body.toString());
    androidCheckOut(notification.hashCode.toString(), 'high_importance_channel',notification.title.toString(), notification.body.toString(),jsonEncode(message.toMap()));
    // localNotification.show(notification.hashCode, notification.title, notification.body, NotificationDetails(
    //   android: AndroidNotificationDetails(
    //       androidChannel.id,androidChannel.name,channelDescription: androidChannel.description,
    //     icon: '@mipmap/ic_launcher'
    //   )
    // ),
    //     payload: jsonEncode(message.toMap())
    // );
  });

}

// @pragma('vm:entry-point')
// Future initLocalNotification()async{
//   const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const initializationSettingsIOS = DarwinInitializationSettings(requestSoundPermission: true);
//   const setting = InitializationSettings(android: initializationSettingsAndroid,iOS:initializationSettingsIOS );
//   await localNotification.initialize(setting,
//       onDidReceiveBackgroundNotificationResponse: (mess){
//         print("8398r");
//       },
//       onDidReceiveNotificationResponse: (payLoad){
//         final message = RemoteMessage.fromMap(jsonDecode(payLoad.toString()));
//         print('object');
//         // handleMessage(message);
//       });
//   final platform = localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//   platform?.createNotificationChannel(androidChannel);
// }


@pragma('vm:entry-point')
Future<void> handleBackGroundMessage(RemoteMessage message) async {
  print("title : ${message.notification?.title}");
  print("Body : ${message.notification?.body}");
  print("payLoad : ${message.data}");

}


Future androidCheckOut(String notificationId,String channelName,String title,String body,String payLoad){
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = DarwinInitializationSettings(requestSoundPermission: true);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse:(response){
    print(response);
    navigatorKey.currentState?.pushNamed('/', arguments: response.payload);
  });
  var androidPlatformChannelSpecifics =   AndroidNotificationDetails(
      notificationId,channelName,channelDescription: 'background',
      playSound: true, importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics =
  const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  return flutterLocalNotificationsPlugin.show(1, title, body, platformChannelSpecifics,payload: payLoad);

}




