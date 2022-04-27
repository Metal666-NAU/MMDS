import '../../data/calculations_repository.dart';

abstract class RootEvent {}

class AppLoaded extends RootEvent {}

class IntegrationStepChanged extends RootEvent {
  final double integrationStep;

  IntegrationStepChanged(this.integrationStep);
}

class DamperTypeChanged extends RootEvent {
  final Damper damper;

  DamperTypeChanged(this.damper);
}
