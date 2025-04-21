import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_page/db/database_provider.dart';
import 'package:form_page/model/note_model.dart';
import 'package:form_page/screens/add_note.dart';
import 'package:form_page/screens/display_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/AddNote": (context) => AddNote(),
        "/ShowNote": (context) => ShowNote(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<NoteModel>> getNotes() async {
    return await DatabaseProvider.db.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bio Form"),
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data found"));
            } else {
              final notes = snapshot.data!;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    child: ListTile(
                      leading: note.photo.isNotEmpty
                          ? Image.file(
                              File(note.photo),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported),
                      title: Text(note.nama),
                      subtitle: Text(
                        'NIM: ${note.nim}\nFakultas: ${note.fakultas}\nProdi: ${note.prodi}\nAlamat: ${note.alamat}\nHP: ${note.nomer_hp}',
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/ShowNote",
                          arguments: note,
                        );
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: Text("Something went wrong"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "/AddNote");
          setState(() {}); // Refresh setelah tambah data
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
