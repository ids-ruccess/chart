class UserDietHistoryData{
  final int? userDietHistoryId;
  final int? userGlucoseAreaAlertId;

  UserDietHistoryData({
    this.userDietHistoryId,
    this.userGlucoseAreaAlertId
  });

  factory UserDietHistoryData.fromJson(Map<String, dynamic> json) {
    return UserDietHistoryData(
      userDietHistoryId: json['userDietHistoryId'],
      userGlucoseAreaAlertId: json['userGlucoseAreaAlertId']
    );
  }
}

class GlucoseData {
  final int measuredTs;
  final int glucose;
  final int? spike;
  final UserDietHistoryData? history;

  GlucoseData({
    required this.measuredTs,
    required this.glucose,
    this.spike,
    this.history,
  });

  factory GlucoseData.fromJson(Map<String, dynamic> json) {
    return GlucoseData(
      measuredTs: json['measuredTs'],
      glucose: json['glucose'],
      spike: json['spike'],
      history: json['history'] != null
          ? UserDietHistoryData.fromJson(json['history'])
          : null,
    );
  }
}

class ChartData {
  final int fbg;
  final int score;
  final int targetGlucoseScore;
  final List<GlucoseData> glucoseData;

  ChartData({
    required this.fbg,
    required this.score,
    required this.targetGlucoseScore,
    required this.glucoseData,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    return ChartData(
      fbg: result['fbg'],
      score: result['score'],
      targetGlucoseScore: result['targetGlucoseScore'],
      glucoseData: (result['glucoseData'] as List)
          .map((e) => GlucoseData.fromJson(e))
          .toList(),
    );
  }
}