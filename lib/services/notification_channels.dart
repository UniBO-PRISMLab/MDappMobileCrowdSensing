import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannel {
  static AndroidNotificationChannel backgroundServiceChannel =
      const AndroidNotificationChannel(
    'mcs_background_service', // id
    'MCS BACKGROUND SERVICE', // title
    description:
        'This channel is used for closing campaign notification.', // description
    importance: Importance.max, // importance must be at low or higher level
  );

}
