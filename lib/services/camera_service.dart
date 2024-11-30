import 'package:camera/camera.dart';

class CameraService {
  Future<CameraController> initializeCamera(CameraDescription camera) async {
    final controller = CameraController(camera, ResolutionPreset.medium);
    await controller.initialize();
    return controller;
  }
}
