import 'dart:math';

import 'package:equations/equations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

void main() {
  final theme = ThemeData.from(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.deepPurple,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      tertiary: Colors.purpleAccent[700],
      onTertiary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.grey[900]!,
      onBackground: Colors.grey[300]!,
      surface: Colors.grey[850]!,
      onSurface: Colors.grey[300]!,
    ),
  );

  runApp(MaterialApp(
    title: 'RGR1',
    theme: theme,
    home: Scaffold(
      body: Row(
        children: [
          Expanded(
            child: _buildGraph(
              leftAxisName: r'm_Z^{\bar{\omega_z}}',
              bottomAxisName: 'M',
              spots: _interpolate(
                <double, double>{
                  0.35: -13,
                  0.4: -13,
                  0.45: -13,
                  0.5: -13,
                  0.6: -13.5,
                  0.7: -14,
                  0.8: -15,
                  0.9: -16,
                  1: -14,
                },
                50,
              ),
            ),
          ),
          Expanded(
            child: _buildGraph(
              leftAxisName: r'm_x^{\delta_H}',
              bottomAxisName: 'M',
              spots: _interpolate(
                <double, double>{
                  0.6: -0.0005,
                  1.05: -0.0003,
                },
                50,
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}

Map<double, double> _interpolate(Map<double, double> input, int count) {
  Map<double, double> result = {};

  final polynomial = PolynomialInterpolation(
    nodes: input.entries
        .map<InterpolationNode>((entry) => InterpolationNode(
              x: entry.key,
              y: entry.value,
            ))
        .toList(),
  );

  final double smallest = input.keys.reduce(min),
      largest = input.keys.reduce(max),
      iteration = (largest - smallest) / count;

  for (var i = smallest; i < largest; i += iteration) {
    result[i] = polynomial.compute(i);
  }

  return result;
}

Widget _buildGraph({
  required String leftAxisName,
  required String bottomAxisName,
  required Map<double, double> spots,
}) =>
    Builder(builder: (context) {
      final List<Color> gradientColors = <Color>[
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.tertiary,
      ];

      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                leftTitles: AxisTitles(
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Math.tex(
                      leftAxisName,
                      textScaleFactor: 2,
                    ),
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max || value == meta.min) {
                        return const Text('');
                      }

                      return Text(
                        value
                            .toStringAsFixed(5)
                            .replaceFirst(RegExp(r'\.?0*$'), ''),
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: Math.tex(
                    bottomAxisName,
                    textScaleFactor: 2,
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max || value == meta.min) {
                        return const Text('');
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          value
                              .toStringAsFixed(4)
                              .replaceFirst(RegExp(r'\.?0*$'), ''),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
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
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              //clipData: FlClipData.all(),
              lineBarsData: <LineChartBarData>[
                LineChartBarData(
                  spots: spots.entries
                      .map<FlSpot>((entry) => FlSpot(
                            entry.key,
                            entry.value,
                          ))
                      .toList(),
                  barWidth: 5,
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
      );
    });
