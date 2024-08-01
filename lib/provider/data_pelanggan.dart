import 'package:clone_state_management/models/provider_pelanggan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Pelanggan>> fetchSuggestions(String pattern) async {
  final apiUrl = 'https://dapurmamakarvin.online/api/v1/data_pelanggan.php';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      // Map data response ke objek Pelanggan
      List<Pelanggan> suggestions = responseData
          .where((pelanggan) => (pelanggan['nama_pelanggan'] as String)
              .toLowerCase()
              .contains(pattern.toLowerCase()))
          .map((pelanggan) => Pelanggan(
                idPelanggan: pelanggan['id_pelanggan'],
                namaPelanggan: pelanggan['nama_pelanggan'],
                noTelpPelanggan: pelanggan['no_telp_pelanggan'],
                alamatPelanggan: pelanggan['alamat_pelanggan'],
              ))
          .toList();

      return suggestions;
    } else {
      throw Exception('Failed to fetch suggestions from API');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
