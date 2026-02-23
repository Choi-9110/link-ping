import 'package:flutter/widgets.dart';
import '../../data/models/badge.dart';
import '../../l10n/app_localizations.dart';

/// BadgeType에 대한 지역화된 이름과 설명을 제공하는 확장
extension BadgeTypeLocalization on BadgeType {
  /// 지역화된 뱃지 이름을 반환
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case BadgeType.streak3:
        return l10n.badge_streak3_name;
      case BadgeType.streak7:
        return l10n.badge_streak7_name;
      case BadgeType.streak30:
        return l10n.badge_streak30_name;
      case BadgeType.streak100:
        return l10n.badge_streak100_name;
      case BadgeType.marathon:
        return l10n.badge_marathon_name;
      case BadgeType.comeback:
        return l10n.badge_comeback_name;
      case BadgeType.quickDraw:
        return l10n.badge_quickDraw_name;
      case BadgeType.speedDemon:
        return l10n.badge_speedDemon_name;
      case BadgeType.quickResponse:
        return l10n.badge_quickResponse_name;
      case BadgeType.morningGlory:
        return l10n.badge_morningGlory_name;
      case BadgeType.earlyBird:
        return l10n.badge_earlyBird_name;
      case BadgeType.nightOwl:
        return l10n.badge_nightOwl_name;
      case BadgeType.nightShift:
        return l10n.badge_nightShift_name;
      case BadgeType.perfectWeek:
        return l10n.badge_perfectWeek_name;
      case BadgeType.perfectMonth:
        return l10n.badge_perfectMonth_name;
      case BadgeType.perfectionist:
        return l10n.badge_perfectionist_name;
      case BadgeType.firstCheer:
        return l10n.badge_firstCheer_name;
      case BadgeType.cheerLeader:
        return l10n.badge_cheerLeader_name;
      case BadgeType.firstPoke:
        return l10n.badge_firstPoke_name;
      case BadgeType.poker:
        return l10n.badge_poker_name;
      case BadgeType.socialButterfly:
        return l10n.badge_socialButterfly_name;
      case BadgeType.firstLink:
        return l10n.badge_firstLink_name;
      case BadgeType.linkCollector:
        return l10n.badge_linkCollector_name;
      case BadgeType.linkMaster:
        return l10n.badge_linkMaster_name;
      case BadgeType.hotLink:
        return l10n.badge_hotLink_name;
      case BadgeType.variety:
        return l10n.badge_variety_name;
      case BadgeType.founder:
        return l10n.badge_founder_name;
      case BadgeType.premium:
        return l10n.badge_premium_name;
      case BadgeType.badgeCollector:
        return l10n.badge_badgeCollector_name;
      case BadgeType.cloudSynced:
        return l10n.badge_cloudSynced_name;
    }
  }

  /// 지역화된 뱃지 설명을 반환
  String localizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case BadgeType.streak3:
        return l10n.badge_streak3_desc;
      case BadgeType.streak7:
        return l10n.badge_streak7_desc;
      case BadgeType.streak30:
        return l10n.badge_streak30_desc;
      case BadgeType.streak100:
        return l10n.badge_streak100_desc;
      case BadgeType.marathon:
        return l10n.badge_marathon_desc;
      case BadgeType.comeback:
        return l10n.badge_comeback_desc;
      case BadgeType.quickDraw:
        return l10n.badge_quickDraw_desc;
      case BadgeType.speedDemon:
        return l10n.badge_speedDemon_desc;
      case BadgeType.quickResponse:
        return l10n.badge_quickResponse_desc;
      case BadgeType.morningGlory:
        return l10n.badge_morningGlory_desc;
      case BadgeType.earlyBird:
        return l10n.badge_earlyBird_desc;
      case BadgeType.nightOwl:
        return l10n.badge_nightOwl_desc;
      case BadgeType.nightShift:
        return l10n.badge_nightShift_desc;
      case BadgeType.perfectWeek:
        return l10n.badge_perfectWeek_desc;
      case BadgeType.perfectMonth:
        return l10n.badge_perfectMonth_desc;
      case BadgeType.perfectionist:
        return l10n.badge_perfectionist_desc;
      case BadgeType.firstCheer:
        return l10n.badge_firstCheer_desc;
      case BadgeType.cheerLeader:
        return l10n.badge_cheerLeader_desc;
      case BadgeType.firstPoke:
        return l10n.badge_firstPoke_desc;
      case BadgeType.poker:
        return l10n.badge_poker_desc;
      case BadgeType.socialButterfly:
        return l10n.badge_socialButterfly_desc;
      case BadgeType.firstLink:
        return l10n.badge_firstLink_desc;
      case BadgeType.linkCollector:
        return l10n.badge_linkCollector_desc;
      case BadgeType.linkMaster:
        return l10n.badge_linkMaster_desc;
      case BadgeType.hotLink:
        return l10n.badge_hotLink_desc;
      case BadgeType.variety:
        return l10n.badge_variety_desc;
      case BadgeType.founder:
        return l10n.badge_founder_desc;
      case BadgeType.premium:
        return l10n.badge_premium_desc;
      case BadgeType.badgeCollector:
        return l10n.badge_badgeCollector_desc;
      case BadgeType.cloudSynced:
        return l10n.badge_cloudSynced_desc;
    }
  }
}
