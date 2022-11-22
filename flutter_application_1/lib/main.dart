import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.

  runApp(
    MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(title: const Text("my first app")),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: CameraComponent(camera: cameras[0]),
          ),
        )),
  );
}

// A screen that allows users to take a picture using a given camera.
class CameraComponent extends StatefulWidget {
  const CameraComponent({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraComponentState createState() => CameraComponentState();
}

class CameraComponentState extends State<CameraComponent> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[Text('Color: ')],
              )),
        )
      ],
    );
  }
}
