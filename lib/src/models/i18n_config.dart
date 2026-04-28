import 'package:meta/meta.dart';

/// Internationalization configuration for MCP UI DSL v1.0
/// 
/// Represents i18n settings for widgets as defined in the spec.
@immutable
class I18nConfig {
  /// The main text configuration
  final I18nText? text;
  
  /// Pluralization configuration
  final I18nPluralization? pluralization;
  
  /// Number formatting configuration
  final I18nNumberFormat? numberFormat;
  
  /// Date formatting configuration
  final I18nDateFormat? dateFormat;

  /// RTL text direction: "auto", "true", or "false"
  /// When "auto", RTL is determined by locale (ar, he, fa, ur, etc.)
  final String? rtl;

  const I18nConfig({
    this.text,
    this.pluralization,
    this.numberFormat,
    this.dateFormat,
    this.rtl,
  });

  /// Create from JSON
  /// Supports both nested structure (implementation) and flat structure (design doc)
  factory I18nConfig.fromJson(Map<String, dynamic> json) {
    // Detect flat design doc structure: has 'key' at top level
    if (json.containsKey('key') && !json.containsKey('text')) {
      final formatType = json['format'] as String?;
      return I18nConfig(
        text: I18nText(
          key: json['key'] as String,
          defaultText: (json['fallback'] ?? json['default'] ?? '') as String,
          params: Map<String, dynamic>.from(json['params'] ?? {}),
        ),
        numberFormat: formatType == 'number' || json['currency'] != null
            ? I18nNumberFormat(
                value: null,
                style: json['currency'] != null ? 'currency' : (formatType == 'number' ? 'decimal' : null),
                currency: json['currency'] as String?,
              )
            : null,
        dateFormat: formatType == 'date'
            ? I18nDateFormat(
                value: null,
                style: json['dateStyle'] as String? ?? 'medium',
              )
            : null,
        rtl: json['rtl'] as String?,
      );
    }

    // Nested structure (existing implementation)
    return I18nConfig(
      text: json['text'] != null
          ? I18nText.fromJson(json['text'] as Map<String, dynamic>)
          : null,
      pluralization: json['pluralization'] != null
          ? I18nPluralization.fromJson(json['pluralization'] as Map<String, dynamic>)
          : null,
      numberFormat: json['formatting']?['number'] != null
          ? I18nNumberFormat.fromJson(json['formatting']['number'] as Map<String, dynamic>)
          : null,
      dateFormat: json['formatting']?['date'] != null
          ? I18nDateFormat.fromJson(json['formatting']['date'] as Map<String, dynamic>)
          : null,
      rtl: json['rtl'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    
    if (text != null) {
      result['text'] = text!.toJson();
    }
    
    if (pluralization != null) {
      result['pluralization'] = pluralization!.toJson();
    }
    
    if (numberFormat != null || dateFormat != null) {
      result['formatting'] = <String, dynamic>{};
      if (numberFormat != null) {
        result['formatting']['number'] = numberFormat!.toJson();
      }
      if (dateFormat != null) {
        result['formatting']['date'] = dateFormat!.toJson();
      }
    }

    if (rtl != null) {
      result['rtl'] = rtl;
    }

    return result;
  }

  /// Check if this configuration has any i18n settings
  bool get hasI18nSettings =>
      text != null ||
      pluralization != null ||
      numberFormat != null ||
      dateFormat != null ||
      rtl != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is I18nConfig &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          pluralization == other.pluralization &&
          numberFormat == other.numberFormat &&
          dateFormat == other.dateFormat &&
          rtl == other.rtl;

  @override
  int get hashCode =>
      text.hashCode ^
      pluralization.hashCode ^
      numberFormat.hashCode ^
      dateFormat.hashCode ^
      rtl.hashCode;
}

/// Text internationalization configuration
@immutable
class I18nText {
  /// The translation key
  final String key;
  
  /// Default text if translation not found
  final String defaultText;
  
  /// Parameters to interpolate into the text
  final Map<String, dynamic> params;

  const I18nText({
    required this.key,
    required this.defaultText,
    this.params = const {},
  });

  /// Create from JSON
  factory I18nText.fromJson(Map<String, dynamic> json) {
    return I18nText(
      key: json['key'] as String,
      defaultText: (json['default'] ?? json['fallback']) as String,
      params: Map<String, dynamic>.from(json['params'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'key': key,
      'default': defaultText,
    };
    
    if (params.isNotEmpty) {
      result['params'] = params;
    }
    
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is I18nText &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          defaultText == other.defaultText &&
          _mapsEqual(params, other.params);

  @override
  int get hashCode =>
      key.hashCode ^
      defaultText.hashCode ^
      params.hashCode;

  bool _mapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

/// Pluralization configuration
@immutable
class I18nPluralization {
  /// The translation key
  final String key;
  
  /// The count expression or value
  final dynamic count;
  
  /// Text for zero items
  final String? zero;
  
  /// Text for one item
  final String? one;
  
  /// Text for two items (some languages)
  final String? two;
  
  /// Text for few items (some languages)
  final String? few;
  
  /// Text for many items (some languages)
  final String? many;
  
  /// Text for other amounts
  final String other;

  const I18nPluralization({
    required this.key,
    required this.count,
    this.zero,
    this.one,
    this.two,
    this.few,
    this.many,
    required this.other,
  });

  /// Create from JSON
  factory I18nPluralization.fromJson(Map<String, dynamic> json) {
    return I18nPluralization(
      key: json['key'] as String,
      count: json['count'],
      zero: json['zero'] as String?,
      one: json['one'] as String?,
      two: json['two'] as String?,
      few: json['few'] as String?,
      many: json['many'] as String?,
      other: json['other'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'key': key,
      'count': count,
      'other': other,
    };
    
    if (zero != null) result['zero'] = zero;
    if (one != null) result['one'] = one;
    if (two != null) result['two'] = two;
    if (few != null) result['few'] = few;
    if (many != null) result['many'] = many;
    
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is I18nPluralization &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          count == other.count &&
          zero == other.zero &&
          one == other.one &&
          two == other.two &&
          few == other.few &&
          many == other.many &&
          this.other == other.other;

  @override
  int get hashCode =>
      key.hashCode ^
      count.hashCode ^
      zero.hashCode ^
      one.hashCode ^
      two.hashCode ^
      few.hashCode ^
      many.hashCode ^
      other.hashCode;
}

/// Number formatting configuration
@immutable
class I18nNumberFormat {
  /// The value to format
  final dynamic value;
  
  /// Formatting style (decimal, currency, percent, unit)
  final String? style;
  
  /// Currency code (for currency style)
  final String? currency;
  
  /// Currency display (symbol, narrowSymbol, code, name)
  final String? currencyDisplay;
  
  /// Unit (for unit style)
  final String? unit;
  
  /// Unit display (short, narrow, long)
  final String? unitDisplay;
  
  /// Minimum integer digits
  final int? minimumIntegerDigits;
  
  /// Minimum fraction digits
  final int? minimumFractionDigits;
  
  /// Maximum fraction digits
  final int? maximumFractionDigits;
  
  /// Minimum significant digits
  final int? minimumSignificantDigits;
  
  /// Maximum significant digits
  final int? maximumSignificantDigits;

  const I18nNumberFormat({
    required this.value,
    this.style,
    this.currency,
    this.currencyDisplay,
    this.unit,
    this.unitDisplay,
    this.minimumIntegerDigits,
    this.minimumFractionDigits,
    this.maximumFractionDigits,
    this.minimumSignificantDigits,
    this.maximumSignificantDigits,
  });

  /// Create from JSON
  factory I18nNumberFormat.fromJson(Map<String, dynamic> json) {
    return I18nNumberFormat(
      value: json['value'],
      style: json['style'] as String?,
      currency: json['currency'] as String?,
      currencyDisplay: json['currencyDisplay'] as String?,
      unit: json['unit'] as String?,
      unitDisplay: json['unitDisplay'] as String?,
      minimumIntegerDigits: json['minimumIntegerDigits'] as int?,
      minimumFractionDigits: json['minimumFractionDigits'] as int?,
      maximumFractionDigits: json['maximumFractionDigits'] as int?,
      minimumSignificantDigits: json['minimumSignificantDigits'] as int?,
      maximumSignificantDigits: json['maximumSignificantDigits'] as int?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'value': value,
    };
    
    if (style != null) result['style'] = style;
    if (currency != null) result['currency'] = currency;
    if (currencyDisplay != null) result['currencyDisplay'] = currencyDisplay;
    if (unit != null) result['unit'] = unit;
    if (unitDisplay != null) result['unitDisplay'] = unitDisplay;
    if (minimumIntegerDigits != null) result['minimumIntegerDigits'] = minimumIntegerDigits;
    if (minimumFractionDigits != null) result['minimumFractionDigits'] = minimumFractionDigits;
    if (maximumFractionDigits != null) result['maximumFractionDigits'] = maximumFractionDigits;
    if (minimumSignificantDigits != null) result['minimumSignificantDigits'] = minimumSignificantDigits;
    if (maximumSignificantDigits != null) result['maximumSignificantDigits'] = maximumSignificantDigits;
    
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is I18nNumberFormat &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          style == other.style &&
          currency == other.currency &&
          currencyDisplay == other.currencyDisplay &&
          unit == other.unit &&
          unitDisplay == other.unitDisplay &&
          minimumIntegerDigits == other.minimumIntegerDigits &&
          minimumFractionDigits == other.minimumFractionDigits &&
          maximumFractionDigits == other.maximumFractionDigits &&
          minimumSignificantDigits == other.minimumSignificantDigits &&
          maximumSignificantDigits == other.maximumSignificantDigits;

  @override
  int get hashCode =>
      value.hashCode ^
      style.hashCode ^
      currency.hashCode ^
      currencyDisplay.hashCode ^
      unit.hashCode ^
      unitDisplay.hashCode ^
      minimumIntegerDigits.hashCode ^
      minimumFractionDigits.hashCode ^
      maximumFractionDigits.hashCode ^
      minimumSignificantDigits.hashCode ^
      maximumSignificantDigits.hashCode;
}

/// Date formatting configuration
@immutable
class I18nDateFormat {
  /// The value to format
  final dynamic value;
  
  /// Formatting style (short, medium, long, full)
  final String? style;
  
  /// Date style (short, medium, long, full)
  final String? dateStyle;
  
  /// Time style (short, medium, long, full)
  final String? timeStyle;
  
  /// Custom pattern (e.g., "yyyy-MM-dd")
  final String? pattern;
  
  /// Time zone
  final String? timeZone;
  
  /// Whether to use 24-hour time
  final bool? hour24;

  const I18nDateFormat({
    required this.value,
    this.style,
    this.dateStyle,
    this.timeStyle,
    this.pattern,
    this.timeZone,
    this.hour24,
  });

  /// Create from JSON
  factory I18nDateFormat.fromJson(Map<String, dynamic> json) {
    return I18nDateFormat(
      value: json['value'],
      style: json['style'] as String?,
      dateStyle: json['dateStyle'] as String?,
      timeStyle: json['timeStyle'] as String?,
      pattern: json['pattern'] as String?,
      timeZone: json['timeZone'] as String?,
      hour24: json['hour24'] as bool?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'value': value,
    };
    
    if (style != null) result['style'] = style;
    if (dateStyle != null) result['dateStyle'] = dateStyle;
    if (timeStyle != null) result['timeStyle'] = timeStyle;
    if (pattern != null) result['pattern'] = pattern;
    if (timeZone != null) result['timeZone'] = timeZone;
    if (hour24 != null) result['hour24'] = hour24;
    
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is I18nDateFormat &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          style == other.style &&
          dateStyle == other.dateStyle &&
          timeStyle == other.timeStyle &&
          pattern == other.pattern &&
          timeZone == other.timeZone &&
          hour24 == other.hour24;

  @override
  int get hashCode =>
      value.hashCode ^
      style.hashCode ^
      dateStyle.hashCode ^
      timeStyle.hashCode ^
      pattern.hashCode ^
      timeZone.hashCode ^
      hour24.hashCode;
}