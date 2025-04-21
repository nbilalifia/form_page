

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_page/model/note_model.dart';

class ShowNote extends StatelessWidget {

  const ShowNote({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteModel note = ModalRoute.of(context)!.settings.arguments as NoteModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                note.nama,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                note.nim, 
                style: TextStyle(fontSize: 18)
              ),
              Text(
                note.fakultas, 
                style: TextStyle(fontSize: 18)
              ),
              Text(
                note.prodi, 
                style: TextStyle(fontSize: 18)
              ),
              Text(
                note.alamat, 
                style: TextStyle(fontSize: 18)
              ),
              Text(
                note.nomer_hp.toString(), 
                style: TextStyle(fontSize: 18)
              ),
              kIsWeb
              ? Image.memory(base64Decode(note.photo))
              : Image.file(File(note.photo))
            ],
          ),
        ),
    );
  }
}