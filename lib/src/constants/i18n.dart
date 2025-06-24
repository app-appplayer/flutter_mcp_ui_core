/// Internationalization constants for MCP UI DSL v1.0
/// 
/// Contains i18n related constants as defined in the spec.
class I18nConstants {
  // Number format styles
  static const String styleDecimal = 'decimal';
  static const String styleCurrency = 'currency';
  static const String stylePercent = 'percent';
  static const String styleUnit = 'unit';
  
  // Currency display options
  static const String currencySymbol = 'symbol';
  static const String currencyNarrowSymbol = 'narrowSymbol';
  static const String currencyCode = 'code';
  static const String currencyName = 'name';
  
  // Unit display options
  static const String unitShort = 'short';
  static const String unitNarrow = 'narrow';
  static const String unitLong = 'long';
  
  // Date/Time styles
  static const String dateStyleShort = 'short';
  static const String dateStyleMedium = 'medium';
  static const String dateStyleLong = 'long';
  static const String dateStyleFull = 'full';
  
  // Plural categories (Unicode CLDR)
  static const String pluralZero = 'zero';
  static const String pluralOne = 'one';
  static const String pluralTwo = 'two';
  static const String pluralFew = 'few';
  static const String pluralMany = 'many';
  static const String pluralOther = 'other';
  
  // Common locale codes
  static const String localeEnUS = 'en-US';
  static const String localeEnGB = 'en-GB';
  static const String localeEsES = 'es-ES';
  static const String localeFrFR = 'fr-FR';
  static const String localeDeDe = 'de-DE';
  static const String localeJaJP = 'ja-JP';
  static const String localeKoKR = 'ko-KR';
  static const String localeZhCN = 'zh-CN';
  static const String localeZhTW = 'zh-TW';
  static const String localePtBR = 'pt-BR';
  static const String localeRuRU = 'ru-RU';
  static const String localeArSA = 'ar-SA';
  static const String localeHiIN = 'hi-IN';
  
  /// Check if a number style is valid
  static bool isValidNumberStyle(String style) {
    return [styleDecimal, styleCurrency, stylePercent, styleUnit].contains(style);
  }
  
  /// Check if a currency display is valid
  static bool isValidCurrencyDisplay(String display) {
    return [currencySymbol, currencyNarrowSymbol, currencyCode, currencyName].contains(display);
  }
  
  /// Check if a unit display is valid
  static bool isValidUnitDisplay(String display) {
    return [unitShort, unitNarrow, unitLong].contains(display);
  }
  
  /// Check if a date style is valid
  static bool isValidDateStyle(String style) {
    return [dateStyleShort, dateStyleMedium, dateStyleLong, dateStyleFull].contains(style);
  }
  
  /// Check if a plural category is valid
  static bool isValidPluralCategory(String category) {
    return [pluralZero, pluralOne, pluralTwo, pluralFew, pluralMany, pluralOther].contains(category);
  }
  
  /// Get all supported locales
  static List<String> get supportedLocales => [
    localeEnUS, localeEnGB, localeEsES, localeFrFR, localeDeDe,
    localeJaJP, localeKoKR, localeZhCN, localeZhTW, localePtBR,
    localeRuRU, localeArSA, localeHiIN,
  ];
  
  /// Parse locale code into language and country
  static Map<String, String> parseLocale(String locale) {
    final parts = locale.split('-');
    return {
      'language': parts[0],
      'country': parts.length > 1 ? parts[1] : '',
    };
  }
  
  /// Format locale code
  static String formatLocale(String language, [String? country]) {
    return country != null && country.isNotEmpty 
        ? '$language-$country' 
        : language;
  }
}