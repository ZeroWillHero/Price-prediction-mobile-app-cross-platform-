import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('en'),
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vege Price'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPredict.
  ///
  /// In en, this message translates to:
  /// **'Predict'**
  String get navPredict;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguageTitle;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get chooseLanguageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSinhala.
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get languageSinhala;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get languageTamil;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get settingsOfflineMode;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsNotificationsOn;

  /// No description provided for @settingsHowPredictionsWork.
  ///
  /// In en, this message translates to:
  /// **'How predictions work'**
  String get settingsHowPredictionsWork;

  /// No description provided for @settingsPrivacyData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & data'**
  String get settingsPrivacyData;

  /// No description provided for @settingsChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get settingsChangeLanguage;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'vege_price v1.0.0'**
  String get appVersion;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, '**
  String get homeWelcomeBack;

  /// No description provided for @homeMarketStable.
  ///
  /// In en, this message translates to:
  /// **'Market stable'**
  String get homeMarketStable;

  /// No description provided for @homeBiggestMoverToday.
  ///
  /// In en, this message translates to:
  /// **'Biggest mover today'**
  String get homeBiggestMoverToday;

  /// No description provided for @evoFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get evoFire;

  /// No description provided for @evoHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get evoHot;

  /// No description provided for @evoMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get evoMild;

  /// No description provided for @evoCool.
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get evoCool;

  /// No description provided for @evoCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get evoCalm;

  /// No description provided for @homeTrendingThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Trending this week'**
  String get homeTrendingThisWeek;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @homeActiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'Active alerts'**
  String get homeActiveAlerts;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @homeAlertsTriggeredToday.
  ///
  /// In en, this message translates to:
  /// **'{count} alerts triggered today'**
  String homeAlertsTriggeredToday(int count);

  /// No description provided for @homeSampleAlertDetail.
  ///
  /// In en, this message translates to:
  /// **'Carrot hit Rs 350/kg'**
  String get homeSampleAlertDetail;

  /// No description provided for @homeThisWeekPrediction.
  ///
  /// In en, this message translates to:
  /// **'This week\'s prediction: {price}'**
  String homeThisWeekPrediction(String price);

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @predictHorizonQuestion.
  ///
  /// In en, this message translates to:
  /// **'How far ahead do you want to predict?'**
  String get predictHorizonQuestion;

  /// No description provided for @predictLongerLessAccurate.
  ///
  /// In en, this message translates to:
  /// **'Longer forecasts are less accurate.'**
  String get predictLongerLessAccurate;

  /// No description provided for @predictedPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Predicted price · {horizon}'**
  String predictedPriceLabel(String horizon);

  /// No description provided for @predictionInfo.
  ///
  /// In en, this message translates to:
  /// **'About this prediction'**
  String get predictionInfo;

  /// No description provided for @predictionMethod.
  ///
  /// In en, this message translates to:
  /// **'Prediction method'**
  String get predictionMethod;

  /// No description provided for @typicalAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Usually accurate within'**
  String get typicalAccuracy;

  /// No description provided for @seeHowModelWorks.
  ///
  /// In en, this message translates to:
  /// **'See how the model works'**
  String get seeHowModelWorks;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @livePriceSuffix.
  ///
  /// In en, this message translates to:
  /// **'live price'**
  String get livePriceSuffix;

  /// No description provided for @todaySuffix.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get todaySuffix;

  /// No description provided for @recordedPrice.
  ///
  /// In en, this message translates to:
  /// **'Recorded price'**
  String get recordedPrice;

  /// No description provided for @aiPrediction.
  ///
  /// In en, this message translates to:
  /// **'Prediction'**
  String get aiPrediction;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickDate;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in with the account details given by your admin.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get loginError;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to log in again to see prices.'**
  String get logoutConfirmMessage;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to get started.'**
  String get signUpSubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpButton;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccountPrompt;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get historyTitle;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get maxPrice;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @volatility.
  ///
  /// In en, this message translates to:
  /// **'Price swings'**
  String get volatility;

  /// No description provided for @thisPeriod.
  ///
  /// In en, this message translates to:
  /// **'This period'**
  String get thisPeriod;

  /// No description provided for @stdDev.
  ///
  /// In en, this message translates to:
  /// **'How much it moves'**
  String get stdDev;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Price alerts'**
  String get alertsTitle;

  /// No description provided for @activeAlertsCount.
  ///
  /// In en, this message translates to:
  /// **'Active alerts ({count})'**
  String activeAlertsCount(int count);

  /// No description provided for @setOn.
  ///
  /// In en, this message translates to:
  /// **'Set on {date}'**
  String setOn(String date);

  /// No description provided for @alertHistory.
  ///
  /// In en, this message translates to:
  /// **'Alert history'**
  String get alertHistory;

  /// No description provided for @setPriceAlert.
  ///
  /// In en, this message translates to:
  /// **'Set price alert'**
  String get setPriceAlert;

  /// No description provided for @priceExceeds.
  ///
  /// In en, this message translates to:
  /// **'Price exceeds'**
  String get priceExceeds;

  /// No description provided for @dropsBelow.
  ///
  /// In en, this message translates to:
  /// **'Drops below'**
  String get dropsBelow;

  /// No description provided for @priceThreshold.
  ///
  /// In en, this message translates to:
  /// **'Price threshold'**
  String get priceThreshold;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @createAlert.
  ///
  /// In en, this message translates to:
  /// **'Create alert'**
  String get createAlert;

  /// No description provided for @alertToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get alertToday;

  /// No description provided for @alertPriceHit.
  ///
  /// In en, this message translates to:
  /// **'Price hit'**
  String get alertPriceHit;

  /// No description provided for @alertPriceDropped.
  ///
  /// In en, this message translates to:
  /// **'Price dropped to'**
  String get alertPriceDropped;

  /// No description provided for @alertPreview.
  ///
  /// In en, this message translates to:
  /// **'{vegetable} alert: {action} Rs {price}/kg (your alert: Rs {threshold})'**
  String alertPreview(
      String vegetable, String action, String price, String threshold);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
