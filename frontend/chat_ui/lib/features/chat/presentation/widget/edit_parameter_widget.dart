import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/parameters_bloc.dart';

class EditParametersDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit the Dorner’s Psi theory parameters",
        style: TextStyle(fontSize: 16),
      ),
      content: BlocBuilder<ParametersBloc, ParametersState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Valence'),
                    Slider(
                      value: state.parameters[0].toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: state.parameters[0].toString(),
                      onChanged: (value) {
                        context
                            .read<ParametersBloc>()
                            .add(UpdateParameterEvent(0, value.toInt()));
                      },
                    ),
                    Text('Arousal'),
                    Slider(
                      value: state.parameters[1].toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: state.parameters[1].toString(),
                      onChanged: (value) {
                        context
                            .read<ParametersBloc>()
                            .add(UpdateParameterEvent(1, value.toInt()));
                      },
                    ),
                    Text('Selection threshold'),
                    Slider(
                      value: state.parameters[2].toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: state.parameters[2].toString(),
                      onChanged: (value) {
                        context
                            .read<ParametersBloc>()
                            .add(UpdateParameterEvent(2, value.toInt()));
                      },
                    ),
                    Text('Resolution Level'),
                    Slider(
                      value: state.parameters[3].toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: state.parameters[3].toString(),
                      onChanged: (value) {
                        context
                            .read<ParametersBloc>()
                            .add(UpdateParameterEvent(3, value.toInt()));
                      },
                    ),
                    Text('Goal-Directedness'),
                    Slider(
                      value: state.parameters[4].toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: state.parameters[4].toString(),
                      onChanged: (value) {
                        context
                            .read<ParametersBloc>()
                            .add(UpdateParameterEvent(4, value.toInt()));
                      },
                    ),
                    Text('Securing Rate'),
                    Slider(
                      value: state.parameters[5].toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: state.parameters[5].toString(),
                      onChanged: (value) {
                        context
                            .read<ParametersBloc>()
                            .add(UpdateParameterEvent(5, value.toInt()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // Access the current state of the parameters

            // Extract the parameters from the state

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: const Text("Apply"),
        ),
      ],
    );
  }
}
