import 'dart:convert';
import 'package:clone_state_management/models/provider_minuman.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataProductMinuman with ChangeNotifier {
  List<ProductMinuman> _dataMinuman = [];

  Future<void> fetchDataAPI() async {
    final apiUrl =
        'https://dapurmamakarvin.online/api/v1/data_barang.php?id_jenis_barang=6';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];

        _dataMinuman.clear();
        responseData.forEach((load) {
          _dataMinuman.add(ProductMinuman(
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

  List<ProductMinuman> get dataMinuman {
    return [..._dataMinuman];
  }

  ProductMinuman findById(productId) {
    return _dataMinuman.firstWhere((prodId) => prodId.id == productId);
  }
}
