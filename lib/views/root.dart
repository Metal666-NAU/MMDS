import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/root/events.dart';
import '../data/calculations_repository.dart';

import '../bloc/root/bloc.dart';
import '../bloc/root/state.dart';
import 'swiper/controls_plugin.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _integrationStepSlider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _damperTypeSelector(),
              const VerticalDivider(width: 50),
              _variantSelector(),
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

  Widget _integrationStepSlider() => BlocBuilder<RootBloc, RootState>(
        builder: (context, state) => Column(
          children: <Widget>[
            const SizedBox(height: 15),
            Text(
              'INTEGRATION STEP',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Slider(
              value: state.integrationStep,
              min: 0,
              max: 1,
              divisions: 1000,
              label: state.integrationStep
                  .toStringAsFixed(3)
                  .replaceFirst(RegExp(r'\.?0*$'), ''),
              onChanged: (value) =>
                  context.read<RootBloc>().add(IntegrationStepChanged(value)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('0'),
                  Text('0.5'),
                  Text('1'),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _damperTypeSelector() => BlocBuilder<RootBloc, RootState>(
        builder: (context, state) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'DAMPER TYPE',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ToggleButtons(
              children: <String>[
                'NONE',
                'TYPE 1',
                'TYPE 2',
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
              isSelected:
                  Damper.values.map((value) => value == state.damper).toList(),
              onPressed: (index) => context
                  .read<RootBloc>()
                  .add(DamperTypeChanged(Damper.values[index])),
            )
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

  Widget _graph1() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _tableGraph(
          columns: const <Widget>[
            Text('Cybal'),
            Text('abal'),
            Text('dvbal'),
            Text('dnyv'),
          ],
          rows: <List<String>>[
            <String>[
              state.results!.cybal.toString(),
              state.results!.abal.toString(),
              state.results!.dvbal.toString(),
              state.results!.dnyv.toString(),
            ],
          ],
        ),
      );

  Widget _graph2() => BlocBuilder<RootBloc, RootState>(
        buildWhen: (previous, current) => current.results != null,
        builder: (context, state) => _tableGraph(
          columns: const <Widget>[
            Text('T'),
            Text('Xb'),
            Text('Dv'),
            Text('Y3'),
            Text('Y4'),
            Text('NY'),
          ],
          rows: List.generate(
            state.results!.t.length,
            (index) => <String>[
              state.results!.t[index].toString(),
              state.results!.xb[index].toString(),
              state.results!.dv[index].toString(),
              state.results!.y2[index].toString(),
              state.results!.y3[index].toString(),
              state.results!.ny[index].toString(),
            ],
          ),
        ),
      );

  Widget _tableGraph({
    required List<Widget> columns,
    required List<List<String>> rows,
  }) =>
      LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) =>
            SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.vertical,
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
                  spots: state.results?.t
                      .map<FlSpot>((element) => FlSpot(element,
                          state.results!.ny[state.results!.t.indexOf(element)]))
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
