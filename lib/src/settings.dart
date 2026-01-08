import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'rich_text.dart';
import 'types.dart';

/// 富文本全局设置
final class AutoRichTextSettings {
  AutoRichTextSettings._();

  /// 获取当前设置
  factory AutoRichTextSettings() => shared;

  /// 单例
  static final AutoRichTextSettings shared = AutoRichTextSettings._();

  /// 运行过程中显示提示
  bool get lintMode => _lint;

  /// 设置是否显示提示
  set lintMode(bool value) {
    _lint = value;
    if (value) {
      debugPrint('AutoRichText: lint mode enabled');
    }
  }

  /// 设置自定义颜色映射，默认为空
  void setCustomColorMapFunc(ColorMapFunc? func) {
    _colorMapFunc = func;
  }

  /// 设置自定义图片映射，默认为空
  ///
  /// 在 [func] 如果返回 null 则使用默认实现，使用 `assets/images` 目录下的图片
  void setCustomImageMapFunc(ImageMapFunc? func) {
    _imageFunc = func;
  }

  /// 自定义富文本创建器，默认使用 [Text.rich]
  void setInternalRichTextCreator(InternalRichTextCreator? func) {
    _richTextCreator = func;
  }

  /// 调用此方法，会是的所有 [AutoRichText] 缓存失效，在下一次重绘时重新计算
  ///
  /// [rebuildAll] 为 `true` 表示重建文本语法数，否则仅重建样式
  void invalidate([bool rebuildAll = false]) {
    final h = rebuildAll ? ((_kMaskIdH & _m) + (_kMaskIdL + 1)) & _kMaskIdH : _kMaskIdH & _m;
    final l = ((_kMaskIdL & _m) + 1) & _kMaskIdL;
    _m = h | l;
  }

  ///#region 内部函数

  /// 当前掩码
  int get $mask => _m;

  /// 自定义映射，内部函数
  ui.Color? $colorMap(String value) {
    return _colorMapFunc?.call(value);
  }

  /// 自定义映射，内部函数
  ImageProvider $imageMap(String value) {
    final provider = _imageFunc?.call(value);
    if (provider != null) return provider;
    return AssetImage('assets/images/$value');
  }

  /// 创建内部富文本封装，内部函数
  Widget $makeInternalRichText(TextSpan span, TextStyle? style) {
    final text = _richTextCreator?.call(span, style);
    if (text != null) return text;
    return Text.rich(span, style: style);
  }

  /// 判断是否需要重新计算
  /// 0 表示不需要重新计算
  /// 1 仅更新样式
  /// 2 重新计算所有
  int $shouldRebuild(int mask) {
    if (mask == _m) return 0;
    if ((mask & _kMaskIdH) != (_m & _kMaskIdH)) {
      return 2;
    }
    return 1;
  }

  ///#endregion 内部函数

  ///#region 私有成员变量

  /// 表示文本也需要重新计算
  static const int _kMaskIdH = 0x7FFFFFFF00000000;

  /// 仅更新样式
  static const int _kMaskIdL = 0x00000000FFFFFFFF;

  /// 自定义颜色映射
  ColorMapFunc? _colorMapFunc;

  /// 自定义图片映射
  ImageMapFunc? _imageFunc;

  /// 自定义富文本创建器
  InternalRichTextCreator? _richTextCreator;

  /// 当前掩码计数
  int _m = 0;

  /// 显示一些 lint 提示
  bool _lint = false;

  ///#endregion 私有成员变量
}
