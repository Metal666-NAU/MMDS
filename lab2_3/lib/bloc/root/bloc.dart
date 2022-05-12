import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/calculations_repository.dart';

import 'events.dart';
import 'state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final CalculationsRepository _calculationsRepository;

  RootBloc(this._calculationsRepository) : super(RootState()) {
    on<AppLoaded>((event, emit) =>
        emit(RootState(results: _calculationsRepository.calculate())));
    on<RudderChanged>((event, emit) {
      RootState newState =
          state.copyWith(rudder: () => event.rudder.clamp(5, 25));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<ElevatingRudderChanged>((event, emit) {
      RootState newState = state.copyWith(
          elevatingRudder: () => event.elevatingRudder.clamp(-5, 5));

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<RollDamperChanged>((event, emit) {
      RootState newState = state.copyWith(rollDamper: () => event.rollDamper);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<YawDamperChanged>((event, emit) {
      RootState newState = state.copyWith(yawDamper: () => event.yawDamper);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
    on<VariantChanged>((event, emit) {
      RootState newState = state.copyWith(variant: () => event.variant);

      emit(newState.copyWith(results: () => _calculate(newState)));
    });
  }

  CalculationResults _calculate(RootState state) =>
      _calculationsRepository.calculate(
        rudder: state.rudder,
        elevatingRudder: state.elevatingRudder,
        rollDamper: state.rollDamper,
        yawDamper: state.yawDamper,
        variant: state.variant,
      );
}
