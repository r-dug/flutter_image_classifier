import 'dart:ffi';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter_platform_interface.dart';

class TFLiteModel {
  Interpreter? _interpreter;
  List<String>? _labels;

  // Load the model and labels
  Future<void> loadModel() async {
    try {
      // Load the model file
      final interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');

      // Load the labels file
      final labelsData = await rootBundle.loadString('assets/model/labels.txt');
      _labels = labelsData.split('\n');
    } catch (e) {
      print("Error loading the model: $e");
    }
  }
  
  Interpreter? get interpreter => _interpreter;
  List<String>? get labels => _labels;

  // Perform image recognition
  Future<String> predict(File image) async {
    try {
      // Placeholder for the image input
      var input = await preprocessImage(image); // You need to implement this method
      print("img size: ${input.length}");
      // print(input.runtimeType);
      // print(input);
      List<List<double>> output = [List.filled(_labels!.length, 0)];
      _interpreter!.run(input, output);

      // Process the output
      int maxIndex = output[0].indexOf(output[0].reduce((curr, next) => curr > next ? curr : next));
      return _labels![maxIndex];
    }catch (e){
      // print(e);
      return 'Inference failed: $e';
    }

  }

  // Image preprocessing (convert image to tensor format)
  Future<List> preprocessImage(File image) async {
    Uint8List bytes = await image.readAsBytes();
    final img.Image? decodedImage = img.decodeImage(bytes);
    final img.Image resizedImage = img.copyResize(
      decodedImage!,
      width: 224,
      height: 224,
    );
    List<double> byteArray = List<double>.filled(224*224*3, 0);
    int index=0;
    // print("W: ${resizedImage.width}");
    // print("H: ${resizedImage.height}");
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        // Get the pixel color at (x, y)
        img.Pixel pixel = resizedImage.getPixel(x, y);
        
        // Extract RGB components
        byteArray[index++] = pixel.r / 255;   // Red component
        byteArray[index++] = pixel.g / 255; // Green component
        byteArray[index++] = pixel.b / 255;  // Blue component
      }
      // print(byteArray);
    }
    print("loop finished");
    List encoded = byteArray.reshape([1,224,224,3]);
    print("reshaping finished");
    return encoded;
  }

  // Clean up when done
  void dispose() {
    _interpreter?.close();
  }
}
