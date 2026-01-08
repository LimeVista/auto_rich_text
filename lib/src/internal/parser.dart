part of '../rich_text.dart';

/// 类型
enum _Type {
  /// 字符串
  string,

  /// 属性开始：<color=#FFFFFF>
  attrBegin,

  /// 属性结束：</color>
  attrEnd,

  /// 单元素：<icon/>
  element;

  String toDebugName() {
    return switch (this) {
      string => 'str',
      attrBegin => 'atb',
      attrEnd => 'ate',
      element => 'ele',
    };
  }
}

/// 词
class _Token {
  const _Token(this.type, this.origin, this.attribute, this.element)
      : assert(!(attribute != null && element != null));

  /// 开（起始）标签匹配
  ///
  /// 必须使用前置约束条件后再使用正则表达式，以保证性能
  static final _beginExp = RegExp(r"(<([a-z]+)>)|(<([a-z]+)=(\S+)(>))|(<([a-z]+)=('[\S ]+')(>))");

  /// 闭合标签在最小区间内匹配验证
  ///
  /// 必须使用前置约束条件后再使用正则表达式，以保证性能
  static final _endExp = RegExp(r'<([a-z]+)=([\S ]+)(/>)');

  /// 类型
  final _Type type;

  /// 原始字符串
  final String origin;

  /// 属性
  final _Attribute? attribute;

  /// 元素
  final _Element? element;

  /// 解析
  static _Token parse(String origin) {
    if (origin.startsWith('</') && origin.endsWith('>')) {
      // 匹配结束标签
      final keyword = origin.substring(2, origin.length - 1);

      if (keyword.isEmpty) return parseToString(origin);

      for (var key in _Key.values) {
        if (keyword != key.keyword) continue;
        return _Token(_Type.attrEnd, origin, _EndAttribute(key), null);
      }
    } else if (origin.startsWith('<') && origin.endsWith('/>')) {
      // 匹配闭合元素标签，验证是否符合闭合元素标签规则
      final match = _endExp.firstMatch(origin);

      // 回落为字符串
      if (match == null) return parseToString(origin);

      final keyword = match[1];
      final value = match[2];

      if (keyword == null || keyword.isEmpty) return parseToString(origin);

      for (var key in _Key.values) {
        if (keyword != key.keyword || !key.element) continue;
        try {
          final element = key.makeElement(origin, value);
          return _Token(_Type.element, origin, null, element);
        } on _MakeElementError catch (ex) {
          debugPrint(ex.stackTrace.toString());
        }
        break;
      }
    } else if (origin.startsWith('<') && origin.endsWith('>')) {
      // 匹配开始标签
      final match = _beginExp.firstMatch(origin);

      // 回落为字符串
      if (match == null) return parseToString(origin);

      final keyword = match[2] ?? match[4] ?? match[8];
      final value = match[9] ?? match[5];

      if (keyword == null || keyword.isEmpty) return parseToString(origin);

      for (final key in _Key.values) {
        if (keyword != key.keyword || key.element) continue;
        try {
          final attr = key.makeAttribute(origin, value);
          return _Token(_Type.attrBegin, origin, attr, null);
        } on _MakeAttributeError catch (ex) {
          debugPrint(ex.stackTrace.toString());
        }
        break;
      }
    }

    // 回落为字符串
    return parseToString(origin);
  }

  /// 解析为字符串
  static _Token parseToString(String origin) {
    return _Token(_Type.string, origin, null, null);
  }

  @override
  String toString() {
    return '_Token{'
        'type: $type, '
        'origin: $origin, '
        'attribute: $attribute, '
        'element: $element'
        '}';
  }

  String toDebugString() {
    final buff = StringBuffer('Token{type: ');
    buff.write(type.toDebugName());
    buff.write(', ');
    if (attribute != null) buff.write('attr: $attribute');
    if (element != null) buff.write('elem: $element');
    if (attribute != null || element != null) buff.write(', ');
    buff.write('orig: ');
    buff.write(origin);
    buff.write('}');
    return buff.toString();
  }
}

/// 作用域
class _Scope {
  _Scope(
    this.begin,
    this.end,
    this.attributes,
    this.children, {
    this.parseChildren = true,
    this.element,
  });

  /// 起始位置
  int begin;

  /// 结束位置
  int end;

  /// 作用属性
  final List<_Attribute> attributes;

  /// 子类
  final List<_Scope> children;

  /// 元素
  _Element? element;

  /// 子类是否需要解析
  bool parseChildren;

  /// 是否有效
  bool get valid => end >= begin;

  /// 输出当前空间下的文本
  String toScopeString(List<_Token> tokens) {
    final sb = StringBuffer();
    for (var i = begin; i <= end; ++i) {
      sb.write(tokens[i].origin);
    }
    return sb.toString();
  }

  /// 输出当前空间下的文本
  String toDebugString(List<_Token> tokens) {
    if (!valid) return '#invalid';
    final sb = StringBuffer();
    for (var i = begin; i <= end; ++i) {
      final origin = tokens[i].origin;
      sb.write(origin.replaceAll('\r', '').replaceAll('\n', '\\n'));
    }
    return sb.toString();
  }

  @override
  String toString() {
    return 'Scope{'
        'begin: $begin, '
        'end: $end, '
        'attributes: $attributes, '
        'children: $children, '
        'parseChildren: $parseChildren'
        '}';
  }
}

final class _Parser {
  ///#region 解析方法

  /// 分词（平面结构）
  static List<_Token> lexer(String text, bool escape) {
    final tokens = <_Token>[];
    final token = StringBuffer();

    // 添加文本
    void tryAddString(bool shouldEscape) {
      if (token.isEmpty) return;
      var rawStr = token.toString();
      if (escape && shouldEscape) {
        // 这里可以考虑优化性能
        rawStr = rawStr.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
      }
      tokens.add(_Token.parseToString(rawStr));
      token.clear();
    }

    // 是否进入尖括号状态
    var begin = false;
    var shouldEscape = false;

    for (final code in text.runes) {
      final ch = String.fromCharCode(code);
      switch (ch) {
        // 进入解析状态
        case '<':
          tryAddString(shouldEscape);
          shouldEscape = false;
          begin = true;
          token.write(ch);
          break;

        // 执行解析
        case '>':
          token.write(ch);
          if (begin) {
            tokens.add(_Token.parse(token.toString()));
            token.clear();
            shouldEscape = false;
          }
          begin = false;
          break;

        case '&':
          token.write(ch);
          shouldEscape = true;
          break;

        default:
          token.write(ch);
          break;
      }
    }

    // 添加最后一个单词
    tryAddString(shouldEscape);

    return tokens;
  }

  /// 解析，立体结构，广度优先遍历
  static void parseScope(_Scope scope, List<_Token> tokens) {
    if (!scope.valid && tokens.isEmpty) {
      scope.parseChildren = false;
      return;
    }
    var mergeBegin = scope.begin, mergeEnd = scope.end;
    var begin = scope.begin, end = scope.begin;

    void setBeginEnd(int start) {
      begin = start;
      end = start - 1;
    }

    for (var i = scope.begin; i <= scope.end; ++i) {
      final it = tokens[i];

      end = i;

      // 处理闭合元素
      if (it.type == _Type.element) {
        // 将之前的添加到作用域
        if (end > begin) {
          scope.children.add(
            _Scope(begin, end - 1, [], [], parseChildren: false),
          );
        }

        setBeginEnd(i + 1);

        // 交给子作用域处理
        scope.children.add(
          _Scope(i, i, [], [], parseChildren: false, element: it.element),
        );
        continue;
      }

      // 不是有效属性
      if (it.type != _Type.attrBegin) continue;

      var deep = 1;
      for (var j = i + 1; j <= scope.end; ++j) {
        final jt = tokens[j];
        final jtAttribute = jt.attribute;

        if (jtAttribute == null || jt.type == _Type.string) continue;
        if (it.attribute!.key != jtAttribute.key) continue;

        if (jt.type == _Type.attrBegin) {
          deep++;
          continue;
        }

        if (jt.type == _Type.attrEnd) {
          deep--;
        }

        if (deep != 0) continue;

        // 将之前的添加到作用域
        if (end > begin) {
          scope.children.add(
            _Scope(begin, end - 1, [], [], parseChildren: false),
          );
        }

        // 尝试优化，合并到当前作用域
        // 这里会尝试合并无效的空匹配
        if (mergeBegin == i && mergeEnd == j) {
          scope.attributes.add(it.attribute!);
          mergeBegin++;
          mergeEnd--;
          scope.begin = mergeBegin;
          scope.end = mergeEnd;
          setBeginEnd(mergeBegin);
          break;
        }

        // 有效匹配，反之是空匹配，丢弃
        if (i + 1 < j) {
          // 交给子作用域处理
          scope.children.add(_Scope(i + 1, j - 1, [it.attribute!], []));
        }

        i = j;
        setBeginEnd(i + 1);
        break; // 已经匹配到，跳出
      }

      // 将之前的添加到作用域，匹配错误表达式
      if (end >= begin) {
        scope.children.add(
          _Scope(begin, end, [], [], parseChildren: false),
        );
        setBeginEnd(i + 1);
      }
    }

    // 优化，子类不再需要解析
    if (begin == mergeBegin && end == mergeEnd) {
      scope.parseChildren = false;
      return;
    }

    // 将之前的添加到作用域
    if (end >= begin) {
      scope.children.add(_Scope(begin, end, [], [], parseChildren: false));
    }

    // 优化，将子类 element 合并到父类
    if (scope.children.length == 1 && scope.children[0].element != null) {
      scope.parseChildren = false;
      scope.element = scope.children[0].element;
      scope.children.clear();
    }

    for (final child in scope.children) {
      if (!child.parseChildren) continue;
      parseScope(child, tokens);
    }
  }

  ///#endregion 解析方法

  ///#region 调试方法

  /// 打印 [_Scope] 信息
  static void printScope(
    _Scope scope,
    int space,
    StringBuffer buffer,
    List<_Token> tokens,
  ) {
    for (final attr in scope.attributes) {
      buffer.write('${'+' * space} - %attr: ');
      buffer.write(attr.key.name);
      if (attr.value != null) {
        buffer.write(', value: ');
        buffer.write(attr.value);
      }
      buffer.write('\n');
    }

    if (!scope.parseChildren || scope.children.isEmpty) {
      buffer.write('${'+' * space} - ');
      buffer.write(scope.toDebugString(tokens));
      buffer.write('\n');
      return;
    }

    for (final child in scope.children) {
      printScope(child, space + 2, buffer, tokens);
    }
  }

  /// 打印 [_Scope] 所有信息
  static void printScopeStack(_Scope scope, List<_Token> tokens) {
    debugPrint('>>> SCOPE START >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    final sb = StringBuffer();
    printScope(scope, -1, sb, tokens);
    final str = sb.toString();
    if (str.isNotEmpty) debugPrint(str.substring(0, str.length - 1));
    debugPrint('>>> SCOPE END >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  }

  /// 打印词
  static void printTokens(List<_Token> tokens) {
    debugPrint('>>> TOKEN START >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    var index = 0;
    for (final token in tokens) {
      final indexStr = index.toString().padLeft(3, '0');
      debugPrint('$indexStr:${token.toDebugString()}');
      index++;
    }
    debugPrint('>>> TOKEN END >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  }

  ///#endregion 调试方法
}

/// 手动解析属性
///
/// 保证性能
class _ArgsKeyValues {
  const _ArgsKeyValues(this.key, this.values);

  /// 属性名
  final String key;

  /// 属性值
  final List<String> values;

  /// 解析传入的字符串
  ///
  /// 传入的字符串必须为 `'` 开头和结尾
  static List<_ArgsKeyValues> parseAll(String origin, String text, bool attr) {
    if (text.length < 2 || !text.startsWith("'") || !text.endsWith("'")) {
      throw attr ? _MakeAttributeError('Err: $origin.') : _MakeElementError('Err: $origin.');
    }

    final sub = text.substring(1, text.length - 1);
    final blocks = sub.split(';').map((e) => e.trim());
    final result = <_ArgsKeyValues>[];
    if (blocks.isEmpty) return result;
    for (final block in blocks) {
      if (block.isEmpty) continue;
      result.add(_parse(origin, block, attr));
    }
    return result;
  }

  /// 解析参数，手动实现保证效率为 O(n)
  static _ArgsKeyValues _parse(String origin, String text, bool attr) {
    String? key;
    List<String> values = [];

    final token = StringBuffer();
    var tokenState = 0; // 0：空，1：字母，2：-，3：数字，4：_#

    Error err() {
      return attr ? _MakeAttributeError('Err: $origin.') : _MakeElementError('Err: $origin.');
    }

    for (final c in text.runes) {
      if (c == 58) {
        // 匹配冒号
        key = token.toString();
        if (tokenState > 2 || tokenState == 0 || key[0] == '-') {
          throw err();
        }
        token.clear();
        tokenState = 0;
      } else if (c >= 65 && c <= 90 || c >= 97 && c <= 122) {
        // 匹配字母 A-Z、a-z
        if (tokenState < 1) tokenState = 1;
        token.writeCharCode(c);
      } else if (c == 45) {
        // 匹配连字符 -
        if (tokenState < 2) tokenState = 2;
        token.writeCharCode(c);
      } else if (c >= 48 && c <= 57) {
        // 匹配数字 0-9
        if (tokenState < 3) tokenState = 3;
        token.writeCharCode(c);
      } else if (c == 95 || c == 35 || c == 46) {
        // 匹配下划线 _，#, .
        if (tokenState < 4) tokenState = 4;
        token.writeCharCode(c);
      } else if (c == 44) {
        // 如果前面没有有效值，则表示错误
        if (key == null || tokenState == 0) throw err();

        values.add(token.toString());
        token.clear();
        tokenState = 0;
      } else if (c == 32) {
        if (tokenState > 0 || key == null) throw err();
        // 忽略
      } else {
        throw err();
      }
    }

    // 处理最后一个值
    if (token.isNotEmpty) {
      values.add(token.toString());
    }

    if (key == null || values.isEmpty) throw err();

    return _ArgsKeyValues(key, values);
  }

  @override
  String toString() {
    return '_ArgsKeyValues{key: $key, values: $values}';
  }
}

/// 用于测试性能
void $parseForBenchmark(String text, {bool escape = false}) {
  final tokens = _Parser.lexer(text, escape);
  final scope = _Scope(0, tokens.length - 1, [], []);
  _Parser.parseScope(scope, tokens);
}
