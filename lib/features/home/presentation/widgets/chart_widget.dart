import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;
import '../../domain/entities/chart_data.dart';

class ChartWidget extends StatefulWidget {
  final ChartData chartData;
  const ChartWidget({super.key, required this.chartData});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  ui.Image? _dotImage;
  Key _chartKey = UniqueKey(); // 차트 새로 생성용 키

  @override
  void initState() {
    super.initState();
    _loadDotImage();
  }

  Future<void> _loadDotImage() async {
    try {
      // assets/chart_meal_symbol.svg 파일은 pubspec.yaml에 등록되어 있어야 합니다.
      final String svgString =
      await rootBundle.loadString('assets/chart_meal_symbol.svg');
      final svg.DrawableRoot svgRoot =
      await svg.svg.fromSvgString(svgString, 'assets/chart_meal_symbol.svg');
      // 원하는 크기로 Picture 생성 (예: 25x25 픽셀)
      final ui.Picture picture = svgRoot.toPicture(size: const Size(25, 25));
      final ui.Image image = await picture.toImage(25, 25);
      setState(() {
        _dotImage = image;
      });
    } catch (e) {
      debugPrint('Error loading dot image: $e');
    }
  }


  @override
  void didUpdateWidget(covariant ChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 만약 chartData가 변경되면 새 key를 생성해서 차트를 완전히 다시 그리도록 합니다.
    if (oldWidget.chartData != widget.chartData) {
      setState(() {
        _chartKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget.chartData를 기반으로 FlSpot 목록 생성
    final spots = widget.chartData.glucoseData.map((data) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        (data.measuredTs * 1000) + (60 * 1000 * 9),
      );
      // x값: 시 + (분/60)로 계산 (예: 12시 30분 -> 12.5)
      final xValue = dateTime.hour + dateTime.minute / 60;
      return FlSpot(xValue, data.glucose.toDouble());
    }).toList();

    return Container(
      key: _chartKey,
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
              isCurved: false,
              barWidth: 4,
              color: Colors.blue,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  // history 정보가 있을 경우 이미지 dot, 없으면 아무것도 그리지 않음.
                  if (widget.chartData.glucoseData[index].history != null &&
                      _dotImage != null) {
                    return CustomDotPainter(image: _dotImage!, radius: 14);
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
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}

/// Custom dot painter that draws an image icon.
class CustomDotPainter extends FlDotPainter {
  final ui.Image image;
  final double radius;

  CustomDotPainter({required this.image, this.radius = 14});

  @override
  void paint(Canvas canvas, FlSpot spot, double percent, Color barColor,
      double radius, {required Color strokeColor, required double strokeWidth}) {
    final double size = this.radius * 2;
    final Paint paint = Paint();
    final Rect destRect = Rect.fromCenter(center: Offset.zero, width: size, height: size);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destRect,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomDotPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.radius != radius;
  }

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    canvas.save();
    canvas.translate(offsetInCanvas.dx, offsetInCanvas.dy);
    paint(canvas, spot, 0.0, mainColor, radius,
        strokeColor: Colors.white, strokeWidth: 2);
    canvas.restore();
  }

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is CustomDotPainter && b is CustomDotPainter) {
      return CustomDotPainter(
        image: t < 0.5 ? a.image : b.image,
        radius: a.radius + (b.radius - a.radius) * t,
      );
    }
    return this;
  }

  @override
  Size getSize(FlSpot spot) => Size((radius + 10) * 3, (radius + 10) * 3);

  @override
  Color get mainColor => Colors.blue;

  @override
  List<Object?> get props => [image, radius];
}

/// Empty dot painter that draws nothing.
class EmptyDotPainter extends FlDotPainter {
  @override
  void paint(Canvas canvas, FlSpot spot, double percent, Color barColor,
      double radius, {required Color strokeColor, required double strokeWidth}) {}

  @override
  bool shouldRepaint(covariant EmptyDotPainter oldDelegate) => false;

  @override
  Size getSize(FlSpot spot) => Size.zero;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;

  @override
  Color get mainColor => Colors.transparent;

  @override
  List<Object?> get props => [];

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {}
}

/*
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chart_provider.dart';

import 'package:flutter_svg/flutter_svg.dart' as svg;


class ChartWidget extends ConsumerStatefulWidget {
  const ChartWidget({super.key});

  @override
  ConsumerState<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends ConsumerState<ChartWidget> {
  bool _isTwoFingerGesture = false;
  double _currentScale = 1.0;
  ui.Image? _dotImage;
  String selectedDate = '2025-04-04';

  @override
  void initState() {
    super.initState();
    _loadDotImage();
  }

  Future<void> _loadDotImage() async {
    try {
      // SVG 파일을 문자열로 로드합니다.
      final String svgString = await rootBundle.loadString('assets/chart_meal_symbol.svg');
      // 문자열을 DrawableRoot로 디코딩합니다.
      final svg.DrawableRoot svgRoot = await svg.svg.fromSvgString(svgString, 'assets/chart_meal_symbol.svg');
      // 원하는 크기로 Picture 생성 (예: 16x16 픽셀)
      final ui.Picture picture = svgRoot.toPicture(size: const Size(25, 25));
      // Picture를 ui.Image로 변환합니다.
      final ui.Image image = await picture.toImage(25, 25);
      setState(() {
        _dotImage = image;
      });
    } catch (e) {
      debugPrint('Error loading dot image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncChartData = ref.watch(fetchChartDataProvider(selectedDate));
    return asyncChartData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Error: $error')),
      data: (chartData) {
        final spots = chartData.glucoseData.map((data) {
          // Unix timestamp를 DateTime으로 변환 (UTC+9 적용)
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            (data.measuredTs * 1000) + (60 * 1000 * 9),
          );
          // x값을 시간 단위 (0~24)로 계산, 분까지 반영하고 싶으면 소수점으로 표현 (예: 12.5는 12시 30분)
          final xValue = dateTime.hour + dateTime.minute / 60;
          return FlSpot(xValue, data.glucose.toDouble());
        }).toList();

        return GestureDetector(
          onScaleStart: (details) {
            _currentScale = 1.0;
            setState(() {
              _isTwoFingerGesture = false;
            });
          },
          onScaleUpdate: (details) {
            // scale이 1.0에서 충분히 벗어나면 두손가락 제스처로 판단
            if ((details.scale - 1.0).abs() > 0.02) {
              if (!_isTwoFingerGesture) {
                setState(() {
                  _isTwoFingerGesture = true;
                });
              }
              // 두손가락 제스처일 때 커스텀 액션 (예: 확대/축소)
              setState(() {
                _currentScale = details.scale;
              });
              // 예시: 확대/축소 값(_currentScale)을 로그로 출력
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
            // 제스처 종료 후 상태 초기화 (필요시 최종 처리 추가)
            setState(() {
              _currentScale = 1.0;
              _isTwoFingerGesture = false;
            });
          },
          // GestureDetector의 터치가 하위 위젯(LineChart)에 영향을 주지 않도록 behavior를 지정
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(16),
            child: LineChart(

              duration: Duration(milliseconds: 150),
              curve: Curves.linear,
              LineChartData(
                minX: 0,
                maxX: 24,
                minY: 50,
                maxY: 200,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false, // X축 그리드 제거
                  drawHorizontalLine: true,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                ),
                // 두손가락 제스처 시 built-in 터치 비활성화
                lineTouchData: LineTouchData(
                  // enabled: !_isTwoFingerGesture,
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        // dashArray를 설정하여 점선으로 표시합니다.
                        FlLine(
                          color: Colors.black26,
                          strokeWidth: 2,
                          dashArray: [5, 5],
                        ),
                        // 터치 인디케이터의 dot은 표시하지 않음
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
                    isCurved: false,
                    barWidth: 4,
                    color: Colors.blue,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        // history(userDietHistory)가 있으면 이미지 dot, 없으면 dot을 전혀 그리지 않음
                        if (chartData.glucoseData[index].history != null && _dotImage != null) {
                          return CustomDotPainter(image: _dotImage!, radius: 14);
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
                        // 50, 100, 150, 200만 표시
                        if (value % 50 == 0) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles:
                    AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 4, // 0, 4, 8, ... 24
                        getTitlesWidget: (value, meta) {
                          // 0, 4, 8, 12, 16, 20, 24 모두 표시하거나 경계값은 빈 텍스트로 처리할 수 있음.
                          // 예시에서는 경계값(0과 24)는 빈 텍스트로 처리합니다.
                          if (value.toInt() == 0 || value.toInt() == 24) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles()
                ),
                borderData: FlBorderData(show: true),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom dot painter that draws an image icon
class CustomDotPainter extends FlDotPainter {
  final ui.Image image;
  final double radius;

  CustomDotPainter({required this.image, this.radius = 0});

  @override
  void paint(Canvas canvas, FlSpot spot, double percent, Color barColor,
      double radius, {required Color strokeColor, required double strokeWidth}) {
    final double size = this.radius * 2;
    final Paint paint = Paint();
    final Rect destRect = Rect.fromCenter(center: Offset.zero, width: size, height: size);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destRect,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomDotPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.radius != radius;
  }

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    canvas.save();
    canvas.translate(offsetInCanvas.dx, offsetInCanvas.dy);
    paint(canvas, spot, 0.0, mainColor, radius,
        strokeColor: Colors.white, strokeWidth: 2);
    canvas.restore();
  }

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is CustomDotPainter && b is CustomDotPainter) {
      return CustomDotPainter(
        image: t < 0.5 ? a.image : b.image,
        radius: a.radius + (b.radius - a.radius) * t,
      );
    }
    return this;
  }

  @override
  Size getSize(FlSpot spot) => Size((radius + 10) * 3, (radius + 10) * 3);

  @override
  Color get mainColor => Colors.blue;

  @override
  List<Object?> get props => [image, radius];
}

// Empty dot painter that draws nothing.
class EmptyDotPainter extends FlDotPainter {
  @override
  void paint(Canvas canvas, FlSpot spot, double percent, Color barColor,
      double radius, {required Color strokeColor, required double strokeWidth}) {
    // 아무것도 그리지 않음.
  }

  @override
  bool shouldRepaint(covariant EmptyDotPainter oldDelegate) => false;

  @override
  Size getSize(FlSpot spot) => Size.zero;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;

  @override
  Color get mainColor => Colors.transparent;

  @override
  List<Object?> get props => [];

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // TODO: implement draw
  }
}
*/
