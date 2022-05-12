import '../../data/calculations_repository.dart';

class RootState {
  final double rudder;
  final double elevatingRudder;
  final RollDamper rollDamper;
  final YawDamper yawDamper;
  final Variant variant;

  final CalculationResults? results;

  RootState({
    this.rudder = 10,
    this.elevatingRudder = 0,
    this.rollDamper = RollDamper.none,
    this.yawDamper = YawDamper.none,
    this.variant = Variant.first,
    this.results,
  });

  RootState copyWith({
    double Function()? rudder,
    double Function()? elevatingRudder,
    RollDamper Function()? rollDamper,
    YawDamper Function()? yawDamper,
    Variant Function()? variant,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        rudder: rudder == null ? this.rudder : rudder.call(),
        elevatingRudder: elevatingRudder == null
            ? this.elevatingRudder
            : elevatingRudder.call(),
        rollDamper: rollDamper == null ? this.rollDamper : rollDamper.call(),
        yawDamper: yawDamper == null ? this.yawDamper : yawDamper.call(),
        variant: variant == null ? this.variant : variant.call(),
        results: results == null ? this.results : results.call(),
      );
}
