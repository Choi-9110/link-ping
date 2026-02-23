import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../data/models/link_reminder.dart';
import 'alarm_sound_service.dart';
import 'auth_service.dart';
import 'badge_service.dart';
import 'firestore_service.dart';
import 'ping_window_service.dart';
import 'url_launcher_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // 액션 ID 상수
  static const String _actionOpenLink = 'open_link';
  static const String _actionCall = 'call';
  static const String _actionSnooze = 'snooze_3min';

  // 카테고리 ID 상수
  static const String _categoryLink = 'link_reminder';
  static const String _categoryPhone = 'phone_reminder';

  /// 알림 서비스 초기화
  Future<void> initialize() async {
    if (_initialized) return;

    // 타임존 초기화 (디바이스 타임존 사용)
    tz_data.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    // Android 설정 (액션 버튼 포함)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정 (액션 카테고리 포함)
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        // 링크 알림 카테고리
        DarwinNotificationCategory(
          _categoryLink,
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              _actionOpenLink,
              '이동하기',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
            DarwinNotificationAction.plain(
              _actionSnooze,
              '3분 후',
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
        // 전화 알림 카테고리
        DarwinNotificationCategory(
          _categoryPhone,
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              _actionCall,
              '전화걸기',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
            DarwinNotificationAction.plain(
              _actionSnooze,
              '3분 후',
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    // 초기화
    await _plugin.initialize(
      InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;

    // 알림 권한 요청
    await requestPermission();
  }

  /// 알림 탭/액션 버튼 처리
  void _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    final actionId = response.actionId;

    // 🔔 3분 후 스누즈 액션 처리
    if (actionId == _actionSnooze) {
      await _handleSnooze(payload);
      return;
    }

    // 알람 응답 시 Ping 윈도우 시작 (응원/약올리기 5분 윈도우)
    await PingWindowService.instance.recordAlarmFired();

    try {
      // payload 형식: {"url": "...", "hour": 7, "minute": 0, "title": "..."}
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final url = data['url'] as String;
      final hour = data['hour'] as int;
      final minute = data['minute'] as int;

      // 스케줄된 시간 계산 (오늘 날짜 + 설정된 시간)
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

      // 만약 현재 시간보다 스케줄 시간이 미래면 (자정 넘어서 탭한 경우) 어제로
      if (scheduledTime.isAfter(now)) {
        scheduledTime = scheduledTime.subtract(const Duration(days: 1));
      }

      // 클릭 기록 및 뱃지 체크
      await BadgeService.instance.recordClick(
        scheduledTime: scheduledTime,
        clickTime: now,
      );

      // 📊 통계 트래킹 (알림 클릭)
      await FirestoreService.instance.trackNotificationClicked(hour: now.hour);

      // tel: URL인 경우 내 번호인지 확인
      if (UrlLauncherService.isPhoneUrl(url)) {
        final myPhoneNumber = await _getMyPhoneNumber();
        if (UrlLauncherService.isMyPhoneNumber(url, myPhoneNumber)) {
          // 내 번호면 전화하지 않고 앱만 열림
          return;
        }
      }

      // URL 열기 (이동하기 / 전화걸기 액션 또는 알림 탭)
      UrlLauncherService.openUrl(url);
    } catch (e) {
      // 기존 형식 (URL만) 호환
      UrlLauncherService.openUrl(payload);
    }
  }

  /// 3분 후 스누즈 처리
  Future<void> _handleSnooze(String payload) async {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final url = data['url'] as String;
      final title = data['title'] as String? ?? 'LinkPing';
      final hour = data['hour'] as int;
      final minute = data['minute'] as int;

      final isPhone = UrlLauncherService.isPhoneUrl(url);

      // 3분 후 알림 스케줄
      final snoozeTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 3));

      final androidDetails = AndroidNotificationDetails(
        'linkping_snooze',
        '스누즈 알림',
        channelDescription: '3분 후 다시 알림',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        actions: isPhone
            ? <AndroidNotificationAction>[
                const AndroidNotificationAction(_actionCall, '전화걸기'),
                const AndroidNotificationAction(_actionSnooze, '3분 후'),
              ]
            : <AndroidNotificationAction>[
                const AndroidNotificationAction(_actionOpenLink, '이동하기'),
                const AndroidNotificationAction(_actionSnooze, '3분 후'),
              ],
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: isPhone ? _categoryPhone : _categoryLink,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 새 payload (시간 정보 유지)
      final newPayload = jsonEncode({
        'url': url,
        'title': title,
        'hour': hour,
        'minute': minute,
      });

      await _plugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch % 100000, // 유니크 ID
        title,
        isPhone ? '탭하여 전화 걸기' : '탭하여 링크로 이동',
        snoozeTime,
        details,
        payload: newPayload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // 스누즈 실패 시 무시
    }
  }

  /// 내 전화번호 가져오기
  Future<String?> _getMyPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    if (user.isAnonymous) {
      // 게스트: 로컬에서 가져오기
      return AuthService.instance.getGuestPhoneNumber();
    } else {
      // 회원: Firestore에서 가져오기
      final profile = await FirestoreService.instance.getUserProfile(user.uid);
      return profile?.phoneNumber;
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

    // 링크별 소리 가져오기 (없으면 전역 설정 사용)
    final soundId = link.soundId ?? AlarmSoundService.instance.getSelectedSoundId();
    final sound = AlarmSoundService.instance.getSoundById(soundId);

    // 사운드 파일이 실제로 존재하는지 확인
    final useCustomSound = sound != null && sound.isAvailable;

    // 전화 vs 링크 구분
    final isPhone = UrlLauncherService.isPhoneUrl(link.url);
    final notificationBody = isPhone ? '탭하여 전화 걸기' : '탭하여 링크로 이동';

    // Android 알림 설정 (액션 버튼 포함)
    final androidDetails = AndroidNotificationDetails(
      'linkping_reminders',
      '링크 알림',
      channelDescription: '저장한 링크 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      sound: useCustomSound
          ? RawResourceAndroidNotificationSound(sound.fileName)
          : null,
      playSound: true,
      // 🔔 액션 버튼 추가
      actions: isPhone
          ? <AndroidNotificationAction>[
              const AndroidNotificationAction(_actionCall, '전화걸기'),
              const AndroidNotificationAction(_actionSnooze, '3분 후'),
            ]
          : <AndroidNotificationAction>[
              const AndroidNotificationAction(_actionOpenLink, '이동하기'),
              const AndroidNotificationAction(_actionSnooze, '3분 후'),
            ],
    );

    // iOS 알림 설정 (카테고리로 액션 버튼 지정)
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: useCustomSound ? '${sound.fileName}.caf' : null,
      // 🔔 카테고리로 액션 버튼 지정
      categoryIdentifier: isPhone ? _categoryPhone : _categoryLink,
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

        // payload에 URL과 시간 정보 포함 (클릭 추적용)
        final payload = jsonEncode({
          'url': link.url,
          'title': link.title,
          'hour': time.hour,
          'minute': time.minute,
        });

        await _plugin.zonedSchedule(
          id,
          link.title,
          notificationBody,
          scheduledDate,
          details,
          payload: payload,
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
