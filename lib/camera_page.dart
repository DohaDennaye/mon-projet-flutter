import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final bool isVideoMode;

  const CameraPage({
    super.key,
    required this.camera,
    required this.isVideoMode,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: widget.isVideoMode,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      await _controller.takePicture().then((file) => file.saveTo(path));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo sauvegardée : $path')),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      final file = await _controller.stopVideoRecording();
      setState(() => isRecording = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vidéo sauvegardée : ${file.path}')),
      );
    } else {
      await _controller.startVideoRecording();
      setState(() => isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isVideoMode ? 'Caméra Vidéo' : 'Caméra Photo'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed:
                      widget.isVideoMode ? _toggleRecording : _takePhoto,
                      backgroundColor: widget.isVideoMode
                          ? (isRecording ? Colors.red : Colors.green)
                          : Colors.blue,
                      child: Icon(widget.isVideoMode
                          ? (isRecording ? Icons.stop : Icons.videocam)
                          : Icons.camera),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
