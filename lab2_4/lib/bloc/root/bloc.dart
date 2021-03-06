import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<HeightStabilizationChanged>((event, emit) {
      RootState newState = state.copyWith(
          heightStabilization: () => event.heightStabilization.clamp(0, 20));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<TurbulentWindVerticalSpeedChanged>((event, emit) {
      RootState newState = state.copyWith(
          turbulentWindVerticalSpeed: () =>
              event.turbulentWindVerticalSpeed.clamp(0, 6));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<FlightTimeChanged>((event, emit) {
      RootState newState =
          state.copyWith(flightTime: () => event.flightTime.clamp(15, 300));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<OutputIntervalChanged>((event, emit) {
      RootState newState = state.copyWith(
          outputInterval: () => event.outputInterval.clamp(0.5, 10));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<AutoStabilizationChanged>((event, emit) {
      RootState newState =
          state.copyWith(autoStabilization: () => event.autoStabilization);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<ElevatingRudderChanged>((event, emit) {
      RootState newState = state.copyWith(
          elevatingRudder: () => event.elevatingRudder.clamp(-5, 5));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<VariantChanged>((event, emit) {
      RootState newState = state.copyWith(variant: () => event.variant);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
  }

  CalculationResults _calculate(RootState state) =>
      _calculationsRepository.calculate(
        heightStabilization: state.heightStabilization,
        turbulentWindVerticalSpeed: state.turbulentWindVerticalSpeed,
        flightTime: state.flightTime,
        outputInterval: state.outputInterval,
        autoStabilization: state.autoStabilization,
        elevatingRudder: state.elevatingRudder,
        variant: state.variant,
      );
}
