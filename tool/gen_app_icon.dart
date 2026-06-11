// Linkku 앱 아이콘 생성기.
//
// `assets/linkku-logo-assets/linkku-appicon.svg`(픽셀 사각형 모음)을 파싱해
// 1024×1024 PNG(`assets/app_icon.png`)로 굽습니다. 모서리 라운드는 OS가
// 적용하므로 사각으로 출력합니다.
//
// 실행: dart run tool/gen_app_icon.dart
import 'dart:io';

import 'package:image/image.dart' as img;

String? _attr(String name, String s) =>
    RegExp('$name="([^"]*)"').firstMatch(s)?.group(1);

img.Color _hex(String hex) {
  final h = hex.replaceAll('#', '');
  return img.ColorRgb8(
    int.parse(h.substring(0, 2), radix: 16),
    int.parse(h.substring(2, 4), radix: 16),
    int.parse(h.substring(4, 6), radix: 16),
  );
}

void main() {
  const src = 'assets/linkku-logo-assets/linkku-appicon.svg';
  const out = 'assets/app_icon.png';

  final svg = File(src).readAsStringSync();
  final image = img.Image(width: 1024, height: 1024, numChannels: 4);

  for (final m in RegExp(r'<rect([^>]*)/>').allMatches(svg)) {
    final s = m.group(1)!;
    final fill = _attr('fill', s);
    if (fill == null || fill == 'none') continue; // 외곽 스트로크 가이드 건너뜀
    final x = double.parse(_attr('x', s) ?? '0').round();
    final y = double.parse(_attr('y', s) ?? '0').round();
    final w = double.parse(_attr('width', s)!).round();
    final h = double.parse(_attr('height', s)!).round();
    img.fillRect(
      image,
      x1: x,
      y1: y,
      x2: x + w - 1,
      y2: y + h - 1,
      color: _hex(fill),
    );
  }

  File(out).writeAsBytesSync(img.encodePng(image));
  stdout.writeln('Wrote $out (1024x1024)');
}
