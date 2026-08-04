// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get appTitle => 'එළවළු මිල';

  @override
  String get navHome => 'මුල් පිටුව';

  @override
  String get navPredict => 'අනාවැකිය';

  @override
  String get navHistory => 'ඉතිහාසය';

  @override
  String get navAlerts => 'ඇඟවීම්';

  @override
  String get navSettings => 'සැකසුම්';

  @override
  String get chooseLanguageTitle => 'ඔබේ භාෂාව තෝරන්න';

  @override
  String get chooseLanguageSubtitle =>
      'ඔබට මෙය පසුව සැකසුම් තුළින් වෙනස් කළ හැක.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get continueButton => 'ඉදිරියට';

  @override
  String get settingsTitle => 'සැකසුම්';

  @override
  String get settingsDarkMode => 'අඳුරු පසුබිම';

  @override
  String get settingsLanguage => 'භාෂාව';

  @override
  String get settingsOfflineMode => 'නොබැඳි ප්‍රකාරය';

  @override
  String get settingsNotifications => 'දැනුම්දීම්';

  @override
  String get settingsNotificationsOn => 'ක්‍රියාත්මකයි';

  @override
  String get settingsHowPredictionsWork => 'අනාවැකි ක්‍රියා කරන ආකාරය';

  @override
  String get settingsPrivacyData => 'පෞද්ගලිකත්වය සහ දත්ත';

  @override
  String get settingsChangeLanguage => 'භාෂාව වෙනස් කරන්න';

  @override
  String get appVersion => 'vege_price v1.0.0';

  @override
  String get homeWelcomeBack => 'ආයුබෝවන්, ';

  @override
  String get homeMarketStable => 'වෙළඳපොළ ස්ථාවරයි';

  @override
  String get homeBiggestMoverToday => 'අද වෙනස්වූ ප්‍රධානතම එළවළුව';

  @override
  String get evoFire => 'අධික';

  @override
  String get evoHot => 'වේගවත්';

  @override
  String get evoMild => 'මධ්‍යම';

  @override
  String get evoCool => 'සන්සුන්';

  @override
  String get evoCalm => 'ස්ථාවර';

  @override
  String get homeTrendingThisWeek => 'මේ සතියේ ප්‍රවණතා';

  @override
  String get seeAll => 'සියල්ල බලන්න';

  @override
  String get homeActiveAlerts => 'ක්‍රියාත්මක ඇඟවීම්';

  @override
  String get manage => 'කළමනාකරණය';

  @override
  String homeAlertsTriggeredToday(int count) {
    return 'අද ඇඟවීම් $countක් ක්‍රියාත්මක විය';
  }

  @override
  String get homeSampleAlertDetail => 'කැරට් රු. 350/kg දක්වා ළඟා විය';

  @override
  String homeThisWeekPrediction(String price) {
    return 'මේ සතියේ අනාවැකිය: $price';
  }

  @override
  String get howItWorks => 'එය ක්‍රියා කරන ආකාරය';

  @override
  String get predictHorizonQuestion => 'ඔබට කොපමණ දුරකට අනාවැකි කිව යුතුද?';

  @override
  String get predictLongerLessAccurate =>
      'දිගු කාලීන අනාවැකි අඩු නිරවද්‍යතාවයක් ඇත.';

  @override
  String predictedPriceLabel(String horizon) {
    return 'අනාවැකි මිල · $horizon';
  }

  @override
  String get predictionInfo => 'මෙම අනාවැකිය ගැන';

  @override
  String get predictionMethod => 'අනාවැකි ක්‍රමය';

  @override
  String get typicalAccuracy => 'සාමාන්‍යයෙන් නිවැරදි වන පරාසය';

  @override
  String get seeHowModelWorks => 'මාදිලිය ක්‍රියා කරන ආකාරය බලන්න';

  @override
  String get share => 'බෙදාගන්න';

  @override
  String get livePriceSuffix => 'සජීවී මිල';

  @override
  String get todaySuffix => 'අද';

  @override
  String get recordedPrice => 'වාර්තා වූ මිල';

  @override
  String get aiPrediction => 'අනාවැකිය';

  @override
  String get pickDate => 'දිනයක් තෝරන්න';

  @override
  String get loginTitle => 'නැවත සාදරයෙන් පිළිගනිමු';

  @override
  String get loginSubtitle =>
      'ඔබේ පරිපාලක විසින් ලබා දුන් තොරතුරු වලින් පිවිසෙන්න.';

  @override
  String get emailLabel => 'විද්‍යුත් තැපෑල';

  @override
  String get passwordLabel => 'මුරපදය';

  @override
  String get loginButton => 'පිවිසෙන්න';

  @override
  String get loginError => 'විද්‍යුත් තැපෑල හෝ මුරපදය වැරදිය.';

  @override
  String get fieldRequired => 'මෙම කොටස අවශ්‍යයි.';

  @override
  String get emailInvalid => 'වලංගු විද්‍යුත් තැපැල් ලිපිනයක් ඇතුළත් කරන්න.';

  @override
  String get logout => 'පිටවීම';

  @override
  String get logoutConfirmTitle => 'පිටවෙනවාද?';

  @override
  String get logoutConfirmMessage => 'මිල නැවත බැලීමට ඔබට නැවත පිවිසිය යුතුය.';

  @override
  String get noAccountPrompt => 'ගිණුමක් නැද්ද?';

  @override
  String get signUpLink => 'ලියාපදිංචි වන්න';

  @override
  String get signUpTitle => 'ඔබේ ගිණුම සාදන්න';

  @override
  String get signUpSubtitle => 'ආරම්භ කිරීමට ඔබේ විස්තර ඇතුළත් කරන්න.';

  @override
  String get firstNameLabel => 'මුල් නම';

  @override
  String get lastNameLabel => 'අවසාන නම';

  @override
  String get confirmPasswordLabel => 'මුරපදය තහවුරු කරන්න';

  @override
  String get signUpButton => 'ලියාපදිංචි වන්න';

  @override
  String get passwordTooShort => 'මුරපදයේ අවම වශයෙන් අක්ෂර 8ක් තිබිය යුතුය.';

  @override
  String get passwordMismatch => 'මුරපද නොගැලපේ.';

  @override
  String get haveAccountPrompt => 'දැනටමත් ගිණුමක් තිබේද?';

  @override
  String get loginLink => 'පිවිසෙන්න';

  @override
  String get historyTitle => 'මිල ඉතිහාසය';

  @override
  String get minPrice => 'අවම මිල';

  @override
  String get maxPrice => 'උපරිම මිල';

  @override
  String get average => 'සාමාන්‍යය';

  @override
  String get volatility => 'මිල උස්පහත් වීම';

  @override
  String get thisPeriod => 'මෙම කාලය';

  @override
  String get stdDev => 'එය වෙනස් වන ප්‍රමාණය';

  @override
  String get exportAsPdf => 'PDF ලෙස නිර්යාත කරන්න';

  @override
  String get alertsTitle => 'මිල ඇඟවීම්';

  @override
  String activeAlertsCount(int count) {
    return 'ක්‍රියාත්මක ඇඟවීම් ($count)';
  }

  @override
  String setOn(String date) {
    return '$date දින සකසන ලදී';
  }

  @override
  String get alertHistory => 'ඇඟවීම් ඉතිහාසය';

  @override
  String get setPriceAlert => 'මිල ඇඟවීමක් සකසන්න';

  @override
  String get priceExceeds => 'මිල ඉක්මවයි';

  @override
  String get dropsBelow => 'අඩු වේ';

  @override
  String get priceThreshold => 'මිල සීමාව';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get createAlert => 'ඇඟවීම සාදන්න';

  @override
  String get alertToday => 'අද';

  @override
  String get alertPriceHit => 'මිල ළඟා විය';

  @override
  String get alertPriceDropped => 'මිල පහත වැටුණි';

  @override
  String alertPreview(
      String vegetable, String action, String price, String threshold) {
    return '$vegetable ඇඟවීම: $action රු. $price/kg (ඔබේ ඇඟවීම: රු. $threshold)';
  }
}
