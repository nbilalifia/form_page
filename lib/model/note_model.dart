
class NoteModel {
  int? id;
  String nama;
  String nim;
  String fakultas;
  String prodi;
  String alamat;
  int nomer_hp;
  String photo; // local path

  NoteModel({
    this.id,
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.prodi,
    required this.alamat,
    required this.nomer_hp,
    required this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'fakultas': fakultas,
      'prodi': prodi,
      'alamat': alamat,
      'nomer_hp': nomer_hp,
      'photo': photo,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      nama: map['nama'],
      nim: map['nim'],
      fakultas: map['fakultas'],
      prodi: map['prodi'],
      alamat: map['alamat'],
      nomer_hp: map['nomer_hp'],
      photo: map['photo'],
    );
  }
}
