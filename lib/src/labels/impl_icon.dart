part of '../rich_text.dart';

/// Font Icon 字体图标
class _IconData {
  const _IconData(this.code, this.fontFamily);

  /// 字符编码
  final int code;

  /// 对应图标字体
  final String fontFamily;

  /// 解析参数
  static _IconData parse(_Key key, String origin, String value) {
    int? code;
    String? fontFamily;

    final blocks = _ArgsKeyValues.parseAll(origin, value, false);
    for (final block in blocks) {
      final key = block.key;
      final val = block.values.first;

      if (block.values.length > 1) {
        throw _MakeAttributeError('$origin invalid argument');
      }

      switch (key) {
        case 'code':
          if (code != null) throw _MakeElementError('$origin duplicate argument');
          code = int.tryParse(val);
          if (code == null) throw _MakeElementError('$origin invalid code argument');
          break;

        case 'font-family':
          if (fontFamily != null) throw _MakeElementError('$origin duplicate argument');
          fontFamily = val;
          if (fontFamily.isEmpty) throw _MakeElementError('$origin invalid font family');
          break;
      }
    }

    if (code == null) {
      throw _MakeElementError('$origin missing code argument');
    }

    if (fontFamily == null) {
      throw _MakeElementError('$origin missing font family argument');
    }

    return _IconData(code, fontFamily);
  }
}

class _IconElement extends _Element<_IconData> {
  const _IconElement(super.key, super.value);

  @override
  InlineSpan makeSpan(TextStyle style, ui.PlaceholderAlignment? alignment, OnRefCallback ref) {
    final ts = style.copyWith(fontFamily: value.fontFamily);
    final iconStr = String.fromCharCode(value.code);
    final baseline = style.textBaseline;
    return alignment == null
        ? TextSpan(text: iconStr, style: ts)
        : Text(iconStr, style: ts).createSpan(alignment, null, baseline);
  }

  /// 匹配字体图标标签
  static _Element make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeElementError('<${key.keyword}/> missing argument');
    return _IconElement(key, _IconData.parse(key, origin, value));
  }
}
