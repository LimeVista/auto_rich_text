import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `u` 01", _testUnderlineLabel01);
  testWidgets("runs AutoRichText Label `u` 02", _testUnderlineLabel02);
}

Future<void> _testUnderlineLabel01(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <u=green>世界</u>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(
      text: "世界",
      style: TextStyle(decoration: TextDecoration.underline, decorationColor: Color(0xFF4CAF50)),
    ),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}

Future<void> _testUnderlineLabel02(WidgetTester tester) async {
  const text = "你好 <u='color:green; style:solid; thickness:1.0; height:1.0'>世界</u>";
  const color = Color(0xFF4CAF50);
  await tester.pumpWidget(AutoRichText(
    text: text,
    style: defStyle.copyWith(color: color),
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(
      text: "世界",
      style: TextStyle(
        decoration: TextDecoration.underline,
        decorationThickness: 1.0,
        color: Colors.transparent,
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: color,
        shadows: [Shadow(color: color, offset: Offset(0, -1.0))],
      ),
    ),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}
