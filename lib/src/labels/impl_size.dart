part of '../rich_text.dart';

/// 计算字体大小
typedef _ComputeFontSize = double Function(double fontSize);

/// 大小属性
class _SizeAttribute extends _Attribute<_ComputeFontSize> {
  const _SizeAttribute(super.key, super.value);

  @override
  void merge(_AttributeValue val, TextStyle style) {
    val.fontSize = value(val.fontSize ?? style.fontSize ?? 14.0);
  }

  static _Attribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<size> missing argument');

    // 解析字体大小
    double parse(String value) {
      final v = double.tryParse(value);
      if (v == null) throw _MakeAttributeError('$origin invalid argument');
      return v;
    }

    var size = 0.0, scale = 1.0;
    if (value.startsWith('+')) {
      size = parse(value.substring(1));
    } else if (value.startsWith('-')) {
      size = -parse(value.substring(1));
    } else {
      scale = 0.0;
      size = parse(value);
    }

    // 计算字体大小
    return _SizeAttribute(key, (double fontSize) => fontSize * scale + size);
  }
}
