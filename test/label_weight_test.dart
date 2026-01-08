import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `weight`", _testWeightLabel);
}

Future<void> _testWeightLabel(WidgetTester tester) async {
  await tester.pumpWidget(const AutoRichText(
    text: '你好 <weight=w700>世界</weight>',
    style: defStyle,
    builder: richTextBuilder,
  ).wrap());
  final span = getTextSpan(tester);

  expect(span.children!.length, 2);
  expect(span, expectedBold);
}
