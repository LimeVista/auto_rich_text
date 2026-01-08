part of '../rich_text.dart';

abstract class _GestureRecognizerAttribute<T> extends _Attribute<T> {
  const _GestureRecognizerAttribute(super.key, super.value);

  /// 创建手势
  GestureRecognizer? makeGestureRecognizer(OnEventCallback? callback);
}

class _TapData {
  const _TapData(this.types, this.id, this.args);

  /// 事件类型
  final Map<String, TapGestureRecognizerRegister> types;

  /// 事件编号
  final String id;

  /// 附加参数
  final List<String> args;

  static _TapData parse(_Key key, String origin, String value) {
    final blocks = _ArgsKeyValues.parseAll(origin, value, true);
    late final support = $supportTapSubTypes;

    Map<String, TapGestureRecognizerRegister>? types;
    String? id;
    List<String>? args;

    _MakeAttributeError err(String msg) => _MakeAttributeError('$origin $msg');

    for (final block in blocks) {
      final key = block.key;
      final vs = block.values;

      switch (key) {
        case 'types':
          if (types != null) throw err('duplicate argument');
          types = <String, TapGestureRecognizerRegister>{};
          for (final value in vs) {
            final v = support[value];
            if (v == null) throw err('invalid type argument');
            types[value] = v;
          }
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

    if (types == null || types.isEmpty) throw err('missing types argument');
    if (id == null) throw err('missing id argument');

    return _TapData(types, id, args ?? const []);
  }
}

class _TapAttribute extends _GestureRecognizerAttribute<_TapData> {
  const _TapAttribute(super.key, super.value);

  @override
  void merge(_AttributeValue val, TextStyle style) {}

  @override
  GestureRecognizer? makeGestureRecognizer(OnEventCallback? callback) {
    if (callback == null) return null;
    final tgr = TapGestureRecognizer();
    for (final func in value.types.values) {
      func(tgr, callback, value.id, value.args);
    }
    return tgr;
  }

  static _TapAttribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<${key.keyword}> missing argument');
    return _TapAttribute(key, _TapData.parse(key, origin, value));
  }
}
