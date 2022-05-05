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
          _centeringSlider(),
          Row(
            children: <Widget>[
              Expanded(child: _elevatingRudderSlider()),
              const VerticalDivider(width: 50),
              Expanded(child: _throttleSlider()),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _windSlider()),
              const VerticalDivider(width: 50),
              Expanded(child: _variantSelector()),
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
                _graph2(),
                _graph3(),
              ].map((widget) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: widget,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );

  Widget _centeringSlider() => _parameterSlider(
        text: 'CENTERING',
        value: (state) => state.centering,
        min: 0,
        max: 1,
        divisions: 100,
        label: (state) => state.centering
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => CenteringChanged(value),
        divisionLabels: <String>['0', '0.5', '1'],
      );

  Widget _elevatingRudderSlider() => _parameterSlider(
        text: 'ELEVATING RUDDER',
        value: (state) => state.elevatingRudder,
        min: -5,
        max: 5,
        divisions: 20,
        label: (state) => state.elevatingRudder
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => ElevatingRudderChanged(value),
        divisionLabels: <String>['-5', '0', '5'],
      );

  Widget _throttleSlider() => _parameterSlider(
        text: 'THROTTLE',
        value: (state) => state.throttle,
        min: -5,
        max: 5,
        divisions: 20,
        label: (state) => state.throttle
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => ThrottleChanged(value),
        divisionLabels: <String>['-5', '0', '5'],
      );

  Widget _windSlider() => _parameterSlider(
        text: 'WIND',
        value: (state) => state.wind,
        min: -5,
        max: 5,
        divisions: 20,
        label: (state) =>
            state.wind.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => WindChanged(value),
        divisionLabels: <String>['-5', '0', '5'],
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

  Widget _variantSelector() => BlocBuilder<RootBloc, RootState>(
        builder: (context, state) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'VARIANT',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ToggleButtons(
              children: <String>[
                '1st',
                '2nd',
                '3rd',
              ]
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
              isSelected: Variant.values
                  .map((value) => value == state.variant)
                  .toList(),
              onPressed: (index) => context
                  .read<RootBloc>()
                  .add(VariantChanged(Variant.values[index])),
            )
          ],
        ),
      );

  Widget _table1() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _resultTable(
          columns: <String>[
            't',
            'W_x',
            'x',
            r'\delta_в',
            r'\delta_г',
            'Y_0',
            'Y_1',
            'Y_3',
            'Y_5',
            'n_y',
            'V_в',
          ]
              .map((string) => Math.tex(
                    string,
                    textScaleFactor: 1.5,
                  ))
              .toList(),
          rows: List.generate(
            state.results!.time.length,
            (index) => <String>[
              state.results!.time[index].toString(),
              state.results!.massWX[index].toString(),
              state.results!.massX[index].toString(),
              state.results!.massDV[index].toString(),
              state.results!.massDG[index].toString(),
              state.results!.massY0[index].toString(),
              state.results!.massY1[index].toString(),
              state.results!.massY3[index].toString(),
              state.results!.massY5[index].toString(),
              state.results!.massNY[index].toString(),
              state.results!.massVV[index].toString(),
            ],
          ),
        ),
      );

  Widget _table2() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _resultTable(
          columns: <String>[
            'c_1',
            'c_2',
            'c_3',
            'c_4',
            'c_5',
            'c_6',
            'c_7',
            'c_8',
            'c_9',
            'c_{16}',
            'c_{17}',
            'c_{18}',
            'c_{19}',
            'e_1',
            'e_2',
            'e_3',
            'a_{гп}',
            'c_{угп}',
            r'\delta_{вгп}',
            r'\delta_в^{n_y}',
            'T_V',
          ]
              .map((string) => Math.tex(
                    string,
                    textScaleFactor: 1.5,
                  ))
              .toList(),
          rows: <List<String>>[
            <double>[
              state.results!.C1,
              state.results!.C2,
              state.results!.C3,
              state.results!.C4,
              state.results!.C5,
              state.results!.C6,
              state.results!.C7,
              state.results!.C8,
              state.results!.C9,
              state.results!.C16,
              state.results!.C17,
              state.results!.C18,
              state.results!.C19,
              state.results!.e1,
              state.results!.e2,
              state.results!.e3,
              state.results!.agp,
              state.results!.cyhp,
              state.results!.dvgp,
              state.results!.dvny,
              state.results!.Tv,
            ].map((value) => value.toString()).toList()
          ],
          direction: Axis.horizontal,
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
        'V_в',
        't',
        (state) =>
            Map.fromIterables(state.results!.time, state.results!.massVV),
      );

  Widget _graph2() => _resultGraph(
        'y_5',
        't',
        (state) =>
            Map.fromIterables(state.results!.time, state.results!.massY5),
      );

  Widget _graph3() => _resultGraph(
        'n_y',
        't',
        (state) =>
            Map.fromIterables(state.results!.time, state.results!.massNY),
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
