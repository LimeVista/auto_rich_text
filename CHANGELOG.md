# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0+1] - 2026-01-09

### 文档格式
- **调整文档**: 完善文档和代码格式。

## [1.0.0+1] - 2026-01-09

### 修复
- **调整文档**: 完善文档。

## [1.0.0] - 2026-01-09

### 新增
- **核心引擎**: `AutoRichText` 初始版本发布，一个专为 Flutter 打造的高性能自动解析富文本引擎。
- **富文本标签**: 支持一系列类 HTML 的标签语法：
    - 文本样式: `bold` (加粗), `weight` (字重), `italic` (斜体), `size` (字号), `font` (字体), `color` (颜色)。
    - 装饰线: `u` (下划线) 和 `delete` (删除线)，支持自定义粗细、颜色和样式。
    - 高级视觉: `gradient` (线性/径向渐变), `image` (资源图片), 以及 `icon` (字体图标)。
    - 布局控制: `align` 标签，用于控制占位符和组件的对齐方式。
- **交互功能**: 支持 `click` 标签，可处理单击 (single tap)、双击 (double tap) 和长按 (long press) 事件。
- **全局配置**: 引入 `AutoRichTextSettings`，支持 Lint 模式、自定义颜色/图片映射及缓存失效管理。
- **性能优化**:
    - 实现了一种受游戏引擎（Unity/Cocos）启发的非严格 XHTML 解析器。
    - 智能合并 `TextSpan`，减少组件树的嵌套深度。
    - 高效的缓存机制，避免不必要的语法树重复计算。
- **文档支持**: 完善的中英文双语 `README` 文档。
- **示例工程**: 发布了 [在线 Demo](https://limevista.github.io/auto_rich_text_example/) 供开发者交互测试。