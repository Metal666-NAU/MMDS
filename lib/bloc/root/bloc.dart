import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_1/data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<IntegrationStepChanged>((event, emit) {
      emit(state.copyWith(
        integrationStep: () => event.integrationStep,
        results: () => _calculationsRepository.calculate(
          integrationStep: event.integrationStep,
          damper: state.damper,
        ),
      ));
    });
    on<DamperTypeChanged>((event, emit) {
      emit(state.copyWith(
        damper: () => event.damper,
        results: () => _calculationsRepository.calculate(
          integrationStep: state.integrationStep,
          damper: event.damper,
        ),
      ));
    });
  }
}
