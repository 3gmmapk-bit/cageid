import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messaging =
      FirebaseMessaging.instance;

  Future<void> initialize() async {
    await messaging.requestPermission();

    final token = await messaging.getToken();

    print('FCM TOKEN: $token');
  }
}