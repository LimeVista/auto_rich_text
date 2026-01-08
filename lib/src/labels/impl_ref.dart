part of '../rich_text.dart';

/// 引用标签
class _RefElement extends _Element<String> {
  const _RefElement(super.key, super.value);

  @override
  InlineSpan makeSpan(TextStyle style, ui.PlaceholderAlignment? alignment, OnRefCallback ref) {
    final span = ref(value, style);
    final baseline = style.textBaseline;
    final shared = AutoRichTextSettings.shared;
    return alignment == null
        ? span
        : shared.$makeInternalRichText(span, style).createSpan(alignment, null, baseline);
  }

  /// 匹配引用标签
  static _Element make(_Key key, String origin, String? value) {
    if (value == null || value.isEmpty) throw _MakeElementError('<${key.keyword}/> missing argument');
    return _RefElement(key, value);
  }
}
