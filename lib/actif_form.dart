import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'camera_page.dart';

class ActifForm extends StatefulWidget {
  const ActifForm({super.key});

  @override
  State<ActifForm> createState() => _ActifFormState();
}

class _ActifFormState extends State<ActifForm> {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? selectedActif;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    codeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> scanQRCode() async {
    try {
      String qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Annuler',
        true,
        ScanMode.QR,
      );

      if (qrCode != '-1') {
        setState(() {
          codeController.text = qrCode;
        });
      }
    } catch (e) {
      print("❌ Erreur lors du scan du QR Code : $e");
    }
  }

  Future<void> handleVideo() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            camera: cameras[0],
            isVideoMode: true,
          ),
        ),
      );
    }
  }

  Future<void> handlePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print("📷 Photo prise : ${photo.path}");
    }
  }

  Future<void> handleAudio() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    if (!isRecording) {
      await recorder.openRecorder();
      final dir = await getTemporaryDirectory();
      final audioPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.aac');
      await recorder.startRecorder(toFile: audioPath);
      setState(() => isRecording = true);
      print("🎙️ Enregistrement audio démarré : $audioPath");
    } else {
      final filePath = await recorder.stopRecorder();
      setState(() => isRecording = false);
      print("✅ Enregistrement terminé : $filePath");
    }
  }

  Future<void> handleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      print("📁 Fichier sélectionné : ${result.files.single.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Formulaire Actif", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          const Text("Actif", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedActif,
                  hint: const Text("Choisissez Actif"),
                  items: ["Ordinateur", "Imprimante", "Scanner"]
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedActif = value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    hintText: "Code",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Scanner QR"),
                onPressed: scanQRCode,
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextFormField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: handleAudio,
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                label: Text(isRecording ? "Stop" : "Audio"),
              ),
              ElevatedButton.icon(
                onPressed: handleVideo,
                icon: const Icon(Icons.videocam),
                label: const Text("Vidéo"),
              ),
              ElevatedButton.icon(
                onPressed: handlePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Photo"),
              ),
              ElevatedButton.icon(
                onPressed: handleFile,
                icon: const Icon(Icons.insert_drive_file),
                label: const Text("Fichier"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

