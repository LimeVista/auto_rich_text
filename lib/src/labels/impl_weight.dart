part of '../rich_text.dart';

class _WeightAttribute extends _Attribute<FontWeight> {
  const _WeightAttribute(super.key, super.weight);

  @override
  void merge(_AttributeValue val, TextStyle style) {
    val.fontWeight = value;
  }

  static _Attribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<weight> missing argument');
    final widget = switch (value) {
      'w100' => FontWeight.w100,
      'w200' => FontWeight.w200,
      'w300' => FontWeight.w300,
      'w400' => FontWeight.w400,
      'w500' => FontWeight.w500,
      'w600' => FontWeight.w600,
      'w700' => FontWeight.w700,
      'w800' => FontWeight.w800,
      'w900' => FontWeight.w900,
      'normal' => FontWeight.normal,
      'bold' => FontWeight.bold,
      _ => throw _MakeAttributeError('$origin invalid argument'),
    };
    return _WeightAttribute(key, widget);
  }

  static _Attribute makeBold(_Key key, String origin, String? value) {
    if (value != null) throw _MakeAttributeError('<bold> no argument required');
    return _WeightAttribute(key, FontWeight.bold);
  }
}
