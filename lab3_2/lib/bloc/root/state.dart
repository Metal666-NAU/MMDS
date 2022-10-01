import '../../data/calculations_repository.dart';

class RootState {
  final double targetHeight;
  final ManagementLaw managementLaw;

  final CalculationResults? results;

  RootState({
    this.targetHeight = 600,
    this.managementLaw = ManagementLaw.none,
    this.results,
  });

  RootState copyWith({
    double Function()? targetHeight,
    ManagementLaw Function()? managementLaw,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        targetHeight:
            targetHeight == null ? this.targetHeight : targetHeight.call(),
        managementLaw:
            managementLaw == null ? this.managementLaw : managementLaw.call(),
        results: results == null ? this.results : results.call(),
      );
}
