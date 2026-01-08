part of '../rich_text.dart';

class _AlignAttribute extends _Attribute<ui.PlaceholderAlignment> {
  const _AlignAttribute(super.key, super.value);

  @override
  void merge(_AttributeValue val, TextStyle style) {}

  static _AlignAttribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<align> missing argument');
    ui.PlaceholderAlignment? align;
    for (final element in ui.PlaceholderAlignment.values) {
      if (element.name != value) continue;
      align = element;
      break;
    }
    if (align == null) throw _MakeAttributeError('$origin invalid argument');
    return _AlignAttribute(key, align);
  }
}
