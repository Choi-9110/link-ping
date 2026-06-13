import 'package:flutter/material.dart';

import '../../core/theme/spacing.dart';

/// 다이얼로그 하단 액션 버튼을 항상 같은 너비로(반반) 배치한다.
///
/// AlertDialog의 기본 `actions`(OverflowBar)는 버튼을 우측으로 쏠리게 하고
/// 너비도 제각각이라, 대신 이 위젯을 `actions: [DialogActions(buttons: [...])]`
/// 형태로 넣어 쓴다. 버튼 N개면 1/N씩 균등 분할된다.
///
/// 관례: 버튼은 왼쪽=보조(취소/나중에), 오른쪽=주요(확인/삭제/저장) 순서.
class DialogActions extends StatelessWidget {
  const DialogActions({
    super.key,
    required this.buttons,
    this.spacing = Spacing.sm,
  });

  /// 왼쪽→오른쪽 순서의 버튼들. 보통 2개(취소/확인).
  final List<Widget> buttons;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < buttons.length; i++) {
      if (i > 0) children.add(SizedBox(width: spacing));
      children.add(Expanded(child: buttons[i]));
    }
    // OverflowBar 안에서도 전체 너비를 차지하도록 maxFinite로 고정한다.
    return SizedBox(
      width: double.maxFinite,
      child: Row(children: children),
    );
  }
}
