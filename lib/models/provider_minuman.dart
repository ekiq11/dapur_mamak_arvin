import 'package:flutter/material.dart';

class ProductMinuman with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String idJenisMakanan;
  final String gambarMakanan;
  final double subtotal;
  bool isFavorite;

  ProductMinuman({
    required this.id,
    required this.title,
    required this.price,
    required this.idJenisMakanan,
    required this.gambarMakanan,
    required this.subtotal,
    this.isFavorite = false,
  });
  factory ProductMinuman.fromJson(Map<String, dynamic> json) {
    return ProductMinuman(
        id: json['id_makanan'],
        title: json['nama_makanan'],
        price: double.parse(json['harga_makanan']),
        idJenisMakanan: json['id_jenis_makanan'],
        gambarMakanan: json['gambar_makanan'],
        subtotal: json['subtotal']);
  }
  void statusFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
