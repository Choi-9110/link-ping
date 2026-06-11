import 'package:flutter/material.dart';

/// Linkku 브랜드킷 v1.0 (DREVV) 디자인 토큰 — 단일 진실 공급원.
///
/// 컬러 **역할은 고정**입니다. 한 화면에서 세 강조색(코랄·민트·퍼플)을
/// 동시에 강조하지 마세요.
/// - 코랄  = 행동 (액션·알람·브랜드·마스코트 바디)
/// - 민트  = 완료·함께·핑 (벨·성공·응원·i의 점)
/// - 퍼플  = 보상 (뱃지·인앱 재화·프리미엄)
///
/// 화면 컬러는 [AppColorTheme]/[ColorThemes]를 통해 쓰고, 여기 토큰은
/// 브랜드 상수(픽셀 음영/하이라이트, 재화 색 등)와 폰트 패밀리 참조용입니다.
class BrandTokens {
  BrandTokens._();

  // ── 핵심 3색 (역할 고정) ──────────────────────────────
  static const Color coral = Color(0xFFFF5A5F); // 액션·알람·브랜드
  static const Color mint = Color(0xFF00D4AA); // 완료·함께·핑·벨
  static const Color purple = Color(0xFF6C5CE7); // 보상·재화·프리미엄

  // ── 픽셀 음영/하이라이트 전용 (UI 사용 금지, 일러스트에만) ──
  static const Color coralShade = Color(0xFFD9434C); // 코랄 음영
  static const Color coralLight = Color(0xFFFF8A8D); // 코랄 하이라이트
  static const Color mintShade = Color(0xFF00A886); // 민트 음영
  static const Color pixelInk = Color(0xFF1C1014); // 픽셀 눈/입 먹색

  // ── 재화(퍼플 오브) 음영 단계 ─────────────────────────
  static const Color purpleHi = Color(0xFFCFC8FF);
  static const Color purpleMid = Color(0xFF9286F0);
  static const Color purpleShade = Color(0xFF5546C8);

  // ── 다크 서피스 (순수 #000 금지 — 특히 앱 아이콘 타일) ──
  static const Color bg = Color(0xFF0E0E11); // 베이스 배경
  static const Color surface = Color(0xFF17171B); // 카드/시트
  static const Color surface2 = Color(0xFF1F1F25); // 밝은 표면
  static const Color line = Color(0xFF2A2A31); // 테두리/구분선
  static const Color iconTile = Color(0xFF17171B); // 앱 아이콘 타일
  static const Color iconTileLine = Color(0xFF26262C); // 아이콘 내부 1px 라인

  // ── 텍스트 ──────────────────────────────────────────
  static const Color ink = Color(0xFFFFFFFF);
  static const Color sub = Color(0xFF8E8E93);
  static const Color dim = Color(0xFF5A5A60);

  // ── 폰트 패밀리 ─────────────────────────────────────
  /// 본문·제목 기본 산스.
  static const String fontSans = 'Pretendard';

  /// 픽셀 악센트 전용 — 스트릭 카운터·뱃지명·시간 표기에만.
  /// 본문에 쓰면 가독성이 무너지므로 금지.
  static const String fontPixel = 'Galmuri11';

  /// 권장 컬러 비율 (다크 62 : 텍스트 22 : 코랄 10 : 민트 6).
  /// 참고용 상수 — 강조색 면적 배분의 기준.
  static const double ratioSurface = 0.62;
  static const double ratioText = 0.22;
  static const double ratioCoral = 0.10;
  static const double ratioMint = 0.06;
}
