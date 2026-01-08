# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0+3] - 2026-01-09

### Documentation
- **Translation**: Translated the entire CHANGELOG into English for better international accessibility.

## [1.0.0+2] - 2026-01-09

### Documentation
- **Refinement**: Polished documentation and standardized code formatting throughout the package.

## [1.0.0+1] - 2026-01-09

### Fixed
- **Documentation**: Corrected and improved documentation details.

## [1.0.0] - 2026-01-09

### Added
- **Core Engine**: Initial release of `AutoRichText`, a high-performance auto-parsing rich text engine specifically designed for Flutter.
- **Rich Text Tags**: Supported a wide range of HTML-like tag syntaxes:
    - **Text Styles**: `bold`, `weight`, `italic`, `size`, `font`, and `color`.
    - **Decorations**: `u` (underline) and `delete` (strikethrough), supporting custom thickness, color, and styles.
    - **Advanced Visuals**: `gradient` (linear/radial), `image` (assets), and `icon` (font icons).
    - **Layout Control**: `align` tag for controlling placeholder and component alignment.
- **Interactions**: Supported the `click` tag for handling single tap, double tap, and long press events.
- **Global Configuration**: Introduced `AutoRichTextSettings`, featuring Lint mode, custom color/image mapping, and cache invalidation management.
- **Performance Optimization**:
    - Implemented a non-strict XHTML parser inspired by game engines like Unity and Cocos.
    - Smart `TextSpan` merging to minimize widget tree nesting depth.
    - Efficient caching mechanism to skip redundant syntax tree calculations.
- **Bilingual Support**: Comprehensive `README` documentation in both English and Simplified Chinese.
- **Example Project**: Launched an [Online Demo](https://limevista.github.io/auto_rich_text_example/) for interactive community testing.