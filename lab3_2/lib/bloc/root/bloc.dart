import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<ManagementLawChanged>((event, emit) {
      RootState newState =
          state.copyWith(managementLaw: () => event.managementLaw);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<TargetHeightChanged>((event, emit) {
      RootState newState =
          state.copyWith(targetHeight: () => event.targetHeight);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
  }

  CalculationResults _calculate(RootState state) =>
      _calculationsRepository.calculate(
        targetHeight: state.targetHeight,
        managementLaw: state.managementLaw,
      );
}
