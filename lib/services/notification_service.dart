import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomFloatingNotification {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4, // Position in the middle of the screen
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.cyan, // Border color
                  width: 2.0, // Border width
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10.0,
                    offset: Offset(0, 6), // Shadow position
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add an app logo here
                  Image.asset(
                    'assets/icons/campus_connect_logo.png', 
                    width: 50.0,
                    height: 50.0,
                  ),
                  SizedBox(width: 15.0), // Space between the logo and the text
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }
}


class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'default_channel_id',
    String channelName = 'Default Channel',
    String channelDescription = 'This is the default channel for notifications.',
    String? sound,
    bool enableVibration = true,
    bool showWhen = true,
    String? icon,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      playSound: sound != null,
      sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
      enableVibration: enableVibration,
      showWhen: showWhen,
      icon: icon,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
