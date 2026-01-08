import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `gradient`", _testGradientLabel);
}

Future<void> _testGradientLabel(WidgetTester tester) async {
  const colors = 'colors:red,yellow';
  const type = 'type:linear';
  const begin = 'begin:topLeft';
  const end = 'end:bottomRight';
  const tile = 'tile:clamp';
  const stops = 'stops:0.0,1.0';
  const blend = 'blend:modulate';

  await tester.pumpWidget(const AutoRichText(
    text: "你好<gradient='$colors; $type; $begin; $end; $tile; $stops; $blend'>世界</gradient>",
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect(span.children![0], const TextSpan(text: "你好"));
  final text = span.children![1];
  expect(text, isInstanceOf<WidgetSpan>());
  expect((text as WidgetSpan).child, isInstanceOf<ShaderMask>());
  final w = text.child as ShaderMask;
  expect(w.blendMode, BlendMode.modulate);
}
