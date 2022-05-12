import '../../data/calculations_repository.dart';

abstract class RootEvent {}

class AppLoaded extends RootEvent {}

class RudderChanged extends RootEvent {
  final double rudder;

  RudderChanged(this.rudder);
}

class ElevatingRudderChanged extends RootEvent {
  final double elevatingRudder;

  ElevatingRudderChanged(this.elevatingRudder);
}

class RollDamperChanged extends RootEvent {
  final RollDamper rollDamper;

  RollDamperChanged(this.rollDamper);
}

class YawDamperChanged extends RootEvent {
  final YawDamper yawDamper;

  YawDamperChanged(this.yawDamper);
}

class VariantChanged extends RootEvent {
  final Variant variant;

  VariantChanged(this.variant);
}
