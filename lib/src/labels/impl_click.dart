part of '../rich_text.dart';

class _ClickData {
  const _ClickData(this.creator, this.id, this.args);

  /// 事件类型
  final GestureRecognizerCreator creator;

  /// 事件编号
  final String id;

  /// 附加参数
  final List<String> args;

  static _ClickData parse(_Key key, String origin, String value) {
    final blocks = _ArgsKeyValues.parseAll(origin, value, true);
    late final support = $supportClickSubTypes;

    GestureRecognizerCreator? creator;
    String? id;
    List<String>? args;

    _MakeAttributeError err(String msg) => _MakeAttributeError('$origin $msg');

    for (final block in blocks) {
      final key = block.key;
      final vs = block.values;

      switch (key) {
        case 'type':
          if (creator != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid type argument');
          final v = support[vs[0]];
          if (v == null) throw err('invalid type argument');
          creator = v;
          break;
        case 'id':
          if (id != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid id argument');
          id = vs[0];
          break;
        case 'args':
          if (args != null) throw err('duplicate argument');
          args = vs;
          break;
        default:
          throw err('unknown argument error');
      }
    }

    if (id == null) throw err('missing id argument');

    return _ClickData(creator ?? support['single']!, id, args ?? const []);
  }
}

class _ClickAttribute extends _GestureRecognizerAttribute<_ClickData> {
  const _ClickAttribute(super.key, super.value);

  @override
  GestureRecognizer? makeGestureRecognizer(OnEventCallback? callback) {
    if (callback == null) return null;
    return value.creator(callback, value.id, value.args);
  }

  @override
  void merge(_AttributeValue val, TextStyle parent) {}

  static _ClickAttribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<${key.keyword}> missing argument');
    return _ClickAttribute(key, _ClickData.parse(key, origin, value));
  }
}
