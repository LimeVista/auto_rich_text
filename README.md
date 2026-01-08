<p align="center">
  <a href="README.md">
    <img src="https://img.shields.io/badge/Language-English-blue?style=for-the-badge" alt="English">
  </a>
  <a href="README_zh.md">
    <img src="https://img.shields.io/badge/语言-简体中文-red?style=for-the-badge" alt="Chinese">
  </a>
</p>

# AutoRichText

An auto-parsing rich text widget.

## Preview

* **Live Demo:** [Online Demo](https://limevista.github.io/auto_rich_text_example/)

## Quick Start

### Installation

```yaml
dependencies:
  auto_rich_text: `ver`

```

### Import

```dart
import 'package:auto_rich_text/auto_rich_text.dart';

```

### Simple Example

```dart
AutoRichText(
  text: 'Hello <bold>World</bold>',
  style: TextStyle(fontSize: 16),
  builder: (span, style) => Text.rich(span, style: style),
);
```

### Global Settings

Reference: `lib/src/settings.dart`

```dart
/// Global settings for AutoRichText
final class AutoRichTextSettings {
  /// Get current settings
  factory AutoRichTextSettings() => shared;

  /// Show hints during runtime
  bool get lintMode;

  /// Set whether to show hints
  set lintMode(bool value);

  /// Set custom color mapping, default is null
  void setCustomColorMapFunc(ColorMapFunc? func);

  /// Set custom image mapping, default is null
  ///
  /// If [func] returns null, the default implementation is used 
  /// (loading images from the `assets/images` directory)
  void setCustomImageMapFunc(ImageMapFunc? func);

  /// Custom rich text creator, defaults to [Text.rich]
  void setInternalRichTextCreator(InternalRichTextCreator? func);

  /// Invalidates the cache for all [AutoRichText] widgets, causing recalculation on the next repaint
  ///
  /// [rebuildAll] being true means rebuilding the syntax tree, otherwise only styles are rebuilt
  void invalidate([bool rebuildAll = false]);
}

```

## Tags & Syntax

### Placeholder Alignment Tag `align`

| Syntax                   | Description                                               |
|--------------------------|-----------------------------------------------------------|
| `<align=middle></align>` | Basic syntax. [See details](#widget-alignment-parameters) |

#### Notes

* Only effective when child tags are placeholders, such as `<gradient>`, `<icon/>`, etc.
* Some widget alignment parameters can be used in conjunction with `TextStyle.textBaseline`.

### Bold (Weight) Tag `bold` or `weight`

| Syntax                   | Description                                    |
|--------------------------|------------------------------------------------|
| `<bold></bold>`          | Equivalent to `<weight=bold></weight>`         |
| `<weight=w700></weight>` | Full syntax. [See details](#font-weight-table) |

### Italic Tag `italic`

| Syntax              | Description  |
|---------------------|--------------|
| `<italic></italic>` | Basic syntax |

### Color Tag `color`

| Syntax                      | Description                                                    |
|-----------------------------|----------------------------------------------------------------|
| `<color=#4C5A79></color>`   | Describe color using RGB. [See details](#color-reference)      |
| `<color=#4C5A79FF></color>` | Describe color using W3C RGBA. [See details](#color-reference) |
| `<color=lime></color>`      | Use color name. [See details](#color-reference)                |

### Strikethrough Tag `delete`

| Syntax                                                        | Description                                                      |
|---------------------------------------------------------------|------------------------------------------------------------------|
| `<delete=#4C5A79></delete>`                                   | Basic syntax, contains only strikethrough color                  |
| `<delete=lime></delete>`                                      | Basic syntax, contains only strikethrough color using color name |
| `<delete='color:white; style:solid; thickness:1.0'></delete>` | Full syntax                                                      |

#### Parameters

| Parameter   | Description                                                      |
|-------------|------------------------------------------------------------------|
| `color`     | Optional. Decorator color. [See details](#color-reference)       |
| `style`     | Optional. Decorator style. [See details](#line-decoration-table) |
| `thickness` | Optional. Decorator thickness                                    |

### Underline Tag `u`

| Syntax                                                          | Description                                                  |
|-----------------------------------------------------------------|--------------------------------------------------------------|
| `<u=#4C5A79></u>`                                               | Basic syntax, contains only underline color                  |
| `<u=lime></u>`                                                  | Basic syntax, contains only underline color using color name |
| `<u='color:white; style:solid; thickness:1.0; height:1.0'></u>` | Full syntax                                                  |

#### Parameters

| Parameter   | Description                                                      |
|-------------|------------------------------------------------------------------|
| `color`     | Optional. Decorator color. [See details](#color-reference)       |
| `style`     | Optional. Decorator style. [See details](#line-decoration-table) |
| `thickness` | Optional. Decorator thickness                                    |
| `height`    | Optional. Height offset from the text                            |

### Text Size Tag `size`

| Syntax             | Description             |
|--------------------|-------------------------|
| `<size=12></size>` | Set absolute font size  |
| `<size=+3></size>` | Increase font size by 3 |
| `<size=-3></size>` | Decrease font size by 3 |

### Font Tag `font`

| Syntax               | Description             |
|----------------------|-------------------------|
| `<font=sans></font>` | Set font family to sans |

### Font Icon Tag `icon`

| Syntax                                   | Description                                            |
|------------------------------------------|--------------------------------------------------------|
| `<icon='code:1; font-family:IconFont'/>` | Displays icon with code `1` and font family `IconFont` |

#### Parameters

| Parameter     | Description                     |
|---------------|---------------------------------|
| `code`        | Required. Icon code             |
| `font-family` | Required. Icon font family name |

#### Notes

* If `font-family` is `MaterialIcons`, you must add the compilation flag `--no-tree-shake-icons`.

### Image Tag `image`

| Syntax                                                                      | Description |
|-----------------------------------------------------------------------------|-------------|
| `<image='file:icon.png; width:32; height:32; color:white; blend:srcOver'/>` | Full syntax |

#### Parameters

| Parameter | Description                                                                                                                                                       |
|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `file`    | Required. Image name. Must not contain spaces. Only supports images in the `assets/images` directory. Loading external files is not allowed for security reasons. |
| `width`   | Optional. Image display width                                                                                                                                     |
| `height`  | Optional. Image display height                                                                                                                                    |
| `color`   | Optional. Image color. [See details](#color-reference)                                                                                                            |
| `blend`   | Optional. Blend mode. [See details](#blend-mode-table)                                                                                                            |

### Gradient Tag `gradient`

| Syntax                                                                                                                                  | Description                      |
|-----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| `<gradient='type:linear; colors:red,yellow; stops:0.0,1.0; tile:clamp; blend:modulate; begin:centerLeft; end: centerRight'></gradient>` | Linear gradient                  |
| `<gradient='type:radial; colors:red,yellow; stops:0.0,1.0; tile:clamp; blend:modulate; center:center; radius: 0.5'></gradient>`         | Radial gradient                  |
| `<gradient='colors:red,yellow'></gradient>`                                                                                             | Simplest form of linear gradient |
| `<gradient='type:radial; colors:red,yellow'></gradient>`                                                                                | Simplest form of radial gradient |

#### Parameters

| Parameter      | Description                                                                                                                    |
|----------------|--------------------------------------------------------------------------------------------------------------------------------|
| `colors`       | Required. Gradient colors. [See details](#color-reference)                                                                     |
| `type`         | Optional. Gradient type. Supports `linear` and `radial`. Default is `linear`.                                                  |
| `stops`        | Optional. Gradient stops. Default is empty. Syntax: `x,y,z` (e.g., `0.5,0.5,1.0`). Must match the number of colors.            |
| `tile`         | Optional. Tile mode. Default is `clamp`. [See details](#tile-mode-table)                                                       |
| `blend`        | Optional. Blend mode. Default is `modulate`. [See details](#blend-mode-table)                                                  |
| `begin`        | Optional. Start position. Only valid for linear gradients. Default is `centerLeft`. [See details](#alignment-parameters-table) |
| `end`          | Optional. End position. Only valid for linear gradients. Default is `centerRight`. [See details](#alignment-parameters-table)  |
| `center`       | Optional. Center position. Only valid for radial gradients. Default is `center`. [See details](#alignment-parameters-table)    |
| `radius`       | Optional. Radial gradient radius. Only valid for radial gradients. Default is `0.5`.                                           |
| `focal`        | Optional. Focal position. Only valid for radial gradients.                                                                     |
| `focal-radius` | Optional. Focal radius. Only valid for radial gradients. Default is `0.0`.                                                     |

### `click` Tag

| Syntax                                        | Description |
|-----------------------------------------------|-------------|
| `<click='id:xxx; type:single; args: a,b,c'/>` | Full syntax |

#### Parameters

| Parameter | Description                                                                                                     |
|-----------|-----------------------------------------------------------------------------------------------------------------|
| `id`      | Required. Tag ID used to identify the tag.                                                                      |
| `type`    | Optional. Event type. Supports `single` (tap), `double` (double tap), `long` (long press). Default is `single`. |
| `args`    | Arguments. Multiple arguments separated by commas.                                                              |

## Parameter Reference

### Color Reference

#### Color Specification

* Only Hex notation is supported here.
* See specification: [
  `Web Hex Color`](https://www.google.com/search?q=%5Bhttps://developer.mozilla.org/en-US/docs/Web/CSS/hex-color%5D(https://developer.mozilla.org/en-US/docs/Web/CSS/hex-color))

| Syntax      | Description                                    |
|-------------|------------------------------------------------|
| `#RGB`      | 3-digit syntax, e.g., `#F00` (Red)             |
| `#RGBA`     | 4-digit syntax, e.g., `#F00A` (Red with Alpha) |
| `#RRGGBB`   | 6-digit syntax, e.g., `#FF0000` (Red)          |
| `#RRGGBBAA` | 8-digit syntax, e.g., `#FF0000FF` (Red Opaque) |

#### Color Names

Uses Material standard, supports the following names:
| Parameter | Description |
| :----|:---- |
|`transparent` | `#00000000` |
|`black` | `#000000` |
|`white` | `#FFFFFF` |
|`red` | `#F44336` |
|`green` | `#4CAF50` |
|`blue` | `#2196F3` |
|`pink` | `#E91E63` |
|`purple` | `#9C27B0` |
|`indigo` | `#3F51B5` |
|`cyan` | `#00BCD4` |
|`teal` | `#009688` |
|`lime` | `#CDDC39` |
|`yellow` | `#FFEB3B` |
|`amber` | `#FFC107` |
|`orange` | `#FF9800` |
|`brown` | `#795548` |
|`grey` | `#9E9E9E` |

### Font Weight Table

| Parameter | Description     |
|-----------|-----------------|
| `normal`  | Standard `w400` |
| `bold`    | Bold `w700`     |
| `w100`    | Thin            |
| `w200`    | Extra Light     |
| `w300`    | Light           |
| `w400`    | Normal          |
| `w500`    | Medium          |
| `w600`    | Semi-bold       |
| `w700`    | Bold            |
| `w800`    | Extra-bold      |
| `w900`    | Black           |

### Widget Alignment Parameters

| Parameter       | Description                       |
|-----------------|-----------------------------------|
| `baseline`      | Baseline alignment                |
| `aboveBaseline` | Bottom edge aligned with baseline |
| `belowBaseline` | Top edge aligned with baseline    |
| `top`           | Top alignment                     |
| `bottom`        | Bottom alignment                  |
| `middle`        | Middle alignment                  |

### Line Decoration Table

| Parameter | Description |
|-----------|-------------|
| `solid`   | Solid line  |
| `double`  | Double line |
| `dotted`  | Dotted line |
| `dashed`  | Dashed line |
| `wavy`    | Wavy line   |

### Blend Mode Table

For more details, see: [
`BlendMode`](https://www.google.com/search?q=%5Bhttps://api.flutter.dev/flutter/dart-ui/BlendMode.html%5D(https://api.flutter.dev/flutter/dart-ui/BlendMode.html))

| Parameter    | Description                                                                                        |
|--------------|----------------------------------------------------------------------------------------------------|
| `clear`      | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_clear.png)      |
| `src`        | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_src.png)        |
| `dst`        | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dst.png)        |
| `srcOver`    | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcOver.png)    |
| `dstOver`    | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstOver.png)    |
| `srcIn`      | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcIn.png)      |
| `dstIn`      | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstIn.png)      |
| `srcOut`     | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcOut.png)     |
| `dstOut`     | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstOut.png)     |
| `srcATop`    | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcATop.png)    |
| `dstATop`    | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstATop.png)    |
| `xor`        | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_xor.png)        |
| `plus`       | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_plus.png)       |
| `modulate`   | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_modulate.png)   |
| `value`      | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_screen.png)     |
| `overlay`    | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_overlay.png)    |
| `darken`     | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_darken.png)     |
| `lighten`    | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_lighten.png)    |
| `colorDodge` | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_colorDodge.png) |
| `colorBurn`  | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_colorBurn.png)  |
| `hardLight`  | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_hardLight.png)  |
| `softLight`  | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_softLight.png)  |
| `difference` | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_difference.png) |
| `exclusion`  | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_exclusion.png)  |
| `multiply`   | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_multiply.png)   |
| `hue`        | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_hue.png)        |
| `saturation` | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_hue.png)        |
| `color`      | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_color.png)      |
| `luminosity` | [As shown](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_luminosity.png) |

### Tile Mode Table

| Parameter  | Description                                                                   |
|------------|-------------------------------------------------------------------------------|
| `clamp`    | Sampling outside the edge uses the closest color in the defined area.         |
| `mirror`   | Sampling outside the edge is mirrored back and forth within the defined area. |
| `repeated` | Sampling outside the edge repeats from the far end of the defined area.       |
| `decal`    | Sampling outside the edge is treated as transparent black.                    |

### Alignment Parameters Table

| Parameter      | Description         |
|----------------|---------------------|
| `topLeft`      | Align top-left      |
| `topCenter`    | Align top-center    |
| `topRight`     | Align top-right     |
| `centerLeft`   | Align center-left   |
| `center`       | Align center        |
| `centerRight`  | Align center-right  |
| `bottomLeft`   | Align bottom-left   |
| `bottomCenter` | Align bottom-center |
| `bottomRight`  | Align bottom-right  |

## Syntax Design & Specifications

### Core Goals

* HTML-like syntax, but does not strictly follow HTML rules.
* Syntax design inspired by rich text tags in Unity, Cocos, and Godot game engines.
* Keep tags sufficiently singular and readable.
* Maintain semantic consistency in syntax as much as possible.
* Unify syntax to reduce learning costs.

### Syntax Specifications

* Tag names consist only of lowercase letters.
* Text consists of UTF-8 encoded characters.
* Parameter names consist of letters (case-insensitive) and hyphens. Names cannot start with a
  hyphen.
* Parameter values consist of letters, numbers, hyphens, plus signs, dots, underscores, and hashes.
* Arrays consist of multiple parameter values separated by commas.
* Dictionary expressions are enclosed in single quotes, with key-value pairs separated by
  semicolons. Note: No space is allowed between `Key` and `:`, but spaces are allowed between
  `Value` and `:`.
* Nesting is not allowed in dictionary expressions; duplicate parameter names are not allowed.

**Detailed syntax description:**

```
# Tag Name
Label: (
    [a-z]+
)

# Text
Text: (
    [\S\s\n\r]*
)

# Parameter Name
Key: (
    [A-Za-z][A-Za-z\-]*
)

# Parameter Value
Value: (
    [A-Za-z0-9\-\+\._#]+
)

# Array
Array: (
    Value, ...
)

# Dictionary Expression
MapExpression: (
    'Key: (Value | Array); ...'
)

# Attribute Tag
AttributeExpression: (
    <Label>Text</Label> |
    <Label=Value>Text</Label> |
    <Label=MapExpression>Text</Label>
)

# Element Tag
ElementExpression: (
    <Label=Value/> |
    <Label=MapExpression/>
)

```

### Parsing & Generation

* **Optimize during generation:**
* Merge attributes to reduce unnecessary nesting (e.g., `<size=3><bold></bold></size>` =>
  `TextSpan(text, style(size, bold))`).
* Remove invalid tags (e.g., `<bold></bold>` => `     `).


* **When multiple attribute tags are nested continuously:**
* If the relationship is computational, calculate cumulatively from outer to inner (e.g.,
  `<size=+3><size=-2></size></size>` results in `x + 3 - 2`).
* If the relationship is inherited, take the value from the nearest layer (e.g.,
  `<size=3><size=5></size></size>` results in `5`).


* Reuse previous `Span` when text hasn't changed.

### Design Q&A

#### Why not use XHTML syntax?

* XHTML tags are complex and the syntax is verbose, which can easily cause ambiguity. We need tags
  to be singular and readable, with syntax that maintains semantic consistency.
* We want to avoid dealing with XML escape semantics as much as possible.
* The design here refers to rich text tags in Unity, Cocos, and Godot game engines.