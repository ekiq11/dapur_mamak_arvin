import 'dart:convert';
import 'package:clone_state_management/models/provider_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataProduct with ChangeNotifier {
  final List<ProductMakanan> _dataProduct = [];

  Future<void> fetchDataFromAPI() async {
    final apiUrl =
        'https://dapurmamakarvin.online/api/v1/data_barang.php?id_jenis_barang=7';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];

        _dataProduct.clear();
        responseData.forEach((load) {
          _dataProduct.add(ProductMakanan(
            id: load['id_makanan'],
            idJenisMakanan: load['id_jenis_makanan'],
            title: load['nama_makanan'],
            price: double.parse(load['harga_makanan'].toString()),
            gambarMakanan: load['gambar_makanan'],
            subtotal: double.parse(load['harga_makanan'].toString()),
          ));
        });

        notifyListeners();
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  List<ProductMakanan> get dataProduct {
    return [..._dataProduct];
  }

  ProductMakanan findById(productId) {
    return _dataProduct.firstWhere((prodId) => prodId.id == productId);
  }
}
