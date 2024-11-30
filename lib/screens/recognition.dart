import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_2/utils/tflite_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';


class ImageRecognitionApp extends StatefulWidget {
  const ImageRecognitionApp({Key? key}) : super(key: key);

  @override
  _ImageRecognitionAppState createState() => _ImageRecognitionAppState();
}

class _ImageRecognitionAppState extends State<ImageRecognitionApp> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _result = '';
  final TFLiteModel interpreter = TFLiteModel();

  @override
  void initState() {
    super.initState();  
    interpreter.loadModel();
  }


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _processImage() async {
    if (_image != null) {
      String result = await interpreter.predict(_image!);
      setState(() {
        _result = result;
      });
    }
  }

  void _reset() {
    setState(() {
      _image = null;
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Recognition App')),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('History'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('About'),
                ),
              ]
            ),
            Flexible(
              child: Center(
                child: _image == null
                    ? const Text('No image selected')
                    : Image.file(_image!),
              ),
            ),
            if (_result.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Camera'),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _image != null ? _processImage : null,
                  child: const Text('Process'),
                ),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
