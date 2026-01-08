part of '../rich_text.dart';

class _TextDecorationData {
  const _TextDecorationData(
    this.decoration,
    this.color,
    this.style,
    this.height,
    this.thickness,
  );

  /// 装饰类型
  final TextDecoration decoration;

  /// 文本装饰器颜色
  final Color? color;

  /// 装饰器样式
  final ui.TextDecorationStyle? style;

  /// 如果是下划线，则是距离文字偏移的高度
  final double? height;

  /// 装饰器厚度
  final double? thickness;

  /// 解析参数
  static _TextDecorationData parse(_Key key, String origin, String value) {
    ui.TextDecorationStyle? style;
    Color? color;
    double? thickness;
    double? height;

    final decoration = switch (key) {
      _Key.underline => TextDecoration.underline,
      _Key.delete => TextDecoration.lineThrough,
      _ => throw _MakeAttributeError('$key invalid type argument'),
    };

    if (!value.startsWith("'") || !value.endsWith("'")) {
      color = value.parseColor();
      if (color == null) throw _MakeAttributeError('$origin invalid argument');
      return _TextDecorationData(decoration, color, style, height, thickness);
    }

    final blocks = _ArgsKeyValues.parseAll(origin, value, true);
    for (final block in blocks) {
      final key = block.key;
      final val = block.values.first;

      if (block.values.length > 1) {
        throw _MakeAttributeError('$origin invalid argument');
      }

      switch (key) {
        case 'color':
          if (color != null) throw _MakeAttributeError('$origin duplicate argument');
          color = val.parseColor();
          if (color == null) throw _MakeAttributeError('$origin invalid color argument');
          break;

        case 'style':
          if (style != null) throw _MakeAttributeError('$origin duplicate argument');
          style = switch (val) {
            'solid' => ui.TextDecorationStyle.solid,
            'double' => ui.TextDecorationStyle.double,
            'dotted' => ui.TextDecorationStyle.dotted,
            'dashed' => ui.TextDecorationStyle.dashed,
            'wavy' => ui.TextDecorationStyle.wavy,
            _ => throw _MakeAttributeError('$origin invalid style argument'),
          };
          break;

        case 'height':
          if (decoration != TextDecoration.underline) {
            throw _MakeAttributeError('$origin unknown height argument');
          }
          if (height != null) throw _MakeAttributeError('$origin duplicate argument');
          height = double.tryParse(val);
          if (height == null) throw _MakeAttributeError('$origin invalid height argument');
          break;

        case 'thickness':
          if (thickness != null) {
            throw _MakeAttributeError('$origin duplicate argument');
          }
          thickness = double.tryParse(val);
          if (thickness == null) {
            throw _MakeAttributeError('$origin invalid thickness argument');
          }
          break;
      }
    }

    return _TextDecorationData(decoration, color, style, height, thickness);
  }
}

class _DecorationAttribute extends _Attribute<_TextDecorationData> {
  const _DecorationAttribute(super.key, super.value);

  @override
  void merge(_AttributeValue val, TextStyle style) {
    final dh = value.height;
    val.decoration = value.decoration;
    val.decorationColor = value.color;
    val.decorationStyle = value.style;
    val.decorationThickness = value.thickness;
    val.decorationHeight = dh != null && dh != 0 ? dh : null;
  }

  static _Attribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<${key.keyword}> missing argument');
    return _DecorationAttribute(
      key,
      _TextDecorationData.parse(key, origin, value),
    );
  }
}
