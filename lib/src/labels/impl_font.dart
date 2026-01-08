part of '../rich_text.dart';

class _FontFamilyAttribute extends _Attribute<String> {
  const _FontFamilyAttribute(super.key, super.family);

  @override
  void merge(_AttributeValue val, TextStyle style) {
    val.fontFamily = value;
  }

  static _Attribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<${key.keyword}> missing argument');
    if (value.isEmpty) throw _MakeAttributeError('$origin invalid argument');
    return _FontFamilyAttribute(key, value);
  }
}
