/*
//pour la camera
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    var status = await Permission.camera.request();

    if (!status.isGranted) {
      print("Permission refusée");
      return;
    }

    cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      _initializeControllerFuture = _controller!.initialize();
      setState(() {}); // Met à jour l'UI après l'initialisation
    } else {
      print("Aucune caméra disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accéder à la Caméra')),
      body: Center(
        child: _controller == null
            ? Text('Caméra non disponible')
            : ElevatedButton(
          onPressed: () async {
            if (_initializeControllerFuture != null) {
              await _initializeControllerFuture;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPreviewPage(controller: _controller!),
                ),
              );
            }
          },
          child: Text('Ouvrir la caméra'),
        ),
      ),
    );
  }
}

class CameraPreviewPage extends StatelessWidget {
  final CameraController controller;

  CameraPreviewPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prévisualisation de la caméra')),
      body: CameraPreview(controller),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'actif_form.dart'; // Importation du formulaire

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulaire Actif")),
      body: Column(
        children: [
          const Expanded(child: ActifForm()), // Formulaire Actif
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text("Ouvrir la Caméra"),
            onPressed: () async {
              var status = await Permission.camera.request();
              if (status.isGranted) {
                final cameras = await availableCameras();
                if (cameras.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(camera: cameras[0]),
                    ),
                  );
                } else {
                  print("Aucune caméra disponible");
                }
              } else {
                print("Permission caméra refusée");
              }
            },
          ),
        ],
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  const CameraPage({super.key, required this.camera});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caméra')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),%

    );
  }
}
*/






import 'package:flutter/material.dart';
import 'actif_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulaire Actif',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire Actif"),
        centerTitle: true,
      ),
      body: const ActifForm(), // Le formulaire est directement affiché
    );
  }
}
