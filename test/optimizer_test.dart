import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText optimizer 01", _testOptimizer01);
  testWidgets("runs AutoRichText optimizer 02", _testOptimizer02);
  testWidgets("runs AutoRichText optimizer 03", _testOptimizer03);
  testWidgets("runs AutoRichText optimizer 04", _testOptimizer04);
  testWidgets("runs AutoRichText optimizer 05", _testOptimizer05);
  testWidgets("runs AutoRichText optimizer 06", _testOptimizer06);
}

Future<void> _testOptimizer01(WidgetTester tester) async {
  const text = '<bold>一段</bold><italic><delete=green>复合文本</delete></italic>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan(children: [
    TextSpan(text: "一段", style: TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
      text: "复合文本",
      style: TextStyle(
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.lineThrough,
        decorationColor: Color(0xFF4CAF50),
      ),
    ),
  ]);
  expect(span, expected);
}

Future<void> _testOptimizer02(WidgetTester tester) async {
  const text = '<italic></italic>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan();
  expect(span, expected);
}

Future<void> _testOptimizer03(WidgetTester tester) async {
  const text = '<italic><delete=green></delete></italic>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan();
  expect(span, expected);
}

Future<void> _testOptimizer04(WidgetTester tester) async {
  const text = '<bold>文本</bold><italic><delete=green></delete></italic>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan(children: [
    TextSpan(text: "文本", style: TextStyle(fontWeight: FontWeight.bold)),
  ]);
  expect(span, expected);
}

Future<void> _testOptimizer05(WidgetTester tester) async {
  const text = '<italic></italic><bold>文本</bold>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan(children: [
    TextSpan(text: "文本", style: TextStyle(fontWeight: FontWeight.bold)),
  ]);
  expect(span, expected);
}

Future<void> _testOptimizer06(WidgetTester tester) async {
  const text = '<color=green>一段</color>'
      '<italic><delete=green><bold></bold></delete></italic>'
      '<bold>文本</bold>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan(children: [
    TextSpan(text: "一段", style: TextStyle(color: Color(0xFF4CAF50))),
    TextSpan(text: "文本", style: TextStyle(fontWeight: FontWeight.bold)),
  ]);
  expect(span, expected);
}
