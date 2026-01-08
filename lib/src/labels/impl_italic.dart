part of '../rich_text.dart';

class _FontStyleAttribute extends _Attribute<FontStyle> {
  const _FontStyleAttribute(super.key, super.style);

  @override
  void merge(_AttributeValue val, TextStyle style) {
    val.fontStyle = value;
  }

  static _Attribute makeItalic(_Key key, String origin, String? value) {
    if (value != null) throw _MakeAttributeError('<italic> no argument required');
    return _FontStyleAttribute(key, FontStyle.italic);
  }
}
