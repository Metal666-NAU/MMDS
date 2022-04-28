import '../../data/calculations_repository.dart';

class RootState {
  final double integrationStep;
  final Damper damper;
  final Variant variant;

  final CalculationResults? results;

  RootState({
    this.integrationStep = 0.001,
    this.damper = Damper.none,
    this.variant = Variant.first,
    this.results,
  });

  RootState copyWith({
    double Function()? integrationStep,
    Damper Function()? damper,
    Variant Function()? variant,
    CalculationResults? Function()? results,
  }) =>
      RootState(
        integrationStep: integrationStep == null
            ? this.integrationStep
            : integrationStep.call(),
        damper: damper == null ? this.damper : damper.call(),
        variant: variant == null ? this.variant : variant.call(),
        results: results == null ? this.results : results.call(),
      );
}
