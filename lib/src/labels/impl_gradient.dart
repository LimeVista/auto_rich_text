part of '../rich_text.dart';

class _GradientData {
  const _GradientData(this.gradient, this.blendMode);

  /// 渐变参数
  final Gradient gradient;

  /// 混合模式
  final ui.BlendMode blendMode;

  static _GradientData parse(_Key key, String origin, String value) {
    final blocks = _ArgsKeyValues.parseAll(origin, value, true);

    int? type;
    Alignment? begin, end, center, focal;
    ui.TileMode? tileMode;
    List<Color>? colors;
    List<double>? stops;
    double? radius, fr;
    ui.BlendMode? blendMode;

    _MakeAttributeError err(String msg) {
      return _MakeAttributeError('$origin $msg');
    }

    for (final block in blocks) {
      final key = block.key;
      final vs = block.values;

      switch (key) {
        case 'colors':
          if (colors != null) throw err('duplicate argument');
          colors = [];
          for (final value in vs) {
            final color = value.parseColor();
            if (color == null) throw err('invalid color argument');
            colors.add(color);
          }
          break;

        case 'stops':
          if (stops != null) throw err('duplicate argument');
          stops = [];
          for (final value in vs) {
            final stop = double.tryParse(value);
            if (stop == null) throw err('invalid stop argument');
            stops.add(stop);
          }
          break;

        case 'type':
          if (type != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid type argument');
          type = switch (vs[0]) {
            'linear' => 0,
            'radial' => 1,
            _ => throw err('invalid type argument'),
          };
          break;

        case 'center':
          if (center != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid center argument');
          center = vs[0].parseAlignment();
          if (center == null) throw err('invalid center argument');
          break;

        case 'begin':
          if (begin != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid begin argument');
          begin = vs[0].parseAlignment();
          if (begin == null) throw err('invalid begin argument');
          break;

        case 'end':
          if (end != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid end argument');
          end = vs[0].parseAlignment();
          if (end == null) throw err('invalid end argument');
          break;

        case 'focal':
          if (focal != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid focal argument');
          focal = vs[0].parseAlignment();
          if (focal == null) throw err('invalid focal argument');
          break;

        case 'radius':
          if (radius != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid radius argument');
          radius = double.tryParse(vs[0]);
          if (radius == null) throw err('invalid radius argument');
          break;

        case 'focal-radius':
          if (fr != null) throw err('duplicate argument');
          if (vs.length != 1) throw err('invalid focal-radius argument');
          fr = double.tryParse(vs[0]);
          if (fr == null) throw err('invalid focal-radius argument');
          break;

        case 'tile':
          if (tileMode != null) throw err('duplicate argument');
          final val = vs[0];
          for (final mode in ui.TileMode.values) {
            if (mode.name != val) continue;
            tileMode = mode;
            break;
          }
          if (tileMode == null) throw err('invalid tile mode argument');
          break;

        case 'blend':
          if (blendMode != null) throw err('duplicate argument');
          final val = vs[0];
          for (final mode in BlendMode.values) {
            if (mode.name != val) continue;
            blendMode = mode;
            break;
          }
          if (blendMode == null) throw err('invalid blend mode argument');
          break;
      }
    }

    if (colors == null) {
      throw err('missing colors argument');
    }

    if (stops != null && colors.length != stops.length) {
      throw err('colors and stops length mismatch');
    }

    blendMode ??= ui.BlendMode.modulate;

    switch (type ?? 0) {
      case 1:
        return _GradientData(
          RadialGradient(
            colors: colors,
            stops: stops,
            center: center ?? Alignment.center,
            radius: radius ?? 0.5,
            focal: focal,
            focalRadius: fr ?? 0.0,
            tileMode: tileMode ?? ui.TileMode.clamp,
          ),
          blendMode,
        );

      default:
        return _GradientData(
          LinearGradient(
            colors: colors,
            stops: stops,
            begin: begin ?? Alignment.centerLeft,
            end: end ?? Alignment.centerRight,
            tileMode: tileMode ?? ui.TileMode.clamp,
          ),
          blendMode,
        );
    }
  }
}

class _GradientAttribute extends _Attribute<_GradientData> {
  const _GradientAttribute(super.key, super.value);

  @override
  void merge(_AttributeValue val, TextStyle style) {}

  static _Attribute make(_Key key, String origin, String? value) {
    if (value == null) throw _MakeAttributeError('<${key.keyword}> missing argument');
    return _GradientAttribute(key, _GradientData.parse(key, origin, value));
  }
}
