import 'package:flutter/material.dart';

class Pelanggan with ChangeNotifier {
  String idPelanggan;
  String namaPelanggan;
  String noTelpPelanggan;
  String alamatPelanggan;

  Pelanggan({
    required this.idPelanggan,
    required this.namaPelanggan,
    required this.noTelpPelanggan,
    required this.alamatPelanggan,
  });

  // Factory method to create Pelanggan from JSON
  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      idPelanggan: json["id_pelanggan"],
      namaPelanggan: json["nama_pelanggan"],
      noTelpPelanggan: json["no_telp_pelanggan"],
      alamatPelanggan: json["alamat_pelanggan"],
    );
  }
}
