import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `delete` 01", _testDeleteLabel01);
  testWidgets("runs AutoRichText Label `delete` 02", _testDeleteLabel02);
}

Future<void> _testDeleteLabel01(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <delete=green>世界</delete>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(
      text: "世界",
      style: TextStyle(
        decoration: TextDecoration.lineThrough,
        decorationColor: Color(0xFF4CAF50),
      ),
    ),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}

Future<void> _testDeleteLabel02(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: "你好 <delete='color:green; style:solid; thickness:1.0'>世界</delete>",
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(
      text: "世界",
      style: TextStyle(
        decoration: TextDecoration.lineThrough,
        decorationThickness: 1.0,
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: Color(0xFF4CAF50),
      ),
    ),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}
