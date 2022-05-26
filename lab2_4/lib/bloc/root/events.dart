import '../../data/calculations_repository.dart';

abstract class RootEvent {}

class AppLoaded extends RootEvent {}

class HeightStabilizationChanged extends RootEvent {
  final double heightStabilization;

  HeightStabilizationChanged(this.heightStabilization);
}

class TurbulentWindVerticalSpeedChanged extends RootEvent {
  final double turbulentWindVerticalSpeed;

  TurbulentWindVerticalSpeedChanged(this.turbulentWindVerticalSpeed);
}

class FlightTimeChanged extends RootEvent {
  final double flightTime;

  FlightTimeChanged(this.flightTime);
}

class OutputIntervalChanged extends RootEvent {
  final double outputInterval;

  OutputIntervalChanged(this.outputInterval);
}

class AutoStabilizationChanged extends RootEvent {
  final bool autoStabilization;

  AutoStabilizationChanged(this.autoStabilization);
}

class ElevatingRudderChanged extends RootEvent {
  final double elevatingRudder;

  ElevatingRudderChanged(this.elevatingRudder);
}

class VariantChanged extends RootEvent {
  final Variant variant;

  VariantChanged(this.variant);
}
