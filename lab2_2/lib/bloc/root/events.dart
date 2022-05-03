import '../../data/calculations_repository.dart';

abstract class RootEvent {}

class AppLoaded extends RootEvent {}

class CenteringChanged extends RootEvent {
  final double centering;

  CenteringChanged(this.centering);
}

class ElevatingRudderChanged extends RootEvent {
  final double elevatingRudder;

  ElevatingRudderChanged(this.elevatingRudder);
}

class ThrottleChanged extends RootEvent {
  final double throttle;

  ThrottleChanged(this.throttle);
}

class WindChanged extends RootEvent {
  final double wind;

  WindChanged(this.wind);
}

class VariantChanged extends RootEvent {
  final Variant variant;

  VariantChanged(this.variant);
}
