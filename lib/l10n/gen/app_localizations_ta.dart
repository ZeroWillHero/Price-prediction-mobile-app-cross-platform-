// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'காய்கறி விலை';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navPredict => 'முன்னறிவிப்பு';

  @override
  String get navHistory => 'வரலாறு';

  @override
  String get navAlerts => 'எச்சரிக்கைகள்';

  @override
  String get navSettings => 'அமைப்புகள்';

  @override
  String get chooseLanguageTitle => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get chooseLanguageSubtitle => 'இதை பின்னர் அமைப்புகளில் மாற்றலாம்.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get settingsDarkMode => 'இருண்ட பயன்முறை';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get settingsOfflineMode => 'ஆஃப்லைன் பயன்முறை';

  @override
  String get settingsNotifications => 'அறிவிப்புகள்';

  @override
  String get settingsNotificationsOn => 'இயக்கத்தில்';

  @override
  String get settingsHowPredictionsWork =>
      'முன்னறிவிப்புகள் எவ்வாறு செயல்படுகின்றன';

  @override
  String get settingsPrivacyData => 'தனியுரிமை & தரவு';

  @override
  String get settingsChangeLanguage => 'மொழியை மாற்றவும்';

  @override
  String get appVersion => 'vege_price v1.0.0';

  @override
  String get homeWelcomeBack => 'மீண்டும் வரவேற்கிறோம், ';

  @override
  String get homeMarketStable => 'சந்தை நிலையானது';

  @override
  String get homeBiggestMoverToday => 'இன்றைய பெரிய மாற்றம்';

  @override
  String get evoFire => 'மிக அதிகம்';

  @override
  String get evoHot => 'அதிகம்';

  @override
  String get evoMild => 'நடுத்தரம்';

  @override
  String get evoCool => 'குறைவு';

  @override
  String get evoCalm => 'நிலையானது';

  @override
  String get homeTrendingThisWeek => 'இந்த வாரம் பிரபலமானவை';

  @override
  String get seeAll => 'அனைத்தையும் காண்க';

  @override
  String get homeActiveAlerts => 'செயலில் உள்ள எச்சரிக்கைகள்';

  @override
  String get manage => 'நிர்வகி';

  @override
  String homeAlertsTriggeredToday(int count) {
    return 'இன்று $count எச்சரிக்கைகள் இயக்கப்பட்டன';
  }

  @override
  String get homeSampleAlertDetail => 'கேரட் விலை Rs 350/kg ஐ எட்டியது';

  @override
  String homeThisWeekPrediction(String price) {
    return 'இந்த வார முன்னறிவிப்பு: $price';
  }

  @override
  String get howItWorks => 'இது எவ்வாறு செயல்படுகிறது';

  @override
  String get predictHorizonQuestion =>
      'எவ்வளவு தூரம் முன்னறிவிக்க விரும்புகிறீர்கள்?';

  @override
  String get predictLongerLessAccurate =>
      'நீண்ட கால முன்னறிவிப்புகள் குறைவான துல்லியத்தன்மை கொண்டவை.';

  @override
  String predictedPriceLabel(String horizon) {
    return 'முன்னறிவிக்கப்பட்ட விலை · $horizon';
  }

  @override
  String get predictionInfo => 'இந்த முன்னறிவிப்பு பற்றி';

  @override
  String get predictionMethod => 'முன்னறிவிப்பு முறை';

  @override
  String get typicalAccuracy => 'பொதுவாக துல்லியமான வரம்பு';

  @override
  String get seeHowModelWorks =>
      'மாதிரி எவ்வாறு செயல்படுகிறது எனப் பார்க்கவும்';

  @override
  String get share => 'பகிரவும்';

  @override
  String get livePriceSuffix => 'நேரடி விலை';

  @override
  String get todaySuffix => 'இன்று';

  @override
  String get recordedPrice => 'பதிவான விலை';

  @override
  String get aiPrediction => 'முன்னறிவிப்பு';

  @override
  String get pickDate => 'தேதியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get loginTitle => 'மீண்டும் வரவேற்கிறோம்';

  @override
  String get loginSubtitle =>
      'உங்கள் நிர்வாகி வழங்கிய கணக்கு விவரங்களுடன் உள்நுழையவும்.';

  @override
  String get emailLabel => 'மின்னஞ்சல்';

  @override
  String get passwordLabel => 'கடவுச்சொல்';

  @override
  String get loginButton => 'உள்நுழையவும்';

  @override
  String get loginError => 'மின்னஞ்சல் அல்லது கடவுச்சொல் தவறானது.';

  @override
  String get fieldRequired => 'இந்த புலம் அவசியம்.';

  @override
  String get emailInvalid => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்.';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get logoutConfirmTitle => 'வெளியேறவா?';

  @override
  String get logoutConfirmMessage =>
      'விலைகளைக் காண மீண்டும் உள்நுழைய வேண்டும்.';

  @override
  String get noAccountPrompt => 'கணக்கு இல்லையா?';

  @override
  String get signUpLink => 'பதிவு செய்யவும்';

  @override
  String get signUpTitle => 'உங்கள் கணக்கை உருவாக்கவும்';

  @override
  String get signUpSubtitle => 'தொடங்க உங்கள் விவரங்களை உள்ளிடவும்.';

  @override
  String get firstNameLabel => 'முதல் பெயர்';

  @override
  String get lastNameLabel => 'கடைசி பெயர்';

  @override
  String get confirmPasswordLabel => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get signUpButton => 'பதிவு செய்யவும்';

  @override
  String get passwordTooShort =>
      'கடவுச்சொல் குறைந்தது 8 எழுத்துகள் இருக்க வேண்டும்.';

  @override
  String get passwordMismatch => 'கடவுச்சொற்கள் பொருந்தவில்லை.';

  @override
  String get haveAccountPrompt => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get loginLink => 'உள்நுழையவும்';

  @override
  String get historyTitle => 'விலை வரலாறு';

  @override
  String get minPrice => 'குறைந்த விலை';

  @override
  String get maxPrice => 'அதிக விலை';

  @override
  String get average => 'சராசரி';

  @override
  String get volatility => 'விலை ஏற்ற இறக்கம்';

  @override
  String get thisPeriod => 'இந்த காலம்';

  @override
  String get stdDev => 'எவ்வளவு மாறுகிறது';

  @override
  String get exportAsPdf => 'PDF ஆக ஏற்றுமதி செய்யவும்';

  @override
  String get alertsTitle => 'விலை எச்சரிக்கைகள்';

  @override
  String activeAlertsCount(int count) {
    return 'செயலில் உள்ள எச்சரிக்கைகள் ($count)';
  }

  @override
  String setOn(String date) {
    return '$date அன்று அமைக்கப்பட்டது';
  }

  @override
  String get alertHistory => 'எச்சரிக்கை வரலாறு';

  @override
  String get setPriceAlert => 'விலை எச்சரிக்கையை அமைக்கவும்';

  @override
  String get priceExceeds => 'விலை மிகுகிறது';

  @override
  String get dropsBelow => 'விலை குறைகிறது';

  @override
  String get priceThreshold => 'விலை வரம்பு';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get createAlert => 'எச்சரிக்கையை உருவாக்கு';

  @override
  String get alertToday => 'இன்று';

  @override
  String get alertPriceHit => 'விலை எட்டியது';

  @override
  String get alertPriceDropped => 'விலை குறைந்தது';

  @override
  String alertPreview(
      String vegetable, String action, String price, String threshold) {
    return '$vegetable எச்சரிக்கை: $action Rs $price/kg (உங்கள் எச்சரிக்கை: Rs $threshold)';
  }
}
