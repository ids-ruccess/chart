import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chart/chart_asset_provider.dart';
import '../../providers/chart/chart_provider.dart';
import '../../providers/date_provider.dart';
import 'chart_dot_painters.dart';

class ChartWidget extends ConsumerStatefulWidget {
  const ChartWidget({super.key});

  @override
  ConsumerState<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends ConsumerState<ChartWidget> {
  bool _isTwoFingerGesture = false;
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    // selectedDateProvider를 구독하여 선택 날짜를 가져옵니다.
    final selectedDate = ref.watch(selectedDateProvider);

    final asyncChartData = ref.watch(fetchChartDataProvider(selectedDate));
    final asyncDotImage = ref.watch(dotImageProvider);


    debugPrint('---------- build : $selectedDate');

    return asyncChartData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (chartData) {
        final spots = chartData.glucoseData.map((data) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            (data.measuredTs * 1000) + (60 * 1000 * 9),
          );
          final xValue = dateTime.hour + dateTime.minute / 60;
          return FlSpot(xValue, data.glucose.toDouble());
        }).toList()
          ..sort((a, b) => a.x.compareTo(b.x));

        debugPrint('[spot data] [$selectedDate] ${spots[0]}');

        return asyncDotImage.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (dotImage) {
            return GestureDetector(
              onScaleStart: (details) {
                _currentScale = 1.0;
                setState(() {
                  _isTwoFingerGesture = false;
                });
              },
              onScaleUpdate: (details) {
                if ((details.scale - 1.0).abs() > 0.02) {
                  if (!_isTwoFingerGesture) {
                    setState(() {
                      _isTwoFingerGesture = true;
                    });
                  }
                  setState(() {
                    _currentScale = details.scale;
                  });
                  debugPrint('Custom two-finger action: scale = $_currentScale');
                } else {
                  if (_isTwoFingerGesture) {
                    setState(() {
                      _isTwoFingerGesture = false;
                    });
                  }
                }
              },
              onScaleEnd: (details) {
                setState(() {
                  _currentScale = 1.0;
                  _isTwoFingerGesture = false;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 24,
                    minY: 50,
                    maxY: 200,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: Colors.black26,
                              strokeWidth: 2,
                              dashArray: [5, 5],
                            ),
                            FlDotData(show: false),
                          );
                        }).toList();
                      },
                      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                        if (event is FlTapUpEvent &&
                            response != null &&
                            response.lineBarSpots != null &&
                            response.lineBarSpots!.isNotEmpty) {
                          final int index = response.lineBarSpots!.first.spotIndex;

                          if (chartData.glucoseData[index].history != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('User Diet History'),
                                  content: Text('ID: ${chartData.glucoseData[index].history!.userDietHistoryId}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((barSpot) {
                            final xValue = barSpot.x;
                            final hour = xValue.floor();
                            final minute = ((xValue - hour) * 60).round();
                            return LineTooltipItem(
                              '시간: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}\n혈당: ${barSpot.y.toInt()}',
                              const TextStyle(color: Colors.white, fontSize: 12),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 4,
                        color: Colors.blue,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            if (chartData.glucoseData[index].history != null) {
                              return CustomDotPainter(image: dotImage, radius: 14);
                            } else {
                              return EmptyDotPainter();
                            }
                          },
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 50,
                          getTitlesWidget: (value, meta) {
                            if (value % 50 == 0) {
                              return Text('${value.toInt()}', style: const TextStyle(fontSize: 12));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 4,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() == 0 || value.toInt() == 24) {
                              return const SizedBox.shrink();
                            }
                            return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12));
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(),
                      topTitles: AxisTitles(),
                    ),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}