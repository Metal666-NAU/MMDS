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
            children: <Widget>[
              Expanded(child: _heightStabilizationSlider()),
              const VerticalDivider(width: 50),
              Expanded(child: _turbulentWindVerticalSpeedSlider()),
              const VerticalDivider(width: 50),
              Expanded(child: _elevatingRudderSlider()),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _flightTimeSlider()),
              const VerticalDivider(width: 50),
              Expanded(child: _outputIntervalSlider()),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _autoStabilizationSwitch()),
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

  Widget _heightStabilizationSlider() => _parameterSlider(
        text: 'HEIGHT STABILIZATION',
        value: (state) => state.heightStabilization,
        min: 0,
        max: 20,
        divisions: 20,
        label: (state) => state.heightStabilization
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => HeightStabilizationChanged(value),
        divisionLabels: <String>['0', '10', '20'],
      );

  Widget _turbulentWindVerticalSpeedSlider() => _parameterSlider(
        text: 'TURBULENT WIND VERTICAL SPEED',
        value: (state) => state.turbulentWindVerticalSpeed,
        min: 0,
        max: 6,
        divisions: 12,
        label: (state) => state.turbulentWindVerticalSpeed
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => TurbulentWindVerticalSpeedChanged(value),
        divisionLabels: <String>['0', '3', '6'],
      );

  Widget _elevatingRudderSlider() => _parameterSlider(
        text: 'ELEVATING RUDDER',
        value: (state) => state.elevatingRudder,
        min: -5,
        max: 5,
        divisions: 10,
        label: (state) => state.elevatingRudder
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => ElevatingRudderChanged(value),
        divisionLabels: <String>['-5', '0', '5'],
      );

  Widget _flightTimeSlider() => _parameterSlider(
        text: 'FLIGHT TIME',
        value: (state) => state.flightTime,
        min: 15,
        max: 300,
        divisions: 57,
        label: (state) => state.flightTime
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => FlightTimeChanged(value),
        divisionLabels: <String>['15', '155', '300'],
      );

  Widget _outputIntervalSlider() => _parameterSlider(
        text: 'OUTPUT INTERVAL',
        value: (state) => state.outputInterval,
        min: 0.5,
        max: 10,
        divisions: 19,
        label: (state) => state.outputInterval
            .toStringAsFixed(3)
            .replaceFirst(RegExp(r'\.?0*$'), ''),
        onChanged: (value) => OutputIntervalChanged(value),
        divisionLabels: <String>['0.5', '5', '10'],
      );

  Widget _autoStabilizationSwitch() => _parameterSwitch(
        text: 'AUTO STABILIZATION',
        value: (state) => state.autoStabilization,
        onChanged: (value) => AutoStabilizationChanged(value),
      );

  Widget _variantSelector() => _parameterSelector(
        text: 'VARIANT',
        labels: [
          '1st',
          '2nd',
          '3rd',
        ],
        isSelected: (state) =>
            Variant.values.map((value) => value == state.variant).toList(),
        onPressed: (index) => VariantChanged(Variant.values[index]),
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

  Widget _parameterSwitch({
    required String text,
    required bool Function(RootState) value,
    required RootEvent Function(bool) onChanged,
  }) =>
      BlocBuilder<RootBloc, RootState>(
        builder: (context, state) => Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
              activeColor: Theme.of(context).colorScheme.primary,
              value: value(state),
              onChanged: (value) =>
                  context.read<RootBloc>().add(onChanged(value)),
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
            'c_{убал}',
            'a_{бал}',
            r'\delta_{вбал}',
            'm_{x_1}',
            'm_{x_2}',
            r'\sigma_{x_1}',
            r'\sigma_{x_2}',
            'x_{max_1}',
            'x_{max_2}',
            'I_{m_{x_{11}}}',
            'I_{m_{x_{12}}}',
            'I_{m_{x_{21}}}',
            'I_{m_{x_{22}}}',
            r'I_{\sigma_{x_{11}}}',
            r'I_{\sigma_{x_{12}}}',
            r'I_{\sigma_{x_{21}}}',
            r'I_{\sigma_{x_{22}}}',
            'T_a',
          ]
              .map((string) => Math.tex(
                    string,
                    textScaleFactor: 1.5,
                  ))
              .toList(),
          rows: <List<String>>[
            <double>[
              state.results!.Cybal,
              state.results!.abal,
              state.results!.dvbal,
              state.results!.MW1,
              state.results!.MW2,
              state.results!.MS1,
              state.results!.MS2,
              state.results!.MAX1,
              state.results!.MAX2,
              state.results!.Imx11,
              state.results!.Imx12,
              state.results!.Imx21,
              state.results!.Imx22,
              state.results!.Idx11,
              state.results!.Idx12,
              state.results!.Idx21,
              state.results!.Idx22,
              state.results!.Ta,
            ].map((value) => value.toString()).toList()
          ],
          direction: Axis.horizontal,
        ),
      );

  Widget _table2() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _resultTable(
          columns: <String>[
            't',
            'W_y',
            r'\varDelta\delta_в',
            r'\alpha_в',
            r'\thetasym',
            'H',
            'n_y',
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
              state.results!.Wy[index].toString(),
              state.results!.Dv[index].toString(),
              state.results!.Y3[index].toString(),
              state.results!.Y0[index].toString(),
              state.results!.Y4[index].toString(),
              state.results!.Ny[index].toString(),
            ],
          ),
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
        'n_y',
        't',
        (state) => Map.fromIterables(state.results!.time, state.results!.Ny),
      );

  Widget _graph2() => _resultGraph(
        'H',
        't',
        (state) => Map.fromIterables(state.results!.time, state.results!.Y4),
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
