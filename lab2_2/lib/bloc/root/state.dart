import '../../data/calculations_repository.dart';

class RootState {
  final double centering;
  final double elevatingRudder;
  final double throttle;
  final double wind;
  final Variant variant;

  final CalculationResults? results;

  RootState({
    this.centering = 0.18,
    this.elevatingRudder = 0,
    this.throttle = 0,
    this.wind = 0,
    this.variant = Variant.first,
    this.results,
  });

  RootState copyWith({
    double Function()? centering,
    double Function()? elevatingRudder,
    double Function()? throttle,
    double Function()? wind,
    Variant Function()? variant,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        centering: centering == null ? this.centering : centering.call(),
        elevatingRudder: elevatingRudder == null
            ? this.elevatingRudder
            : elevatingRudder.call(),
        throttle: throttle == null ? this.throttle : throttle.call(),
        wind: wind == null ? this.wind : wind.call(),
        variant: variant == null ? this.variant : variant.call(),
        results: results == null ? this.results : results.call(),
      );
}
