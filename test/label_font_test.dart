import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `font`", _testFontLabel);
}

Future<void> _testFontLabel(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <font=sans>世界</font>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect(
    span,
    const TextSpan(
      children: [
        TextSpan(text: "你好 "),
        TextSpan(text: "世界", style: TextStyle(fontFamily: 'sans')),
      ],
    ),
  );
}
