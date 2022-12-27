import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';

class DataCollectionCameraController extends StatefulWidget {
  const DataCollectionCameraController({super.key});

  @override
  State<StatefulWidget> createState() {
    return DataCollectionCameraControllerState();
  }
}

class DataCollectionCameraControllerState
    extends State<DataCollectionCameraController> {
  late dynamic cameras;
  late dynamic camera;
  bool autoFlash = true,activeFlash = false,flashOff = false;

  bool showFocusCircle = false;
  double x = 0;
  double y = 0;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  List<File> pictures = [];

  void getDeviceCamera() async {
    cameras = await availableCameras();
    camera = cameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getDeviceCamera();
    super.initState();
  }

  Future<void> _onTap(TapUpDetails details) async {
    if(_controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;
      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * _controller.value.aspectRatio;
      double xp = x / fullWidth;
      double yp = y / cameraHeight;
      Offset point = Offset(xp,yp);
      if (kDebugMode) {
        print("point : $point");
      }
      await _controller.setFocusPoint(point);
      _controller.setExposurePoint(point);
      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: CustomColors.blue900(context),
            title: const Text('Take a picture')),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, pictures);
            return false;
          },
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                    onTapUp: (details) {
                  _onTap(details);
                },
              child:Stack(children: [
                  SizedBox(
                      width: size.width,
                      height: size.height,
                      child: CameraPreview(_controller)),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Column(children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() => {
                            _controller.setFlashMode(FlashMode.off),
                            activeFlash = false,
                            autoFlash = false,
                            flashOff = !flashOff
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: Icon(Icons.flash_off_rounded,color:flashOff? Colors.orangeAccent : CustomColors.customWhite(context)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => {
                            _controller.setFlashMode(FlashMode.always),
                            flashOff = false,
                            autoFlash = false,
                            activeFlash = !activeFlash,
                          });

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: Icon(Icons.flash_on_rounded,color:activeFlash? Colors.orangeAccent : CustomColors.customWhite(context)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => {
                            _controller.setFlashMode(FlashMode.auto),
                            flashOff = false,
                            activeFlash = false,
                            autoFlash = !autoFlash,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: Icon(Icons.flash_auto_rounded,color:autoFlash? Colors.orangeAccent : CustomColors.customWhite(context)),
                      ),
                    ])
                  ]),
                  Row(
                    children: [
                      Text(
                        ' Photos taken: ${pictures.length}',
                        style: CustomTextStyle.cameraDataFont(context),
                      ),
                    ],
                  ),
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: FittedBox(
                              child: FloatingActionButton(
                            backgroundColor: CustomColors.blue900(context),
                            onPressed: () async {
                              try {
                                await _initializeControllerFuture;
                                _controller.setExposureMode(ExposureMode.auto);
                                final image = await _controller.takePicture();
                                if (!mounted) return;
                                File? res = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayPictureScreen(
                                              imagePath: image.path,
                                            )));

                                if (res != null) {
                                  setState(() {
                                    pictures.add(res);
                                    if (kDebugMode) {
                                      print('_______${pictures.length}______');
                                    }
                                  });
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            },
                            child: const Icon(Icons.camera_alt),
                          ))),
                    ],
                  ))
                ]));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "addImg",
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.pop(context, File(imagePath));
                  },
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "discardImg",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.dangerous_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
