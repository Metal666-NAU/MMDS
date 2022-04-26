import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  final Random _random = Random();

  Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = <Color>[
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.tertiary,
    ];

    return Column(
      children: [
        Text('test'),
        Expanded(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Theme.of(context).colorScheme.surface,
                        getTooltipItems: (spots) => spots
                            .map<LineTooltipItem>(
                              (element) => LineTooltipItem(
                                element.x.toStringAsPrecision(3) +
                                    " : " +
                                    element.y.toStringAsPrecision(3),
                                TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    lineBarsData: <LineChartBarData>[
                      LineChartBarData(
                        spots: List.generate(
                          50,
                          (index) => FlSpot(
                              index.toDouble(), _random.nextDouble() * 10),
                        ),
                        barWidth: 5,
                        isCurved: true,
                        preventCurveOverShooting: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  swapAnimationDuration:
                      const Duration(milliseconds: 300), // Optional
                  swapAnimationCurve: Curves.fastOutSlowIn, // Optional
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
