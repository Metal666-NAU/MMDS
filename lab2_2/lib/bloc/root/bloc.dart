import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<CenteringChanged>((event, emit) {
      RootState newState =
          state.copyWith(centering: () => event.centering.clamp(0, 1));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<ElevatingRudderChanged>((event, emit) {
      RootState newState = state.copyWith(
          elevatingRudder: () => event.elevatingRudder.clamp(-5, 5));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<ThrottleChanged>((event, emit) {
      RootState newState =
          state.copyWith(throttle: () => event.throttle.clamp(-5, 5));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<WindChanged>((event, emit) {
      RootState newState = state.copyWith(wind: () => event.wind.clamp(-5, 5));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<VariantChanged>((event, emit) {
      RootState newState = state.copyWith(variant: () => event.variant);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
  }

  CalculationResults _calculate(RootState state) =>
      _calculationsRepository.calculate(
        centering: state.centering,
        elevatingRudder: state.elevatingRudder,
        throttle: state.throttle,
        wind: state.wind,
        variant: state.variant,
      );
}
