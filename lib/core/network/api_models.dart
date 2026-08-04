/// One row of `ForecastOut` from the VegePredict API — a single week's
/// predicted (and, once resolved, actual) price for one vegetable.
class ForecastOut {
  ForecastOut({
    required this.vegetable,
    required this.modelFamily,
    required this.forecastDate,
    required this.predictedPrice,
    required this.predictedLower,
    required this.predictedUpper,
    required this.actualPrice,
  });

  factory ForecastOut.fromJson(Map<String, dynamic> json) {
    return ForecastOut(
      vegetable: json['vegetable'] as String,
      modelFamily: json['model_family'] as String,
      forecastDate: DateTime.parse(json['forecast_date'] as String),
      predictedPrice: (json['predicted_price'] as num).toDouble(),
      predictedLower: (json['predicted_lower'] as num?)?.toDouble(),
      predictedUpper: (json['predicted_upper'] as num?)?.toDouble(),
      actualPrice: (json['actual_price'] as num?)?.toDouble(),
    );
  }

  final String vegetable;
  final String modelFamily;
  final DateTime forecastDate;
  final double predictedPrice;
  final double? predictedLower;
  final double? predictedUpper;
  final double? actualPrice;
}

/// One row of `HistoricalPriceOut` — a week's recorded retail price.
class HistoricalPriceOut {
  HistoricalPriceOut({
    required this.vegetable,
    required this.weekStart,
    required this.retailPrice,
  });

  factory HistoricalPriceOut.fromJson(Map<String, dynamic> json) {
    return HistoricalPriceOut(
      vegetable: json['vegetable'] as String,
      weekStart: DateTime.parse(json['week_start'] as String),
      retailPrice: (json['retail_price'] as num).toDouble(),
    );
  }

  final String vegetable;
  final DateTime weekStart;
  final double retailPrice;
}

/// `TokenOut` — the response from `POST /auth/login`.
class TokenOut {
  TokenOut({required this.accessToken, required this.expiresIn});

  factory TokenOut.fromJson(Map<String, dynamic> json) {
    return TokenOut(
      accessToken: json['access_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }

  final String accessToken;
  final int expiresIn;
}

/// `UserOut` — the response from `GET /auth/me`.
class UserOut {
  UserOut({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  factory UserOut.fromJson(Map<String, dynamic> json) {
    return UserOut(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  String get fullName => '$firstName $lastName';
}

/// One row of `ModelMetricOut` — holdout accuracy for a model family.
class ModelMetricOut {
  ModelMetricOut({
    required this.vegetable,
    required this.modelFamily,
    required this.mae,
    required this.rmse,
  });

  factory ModelMetricOut.fromJson(Map<String, dynamic> json) {
    return ModelMetricOut(
      vegetable: json['vegetable'] as String,
      modelFamily: json['model_family'] as String,
      mae: (json['mae'] as num).toDouble(),
      rmse: (json['rmse'] as num).toDouble(),
    );
  }

  final String vegetable;
  final String modelFamily;
  final double mae;
  final double rmse;
}
