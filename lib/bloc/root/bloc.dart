import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<IntegrationStepChanged>((event, emit) {
      double integrationStep = event.integrationStep.clamp(0.001, 1);

      emit(state.copyWith(
        integrationStep: () => integrationStep,
        results: () => _calculationsRepository.calculate(
          integrationStep: integrationStep,
          damper: state.damper,
        ),
      ));
    });
    on<DamperTypeChanged>((event, emit) => emit(state.copyWith(
          damper: () => event.damper,
          results: () => _calculationsRepository.calculate(
            integrationStep: state.integrationStep,
            damper: event.damper,
          ),
        )));
  }
}
