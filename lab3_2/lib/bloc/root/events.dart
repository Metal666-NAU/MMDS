import '../../data/calculations_repository.dart';

abstract class RootEvent {}

class AppLoaded extends RootEvent {}

class TargetHeightChanged extends RootEvent {
  final double targetHeight;

  TargetHeightChanged(this.targetHeight);
}

class ManagementLawChanged extends RootEvent {
  final ManagementLaw managementLaw;

  ManagementLawChanged(this.managementLaw);
}
