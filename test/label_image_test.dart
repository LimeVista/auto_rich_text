import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `image`", _testImageLabel);
}

Future<void> _testImageLabel(WidgetTester tester) async {
  const name = 'img.png';
  const color = 'color:white';
  const fit = 'fit:contain';
  const blend = 'blend:srcOver';
  const size = 'width:32; height:32';

  await tester.pumpWidget(const AutoRichText(
    text: "你好<image='file:$name; $size; $color; $fit; $blend'/>世界",
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 3);
  expect(span.children![0], const TextSpan(text: "你好"));
  expect(span.children![2], const TextSpan(text: "世界"));

  final imageSpan = span.children![1] as WidgetSpan;
  final imageWidget = imageSpan.child as Image;
  expect((imageWidget.image as AssetImage).assetName, 'assets/images/$name');
  expect(imageWidget.fit, BoxFit.contain);
  expect(imageWidget.width, 32);
  expect(imageWidget.height, 32);
  expect(imageWidget.colorBlendMode, BlendMode.srcOver);
}
