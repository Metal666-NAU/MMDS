import '../../data/calculations_repository.dart';

class RootState {
  final double integrationStep;
  final Damper damper;

  final CalculationResults? results;

  RootState({
    this.integrationStep = 0.001,
    this.damper = Damper.none,
    this.results,
  });

  RootState copyWith({
    double Function()? integrationStep,
    Damper Function()? damper,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        integrationStep: integrationStep == null
            ? this.integrationStep
            : integrationStep.call(),
        damper: damper == null ? this.damper : damper.call(),
        results: results == null ? this.results : results.call(),
      );
}
