import 'package:flutter/material.dart';
import 'qr_scanner_page.dart';

class ActifForm extends StatefulWidget {
  const ActifForm({super.key});

  @override
  ActifFormState createState() => ActifFormState();
}

class ActifFormState extends State<ActifForm> {
  String? selectedActif = "Choisissez Actif";
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Actif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              // Dropdown pour choisir l'actif
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedActif,
                      items: ["Choisissez Actif", "Actif 1", "Actif 2"]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedActif = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Champ de texte pour le code
              Expanded(
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    hintText: "Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Bouton Scanner QR
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scanner"),
                  onPressed: () async {
                    final scannedCode = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QRScannerPage()),
                    );

                    if (scannedCode != null) {
                      setState(() {
                        codeController.text = scannedCode;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Champ de description
          const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
