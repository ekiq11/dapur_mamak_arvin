import 'package:flutter/material.dart';

class ProductLain with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String idJenisMakanan;
  final String gambarMakanan;
  final double subtotal;
  bool isFavorite;

  ProductLain({
    required this.id,
    required this.title,
    required this.price,
    required this.idJenisMakanan,
    required this.gambarMakanan,
    required this.subtotal,
    this.isFavorite = false,
  });
  factory ProductLain.fromJson(Map<String, dynamic> json) {
    return ProductLain(
      id: json['id_makanan'],
      title: json['nama_makanan'],
      price: double.parse(json['harga_makanan']),
      idJenisMakanan: json['id_jenis_makanan'],
      gambarMakanan: json['gambar_makanan'],
      subtotal: json['subtotal'],
    );
  }
  void statusFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
