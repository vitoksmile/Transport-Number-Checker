// ignore_for_file: file_names

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

typedef TextScannerCallback = void Function(RecognisedText);

class TextScannerWidget extends StatefulWidget {
  final TextScannerCallback _textScannerCallback;

  const TextScannerWidget({
    Key? key,
    required TextScannerCallback callback,
  })  : _textScannerCallback = callback,
        super(key: key);

  @override
  State<TextScannerWidget> createState() => _TextScannerWidgetState();
}

class _TextScannerWidgetState extends State<TextScannerWidget> {
  late TextDetector _textDetector;
  CameraController? _cameraController;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _textDetector = GoogleMlKit.vision.textDetector();
    _initializeCamera();
  }

  @override
  void dispose() {
    _textDetector.close();
    _cameraController
        ?.stopImageStream()
        .whenComplete(() => _cameraController?.dispose());
    super.dispose();
  }

  void _initializeCamera() async {
    CameraController? cameraController;
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;
      cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();

      setState(() {
        _cameraController = cameraController;
      });

      cameraController.startImageStream((CameraImage cameraImage) async {
        if (_isDetecting) return;
        _isDetecting = true;

        final WriteBuffer allBytes = WriteBuffer();
        for (Plane plane in cameraImage.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final bytes = allBytes.done().buffer.asUint8List();

        final Size imageSize = Size(
          cameraImage.width.toDouble(),
          cameraImage.height.toDouble(),
        );

        final InputImageRotation imageRotation =
            InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
                InputImageRotation.Rotation_0deg;

        final InputImageFormat inputImageFormat =
            InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
                InputImageFormat.NV21;

        final planeData = cameraImage.planes
            .map(
              (plane) => InputImagePlaneMetadata(
                bytesPerRow: plane.bytesPerRow,
                height: plane.height,
                width: plane.width,
              ),
            )
            .toList();

        final inputImageData = InputImageData(
          size: imageSize,
          imageRotation: imageRotation,
          inputImageFormat: inputImageFormat,
          planeData: planeData,
        );

        final inputImage = InputImage.fromBytes(
          bytes: bytes,
          inputImageData: inputImageData,
        );

        final RecognisedText recognisedText = await _textDetector.processImage(
          inputImage,
        );

        _isDetecting = false;
        widget._textScannerCallback.call(recognisedText);
      });
    } on CameraException catch (_) {
      debugPrint('Some error occurred!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _cameraController == null
              ? Container(
                  color: Colors.black,
                )
              : AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
        ],
      ),
    );
  }
}
