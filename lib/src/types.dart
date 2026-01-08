import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// 构建富文本
typedef AutoRichTextBuilder = Widget Function(InlineSpan span, TextStyle style);

/// 获取颜色自定义映射
typedef ColorMapFunc = ui.Color? Function(String name);

/// 获取图片自定义映射
typedef ImageMapFunc = ImageProvider? Function(String name);

/// 创建内部使用的富文本封装
typedef InternalRichTextCreator = Widget Function(TextSpan span, TextStyle? style);

/// 事件回调
typedef OnEventCallback = void Function(AutoRichTextEvent event);

/// 引用回调
typedef OnRefCallback = TextSpan Function(String ref, TextStyle style);

enum AutoRichTextEventType {
  /// 触摸事件，对应的子事件类型为 [$supportTapSubTypes]
  tap,

  /// 点击事件，对应的子事件类型为 [$supportClickSubTypes]
  click,
}

/// 产生事件
final class AutoRichTextEvent {
  const AutoRichTextEvent(this.type, this.subType, this.id, this.args, this.extra);

  /// 事件类型
  final AutoRichTextEventType type;

  /// 事件子类型，见对应的 [AutoRichTextEventType]
  final String subType;

  /// 事件编号
  final String id;

  /// 事件传入参数
  final List<String> args;

  /// 由事件所产生的附加参数
  final dynamic extra;

  @override
  String toString() => 'AutoRichTextEvent{type: $type, id: $id, args: $args, extra: $extra}';
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/// 创建 [AutoRichTextEventType.tap] 事件
typedef TapGestureRecognizerRegister = void Function(
  TapGestureRecognizer recognizer,
  OnEventCallback callback,
  String id,
  List<String> args,
);

/// 创建 [AutoRichTextEventType.click] 事件
typedef GestureRecognizerCreator = GestureRecognizer Function(
  OnEventCallback callback,
  String id,
  List<String> args,
);

/// 用于支持 [AutoRichTextEventType.tap]
Map<String, TapGestureRecognizerRegister> get $supportTapSubTypes {
  void Function(dynamic) r1(OnEventCallback call, String id, String type, List<String> args) {
    return (ret) => call(AutoRichTextEvent(AutoRichTextEventType.tap, type, id, args, ret));
  }

  void Function() r0(OnEventCallback call, String id, String type, List<String> args) {
    return () => call(AutoRichTextEvent(AutoRichTextEventType.tap, type, id, args, null));
  }

  const kDown = "tapDown";
  const kUp = "tapUp";
  const kCancel = "tapCancel";
  const kTap = "tap";
  const kSecondary = "secondaryTap";
  const kSecondaryDown = "secondaryTapDown";
  const kSecondaryUp = "secondaryTapUp";
  const kSecondaryCancel = "secondaryTapCancel";
  const kTertiaryDown = "tertiaryTapDown";
  const kTertiaryUp = "tertiaryTapUp";
  const kTertiaryCancel = "tertiaryTapCancel";

  return {
    kDown: (r, f, i, a) => r.onTapDown = r1(f, i, kDown, a),
    kUp: (r, f, i, a) => r.onTapUp = r1(f, i, kUp, a),
    kCancel: (r, f, i, a) => r.onTapCancel = r0(f, i, kCancel, a),
    kTap: (r, f, i, a) => r.onTap = r0(f, i, kTap, a),
    kSecondary: (r, f, i, a) => r.onSecondaryTap = r0(f, i, kSecondary, a),
    kSecondaryDown: (r, f, i, a) => r.onSecondaryTapDown = r1(f, i, kSecondaryDown, a),
    kSecondaryUp: (r, f, i, a) => r.onSecondaryTapUp = r1(f, i, kSecondaryUp, a),
    kSecondaryCancel: (r, f, i, a) => r.onSecondaryTapCancel = r0(f, i, kSecondaryCancel, a),
    kTertiaryDown: (r, f, i, a) => r.onTertiaryTapDown = r1(f, i, kTertiaryDown, a),
    kTertiaryUp: (r, f, i, a) => r.onTertiaryTapUp = r1(f, i, kTertiaryUp, a),
    kTertiaryCancel: (r, f, i, a) => r.onTertiaryTapCancel = r0(f, i, kTertiaryCancel, a),
  };
}

/// 用于支持 [AutoRichTextEventType.click]
Map<String, GestureRecognizerCreator> get $supportClickSubTypes {
  void Function() r0(OnEventCallback call, String id, String type, List<String> args) {
    return () => call(AutoRichTextEvent(AutoRichTextEventType.click, type, id, args, null));
  }

  return {
    "single": (f, i, a) => TapGestureRecognizer()..onTap = r0(f, i, "single", a),
    "double": (f, i, a) => DoubleTapGestureRecognizer()..onDoubleTap = r0(f, i, "double", a),
    "long": (f, i, a) => LongPressGestureRecognizer()..onLongPress = r0(f, i, "long", a),
  };
}
