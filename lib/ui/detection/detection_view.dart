import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

class DetectionView extends StatefulWidget {
  const DetectionView({super.key});

  @override
  State<DetectionView> createState() => _DetectionViewState();
}

class _DetectionViewState extends State<DetectionView>
    with WidgetsBindingObserver {
  final FlutterVision vision = FlutterVision();
  late List<CameraDescription> cameras;
  CameraController? controller;
  List<Map<String, dynamic>> yoloResults = [];
  CameraImage? cameraImage;
  bool isReadyToDetect = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    await _loadYoloModel();

    cameras = await availableCameras();
    await _initNewCameraController();

    setState(() {
      isReadyToDetect = true;
    });
  }

  Future<void> _loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov5n_epoch300.tflite',
      modelVersion: "yolov5",
      numThreads: 1,
      useGpu: false,
    );
  }

  Future<void> _initNewCameraController() async {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.low,
      enableAudio: false,
    );

    await controller!.initialize();

    controller!.startImageStream((image) => _detect(image));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed && controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;

    if (oldController != null) {
      controller = null;
      await oldController.dispose();
    }

    await _initNewCameraController();
  }

  Future<void> _detect(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: controller == null
          ? const Text('Loading')
          : Stack(
              children: [
                Transform.scale(
                  scale: 1 /
                      (controller!.value.aspectRatio *
                          MediaQuery.of(context).size.aspectRatio),
                  alignment: Alignment.topCenter,
                  child: CameraPreview(controller!),
                ),
              ],
            ),
    );
  }
}
