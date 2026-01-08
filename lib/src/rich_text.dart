import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'settings.dart';
import 'types.dart';

part 'internal/define.dart';
part 'internal/extension.dart';
part 'internal/parser.dart';
part 'labels/impl_align.dart';
part 'labels/impl_click.dart';
part 'labels/impl_color.dart';
part 'labels/impl_decoration.dart';
part 'labels/impl_font.dart';
part 'labels/impl_gradient.dart';
part 'labels/impl_icon.dart';
part 'labels/impl_image.dart';
part 'labels/impl_italic.dart';
part 'labels/impl_ref.dart';
part 'labels/impl_size.dart';
part 'labels/impl_tap.dart';
part 'labels/impl_weight.dart';

/// 自动富文本解析组件
/// 支持以下以下标签，跳转到相应的 [_Key] 可以查看相应规则
/// align    -> [_Key.align]
/// bold     -> [_Key.bold]
/// click    -> [_Key.click]
/// color    -> [_Key.color]
/// delete   -> [_Key.delete]
/// font     -> [_Key.font]
/// gradient -> [_Key.gradient]
/// icon     -> [_Key.icon]
/// image    -> [_Key.image]
/// italic   -> [_Key.italic]
/// size     -> [_Key.size]
/// weight   -> [_Key.weight]
/// u        -> [_Key.underline]
/// ref      -> [_Key.ref]
///
/// 使用实例：
/// ```
/// AutoRichText(
///   text: '你好 <bold>世界</bold>',
///   style: TextStyle(fontSize: 16),
///   builder: (span, style) => Text.rich(span, style: style),
/// )
/// ```
class AutoRichText extends StatefulWidget {
  /// 创建自动富文本解析组件
  /// 本组件将 [text] 根据 [style] 解析为 [InlineSpan]，
  /// 通过 [builder] 提供给 [Text] 或者其它 文本组件
  /// [debug] 用于打印调试信息
  /// [escape] 表示是否转义尖括号即 (< ~ &lt;) 和 (> ~ &gt);
  const AutoRichText({
    super.key,
    required this.text,
    required this.style,
    required this.builder,
    this.onRefCallback,
    this.onEventCallback,
    this.debug = false,
    this.escape = false,
    this.immutableRefCallback = true,
  });

  /// 默认使用 [Text.rich] 作为载体，且不需要任何额外设置
  /// 如需要额外设置，请使用默认构造
  /// 本组件将 [text] 根据 [style] 解析为 [InlineSpan]，
  /// [debug] 用于打印调试信息
  /// [escape] 表示是否转义尖括号即 (< ~ &lt;) 和 (> ~ &gt);
  const AutoRichText.sample({
    super.key,
    required this.text,
    required this.style,
    this.onRefCallback,
    this.onEventCallback,
    this.debug = false,
    this.escape = false,
    this.immutableRefCallback = true,
    this.builder = _sampleTextBuilder,
  });

  /// 构建回调
  final AutoRichTextBuilder builder;

  /// 文本样式
  final TextStyle style;

  /// 文本
  final String text;

  /// 事件回调
  final OnEventCallback? onEventCallback;

  /// 在使用 [_Key.ref] 标签后，会触发此回调，如果为空，则会使用字符串替换
  ///
  /// 不建议原地构造闭包函数，这可能导致缓存被重建
  final OnRefCallback? onRefCallback;

  /// 用于描述 [onRefCallback] 一般情况不可变，尽可能保证缓存被重用
  final bool immutableRefCallback;

  /// 输出调试信息
  final bool debug;

  /// 表示是否转义尖括号即 (< ~ &lt;) 和 (> ~ &gt);
  final bool escape;

  /// 便捷生成文本块
  ///
  /// [text] 输入文本
  /// [style] 文本样式
  /// [onEventCallback] 事件回调
  /// [escape] 表示是否转义尖括号即 (< ~ &lt;) 和 (> ~ &gt);
  /// 在使用 [_Key.ref] 标签后，会触发 [onRefCallback] 回调，如果为空，则会使用字符串替换
  static InlineSpan createSpanFromText(
    String text,
    TextStyle style, {
    OnEventCallback? onEventCallback,
    OnRefCallback? onRefCallback,
    bool escape = false,
  }) {
    final tokens = _Parser.lexer(text, escape);
    final scope = _Scope(0, tokens.length - 1, [], []);
    _Parser.parseScope(scope, tokens);
    return _SpanBuilder(tokens, style, onEventCallback, onRefCallback).build(scope);
  }

  @override
  AutoRichTextState createState() => AutoRichTextState._();
}

/// 状态类
@visibleForTesting
final class AutoRichTextState extends State<AutoRichText> {
  ///#region 构造函数

  AutoRichTextState._();

  ///#endregion 构造函数

  ///#region 成员变量

  /// 分词器缓存结果，被拆分的词
  List<_Token>? _tokens;

  /// 将被拆分的词转换为作用域多叉树
  _Scope? _scope;

  /// 掩码
  int _mask = AutoRichTextSettings.shared.$mask;

  /// 解析结果
  @visibleForTesting
  late InlineSpan span;

  ///#endregion 成员变量

  ///#region UI 处理

  @override
  void initState() {
    super.initState();
    _recreate();
  }

  @override
  void didUpdateWidget(covariant AutoRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final rStr = widget.text != oldWidget.text || widget.escape != oldWidget.escape;
    final rSty = widget.style != oldWidget.style || _shouldRefreshOnRef(widget, oldWidget);
    if (!rStr && !rSty) return;
    _recreate(rStr, rSty);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(span, widget.style);
  }

  /// 重建文本
  void _recreate([bool refreshString = true, bool refreshStyle = true]) {
    final rebuild = AutoRichTextSettings.shared.$shouldRebuild(_mask);
    _mask = AutoRichTextSettings.shared.$mask;

    if (!refreshString && rebuild > 1) {
      refreshString = true;
    }
    if (!refreshStyle && rebuild > 0) {
      refreshStyle = true;
    }

    if (refreshString || _tokens == null || _scope == null) {
      _tokens = _Parser.lexer(widget.text, widget.escape);
      _scope = _Scope(0, _tokens!.length - 1, [], []);
      _Parser.parseScope(_scope!, _tokens!);

      if (widget.debug) {
        _Parser.printTokens(_tokens!);
        _Parser.printScopeStack(_scope!, _tokens!);
      }
    }

    if (refreshString || refreshStyle) {
      span = _SpanBuilder(_tokens!, widget.style, _onEvent, _onRef).build(_scope!);
    }
  }

  /// 事件回调
  void _onEvent(AutoRichTextEvent event) {
    widget.onEventCallback?.call(event);
  }

  /// 引用回调
  TextSpan _onRef(String ref, TextStyle style) {
    return widget.onRefCallback?.call(ref, style) ?? const TextSpan();
  }

  /// 引用回调是否会导致刷新
  bool _shouldRefreshOnRef(AutoRichText n, AutoRichText o) {
    if (n.onRefCallback == o.onRefCallback) return false;
    if (n.onRefCallback == null || o.onRefCallback == null) return true;
    return !n.immutableRefCallback;
  }

  ///#endregion UI 处理
}

/// 生成属性错误
class _MakeAttributeError extends Error {
  _MakeAttributeError([this.message]);

  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return "Make attribute failed: ${Error.safeToString(message)}";
    }
    return "Make attribute failed";
  }
}

/// 生成元素错误
class _MakeElementError extends Error {
  _MakeElementError([this.message]);

  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return "Make element failed: ${Error.safeToString(message)}";
    }
    return "Make element failed";
  }
}

/// 用于生成 Span 块
class _SpanBuilder {
  const _SpanBuilder(this.tokens, this.origin, this.onEventCallback, OnRefCallback? onRefCallback)
      : onRefCallback = onRefCallback ?? _onRef;

  /// 所有词
  final List<_Token> tokens;

  /// 原始字体样式
  final TextStyle origin;

  /// 事件回调
  final OnEventCallback? onEventCallback;

  /// 引用回调
  final OnRefCallback onRefCallback;

  /// 创建文本块
  InlineSpan build(_Scope scope) => _build(scope, origin, null);

  /// 创建文本块，深度优先遍历
  InlineSpan _build(_Scope scope, TextStyle parent, ui.PlaceholderAlignment? mergeAlign) {
    final attrs = scope.attributes;
    final style = _Attribute.mergeStyle(attrs, parent);
    final align = _Attribute.getPlaceholderAlignment(attrs) ?? mergeAlign;
    final gradient = _Attribute.getGradient(attrs);
    final mergeStyle = parent.merge(style);

    if (!scope.parseChildren || scope.children.isEmpty) {
      if (!scope.valid) return const TextSpan(); // 仅会发生在根节点

      // 插入元素
      final element = scope.element;
      if (element != null) {
        return element.makeSpan(mergeStyle, align, onRefCallback);
      }

      // 插入属性
      return _Attribute.makeSpan(
        attrs,
        scope.toScopeString(tokens),
        mergeStyle,
        style,
        gradient,
        align,
        onEventCallback,
      );
    }

    final children = <InlineSpan>[];
    for (final child in scope.children) {
      if (!child.valid) continue; // 忽略无效节点
      children.add(_build(child, mergeStyle, gradient != null ? null : align));
    }

    if (gradient == null) {
      return TextSpan(style: style, children: children);
    }
    return _Attribute.makeGradientSpan(
      AutoRichTextSettings.shared.$makeInternalRichText(
        TextSpan(style: style, children: children),
        parent,
      ),
      gradient,
      align,
    );
  }

  static TextSpan _onRef(String _, TextStyle __) => const TextSpan();
}

Widget _sampleTextBuilder(InlineSpan span, TextStyle style) {
  return Text.rich(span, style: style);
}
