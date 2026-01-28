import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../data/models/link_reminder.dart';
import 'url_launcher_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// 알림 서비스 초기화
  Future<void> initialize() async {
    if (_initialized) return;

    // 타임존 초기화
    tz_data.initializeTimeZones();

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 초기화
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// 알림 탭 시 처리
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      UrlLauncherService.openUrl(payload);
    }
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    // Android 13+ 권한 요청
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS 권한 요청
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// 링크 알림 스케줄 (다중 시간 지원)
  Future<void> scheduleReminder(LinkReminder link) async {
    // 기존 알림 모두 취소
    await cancelReminder(link.id);

    if (!link.isEnabled) return;

    final androidDetails = AndroidNotificationDetails(
      'linkping_reminders',
      '링크 알림',
      channelDescription: '저장한 링크 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 모든 알림 시간에 대해 스케줄 (기본 시간 + 추가 시간)
    final allTimes = link.allTimes;

    for (int timeIndex = 0; timeIndex < allTimes.length; timeIndex++) {
      final time = allTimes[timeIndex];

      // 선택된 요일마다 알림 스케줄
      for (final day in link.repeatDays) {
        final id = _generateNotificationId(link.id, day, timeIndex);
        final scheduledDate = _nextInstanceOfDayTime(
          day,
          time.hour,
          time.minute,
        );

        await _plugin.zonedSchedule(
          id,
          link.title,
          '탭하여 링크로 이동',
          scheduledDate,
          details,
          payload: link.url,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  /// 알림 취소 (다중 시간 지원 - 최대 10개 시간 슬롯)
  Future<void> cancelReminder(String linkId) async {
    // 모든 요일 × 모든 시간 슬롯의 알림 취소
    for (int day = 0; day <= 6; day++) {
      for (int timeIndex = 0; timeIndex < 10; timeIndex++) {
        final id = _generateNotificationId(linkId, day, timeIndex);
        await _plugin.cancel(id);
      }
    }
  }

  /// 모든 알림 취소
  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }

  /// 알림 ID 생성 (링크 ID + 요일 + 시간 인덱스)
  int _generateNotificationId(String linkId, int dayOfWeek, int timeIndex) {
    // 형식: [linkIdHash 5자리][timeIndex 1자리][dayOfWeek 1자리]
    return linkId.hashCode.abs() % 100000 * 100 + timeIndex * 10 + dayOfWeek;
  }

  /// 다음 해당 요일/시간 계산
  tz.TZDateTime _nextInstanceOfDayTime(int dayOfWeek, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 해당 요일까지 날짜 조정 (0=일, 1=월, ..., 6=토)
    // DateTime.weekday는 1=월, 7=일이므로 변환 필요
    int currentDayOfWeek = now.weekday % 7; // 0=일, 1=월, ..., 6=토로 변환

    int daysUntil = dayOfWeek - currentDayOfWeek;
    if (daysUntil < 0) {
      daysUntil += 7;
    }

    scheduledDate = scheduledDate.add(Duration(days: daysUntil));

    // 오늘이고 이미 지난 시간이면 다음 주로
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  /// 즉시 테스트 알림
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'linkping_test',
      '테스트 알림',
      channelDescription: '테스트용 알림',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0,
      'LinkPing 테스트',
      '알림이 정상적으로 작동합니다!',
      details,
    );
  }
}
