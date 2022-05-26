import '../../data/calculations_repository.dart';

abstract class RootEvent {}

class AppLoaded extends RootEvent {}

class ElevatingRudderChanged extends RootEvent {
  final double elevatingRudder;

  ElevatingRudderChanged(this.elevatingRudder);
}

class AutoStabilizationChanged extends RootEvent {
  final bool autoStabilization;

  AutoStabilizationChanged(this.autoStabilization);
}

class PilotGainChanged extends RootEvent {
  final double pilotGain;

  PilotGainChanged(this.pilotGain);
}

class LatentReactionTimeChanged extends RootEvent {
  final double latentReactionTime;

  LatentReactionTimeChanged(this.latentReactionTime);
}

class T2Changed extends RootEvent {
  final double T2;

  T2Changed(this.T2);
}

class T3Changed extends RootEvent {
  final double T3;

  T3Changed(this.T3);
}

class VariantChanged extends RootEvent {
  final Variant variant;

  VariantChanged(this.variant);
}
