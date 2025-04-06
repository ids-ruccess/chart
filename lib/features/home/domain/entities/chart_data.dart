class GlucoseData {
  final int measuredTs;
  final int glucose;
  final int? spike;

  GlucoseData({
    required this.measuredTs,
    required this.glucose,
    this.spike,
  });

  factory GlucoseData.fromJson(Map<String, dynamic> json) {
    return GlucoseData(
      measuredTs: json['measuredTs'],
      glucose: json['glucose'],
      spike: json['spike'],
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