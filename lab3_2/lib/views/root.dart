import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../bloc/root/bloc.dart';
import '../bloc/root/events.dart';
import '../bloc/root/state.dart';
import '../data/calculations_repository.dart';
import 'swiper/controls_plugin.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(child: _targetHeightSelector()),
              Expanded(child: _managementLawSelector()),
            ],
          ),
          Expanded(
            child: Swiper.children(
              plugins: <SwiperPlugin>[ControlsPlugin()],
              fade: 0.2,
              scale: 0.9,
              loop: false,
              curve: Curves.fastOutSlowIn,
              duration: 400,
              viewportFraction: 0.85,
              children: <Widget>[
                _table1(),
                _table2(),
                _graph1(),
              ]
                  .map((widget) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 40),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: widget,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      );

  Widget _targetHeightSelector() => _parameterSlider(
        text: 'TARGET HEIGHT',
        value: (state) => state.targetHeight,
        min: 500,
        max: 700,
        divisions: 20,
        label: (state) => state.targetHeight
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => TargetHeightChanged(value),
        divisionLabels: <String>['500', '600', '700'],
      );

  Widget _managementLawSelector() => _parameterSelector(
        text: 'MANAGEMENT LAW',
        labels: [
          'Disabled',
          '1st',
          '2nd',
          '3rd',
          '4th',
          '5th',
          '6th',
          '7th',
        ],
        isSelected: (state) => ManagementLaw.values
            .map((value) => value == state.managementLaw)
            .toList(),
        onPressed: (index) => ManagementLawChanged(ManagementLaw.values[index]),
      );

  Widget _parameterSlider({
    required String text,
    required double Function(RootState) value,
    required double min,
    required double max,
    required int divisions,
    required String Function(RootState) label,
    required RootEvent Function(double) onChanged,
    required List<String> divisionLabels,
  }) =>
      BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => value(previous) != value(current),
        builder: (context, state) => Column(
          children: <Widget>[
            const SizedBox(height: 15),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Slider(
              value: value(state),
              min: min,
              max: max,
              divisions: divisions,
              label: label(state),
              onChanged: (value) =>
                  context.read<RootBloc>().add(onChanged(value)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    divisionLabels.map<Text>((label) => Text(label)).toList(),
              ),
            ),
          ],
        ),
      );

  Widget _parameterSelector({
    required String text,
    required List<String> labels,
    required List<bool> Function(RootState) isSelected,
    required RootEvent Function(int) onPressed,
  }) =>
      BlocBuilder<RootBloc, RootState>(
        builder: (context, state) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ToggleButtons(
              children: labels
                  .map((string) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 25,
                        ),
                        child: Text(
                          string,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ))
                  .toList(),
              isSelected: isSelected(state),
              onPressed: (index) =>
                  context.read<RootBloc>().add(onPressed(index)),
            )
          ],
        ),
      );

  Widget _table1() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _resultTable(
          columns: <String>[
            'c_{убал1}',
            'a_{бал1}',
            r'\delta_{вбал1}',
            'c_{101}',
            'c_{102}',
            'c_{103}',
            'c_{104}',
            'c_{105}',
            'c_{106}',
            'c_{109}',
            'c_{116}',
            'c_{120}',
          ]
              .map((string) => Math.tex(
                    string,
                    textScaleFactor: 1.5,
                  ))
              .toList(),
          rows: <List<String>>[
            <double>[
              state.results!.Cybal1,
              state.results!.abal1,
              state.results!.dvbal1,
              state.results!.c101,
              state.results!.c102,
              state.results!.c103,
              state.results!.c104,
              state.results!.c105,
              state.results!.c106,
              state.results!.c109,
              state.results!.c116,
              state.results!.c120,
            ].map((value) => value.toString()).toList()
          ],
          direction: Axis.horizontal,
        ),
      );

  Widget _table2() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _resultTable(
          columns: <String>[
            'c_{убал2}',
            'a_{бал2}',
            r'\delta_{вбал2}',
            'c_{201}',
            'c_{202}',
            'c_{203}',
            'c_{204}',
            'c_{205}',
            'c_{206}',
            'c_{209}',
            'c_{216}',
            'c_{220}',
          ]
              .map((string) => Math.tex(
                    string,
                    textScaleFactor: 1.5,
                  ))
              .toList(),
          rows: <List<String>>[
            <double>[
              state.results!.Cybal2,
              state.results!.abal2,
              state.results!.dvbal2,
              state.results!.c201,
              state.results!.c202,
              state.results!.c203,
              state.results!.c204,
              state.results!.c205,
              state.results!.c206,
              state.results!.c209,
              state.results!.c216,
              state.results!.c220,
            ].map((value) => value.toString()).toList()
          ],
        ),
      );

  Widget _resultTable({
    required List<Widget> columns,
    required List<List<String>> rows,
    Axis direction = Axis.vertical,
  }) =>
      LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) =>
            SingleChildScrollView(
          primary: false,
          child: DataTable(
            columns:
                columns.map((column) => DataColumn(label: column)).toList(),
            rows: rows
                .map((row) => DataRow(
                    cells: row
                        .map((cell) => DataCell(SizedBox(
                              width:
                                  (constraints.maxWidth - 60) / row.length / 2,
                              child: Text(
                                cell,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            )))
                        .toList()))
                .toList(),
          ),
        ),
      );

  Widget _graph1() => _resultGraph(
        'h',
        't',
        (state) => Map.fromIterables(state.results!.time, state.results!.Y6),
      );

  Widget _resultGraph(
    String leftAxisName,
    String bottomAxisName,
    Map<double, double> Function(RootState) spots,
  ) =>
      BlocBuilder<RootBloc, RootState>(
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
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max || value == meta.min) {
                        return const Text('');
                      }
                      return Text(
                        value
                            .toStringAsFixed(2)
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
                              .toStringAsFixed(1)
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
              clipData: FlClipData.all(),
              lineBarsData: <LineChartBarData>[
                LineChartBarData(
                  spots: spots(state)
                      .entries
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
          );
        },
      );
}
