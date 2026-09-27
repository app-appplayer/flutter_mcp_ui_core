/// Below this a `lineHeight` is a multiplier; at or above it, logical px
/// (05_Theme §5.4.2).
const int lineHeightPxThreshold = 16;

/// A text style's line height as a multiple of its font size — the value a
/// renderer's per-line advance is `fontSize ×`.
///
/// A text style carries line height under two names, and the 1.4 spec
/// admits both: `lineHeight` (05_Theme §5.4.2, the field §18.2.7 requires)
/// and `height` (the `TextStyle` primitive the theme typography and widget
/// `style` schemas share). A document that validates with either must render
/// with it.
///
/// - [lineHeight] below [lineHeightPxThreshold] is a multiplier; at or above
///   it is logical px and is divided by [fontSize].
/// - [height] is always a multiplier.
/// - With both set, [lineHeight] wins — it is the field the conformance
///   section names. When it cannot be used (px with no font size to divide
///   by), [height] still applies.
///
/// Returns null when neither yields a positive multiplier, so the caller
/// keeps whatever line height it would have had.
double? lineHeightMultiplier({num? lineHeight, num? height, num? fontSize}) {
  if (lineHeight != null && lineHeight > 0) {
    if (lineHeight < lineHeightPxThreshold) return lineHeight.toDouble();
    if (fontSize != null && fontSize > 0) return lineHeight / fontSize;
  }
  if (height != null && height > 0) return height.toDouble();
  return null;
}
