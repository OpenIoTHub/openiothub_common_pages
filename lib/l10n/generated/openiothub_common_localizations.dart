import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openiothub_common_localizations_en.dart'
    deferred as openiothub_common_localizations_en;
import 'openiothub_common_localizations_zh.dart'
    deferred as openiothub_common_localizations_zh;

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OpenIoTHubCommonLocalizations
/// returned by `OpenIoTHubCommonLocalizations.of(context)`.
///
/// Applications need to include `OpenIoTHubCommonLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/openiothub_common_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OpenIoTHubCommonLocalizations.localizationsDelegates,
///   supportedLocales: OpenIoTHubCommonLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the OpenIoTHubCommonLocalizations.supportedLocales
/// property.
abstract class OpenIoTHubCommonLocalizations {
  OpenIoTHubCommonLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OpenIoTHubCommonLocalizations of(BuildContext context) {
    return Localizations.of<OpenIoTHubCommonLocalizations>(
      context,
      OpenIoTHubCommonLocalizations,
    )!;
  }

  static const LocalizationsDelegate<OpenIoTHubCommonLocalizations> delegate =
      _OpenIoTHubCommonLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
    Locale('zh', 'CN'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'OpenIoTHub'**
  String get app_title;
}

class _OpenIoTHubCommonLocalizationsDelegate
    extends LocalizationsDelegate<OpenIoTHubCommonLocalizations> {
  const _OpenIoTHubCommonLocalizationsDelegate();

  @override
  Future<OpenIoTHubCommonLocalizations> load(Locale locale) {
    return lookupOpenIoTHubCommonLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenIoTHubCommonLocalizationsDelegate old) => false;
}

Future<OpenIoTHubCommonLocalizations> lookupOpenIoTHubCommonLocalizations(
  Locale locale,
) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return openiothub_common_localizations_zh.loadLibrary().then(
              (dynamic _) =>
                  openiothub_common_localizations_zh.OpenIoTHubCommonLocalizationsZhHans(),
            );
          case 'Hant':
            return openiothub_common_localizations_zh.loadLibrary().then(
              (dynamic _) =>
                  openiothub_common_localizations_zh.OpenIoTHubCommonLocalizationsZhHant(),
            );
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return openiothub_common_localizations_zh.loadLibrary().then(
              (dynamic _) =>
                  openiothub_common_localizations_zh.OpenIoTHubCommonLocalizationsZhCn(),
            );
          case 'TW':
            return openiothub_common_localizations_zh.loadLibrary().then(
              (dynamic _) =>
                  openiothub_common_localizations_zh.OpenIoTHubCommonLocalizationsZhTw(),
            );
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return openiothub_common_localizations_en.loadLibrary().then(
        (dynamic _) =>
            openiothub_common_localizations_en.OpenIoTHubCommonLocalizationsEn(),
      );
    case 'zh':
      return openiothub_common_localizations_zh.loadLibrary().then(
        (dynamic _) =>
            openiothub_common_localizations_zh.OpenIoTHubCommonLocalizationsZh(),
      );
  }

  throw FlutterError(
    'OpenIoTHubCommonLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
