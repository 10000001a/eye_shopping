import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Map<String, dynamic>> yoloResults = <Map<String, dynamic>>[];
  List<YoloResult> yoloResults2 = <YoloResult>[];
  CameraImage? cameraImage;
  bool isReadyToDetect = false;

  bool wasEmpty = true;
  bool findAll = true;

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
      modelPath: 'assets/yolov5n_1900_best.tflite',
      modelVersion: 'yolov5',
      numThreads: 1,
      useGpu: false,
    );
  }

  Future<void> _initNewCameraController() async {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high, // 가로 1280, 세로 720

      enableAudio: false,
    );

    await controller!.initialize();

    await controller!.startImageStream(_detect);
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
    final List<Map<String, dynamic>> result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((Plane plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (result.isNotEmpty) {
      if (wasEmpty) {
        await HapticFeedback.heavyImpact();
      }
      setState(() {
        wasEmpty = false;
        yoloResults2 = result
            .map(YoloResult.fromMap)
            .where(
              (YoloResult element) => findAll || element.tag == 'orange',
            )
            .toList();
      });
    } else {
      setState(() {
        wasEmpty = true;
      });
    }
  }

  @override
  void dispose() {
    vision.closeYoloModel();
    controller?.dispose();
    super.dispose();
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults2.isEmpty) {
      return <Widget>[];
    }

    final double factorX = screen.width / 1280 * 2.3;

    final double factorY = (screen.height - 100) / 720 * 2.6;

    const Color colorPick = Color.fromARGB(255, 50, 233, 30);

    return yoloResults2
        .map(
          (YoloResult result) => Positioned(
            top: result.top * factorY,
            left: result.left * factorX,
            width: (result.right - result.left) * factorX,
            height: (result.bottom - result.top) * factorY,
            // ignore: use_decorated_box
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Colors.pink, width: 2.0),
              ),
              child: Text(
                '${result.tag} '
                '${(result.confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  background: Paint()..color = colorPick,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  String getYoloResultString() {
    final Map<String, int> resultMap = <String, int>{};
    for (final YoloResult element in yoloResults2) {
      if (resultMap.containsKey(element.tag)) {
        resultMap[element.tag] = resultMap[element.tag]! + 1;
      } else {
        resultMap[element.tag] = 1;
      }
    }

    String resultString = '';

    resultMap.forEach((String key, int value) {
      resultString += '$key: $value\n';
    });

    return resultString;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Camera'),
        ),
        body: controller == null
            ? const Text('Loading')
            : Stack(
                children: <Widget>[
                  Transform.scale(
                    scale: 1 /
                        (controller!.value.aspectRatio *
                            MediaQuery.of(context).size.aspectRatio),
                    alignment: Alignment.topCenter,
                    child: CameraPreview(controller!),
                  ),
                  ...displayBoxesAroundRecognizedObjects(
                    MediaQuery.of(context).size,
                  ),
                  // ...yoloResults2.map((e) => TabBox(yoloData: e)),
                  if (yoloResults2.isNotEmpty)
                    Text(
                      getYoloResultString(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                      ),
                    ),
                  Positioned(
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          findAll = !findAll;
                        });
                      },
                      child: findAll
                          ? const Text('find only orange')
                          : const Text('find all'),
                    ),
                  ),
                ],
              ),
      );
}

class YoloResult extends Equatable {
  final List<double> box;
  final String tag;

  const YoloResult({
    required this.box,
    required this.tag,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'box': box,
        'tag': tag,
      };

  double get left => box[0];
  double get top => box[1];
  double get right => box[2];
  double get bottom => box[3];
  double get confidence => box[4];

  double get width => right - left;
  double get height => bottom - top;

  @override
  String toString() =>
      'top: $top\n left: $left\n bottom: $bottom\n right: $right\n'
      'height: $height\n width: $width\n'
      'confidence: $confidence\n tag: $tag';

  factory YoloResult.fromMap(Map<String, dynamic> map) => YoloResult(
        box: List<double>.from(map['box'] as List<double>),
        tag: map['tag'] as String,
      );

  factory YoloResult.fromJson(String source) =>
      YoloResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => <Object>[box, tag];
}

class TabBox extends StatelessWidget {
  final YoloResult yoloData;
  const TabBox({required this.yoloData, super.key});

  @override
  Widget build(BuildContext context) {
    final double factorX = MediaQuery.of(context).size.width / 1280 * 2.3;
    final double factorY =
        (MediaQuery.of(context).size.width - 100) / 720 * 2.6;

    return Positioned(
      top: yoloData.top * factorY,
      left: yoloData.left * factorX,
      width: (yoloData.right - yoloData.left) * factorX,
      height: (yoloData.bottom - yoloData.top) * factorY,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.pink, width: 2.0),
        ),
        child: Text(
          '${yoloData.tag} '
          '${(yoloData.confidence * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            background: Paint()..color = const Color.fromARGB(255, 50, 233, 30),
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
