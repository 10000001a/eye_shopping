import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? controller;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  void _initializeCamera() async {
    final List<CameraDescription> cameraDescriptions = await availableCameras();

    print(cameraDescriptions.toString());

    // cameras[0] for rear-camera
    setState(() {
      controller = CameraController(
        cameraDescriptions[0],
        ResolutionPreset.low,
        enableAudio: false,
      );
    });

    await controller!.initialize();

    await controller!.startImageStream(onLatestImageAvailable);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {}
    });

    try {
      await cameraController.initialize();
      // await Future.wait(<Future<Object?>>[
      //   // The exposure mode is currently not supported on the web.
      //   ...!kIsWeb
      //       ? <Future<Object?>>[
      //           cameraController.getMinExposureOffset().then(
      //               (double value) => _minAvailableExposureOffset = value),
      //           cameraController
      //               .getMaxExposureOffset()
      //               .then((double value) => _maxAvailableExposureOffset = value)
      //         ]
      //       : <Future<Object?>>[],
      //   cameraController
      //       .getMaxZoomLevel()
      //       .then((double value) => _maxAvailableZoom = value),
      //   cameraController
      //       .getMinZoomLevel()
      //       .then((double value) => _minAvailableZoom = value),
      // ]);
    } on CameraException catch (e) {}

    if (mounted) {
      setState(() {});
    }
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: controller == null
          ? const Text('Loading')
          : CameraPreview(controller!),
    );
  }
}
