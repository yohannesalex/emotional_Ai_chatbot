import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ParametersEvent {}

class UpdateParameterEvent extends ParametersEvent {
  final int index; // Index of the parameter to update
  final int value; // New value for the parameter

  UpdateParameterEvent(this.index, this.value);
}

// States
class ParametersState {
  final List<int> parameters; // List of parameter values

  ParametersState(this.parameters);

  // Create an initial state with default parameter values
  ParametersState.initial()
      : parameters = [4, 4, 4, 4, 4, 4]; // Default values for all parameters

  // Create a new state with updated parameters
  ParametersState copyWith({List<int>? parameters}) {
    return ParametersState(parameters ?? this.parameters);
  }
}

// Bloc
class ParametersBloc extends Bloc<ParametersEvent, ParametersState> {
  ParametersBloc() : super(ParametersState.initial()) {
    on<UpdateParameterEvent>(_onUpdateParameterEvent);
  }

  // Handler for UpdateParameterEvent
  void _onUpdateParameterEvent(
      UpdateParameterEvent event, Emitter<ParametersState> emit) {
    // Create a new list with the updated parameter value
    final updatedParameters = List<int>.from(state.parameters);
    updatedParameters[event.index] = event.value;

    // Emit a new state with the updated parameters
    emit(state.copyWith(parameters: updatedParameters));
  }
}
