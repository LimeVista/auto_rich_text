import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `icon`", _testIconLabel);
}

Future<void> _testIconLabel(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: "你好<icon='code: 0xE047; font-family:MaterialIcons'/>世界",
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());

  final span = getTextSpan(tester);
  expect(span.children!.length, 3);
  expect(span.children![0], const TextSpan(text: "你好"));
  expect(span.children![2], const TextSpan(text: "世界"));

  final iconSpan = span.children![1];
  expect(iconSpan, isInstanceOf<TextSpan>());
  expect(
    iconSpan,
    TextSpan(
      text: String.fromCharCode(0xE047),
      style: defStyle.copyWith(fontFamily: 'MaterialIcons'),
    ),
  );
}
