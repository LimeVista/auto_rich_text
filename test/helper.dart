import 'dart:convert';

import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

extension UI on Widget {
  /// UI 包裹
  Widget wrap() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultAssetBundle(
        bundle: _TestAssetBundle(),
        child: this,
      ),
    );
  }
}

class _TestAssetBundle extends PlatformAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.startsWith('AssetManifest')) {
      return super.load(key);
    }
    return switch (key) {
      'assets/images/img.png' => ByteData.sublistView(base64Decode(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAA1"
            "JREFUGFdj0PnN/R8ABLsCMuJgjmoAAAAASUVORK5CYII=",
      )),
      _ => ByteData(0),
    };
  }
}

/// 默认样式
const defStyle = TextStyle(fontSize: 16);

const expectedBold = TextSpan(children: [
  TextSpan(text: "你好 "),
  TextSpan(text: "世界", style: TextStyle(fontWeight: FontWeight.bold)),
]);

const expectedColor = TextSpan(children: [
  TextSpan(text: "你好 "),
  TextSpan(text: "世界", style: TextStyle(color: Color(0xFF4CAF50))),
]);

/// 富文本构建器
Widget richTextBuilder(InlineSpan span, TextStyle style) {
  return Text.rich(span, style: style);
}

/// 获取状态内的富文本块
TextSpan getTextSpan(WidgetTester tester) {
  AutoRichTextState state = tester.state(find.byType(AutoRichText));
  final span = state.span;
  expect(span, isInstanceOf<TextSpan>());
  return span as TextSpan;
}
