part of '../rich_text.dart';

enum _Key {
  /// 文本占位符对齐标签：`<align=middle></align>`，
  ///
  /// 仅子标签存在占位符标签：诸如 `<gradient>`、`<icon/>` 等时才会生效
  /// 部分组件对齐参数， 可以同 `TextStyle.textBaseline` 一同使用
  ///
  /// 支持以下标签：详见 [ui.PlaceholderAlignment]
  align._('align', attr: _AlignAttribute.make),

  /// 字体加粗标签：`<bold></bold>`
  /// 等同于 `<weight=w700></weight>` 或 `<weight=bold></weight>`
  bold._('bold', attr: _WeightAttribute.makeBold),

  /// 颜色标签：`<color=#4C5A79></color>`
  /// 同时支持 `<color=#4C5A79FF></color>` 和 `<color=lime></color>`
  ///
  /// 颜色名称为 Material 标准，支持以下命名：
  /// transparent、black、white、red、green、blue、pink、purple、indigo、cyan、teal、
  /// lime、yellow、amber、orange、brown、grey
  ///
  /// 颜色规范 https://developer.mozilla.org/zh-CN/docs/Web/CSS/hex-color
  color._('color', attr: _ColorAttribute.make),

  /// 字体标签：`<font=sans></font>`
  ///
  /// 设置字体名称，即：[TextStyle.fontFamily]
  font._('font', attr: _FontFamilyAttribute.make),

  /// 删除线标签：`<delete=#4C5A79></delete>`，与 [underline] 互斥
  /// 同时支持 `<delete=#FF4C5A79></delete>` 和 `<delete=lime></delete>`
  /// 且支持 `<delete='color:white; style:solid; thickness:1.0'></delete>`
  /// `color`： 可选参数，装饰器颜色
  /// `style`：可选参数，装饰器样式，名称参见：[ui.TextDecorationStyle]
  /// `thickness`: 可选参数，装饰器厚度
  ///
  /// 颜色名称为 Material 标准，支持以下命名：
  /// transparent、black、white、red、green、blue、pink、purple、indigo、cyan、teal、
  /// lime、yellow、amber、orange、brown、grey
  delete._('delete', attr: _DecorationAttribute.make),

  /// 下划线标签：`<u=#4C5A79></u>`，与 [delete] 互斥
  /// 同时支持 `<u=#FF4C5A79></u>` 和 `<u=lime></u>`
  /// 且支持 `<u='color:white; style:solid; thickness:1.0; height:1.0'></u>`
  /// `color`： 可选参数，装饰器颜色
  /// `style`：可选参数，装饰器样式，名称参见：[ui.TextDecorationStyle]
  /// `thickness`: 可选参数，装饰器厚度
  /// `height`: 可选参数，距离文字偏移的高度
  ///
  /// 颜色名称为 Material 标准，支持以下命名：
  /// transparent、black、white、red、green、blue、pink、purple、indigo、cyan、teal、
  /// lime、yellow、amber、orange、brown、grey
  underline._('u', attr: _DecorationAttribute.make),

  /// 字体图标标签：`<icon='code:11; font-family:custom'/>`
  /// `code`: 必选参数，图标代码
  /// `font-family`：必选参数，图标字体名称
  icon._('icon', ele: _IconElement.make),

  /// 图标标签：`<image='file:ic_ad.png; width:32; height:32; color:white; blend:srcOver'/>`
  /// `file`：必选参数，图片名称
  /// `width`：可选参数，图片显示宽度
  /// `height`：可选参数，图片显示高度
  /// `color`： 可选参数，图片颜色
  /// `blend`：可选参数，图片混合模式，名称参见：[BlendMode]
  ///
  /// 颜色名称为 Material 标准，支持以下命名：
  /// transparent、black、white、red、green、blue、pink、purple、indigo、cyan、teal、
  /// lime、yellow、amber、orange、brown、grey
  ///
  /// 默认图标支持 `assets/images` 目录下的图片，也可以自定义 [AutoRichTextSettings.setCustomImageMapFunc]
  ///
  /// 颜色规范 https://developer.mozilla.org/zh-CN/docs/Web/CSS/hex-color
  image._('image', ele: _ImageElement.make),

  /// 斜体标签：`<italic></italic>`
  italic._('italic', attr: _FontStyleAttribute.makeItalic),

  /// 字体大小标签：`<size=12></size>`
  /// 同时支持 `<size=+3></size>` 和 `<size=-3></size>`
  size._('size', attr: _SizeAttribute.make),

  /// 字体粗细标签：`<weight=w700></weight>` 也可以是 `<weight=bold></weight>`
  /// 支持以下命名：
  /// w100、w200、w300、w400、w500、w600、w700、w800、w900、normal、bold
  weight._('weight', attr: _WeightAttribute.make),

  /// 渐变标签：`<gradient='colors:red,yellow; type:linear'></gradient>`
  ///
  /// `colors`：必选参数，文本颜色
  /// `stops`：可选参数，渐变颜色位置，默认为空，语法为：`x1,x2,x3`，例如：`0.5,0.5,1.0`
  /// `type`：可选参数，渐变类型，默认为 `linear`
  /// `tile`：可选参数，渐变平铺模式，默认为：`clamp`
  /// `blend`：可选参数，渐变混合模式，默认为：`modulate`
  ///
  /// `begin`：可选参数，渐变起始位置，仅线性渐变有效，默认为 `centerLeft`
  /// `end`：可选参数，渐变结束位置，仅线性渐变有效，默认为 `centerRight`
  ///
  /// `center`：可选参数，渐变中心位置，仅径向渐变有效，默认为 `center`
  /// `radius`：可选参数，径向渐变半径，仅径向渐变有效，默认为 `0.5`
  /// `focal`：可选参数，径向渐变焦点位置，仅径向渐变有效
  /// `focal-radius`：可选参数，径向渐变焦点半径，仅径向渐变有效，默认为 `0.0`
  ///
  ///
  /// 渐变类型支持以下命名：
  /// linear、radial
  ///
  /// 起始和结束参数支持以下命名：
  /// topLeft、topCenter、topRight、centerLeft、center、centerRight、bottomLeft、
  /// bottomCenter、bottomRight
  ///
  /// 径向渐变焦点位置参数支持以下命名：
  /// topLeft、topCenter、topRight、centerLeft、center、centerRight、bottomLeft、
  /// bottomCenter、bottomRight
  ///
  /// 渐变平铺模式参数支持以下命名：
  /// clamp、repeated、mirror、decal
  ///
  /// 颜色名称为 Material 标准，支持以下命名：
  /// transparent、black、white、red、green、blue、pink、purple、indigo、cyan、teal、
  /// lime、yellow、amber、orange、brown、grey
  ///
  /// 颜色规范 https://developer.mozilla.org/zh-CN/docs/Web/CSS/hex-color
  gradient._('gradient', attr: _GradientAttribute.make),

  /// 点击标签：`<click='id:xxx; type:single; args:1,2;'></click>`
  ///
  /// `id`: 必选参数，标签参数，用于标识标签
  /// `type`: 可选参数，事件类型，默认为 `single`
  /// `args`：可选参数，附带参数，多个参数用逗号隔开
  ///
  /// 类型参数支持以下命名：
  /// single、double、long
  click._('click', attr: _ClickAttribute.make),

  /// 触摸标签：`<tap='id:xxx; types:tap; args:1,2;'></tap>`
  ///
  /// `id`: 必选参数，标签参数，用于标识标签
  /// `types`: 必选参数，事件类型，多个类型用逗号隔开
  /// `args`：可选参数，附带参数，多个参数用逗号隔开
  ///
  ///
  /// 类型参数支持以下命名：
  /// tapDown、tapUp、tapCancel、tap、secondaryTap、secondaryTapDown、secondaryTapUp、
  /// secondaryTapCancel、tertiaryTapDown、tertiaryTapUp、tertiaryTapCancel
  tap._('tap', attr: _TapAttribute.make),

  /// 引用标签：`<ref=xxx/>`，引入自定义 [TextSpan]
  ///
  /// 需要监听 [OnRefCallback]
  ref._('ref', ele: _RefElement.make);

  const _Key._(
    this.keyword, {
    this.attr,
    this.ele,
  }) : assert((attr == null || ele == null) && (attr != null || ele != null));

  /// 关键字
  final String keyword;

  /// 匹配表达式
  final _Attribute Function(_Key, String, String?)? attr;

  /// 匹配表达式
  final _Element Function(_Key, String, String?)? ele;

  /// 是否为闭合元素
  bool get element => ele != null;

  /// 生成属性
  _Attribute makeAttribute(String origin, String? value) => attr!(this, origin, value);

  /// 生成元素
  _Element makeElement(String origin, String? value) => ele!(this, origin, value);
}

/// 键值对
abstract class _KeyValue<V> {
  const _KeyValue(this.key, this.value);

  /// 标签类型
  final _Key key;

  /// 值
  final V value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _KeyValue &&
            runtimeType == other.runtimeType &&
            key == other.key &&
            value == other.value;
  }

  @override
  int get hashCode => Object.hash(key, value);

  @override
  String toString() => '{key: ${key.name}, value: $value}';
}

/// 属性值
final class _AttributeValue {
  _AttributeValue();

  Color? color;
  Color? backgroundColor;
  double? fontSize;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  double? letterSpacing;
  double? wordSpacing;
  TextBaseline? textBaseline;
  double? height;
  TextLeadingDistribution? leadingDistribution;
  Locale? locale;
  Paint? foreground;
  Paint? background;
  List<Shadow>? shadows;
  List<FontFeature>? fontFeatures;
  List<FontVariation>? fontVariations;
  TextDecoration? decoration;
  Color? decorationColor;
  TextDecorationStyle? decorationStyle;
  double? decorationThickness;
  double? decorationHeight;
  String? fontFamily;
  TextOverflow? overflow;

  bool get isEmpty =>
      color == null &&
      backgroundColor == null &&
      fontSize == null &&
      fontWeight == null &&
      fontStyle == null &&
      letterSpacing == null &&
      wordSpacing == null &&
      textBaseline == null &&
      height == null &&
      leadingDistribution == null &&
      locale == null &&
      foreground == null &&
      background == null &&
      shadows == null &&
      fontFeatures == null &&
      fontVariations == null &&
      decoration == null &&
      decorationColor == null &&
      decorationStyle == null &&
      decorationThickness == null &&
      decorationHeight == null &&
      fontFamily == null &&
      overflow == null;

  TextStyle? toStyle(Color? color) {
    if (isEmpty) return null;
    late final shadowColor = this.color ?? color ?? const Color(0xFF000000);
    final shadows = decorationHeight == null
        ? this.shadows
        : [Shadow(color: shadowColor, offset: Offset(0, -decorationHeight!))];

    return TextStyle(
      color: decorationHeight == null ? this.color : const Color(0x00000000),
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontFamily: fontFamily,
      overflow: overflow,
    );
  }
}

/// 属性
abstract class _Attribute<V> extends _KeyValue<V> {
  const _Attribute(super.key, super.value);

  /// 将当前属性合并到 [val]
  /// [parent] 为父类型
  void merge(_AttributeValue val, TextStyle parent);

  /// 合并并创建样式
  static TextStyle? mergeStyle(List<_Attribute> attributes, TextStyle parent) {
    if (attributes.isEmpty) return null;

    final attrVal = _AttributeValue();
    for (final attr in attributes) {
      attr.merge(attrVal, parent);
    }
    return attrVal.toStyle(parent.color);
  }

  /// 创建文本块
  static InlineSpan makeSpan(
    List<_Attribute> attributes,
    String text,
    TextStyle mergeStyle,
    TextStyle? style,
    _GradientData? gradient,
    ui.PlaceholderAlignment? align,
    OnEventCallback? onEvent,
  ) {
    _GestureRecognizerAttribute? gra;
    for (final value in attributes.reversed) {
      if (value is _GestureRecognizerAttribute) {
        gra = value;
        break;
      }
    }

    if (gra != null && AutoRichTextSettings.shared.lintMode) {
      final count = attributes.whereType<_GestureRecognizerAttribute>().length;
      if (count > 1) {
        debugPrint(
          '[AutoRichText] Warning: The number of gesture recognizers is greater than one. ',
        );
      }
    }

    GestureRecognizer? recognizer;
    if (gra != null) {
      recognizer = gra.makeGestureRecognizer(onEvent);
    }

    // 最简解
    if (gradient == null) {
      return TextSpan(text: text, style: style, recognizer: recognizer);
    }

    return makeGradientSpan(
      recognizer == null
          ? Text(text, style: mergeStyle)
          : AutoRichTextSettings.shared.$makeInternalRichText(
              TextSpan(text: text, style: mergeStyle, recognizer: recognizer),
              mergeStyle,
            ),
      gradient,
      align,
    );
  }

  /// 创建渐变文本块
  static InlineSpan makeGradientSpan(
    Widget child,
    _GradientData gradient,
    ui.PlaceholderAlignment? align,
  ) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.gradient.createShader(bounds),
      blendMode: gradient.blendMode,
      child: child,
    ).createSpan(align);
  }

  /// 获取对齐方式
  static ui.PlaceholderAlignment? getPlaceholderAlignment(List<_Attribute> attrs) {
    ui.PlaceholderAlignment? value;
    for (final attr in attrs.reversed) {
      if (attr.key != _Key.align) continue;
      value = attr.value;
      break;
    }
    return value;
  }

  /// 获取渐变属性
  static _GradientData? getGradient(List<_Attribute> attrs) {
    _GradientData? value;
    for (final attr in attrs.reversed) {
      if (attr.key != _Key.gradient) continue;
      value = attr.value;
      break;
    }
    return value;
  }
}

/// 元素
abstract class _Element<V> extends _KeyValue<V> {
  const _Element(super.key, super.value);

  /// 创建文本块
  InlineSpan makeSpan(TextStyle style, ui.PlaceholderAlignment? alignment, OnRefCallback ref);
}

/// 结束标签
final class _EndAttribute extends _Attribute<void> {
  const _EndAttribute(_Key key) : super(key, null);

  @override
  void merge(_AttributeValue val, TextStyle style) {}
}
