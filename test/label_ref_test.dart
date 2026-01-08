import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `ref`", _testRefLabel);
  testWidgets("throws on missing argument in `ref`", _testRefMissingArgument);
}

Future<void> _testRefLabel(WidgetTester tester) async {
  String? refValue;

  await tester.pumpWidget(AutoRichText(
    text: 'Tap <ref=target/>',
    style: defStyle,
    onRefCallback: (ref, style) {
      refValue = ref;
      return TextSpan(text: "Linked", style: style.copyWith(color: Colors.blue));
    },
    builder: richTextBuilder,
  ).wrap());

  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect((span.children![0] as TextSpan).text, "Tap ");
  expect((span.children![1] as TextSpan).text, "Linked");
  expect((span.children![1] as TextSpan).style!.color, Colors.blue);

  expect(refValue, "target");
}

Future<void> _testRefMissingArgument(WidgetTester tester) async {
  final span = AutoRichText.createSpanFromText('Error <ref/>', defStyle);
  expect(span, const TextSpan(text: "Error <ref/>"));
}
