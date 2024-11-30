import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late XFile image;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().catchError((e) {
      // print('Failed to initialize camera: $e');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> capturePhoto() async {
    if (_controller.value.isInitialized) {
      image = await _controller.takePicture();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera Preview')),
      body: CameraPreview(_controller),
      floatingActionButton: FloatingActionButton(
        onPressed: capturePhoto,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
