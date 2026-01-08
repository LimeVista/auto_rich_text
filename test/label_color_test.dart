import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `color` 01", _testColorLabel01);
  testWidgets("runs AutoRichText Label `color` 02", _testColorLabel02);
  testWidgets("runs AutoRichText Label `color` 03", _testColorLabel03);
}

Future<void> _testColorLabel01(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <color=#4CAF50>世界</color>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect(span, expectedColor);
}

Future<void> _testColorLabel02(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <color=#4CAF50FF>世界</color>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect(span, expectedColor);
}

Future<void> _testColorLabel03(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <color=green>世界</color>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect(span, expectedColor);
}
