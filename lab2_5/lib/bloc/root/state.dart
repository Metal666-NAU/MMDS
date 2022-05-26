import '../../data/calculations_repository.dart';

class RootState {
  final double elevatingRudder;
  final bool autoStabilization;
  final double pilotGain;
  final double latentReactionTime;
  final double T2;
  final double T3;
  final Variant variant;

  final CalculationResults? results;

  RootState({
    this.elevatingRudder = -2,
    this.autoStabilization = false,
    this.pilotGain = 1,
    this.latentReactionTime = 0.15,
    this.T2 = 1,
    this.T3 = 0.15,
    this.variant = Variant.first,
    this.results,
  });

  RootState copyWith({
    double Function()? elevatingRudder,
    bool Function()? autoStabilization,
    double Function()? pilotGain,
    double Function()? latentReactionTime,
    double Function()? T2,
    double Function()? T3,
    Variant Function()? variant,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        elevatingRudder: elevatingRudder == null
            ? this.elevatingRudder
            : elevatingRudder.call(),
        autoStabilization: autoStabilization == null
            ? this.autoStabilization
            : autoStabilization.call(),
        pilotGain: pilotGain == null ? this.pilotGain : pilotGain.call(),
        latentReactionTime: latentReactionTime == null
            ? this.latentReactionTime
            : latentReactionTime.call(),
        T2: T2 == null ? this.T2 : T2.call(),
        T3: T3 == null ? this.T3 : T3.call(),
        variant: variant == null ? this.variant : variant.call(),
        results: results == null ? this.results : results.call(),
      );
}
