// import 'package:tflite_flutter/tflite_flutter.dart';

// class WildlifeModel {
//   late Interpreter _interpreter;

//   static const List<String> healthLabels = ['Healthy', 'Sick', 'Critical'];
//   static const List<String> reproLabels = [
//     'Not Pregnant',
//     'On Heat',
//     'Pregnant',
//     'Postpartum',
//   ];

//   Future<void> load() async {
//     _interpreter = await Interpreter.fromAsset(
//       'assets/wildlife_health_model.tflite',
//     );
//     print('TFLite Interpreter loaded');
//     print('Input tensors: ${_interpreter.getInputTensors()}');
//     print('Output tensors: ${_interpreter.getOutputTensors()}');
//   }

//   List<double> _normalize(List<double> input) {
//     // TODO: Apply normalization if model expects it
//     return input;
//   }

//   Map<String, String> predict(List<double> rawInput) {
//     final input = [_normalize(rawInput)];

//     final outputs = _interpreter.getOutputTensors();
//     final healthOutput = List.generate(1, (_) => List.filled(3, 0.0));
//     final reproOutput = List.generate(1, (_) => List.filled(4, 0.0));

//     _interpreter.runForMultipleInputs(input, {0: healthOutput, 1: reproOutput});

//     final healthIdx = healthOutput[0].indexOf(
//       healthOutput[0].reduce((a, b) => a > b ? a : b),
//     );
//     final reproIdx = reproOutput[0].indexOf(
//       reproOutput[0].reduce((a, b) => a > b ? a : b),
//     );

//     return {
//       'health': healthLabels[healthIdx],
//       'reproductive': reproLabels[reproIdx],
//     };
//   }
// }

import 'package:tflite_flutter/tflite_flutter.dart';

class WildlifeModel {
  late Interpreter _interpreter;

  // ===== LABELS =====
  static const List<String> healthLabels = ['Healthy', 'Sick', 'Critical'];

  static const List<String> reproLabels = [
    'Not Pregnant',
    'On Heat',
    'Pregnant',
    'Postpartum',
  ];

  // ===== SCALER PARAMETERS (FROM COLAB) =====
  static const List<double> _mean = [
    38.243409481481464,
    53.71898888888889,
    53.08953703703704,
    5.823344444444444,
    20.49855185185185,
    26.497298518518523,
    64.98845703703704,
    2.5480478518518526,
    8.0,
    38.24344530864198,
    53.09230864197531,
  ];

  static const List<double> _scale = [
    1.1747617687062366,
    17.350412936057985,
    16.796096156010826,
    2.4284830350917415,
    5.191024102833686,
    4.906696501094158,
    14.414034254876281,
    1.41631266591672,
    6.531972647421808,
    1.0676445176954894,
    13.84371174341554,
  ];

  // ===== LOAD MODEL =====
  Future<void> load() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/wildlife_health_model.tflite',
    );

    print('✅ TFLite model loaded');
    print('Input tensors: ${_interpreter.getInputTensors()}');
    print('Output tensors: ${_interpreter.getOutputTensors()}');
  }

  // ===== NORMALIZATION =====
  List<double> _normalize(List<double> input) {
    assert(
      input.length == _mean.length,
      'Input length mismatch: expected ${_mean.length}, got ${input.length}',
    );

    return List<double>.generate(input.length, (i) {
      return (input[i] - _mean[i]) / _scale[i];
    });
  }

  // ===== PREDICTION =====
  Map<String, String> predict(List<double> rawInput) {
    final normalizedInput = _normalize(rawInput);

    final input = [normalizedInput];

    final healthOutput = List.generate(1, (_) => List.filled(3, 0.0));
    final reproOutput = List.generate(1, (_) => List.filled(4, 0.0));

    _interpreter.runForMultipleInputs(input, {0: healthOutput, 1: reproOutput});

    final healthIdx = _argMax(healthOutput[0]);
    final reproIdx = _argMax(reproOutput[0]);

    return {
      'health': healthLabels[healthIdx],
      'reproductive': reproLabels[reproIdx],
    };
  }

  // ===== ARGMAX UTILITY =====
  int _argMax(List<double> values) {
    double maxVal = values[0];
    int maxIdx = 0;

    for (int i = 1; i < values.length; i++) {
      if (values[i] > maxVal) {
        maxVal = values[i];
        maxIdx = i;
      }
    }
    return maxIdx;
  }
}
