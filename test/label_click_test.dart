import 'package:auto_rich_text/auto_rich_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testWidgets("runs AutoRichText Label `click`", _testClickLabel);
}

Future<void> _testClickLabel(WidgetTester tester) async {
  var clicked = false;

  await tester.pumpWidget(AutoRichText(
    text: "<click='id:tap'>点击</click>",
    style: defStyle,
    builder: richTextBuilder,
    onEventCallback: (event) {
      clicked = true;
      expect(event.type, AutoRichTextEventType.click);
      expect(event.id, 'tap');
      expect(event.subType, 'single');
      const ListEquality().equals(event.args, <String>[]);
    },
  ).wrap());

  var span = getTextSpan(tester);
  expect(span.recognizer != null, true);

  await tester.tapOnText(find.textRange.ofSubstring("点击"));
  expect(clicked, true);

  clicked = false;
  await tester.pumpWidget(AutoRichText(
    text: "<click='id:tap; type:double; args:1,2,3;'>点击</click>",
    style: defStyle,
    builder: richTextBuilder,
    onEventCallback: (event) {
      clicked = true;
      expect(event.type, AutoRichTextEventType.click);
      expect(event.id, 'tap');
      expect(event.subType, 'double');
      const ListEquality().equals(event.args, ["1", "2", "3"]);
    },
  ).wrap());

  span = getTextSpan(tester);
  expect(span.recognizer != null, true);

  (span.recognizer as DoubleTapGestureRecognizer).onDoubleTap!();
  expect(clicked, true);

  clicked = false;
  await tester.pumpWidget(AutoRichText(
    text: "<click='id:tap; type:long; args:aa,bb'>点击</click>",
    style: defStyle,
    builder: richTextBuilder,
    onEventCallback: (event) {
      clicked = true;
      expect(event.type, AutoRichTextEventType.click);
      expect(event.id, 'tap');
      expect(event.subType, 'long');
      const ListEquality().equals(event.args, ["aa", "bb"]);
    },
  ).wrap());

  span = getTextSpan(tester);
  expect(span.recognizer != null, true);
  (span.recognizer as LongPressGestureRecognizer).onLongPress!();
  expect(clicked, true);
}
