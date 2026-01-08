import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `italic`", _testItalicLabel);
}

Future<void> _testItalicLabel(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <italic>世界</italic>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  const expected = TextSpan(children: [
    TextSpan(text: "你好 "),
    TextSpan(text: "世界", style: TextStyle(fontStyle: FontStyle.italic)),
  ]);

  final span = getTextSpan(tester);
  expect(span.children!.length, 2);
  expect(span, expected);
}
