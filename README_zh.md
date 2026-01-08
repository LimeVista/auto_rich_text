<p align="center">
  <a href="README.md">
    <img src="https://img.shields.io/badge/Language-English-blue?style=for-the-badge" alt="English">
  </a>
  <a href="README_zh.md">
    <img src="https://img.shields.io/badge/语言-简体中文-red?style=for-the-badge" alt="Chinese">
  </a>
</p>

# AutoRichText

中文 | [English](README.md)

自动解析型富文本组件

## 效果预览
* **在线预览** [在线预览](https://limevista.github.io/auto_rich_text_example/)
* **参考样例** [参考样例](https://github.com/limevista/auto_rich_text_example)

![预览图](/art/preview.png)

## 快速使用

### 引入包

```yaml
dependencies:
  auto_rich_text: `ver`
```

### 导入 import

```dart
import 'package:auto_rich_text/auto_rich_text.dart';
```

### 简单示例

```dart
AutoRichText(
  text: 'Hello <bold>World</bold>',
  style: TextStyle(fontSize: 16),
  builder: (span, style) => Text.rich(span, style: style),
);
```

### 全局设置

文档参考 `lib/src/settings.dart`

```dart
/// 富文本全局设置
final class AutoRichTextSettings {
  /// 获取当前设置
  factory AutoRichTextSettings() => shared;

  /// 运行过程中显示提示
  bool get lintMode;

  /// 设置是否显示提示
  set lintMode(bool value);

  /// 设置自定义颜色映射，默认为空
  void setCustomColorMapFunc(ColorMapFunc? func);

  /// 设置自定义图片映射，默认为空
  ///
  /// 在 [func] 如果返回 null 则使用默认实现，使用 `assets/images` 目录下的图片
  void setCustomImageMapFunc(ImageMapFunc? func);

  /// 自定义富文本创建器，默认使用 [Text.rich]
  void setInternalRichTextCreator(InternalRichTextCreator? func);

  /// 调用此方法，会是的所有 [AutoRichText] 缓存失效，在下一次重绘时重新计算
  ///
  /// [rebuildAll] 为 `true` 表示重建文本语法数，否则仅重建样式
  void invalidate([bool rebuildAll = false]);
}
```

## 标签与语法

### 占位符对齐标签 `align`

| 语法                       | 描述                  |
|:-------------------------|:--------------------|
| `<align=middle></align>` | 基础语法，[详见](#组件对齐参数表) |

#### 附注

* 仅子标签存在占位符标签：诸如 `<gradient>`、`<icon/>` 等等时才会生效
* 部分组件对齐参数， 可以同 `TextStyle.textBaseline` 一同使用

### 字体加粗（权重）标签 `bold` 获取 `weight`

| 语法                       | 描述                           |
|:-------------------------|:-----------------------------|
| `<bold></bold>`          | 等同于 `<weight=bold></weight>` |
| `<weight=w700></weight>` | 完整语法，[详见](#字体粗细表)            |

### 斜体标签 `italic`

| 语法                  | 描述   |
|:--------------------|:-----|
| `<italic></italic>` | 基础语法 |

### 颜色标签 `color`

| 语法                          | 描述                           |
|:----------------------------|:-----------------------------|
| `<color=#4C5A79></color>`   | 使用 RGB 描述颜色，[详见](#颜色参考)      |
| `<color=#4C5A79FF></color>` | 使用 W3C RGBA 描述颜色，[详见](#颜色参考) |
| `<color=lime></color>`      | 使用颜色标签，[详见](#颜色参考)           |

### 删除线标签 `delete`

| 语法                                                            | 描述                     |
|:--------------------------------------------------------------|:-----------------------|
| `<delete=#4C5A79></delete>`                                   | 基础语法，仅包含删除线颜色          |
| `<delete=lime></delete>`                                      | 基础语法，仅包含删除线颜色，使用颜色名称描述 |
| `<delete='color:white; style:solid; thickness:1.0'></delete>` | 完整语法                   |

#### 参数

| 参数          | 描述                      |
|:------------|:------------------------|
| `color`     | 可选参数，装饰器颜色，[详见](#颜色参考)  |
| `style`     | 可选参数，装饰器样式，[详见](#线条装饰表) |
| `thickness` | 可选参数，装饰器厚度              |

### 下划线标签 `u`

| 语法                                                              | 描述                     |
|:----------------------------------------------------------------|:-----------------------|
| `<u=#4C5A79></u>`                                               | 基础语法，仅包含下划线颜色          |
| `<u=lime></u>`                                                  | 基础语法，仅包含下划线颜色，使用颜色名称描述 |
| `<u='color:white; style:solid; thickness:1.0; height:1.0'></u>` | 完整语法                   |

#### 参数

| 参数          | 描述                      |
|:------------|:------------------------|
| `color`     | 可选参数，装饰器颜色，[详见](#颜色参考)  |
| `style`     | 可选参数，装饰器样式，[详见](#线条装饰表) |
| `thickness` | 可选参数，装饰器厚度              |
| `height`    | 可选参数，距离文字偏移的高度          |

### 文本大小标签 `size`

| 语法                 | 描述       |
|:-------------------|:---------|
| `<size=12></size>` | 设置绝对字体大小 |
| `<size=+3></size>` | 字体上增加三号  |
| `<size=-3></size>` | 字体上减少三号  |

### 字体标签：`font`

| 语法                   | 描述         |
|:---------------------|:-----------|
| `<font=sans></font>` | 设置字体为 sans |

### 字体图标标签 `icon`

| 语法                                       | 描述                           |
|:-----------------------------------------|:-----------------------------|
| `<icon='code:1; font-family:IconFont'/>` | 显示编码为 `1` 字体为 `IconFont` 的图标 |

#### 参数

| 参数            | 描述          |
|:--------------|:------------|
| `code`        | 必选参数，图标代码   |
| `font-family` | 必选参数，图标字体名称 |

#### 附注

* 如果 `font-family` 为 `MaterialIcons` 必须添加编译参数 `--no-tree-shake-icons`

### 图片标签 `image`

| 语法                                                                          | 描述   |
|:----------------------------------------------------------------------------|:-----|
| `<image='file:icon.png; width:32; height:32; color:white; blend:srcOver'/>` | 完整语法 |

#### 参数

| 参数       | 描述                                                             |
|:---------|:---------------------------------------------------------------|
| `file`   | 必选参数，图片名称，名称不允许包含空格，仅支持 `assets/images` 目录下的图片。为保证安全，不允许加载外部文件 |
| `width`  | 可选参数，图片显示宽度                                                    |
| `height` | 可选参数，图片显示高度                                                    |
| `color`  | 可选参数，图片颜色，[详见](#颜色参考)                                          |
| `blend`  | 可选参数，混合模式，[详见](#混合模式表)                                         |

### 渐变标签 `gradient`

| 语法                                                                                                                                      | 描述       |
|:----------------------------------------------------------------------------------------------------------------------------------------|:---------|
| `<gradient='type:linear; colors:red,yellow; stops:0.0,1.0; tile:clamp; blend:modulate; begin:centerLeft; end: centerRight'></gradient>` | 线性渐变     |
| `<gradient='type:radial; colors:red,yellow; stops:0.0,1.0; tile:clamp; blend:modulate; center:center; radius: 0.5'></gradient>`         | 径向渐变     |
| `<gradient='colors:red,yellow'></gradient>`                                                                                             | 线性渐变最简方式 |
| `<gradient='type:radial; colors:red,yellow'></gradient>`                                                                                | 径向渐变最简方式 |

#### 参数

| 参数             | 描述                                                         |
|:---------------|:-----------------------------------------------------------|
| `colors`       | 必选参数，渐变颜色，[详见](#颜色参考)                                      |
| `type`         | 可选参数，渐变类型，支持 `linear`（线性渐变） 和 `radial` （径向渐变），默认为 `linear` |
| `stops`        | 可选参数，渐变颜色停止位置，默认为空，语法为：`x,y,z`，例如：`0.5,0.5,1.0` 和颜色个数必须一致  |
| `tile`         | 可选参数，渐变平铺模式，默认为：`clamp`，[详见](#平铺模式表)                       |
| `blend`        | 可选参数，渐变混合模式，默认为 `modulate`，[详见](#混合模式表)                    |
| `begin`        | 可选参数，渐变起始位置，仅线性渐变有效，默认为 `centerLeft`，[详见](#对齐参数表)          |
| `end`          | 可选参数，渐变结束位置，仅线性渐变有效，默认为 `centerRight`，[详见](#对齐参数表)         |
| `center`       | 可选参数，渐变中心位置，仅径向渐变有效，默认为 `center`，[详见](#对齐参数表)              |
| `radius`       | 可选参数，径向渐变半径，仅径向渐变有效，默认为 `0.5`                              |
| `focal`        | 可选参数，径向渐变焦点位置，仅径向渐变有效                                      |
| `focal-radius` | 可选参数，径向渐变焦点半径，仅径向渐变有效，默认为 `0.0`                            |

### `click` 标签

| 语法                                            | 描述   |
|:----------------------------------------------|:-----|
| `<click='id:xxx; type:single; args: a,b,c'/>` | 完整语法 |

#### 参数

| 参数     | 描述                                                              |
|:-------|:----------------------------------------------------------------|
| `id`   | 必选参数，标签参数，用于标识标签                                                |
| `type` | 可选参数，事件类型，支持 `single`（单击）、`double` （双击）、`long`（长按），默认为 `single` |
| `args` | 附带参数，多个参数用逗号隔开                                                  |

## 参数表

### 颜色参考

#### 颜色规范

* 这里仅支持 16 进制表示
* 规范参见：[`Web Hex Color`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/hex-color)

| 语法          | 描述                          |
|:------------|:----------------------------|
| `#RGB`      | 三值语法，例如：`#F00`，表示红色         |
| `#RGBA`     | 四值语法，例如：`#F00A`，表示红色半透明     |
| `#RRGGBB`   | 六值语法，例如：`#FF0000`，表示红色      |
| `#RRGGBBAA` | 八值语法，例如：`#FF0000FF`，表示红色不透明 |

#### 颜色名称

采用 Material 标准，支持以下命名：
| 参数 | 描述 |
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

### 字体粗细表

| 参数       | 描述        |
|:---------|:----------|
| `normal` | 标准 `w400` |
| `bold`   | 粗体 `w700` |
| `w100`   | 很细        |
| `w200`   | 超细        |
| `w300`   | 细体        |
| `w400`   | 标准        |
| `w500`   | 中型        |
| `w600`   | 细粗        |
| `w700`   | 粗体        |
| `w800`   | 加粗        |
| `w900`   | 黑体        |

### 组件对齐参数表

| 参数              | 描述        |
|:----------------|:----------|
| `baseline`      | 基线对齐      |
| `aboveBaseline` | 底部边缘与基线对齐 |
| `belowBaseline` | 上边缘与基线对齐  |
| `top`           | 顶部对齐      |
| `bottom`        | 底部对齐      |
| `middle`        | 中部对齐      |

### 线条装饰表

| 参数       | 描述  |
|:---------|:----|
| `solid`  | 实线  |
| `double` | 双线  |
| `dotted` | 点线  |
| `dashed` | 虚线  |
| `wavy`   | 波浪线 |

### 混合模式表

更详细内容可以参照：[`BlendMode`](https://api.flutter.dev/flutter/dart-ui/BlendMode.html)

| 参数           | 描述                                                                                             |
|:-------------|:-----------------------------------------------------------------------------------------------|
| `clear`      | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_clear.png)      |
| `src`        | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_src.png)        |
| `dst`        | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dst.png)        |
| `srcOver`    | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcOver.png)    |
| `dstOver`    | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstOver.png)    |
| `srcIn`      | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcIn.png)      |
| `dstIn`      | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstIn.png)      |
| `srcOut`     | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcOut.png)     |
| `dstOut`     | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstOut.png)     |
| `srcATop`    | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_srcATop.png)    |
| `dstATop`    | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dstATop.png)    |
| `xor`        | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_xor.png)        |
| `plus`       | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_plus.png)       |
| `modulate`   | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_modulate.png)   |
| `value`      | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_screen.png)     |
| `overlay`    | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_overlay.png)    |
| `darken`     | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_darken.png)     |
| `lighten`    | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_lighten.png)    |
| `colorDodge` | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_colorDodge.png) |
| `colorBurn`  | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_colorBurn.png)  |
| `hardLight`  | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_hardLight.png)  |
| `softLight`  | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_softLight.png)  |
| `difference` | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_difference.png) |
| `exclusion`  | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_exclusion.png)  |
| `multiply`   | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_multiply.png)   |
| `hue`        | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_hue.png)        |
| `saturation` | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_hue.png)        |
| `color`      | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_color.png)      |
| `luminosity` | [如图所示](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_luminosity.png) |

### 平铺模式表

| 参数         | 描述                   |
|:-----------|:---------------------|
| `clamp`    | 超出边缘采样使用内部区域中最近的颜色。  |
| `mirror`   | 超出边缘的采样将在定义的区域内来回镜像。 |
| `repeated` | 超出边缘的采样将从定义区域的远端重复。  |
| `decal`    | 超出边缘的采样被视为透明黑色。      |

### 对齐参数表

| 参数             | 描述       |
|:---------------|:---------|
| `topLeft`      | 左上角对齐    |
| `topCenter`    | 顶部水平居中对齐 |
| `topRight`     | 右上角对齐    |
| `centerLeft`   | 左侧垂直居中对齐 |
| `center`       | 居中对齐     |
| `centerRight`  | 右侧垂直居中对齐 |
| `bottomLeft`   | 左下角对齐    |
| `bottomCenter` | 底部水平居中对齐 |
| `bottomRight`  | 右下角对齐    |

## 语法设计与规范

### 核心目标

* 语法类 `HTML`，但不遵守 `HTML` 的规则
* 语法设计参考 `Unity`、`Cocos`、`Godot` 游戏引擎中的富文本标签
* 标签保持足够的单一性、可读性
* 语法尽可能在语义上保持一致性
* 语法上尽可能统一，降低学习成本

### 语法规范

* 标签名仅由小写字母组成
* 文本为 UTF-8 编码字符组成
* 参数名仅由大小写字母、连字符（减号）组成，开头不能为连字符（减号）
* 参数值仅由大小写字母、数字、连字符（减号）、加号、点、下划线、井号组成
* 数组多个参数值组成以逗号分隔
* 字典表达式以单引号括起来，键值对用分号分隔，注意 `Key` 与 `:` 之间不能有空格，值 与 `:` 之间则允许
* 字典表达式中不允许嵌套，不允许存在多个相同的参数名

**详细语法如下描述：**

```
# 标签名
Label: (
    [a-z]+
)

# 文本
Text: (
    [\S\s\n\r]*
)

# 参数名
Key: (
    [A-Za-z][A-Za-z\-]*
)

# 参数值
Value: (
    [A-Za-z0-9\-\+\._#]+
)

# 数组
Array: (
    Value, ...
)

# 字典表达式
MapExpression: (
    'Key: (Value | Array); ...'
)

# 属性标签
AttributeExpression: (
    <Label>Text</Label> |
    <Label=Value>Text</Label> |
    <Label=MapExpression>Text</Label>
)

# 元素标签
ElementExpression: (
    <Label=Value/> |
    <Label=MapExpression/>
)

```

### 解析与生成

* 生成时尽可能优化
    * 合并属性，减少多余层级，如：`<size=3><blod></blod></size>` => `TextSpan(text, style(size, bold))`
    * 删除掉无效标签，如：`<blod></blod>` => ` `
* 存在多个属性标签连续嵌套时
    * 如果为计算关系，则由外层向内层累计计算，如：`<size=+3><size=-2></size></size>`，值为 `x + 3 - 2`
    * 如果为继承关系，则取最近一层的属性值，如：`<size=3><size=5></size></size>`，值为 `5`
* 当文本不变时，复用之前的 `Span`

### 设计疑问

#### 为什么不使用 XHTML 语法？

* XHTML 标签复杂，语法繁多，容易引起歧义。我们需要标签保持足够的单一性、可读性；语法尽可能在语义上保持一致性。
* 尽可能不需要去理会 XML 的转义语义
* 这里参考 `Unity`、`Cocos`、`Godot` 游戏引擎中的富文本标签设计