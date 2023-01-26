import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannel {
  static AndroidNotificationChannel importantChannel =
      const AndroidNotificationChannel(
    'important_channel', // id
    'IMPORTANT NOTIFICATION CHANNEL', // title
    description:
        'This channel is used for important notification.', // description
    importance: Importance.max, // importance must be at low or higher level
  );

  static AndroidNotificationChannel importantChannel_2 =
  const AndroidNotificationChannel(
    'important_channel_2', // id
    'IMPORTANT NOTIFICATION CHANNEL', // title
    description:
    'This channel is used for important notification.', // description
    importance: Importance.max, // importance must be at low or higher level
  );

  static AndroidNotificationChannel lowImportantChannel =
      const AndroidNotificationChannel(
    'low_important_channel', // id
    'LOW IMPORTANT NOTIFICATION CHANNEL', // title
    description:
        'This channel is used for not important notification.', // description
    importance: Importance.low, // importance must be at low or higher level
  );
}
