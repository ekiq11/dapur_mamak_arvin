import 'dart:convert';
import 'package:clone_state_management/models/provider_lain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataProductLain with ChangeNotifier {
  final List<ProductLain> _dataLain = [];

  Future<void> fetchDataAPI() async {
    final apiUrl =
        'https://dapurmamakarvin.online/api/v1/data_barang.php?id_jenis_barang=5';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];

          _dataLain.clear();
          data.forEach((load) {
            _dataLain.add(ProductLain(
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
          throw Exception('No data available.');
        }
      } else {
        throw Exception('Failed to load data from API: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  List<ProductLain> get dataLain {
    return [..._dataLain];
  }

  ProductLain findById(productId) {
    return _dataLain.firstWhere((prodId) => prodId.id == productId);
  }
}
