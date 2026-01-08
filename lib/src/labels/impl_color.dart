part of '../rich_text.dart';

class _ColorAttribute extends _Attribute<Color> {
  const _ColorAttribute(super.key, super.color);

  @override
  void merge(_AttributeValue val, TextStyle style) {
    val.color = value;
  }

  static _Attribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<${key.keyword}> missing argument');
    final color = value.parseColor();
    if (color == null) throw _MakeAttributeError('$origin invalid argument');
    return _ColorAttribute(key, color);
  }
}
