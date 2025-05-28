import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//import 'package:flutter_native_timezone/flutter_native_timezone.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'brainace_channel_name',
    'BrainAce.pro',
    //channelDescription: 'your_channel_description',
    //icon: "@drawable/notification",
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  static const DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails(
    interruptionLevel: InterruptionLevel.timeSensitive,
    presentSound: true,
  );

  static const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iOSNotificationDetails,
  );

  static Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
    print('Notification receive');
    print(['onDidReceiveNotificationResponse', notificationResponse.actionId]);
  }

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/notification');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveBackgroundNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
      );
    } catch (e) {
      print('Error initializing notifications: $e');
    }
    // app_icon needs to be a added as a drawable resource to the
    // Android head project

    tz.initializeTimeZones();
    final String currentTimeZone = DateTime.now().timeZoneName;
    //print("CurrentTimeZone: ${currentTimeZone}");

    //String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    //print("TimeZoneName: ${timeZoneName}");
    // tz.setLocalLocation(tz.getLocation("Europe/Warsaw"));
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
  }

  static Future<void> showInstantNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'instant_notification',
    );
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime selectedTime) async {
    if (selectedTime.isBefore(DateTime.now())) {
      selectedTime = selectedTime.add(const Duration(days: 1));
    }
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(selectedTime, tz.local);
    print('TIME SCHEDULED: $scheduledTime');
    print('TIME NOW: ${DateTime.now()}');

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        //matchDateTimeComponents: DateTimeComponents.time,
        // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );

      print('Notification scheduled successfully');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  static Future<bool> isNotificationScheduled(int id) async {
    final List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var request in pendingNotificationRequests) {
      if (request.id == id) {
        return true;
      }
    }
    return false;
  }

  static Future<void> scheduleAllNotifications() async {
    if (!(await isNotificationScheduled(40))) {
      for (int i = 0; i < rotatingNotifications.length; i++) {
        DateTime now = DateTime.now();
        DateTime selectedTime = DateTime(now.year, now.month, now.day + i + 1, 7, 0); // Next day at 7 a.m.
        scheduleNotification(i + 30, rotatingNotifications[i]['title']!, rotatingNotifications[i]['body']!, selectedTime);
      }
      for (int i = rotatingNotifications.length - 1; i >= 0; i--) {
        DateTime now = DateTime.now();
        DateTime selectedTime = DateTime(now.year, now.month, now.day + i + 1, 20, 0); // Next day at 8 pm
        scheduleNotification(i + 30, rotatingNotifications[i]['title']!, rotatingNotifications[i]['body']!, selectedTime);
      }
    }
  }

  static final List<Map<String, String>> rotatingNotifications = [
    {
      'title': 'BrainAce.pro',
      'body': '"If it were easy, then everyone would do it." - Weronika Sioda',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Strive for continuous improvement, instead of perfection." - Kim Collins',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"One can always improve." - BrainAce',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Some people spend their entire lives waiting for the time to be right to make an improvement." - James Clear',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Be the designer of your world and not merely the consumer of it." - James Clear',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Habits are the compound interest of self-improvement." - James Clear',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Goals are good for setting a direction, but systems are best for making progress." - James Clear',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"You should be far more concerned with your current trajectory than with your current results." - James Clear',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Only fools reach the top." - BrainAce',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Learning is a lifelong process." - Peter Drucker',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Live as if you were to die tomorrow. Learn as if you were to live forever." - Mahatma Gandhi',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Tell me and I forget, teach me and I may remember, involve me and I learn." - Benjamin Franklin',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Anyone who stops learning is old, whether at twenty or eighty." - Henry Ford',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"I never dreamt of success. I worked for it." - Estée Lauder',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Success is the sum of small efforts, repeated day in and day out." - Robert Collier',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"The most certain way to succeed is always to try just one more time." - Thomas Edison',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"It does not matter how slowly you go so long as you do not stop." - Confucius',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Continuous effort - not strength or intelligence - is the key to unlocking our potential." - Winston Churchill',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"Discipline is choosing between what you want now and what you want most." - Augusta F. Kantra',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"The way to get started is to quit talking and begin doing." - Walt Disney',
    },
    {
      'title': 'BrainAce.pro',
      'body': '"The future depends on what you do today." - Mahatma Gandhi',
    },
    {
      'title': 'BrainAce.pro',
      'body': "\"I'm a great believer in luck, and I find the harder I work the more I have of it.\" - Thomas Jefferson",
    },
    {
      'title': 'BrainAce.pro',
      'body': 'We invite you to practice your brain today.',
    },
    {
      'title': 'BrainAce.pro',
      'body': 'One day or day one.',
    },
    {
      'title': 'BrainAce.pro',
      'body': "It's never too late to start.",
    },
    {
      'title': 'BrainAce.pro',
      'body': 'We would be exceedingly happy if you could use our app today :).',
    },
    {
      'title': 'BrainAce.pro',
      'body': 'Time is like the sun - always there, just not always seen.',
    },
    {
      'title': 'BrainAce.pro',
      'body': "These notifications don't seem to be working ... Ahh... Life.",
    },
    {
      'title': 'BrainAce.pro',
      'body': 'We would appreciate it if you used the app a bit.',
    },
    {
      'title': 'BrainAce.pro',
      'body': 'We suggest you practice your brain a bit - you know - to be smarter.',
    }
  ];
}
