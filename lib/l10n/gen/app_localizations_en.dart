// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vege Price';

  @override
  String get navHome => 'Home';

  @override
  String get navPredict => 'Predict';

  @override
  String get navHistory => 'History';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navSettings => 'Settings';

  @override
  String get chooseLanguageTitle => 'Choose your language';

  @override
  String get chooseLanguageSubtitle => 'You can change this later in Settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get continueButton => 'Continue';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsOfflineMode => 'Offline mode';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsOn => 'On';

  @override
  String get settingsHowPredictionsWork => 'How predictions work';

  @override
  String get settingsPrivacyData => 'Privacy & data';

  @override
  String get settingsChangeLanguage => 'Change language';

  @override
  String get appVersion => 'vege_price v1.0.0';

  @override
  String get homeWelcomeBack => 'Welcome back, ';

  @override
  String get homeMarketStable => 'Market stable';

  @override
  String get homeBiggestMoverToday => 'Biggest mover today';

  @override
  String get evoFire => 'Fire';

  @override
  String get evoHot => 'Hot';

  @override
  String get evoMild => 'Mild';

  @override
  String get evoCool => 'Cool';

  @override
  String get evoCalm => 'Calm';

  @override
  String get homeTrendingThisWeek => 'Trending this week';

  @override
  String get seeAll => 'See all';

  @override
  String get homeActiveAlerts => 'Active alerts';

  @override
  String get manage => 'Manage';

  @override
  String homeAlertsTriggeredToday(int count) {
    return '$count alerts triggered today';
  }

  @override
  String get homeSampleAlertDetail => 'Carrot hit Rs 350/kg';

  @override
  String homeThisWeekPrediction(String price) {
    return 'This week\'s prediction: $price';
  }

  @override
  String get howItWorks => 'How it works';

  @override
  String get predictHorizonQuestion => 'How far ahead do you want to predict?';

  @override
  String get predictLongerLessAccurate => 'Longer forecasts are less accurate.';

  @override
  String predictedPriceLabel(String horizon) {
    return 'Predicted price · $horizon';
  }

  @override
  String get predictionInfo => 'About this prediction';

  @override
  String get predictionMethod => 'Prediction method';

  @override
  String get typicalAccuracy => 'Usually accurate within';

  @override
  String get seeHowModelWorks => 'See how the model works';

  @override
  String get share => 'Share';

  @override
  String get livePriceSuffix => 'live price';

  @override
  String get todaySuffix => 'today';

  @override
  String get recordedPrice => 'Recorded price';

  @override
  String get aiPrediction => 'Prediction';

  @override
  String get pickDate => 'Pick a date';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle =>
      'Log in with the account details given by your admin.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginError => 'Incorrect email or password.';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmMessage =>
      'You\'ll need to log in again to see prices.';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get signUpTitle => 'Create your account';

  @override
  String get signUpSubtitle => 'Enter your details to get started.';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get signUpButton => 'Sign up';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get loginLink => 'Log in';

  @override
  String get historyTitle => 'Price history';

  @override
  String get minPrice => 'Min price';

  @override
  String get maxPrice => 'Max price';

  @override
  String get average => 'Average';

  @override
  String get volatility => 'Price swings';

  @override
  String get thisPeriod => 'This period';

  @override
  String get stdDev => 'How much it moves';

  @override
  String get exportAsPdf => 'Export as PDF';

  @override
  String get alertsTitle => 'Price alerts';

  @override
  String activeAlertsCount(int count) {
    return 'Active alerts ($count)';
  }

  @override
  String setOn(String date) {
    return 'Set on $date';
  }

  @override
  String get alertHistory => 'Alert history';

  @override
  String get setPriceAlert => 'Set price alert';

  @override
  String get priceExceeds => 'Price exceeds';

  @override
  String get dropsBelow => 'Drops below';

  @override
  String get priceThreshold => 'Price threshold';

  @override
  String get cancel => 'Cancel';

  @override
  String get createAlert => 'Create alert';

  @override
  String get alertToday => 'Today';

  @override
  String get alertPriceHit => 'Price hit';

  @override
  String get alertPriceDropped => 'Price dropped to';

  @override
  String alertPreview(
      String vegetable, String action, String price, String threshold) {
    return '$vegetable alert: $action Rs $price/kg (your alert: Rs $threshold)';
  }
}
