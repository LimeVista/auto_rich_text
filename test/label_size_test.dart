import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `size` 01", _testSizeLabel01);
  testWidgets("runs AutoRichText Label `size` 02", _testSizeLabel02);
  testWidgets("runs AutoRichText Label `size` 03", _testSizeLabel03);
  testWidgets("runs AutoRichText Label `size` 04", _testSizeLabel04);
}

Future<void> _testSizeLabel01(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <size=-2>世界</size>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(text: "世界", style: TextStyle(fontSize: 14)),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}

Future<void> _testSizeLabel02(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <size=+2>世界</size>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(text: "世界", style: TextStyle(fontSize: 18)),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}

Future<void> _testSizeLabel03(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <size=16>世界</size>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(text: "世界", style: defStyle),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}

Future<void> _testSizeLabel04(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <size=+2><size=16><size=-2>世界</size></size></size>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(text: "世界", style: TextStyle(fontSize: 14)),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}
