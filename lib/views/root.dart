import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root/bloc.dart';
import '../bloc/root/state.dart';
import 'swiper/controls_plugin.dart';

class Root extends StatelessWidget {
  final Random _random = Random();

  Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Swiper.children(
        plugins: <SwiperPlugin>[ControlsPlugin()],
        fade: 0.2,
        scale: 0.9,
        loop: false,
        curve: Curves.fastOutSlowIn,
        duration: 400,
        viewportFraction: 0.85,
        children: <Widget>[
          _graph3(),
          _graph3(),
          _graph3(),
        ]
            .map((widget) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: widget,
                  ),
                ))
            .toList(),
      );

  Widget _graph1() => Table();

  Widget _graph2() => Table();

  Widget _graph3() => BlocBuilder<RootBloc, RootState>(
        builder: (context, state) {
          final List<Color> gradientColors = <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ];

          return LineChart(
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
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              clipData: FlClipData.all(),
              lineBarsData: <LineChartBarData>[
                LineChartBarData(
                  spots: List.generate(
                    50,
                    (index) =>
                        FlSpot(index.toDouble(), _random.nextDouble() * 10),
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
          );
        },
      );
}
