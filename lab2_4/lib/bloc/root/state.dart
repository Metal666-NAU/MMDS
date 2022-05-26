import '../../data/calculations_repository.dart';

class RootState {
  final double heightStabilization;
  final double turbulentWindVerticalSpeed;
  final double flightTime;
  final double outputInterval;
  final bool autoStabilization;
  final double elevatingRudder;
  final Variant variant;

  final CalculationResults? results;

  RootState({
    this.heightStabilization = 0,
    this.turbulentWindVerticalSpeed = 0,
    this.flightTime = 15,
    this.outputInterval = 1,
    this.autoStabilization = false,
    this.elevatingRudder = -2,
    this.variant = Variant.first,
    this.results,
  });

  RootState copyWith({
    double Function()? heightStabilization,
    double Function()? turbulentWindVerticalSpeed,
    double Function()? flightTime,
    double Function()? outputInterval,
    bool Function()? autoStabilization,
    double Function()? elevatingRudder,
    Variant Function()? variant,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        heightStabilization: heightStabilization == null
            ? this.heightStabilization
            : heightStabilization.call(),
        turbulentWindVerticalSpeed: turbulentWindVerticalSpeed == null
            ? this.turbulentWindVerticalSpeed
            : turbulentWindVerticalSpeed.call(),
        flightTime: flightTime == null ? this.flightTime : flightTime.call(),
        outputInterval: outputInterval == null
            ? this.outputInterval
            : outputInterval.call(),
        autoStabilization: autoStabilization == null
            ? this.autoStabilization
            : autoStabilization.call(),
        elevatingRudder: elevatingRudder == null
            ? this.elevatingRudder
            : elevatingRudder.call(),
        variant: variant == null ? this.variant : variant.call(),
        results: results == null ? this.results : results.call(),
      );
}
