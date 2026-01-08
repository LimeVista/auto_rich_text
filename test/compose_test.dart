import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText compose text", _testCompose);
}

Future<void> _testCompose(WidgetTester tester) async {
  const text = '<bold>一段</bold>'
      '<color=green>'
      '<italic><delete=green>复合</delete></italic>'
      '<size=+2>文本</size>'
      '</color>';
  await tester.pumpWidget(const AutoRichText(
    text: text,
    style: defStyle,
    builder: richTextBuilder,
    debug: true,
  ).wrap());
  final span = getTextSpan(tester);

  const expected = TextSpan(children: [
    TextSpan(text: "一段", style: TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
      style: TextStyle(color: Color(0xFF4CAF50)),
      children: [
        TextSpan(
          text: "复合",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.lineThrough,
            decorationColor: Color(0xFF4CAF50),
          ),
        ),
        TextSpan(text: "文本", style: TextStyle(fontSize: 18)),
      ],
    ),
  ]);
  expect(span, expected);
}
