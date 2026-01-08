// ignore_for_file: avoid_print

import 'package:auto_rich_text/src/rich_text.dart';
import 'package:flutter/rendering.dart';

/// 循环 50 万次
const kCount = 500000;

void main() async {
  const warmUpText = "预热";
  AutoRichText.createSpanFromText(warmUpText, const TextStyle());

  await _run("Benchmark 01", _t01);
  await _run("Benchmark 02", _t02);
  await _run("Benchmark 03", _t03);
  await _run("Benchmark 04", _t04);
}

Future<void> _run(String name, VoidCallback fn) async {
  print("Running $name...");
  // 停留一下，让出 GC 时间片
  await Future.delayed(const Duration(milliseconds: 100));

  fn();

  print("Done $name\n");
}

void _t01() {
  const text = '<bold>一段</bold>'
      '<color=green>'
      '<italic><delete=green>复合</delete></italic>'
      '<size=+2>文本</size>'
      '</color>';
  const style = TextStyle(fontSize: 16);
  final sc = Stopwatch();
  sc.start();
  for (var n = 0; n < kCount; ++n) {
    final _ = AutoRichText.createSpanFromText(text, style);
  }
  sc.stop();
  final ms = sc.elapsedMilliseconds;
  final avg = sc.elapsedMicroseconds / kCount;
  print('用例一: $ms 毫秒，平均：${avg.toStringAsFixed(2)} 微秒');
}

void _t02() {
  const text = '你好 <size=+2><size=16><size=-2>世界</size></size></size>';
  const style = TextStyle(fontSize: 16);
  final sc = Stopwatch();
  sc.start();
  for (var n = 0; n < kCount; ++n) {
    final _ = AutoRichText.createSpanFromText(text, style);
  }
  sc.stop();
  final ms = sc.elapsedMilliseconds;
  final avg = sc.elapsedMicroseconds / kCount;
  print('用例二: $ms 毫秒，平均：${avg.toStringAsFixed(2)} 微秒');
}

void _t03() {
  const colors = 'colors:red,yellow';
  const type = 'type:linear';
  const begin = 'begin:topLeft';
  const end = 'end:bottomRight';
  const tile = 'tile:clamp';
  const stops = 'stops:0.0,1.0';
  const blend = 'blend:modulate';
  const text = "你好<gradient='$colors; $type; $begin; $end; $tile; $stops; $blend'>世界</gradient>";
  const style = TextStyle(fontSize: 16);
  final sc = Stopwatch();
  sc.start();
  for (var n = 0; n < kCount; ++n) {
    final _ = AutoRichText.createSpanFromText(text, style);
  }
  sc.stop();
  final ms = sc.elapsedMilliseconds;
  final avg = sc.elapsedMicroseconds / kCount;
  print('用例三: $ms 毫秒，平均：${avg.toStringAsFixed(2)} 微秒');
}

void _t04() {
  const text = '<bold>一段</bold><italic>简单</italic><bold><italic>文本</italic></bold>';
  final sc = Stopwatch();
  sc.start();
  for (var n = 0; n < kCount; ++n) {
    $parseForBenchmark(text);
  }
  sc.stop();
  final ms = sc.elapsedMilliseconds;
  final avg = sc.elapsedMicroseconds / kCount;
  print('用例四: $ms 毫秒，平均：${avg.toStringAsFixed(2)} 微秒');
}
