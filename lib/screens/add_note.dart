
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io show File;
import 'package:flutter/foundation.dart'; // buat kIsWeb
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../db/database_provider.dart';
import '../model/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final fakultasController = TextEditingController();
  final prodiController = TextEditingController();
  final alamatController = TextEditingController();
  final nomerHpController = TextEditingController();

  Uint8List? _webImage;
  String? _webImageName;

  io.File? _imageFile;

  Future<void> pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.first.bytes != null) {
        setState(() {
          _webImage = result.files.first.bytes!;
          _webImageName = result.files.first.name;
        });
      }
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.first.path != null) {
        setState(() {
          _imageFile = io.File(result.files.first.path!);
        });
      }
  }

  void saveNote() {
    final valid = _formKey.currentState!.validate();
    final hasImage = kIsWeb ? _webImage != null : _imageFile != null;

    if (valid && hasImage) {
      final note = NoteModel(
        nama: namaController.text,
        nim: nimController.text,
        fakultas: fakultasController.text,
        prodi: prodiController.text,
        alamat: alamatController.text,
        nomer_hp: int.parse(nomerHpController.text),
        photo: kIsWeb ? base64Encode(_webImage!) : _imageFile!.path, // Simpan nama di web, path di mobile
      );
      DatabaseProvider.db.addNewNote(note).then((_) {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lengkapi semua data dan pilih foto!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Biodata")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: namaController, decoration: InputDecoration(labelText: 'Nama'), validator: (val) => val!.isEmpty ? 'Wajib diisi' : null),
            TextFormField(controller: nimController, decoration: InputDecoration(labelText: 'NIM'), validator: (val) => val!.isEmpty ? 'Wajib diisi' : null),
            TextFormField(controller: fakultasController, decoration: InputDecoration(labelText: 'Fakultas')),
            TextFormField(controller: prodiController, decoration: InputDecoration(labelText: 'Prodi')),
            TextFormField(controller: alamatController, decoration: InputDecoration(labelText: 'Alamat')),
            TextFormField(controller: nomerHpController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Nomor HP')),
            SizedBox(height: 16),

            if (kIsWeb)
              _webImage != null
                  ? Image.memory(_webImage!, height: 200)
                  : Text("Belum ada foto")
            else
              _imageFile != null
                  ? Image.file(_imageFile!, height: 200)
                  : Text("Belum ada foto"),

            TextButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.image),
              label: Text("Pilih Foto"),
            ),

            ElevatedButton.icon(
              onPressed: saveNote,
              icon: Icon(Icons.save),
              label: Text("Simpan"),
            )
          ]),
        ),
      ),
    );
  }
}
