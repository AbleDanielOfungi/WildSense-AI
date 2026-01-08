import 'package:tflite_flutter/tflite_flutter.dart';

class WildlifeModel {
  late Interpreter _interpreter;

  // MUST MATCH TRAINING ORDER
  static const List<double> mean = [
    38.24340948,
    53.71898889,
    53.08953704,
    5.82334444,
    20.49855185,
    26.49729852,
    64.98845704,
    2.54804785,
    8.0,
    38.24344531,
    53.09230864,
  ];

  static const List<double> std = [
    1.17476177,
    17.35041294,
    16.79609616,
    2.42848304,
    5.1910241,
    4.9066965,
    14.41403425,
    1.41631267,
    6.53197265,
    1.06764452,
    13.84371174,
  ];

  static const List<String> healthLabels = ['Critical', 'Healthy', 'Sick'];

  static const List<String> reproLabels = [
    'Not Pregnant',
    'On Heat',
    'Pregnant',
  ];

  // Future<void> load() async {
  //   _interpreter = await Interpreter.fromAsset(
  //     'assets/wildlife_health_model.tflite',
  //   );
  // }

  Future<void> load() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/wildlife_health_model.tflite',
    );

    print('Input tensors: ${_interpreter.getInputTensors()}');
    print('Output tensors: ${_interpreter.getOutputTensors()}');
  }

  List<double> _normalize(List<double> input) {
    return List.generate(input.length, (i) => (input[i] - mean[i]) / std[i]);
  }

  Map<String, String> predict(List<double> rawInput) {
    final input = [_normalize(rawInput)];

    final healthOutput = List.generate(1, (_) => List.filled(3, 0.0));
    final reproOutput = List.generate(1, (_) => List.filled(3, 0.0));

    _interpreter.runForMultipleInputs(input, {0: healthOutput, 1: reproOutput});

    final healthIdx = healthOutput[0].indexOf(
      healthOutput[0].reduce((a, b) => a > b ? a : b),
    );

    final reproIdx = reproOutput[0].indexOf(
      reproOutput[0].reduce((a, b) => a > b ? a : b),
    );

    return {
      'health': healthLabels[healthIdx],
      'reproductive': reproLabels[reproIdx],
    };
  }
}
