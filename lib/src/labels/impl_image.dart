part of '../rich_text.dart';

/// 图片数据
class _ImageData {
  const _ImageData(
    this.file,
    this.fit,
    this.color,
    this.width,
    this.height,
    this.blend,
  );

  /// 图片路径
  final String file;

  /// 图片适配模式
  final BoxFit fit;

  /// 图片颜色
  final Color? color;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 混合模式
  final BlendMode? blend;

  /// 解析参数
  static _ImageData parse(_Key key, String origin, String value) {
    String? file;
    Color? color;
    double? width;
    double? height;
    BlendMode? blend;
    BoxFit? fit;

    final blocks = _ArgsKeyValues.parseAll(origin, value, false);
    for (final block in blocks) {
      final key = block.key;
      final val = block.values.first;

      if (block.values.length > 1) {
        throw _MakeAttributeError('$origin invalid argument');
      }

      switch (key) {
        case 'file':
          if (file != null) throw _MakeElementError('$origin duplicate argument');
          file = val;
          if (!val.endsWith('.png') && !val.endsWith('.jpg') && !val.endsWith('.webp')) {
            throw _MakeElementError('$origin invalid file argument');
          }
          break;

        case 'color':
          if (color != null) throw _MakeElementError('$origin duplicate argument');
          color = val.parseColor();
          if (color == null) throw _MakeElementError('$origin invalid color argument');
          break;

        case 'width':
          if (width != null) throw _MakeElementError('$origin duplicate argument');
          width = double.tryParse(val);
          if (width == null) throw _MakeElementError('$origin invalid width argument');
          break;

        case 'height':
          if (height != null) throw _MakeElementError('$origin duplicate argument');
          height = double.tryParse(val);
          if (height == null) throw _MakeElementError('$origin invalid height argument');
          break;

        case 'blend':
          if (blend != null) throw _MakeElementError('$origin duplicate argument');
          for (final mode in BlendMode.values) {
            if (mode.name != val) continue;
            blend = mode;
            break;
          }
          if (blend == null) throw _MakeElementError('$origin invalid blend mode argument');
          break;

        case 'fit':
          if (fit != null) throw _MakeElementError('$origin duplicate argument');
          for (final mode in BoxFit.values) {
            if (mode.name != val) continue;
            fit = mode;
            break;
          }
          if (fit == null) throw _MakeElementError('$origin invalid fit argument');
          break;
      }
    }

    if (file == null) {
      throw _MakeElementError('$origin missing file argument');
    }

    fit ??= BoxFit.scaleDown;

    return _ImageData(file, fit, color, width, height, blend);
  }
}

class _ImageElement extends _Element<_ImageData> {
  const _ImageElement(super.key, super.value);

  @override
  InlineSpan makeSpan(TextStyle style, ui.PlaceholderAlignment? alignment, OnRefCallback ref) {
    final img = Image.asset(
      'assets/images/${value.file}',
      fit: value.fit,
      width: value.width,
      height: value.height,
      color: value.color,
      colorBlendMode: value.blend,
    );
    return img.createSpan(alignment, null, style.textBaseline);
  }

  static _Element make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeElementError('<${key.keyword}/> missing argument');
    return _ImageElement(key, _ImageData.parse(key, origin, value));
  }
}
