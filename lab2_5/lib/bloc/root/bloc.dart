import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<ElevatingRudderChanged>((event, emit) {
      RootState newState = state.copyWith(
          elevatingRudder: () => event.elevatingRudder.clamp(-5, 5));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<AutoStabilizationChanged>((event, emit) {
      RootState newState =
          state.copyWith(autoStabilization: () => event.autoStabilization);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<PilotGainChanged>((event, emit) {
      RootState newState =
          state.copyWith(pilotGain: () => event.pilotGain.clamp(1, 30));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<LatentReactionTimeChanged>((event, emit) {
      RootState newState = state.copyWith(
          latentReactionTime: () => event.latentReactionTime.clamp(0, 0.3));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<T2Changed>((event, emit) {
      RootState newState = state.copyWith(T2: () => event.T2.clamp(0, 10));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<T3Changed>((event, emit) {
      RootState newState = state.copyWith(T3: () => event.T3.clamp(0, 0.3));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<VariantChanged>((event, emit) {
      RootState newState = state.copyWith(variant: () => event.variant);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
  }

  CalculationResults _calculate(RootState state) =>
      _calculationsRepository.calculate(
        elevatingRudder: state.elevatingRudder,
        autoStabilization: state.autoStabilization,
        pilotGain: state.pilotGain,
        latentReactionTime: state.latentReactionTime,
        T2: state.T2,
        T3: state.T3,
        variant: state.variant,
      );
}
