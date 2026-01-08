part of '../rich_text.dart';

extension _StringParser on String {
  /// 匹配对齐方式
  Alignment? parseAlignment() {
    return switch (this) {
      'topLeft' => Alignment.topLeft,
      'topCenter' => Alignment.topCenter,
      'topRight' => Alignment.topRight,
      'centerLeft' => Alignment.centerLeft,
      'center' => Alignment.center,
      'centerRight' => Alignment.centerRight,
      'bottomLeft' => Alignment.bottomLeft,
      'bottomCenter' => Alignment.bottomCenter,
      'bottomRight' => Alignment.bottomRight,
      _ => null
    };
  }

  /// 匹配包含颜色的标签
  Color? parseColor() {
    if (startsWith('#')) {
      // 剔除 # 号
      final str = substring(1);
      int? colorInt;
      switch (str.length) {
        case 3:
          String r = str[0], g = str[1], b = str[2];
          colorInt = int.tryParse('FF$r$r$g$g$b$b', radix: 16);
          break;
        case 4:
          String r = str[0], g = str[1], b = str[2], a = str[3];
          colorInt = int.tryParse('$a$a$r$r$g$g$b$b', radix: 16);
          break;
        case 6:
          colorInt = int.tryParse('FF$str', radix: 16);
          break;
        case 8:
          colorInt = int.tryParse(str, radix: 16);
          if (colorInt == null) break;
          colorInt = (colorInt >> 8) | ((colorInt & 0xFF) << 24);
          break;
      }
      return colorInt != null ? Color(colorInt) : null;
    }

    // 这里使用 Material 颜色
    return switch (this) {
      'transparent' => const Color(0x00000000),
      'black' => const Color(0xFF000000),
      'white' => const Color(0xFFFFFFFF),
      'red' => const Color(0xFFF44336),
      'green' => const Color(0xFF4CAF50),
      'blue' => const Color(0xFF2196F3),
      'pink' => const Color(0xFFE91E63),
      'purple' => const Color(0xFF9C27B0),
      'indigo' => const Color(0xFF3F51B5),
      'cyan' => const Color(0xFF00BCD4),
      'teal' => const Color(0xFF009688),
      'lime' => const Color(0xFFCDDC39),
      'yellow' => const Color(0xFFFFEB3B),
      'amber' => const Color(0xFFFFC107),
      'orange' => const Color(0xFFFF9800),
      'brown' => const Color(0xFF795548),
      'grey' => const Color(0xFF9E9E9E),
      _ => AutoRichTextSettings.shared.$colorMap(this),
    };
  }
}

extension _WidgetExt on Widget {
  /// 构建文字块
  WidgetSpan createSpan(
    ui.PlaceholderAlignment? alignment, [
    TextStyle? style,
    TextBaseline? baseline,
  ]) {
    return WidgetSpan(
      style: style,
      alignment: alignment ?? ui.PlaceholderAlignment.baseline,
      baseline: baseline ?? style?.textBaseline ?? TextBaseline.alphabetic,
      child: this,
    );
  }
}
