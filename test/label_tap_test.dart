import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `tap`", _testTapLabel);
}

Future<void> _testTapLabel(WidgetTester tester) async {
  var count = 0;
  await tester.pumpWidget(AutoRichText(
    text: "<tap='id:tap; types:tap,tapDown,tapUp; args:1,2,3;'>点击</tap>",
    style: defStyle,
    builder: richTextBuilder,
    onEventCallback: (event) {
      count++;
      if (count == 3) expect(event.subType, 'tap');
      expect(event.type, AutoRichTextEventType.tap);
      expect(event.id, 'tap');
      const ListEquality().equals(event.args, ["1", "2", "3"]);
    },
  ).wrap());

  await tester.tapOnText(find.textRange.ofSubstring("点击"));
  expect(count, 3);
}
