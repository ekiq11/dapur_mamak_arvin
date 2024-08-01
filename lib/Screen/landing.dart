import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:clone_state_management/models/currency_format.dart';
import 'package:clone_state_management/widget/drawer.dart';
import 'package:clone_state_management/Screen/home_product.dart';
import 'package:clone_state_management/api/api.dart';
import 'package:clone_state_management/models/provider_pelanggan.dart';
import 'package:clone_state_management/provider/cart.dart';
import 'package:clone_state_management/provider/data_pelanggan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  DateTime current_date = DateTime.now();
  final StreamController<List>? streamController = StreamController();
  Timer? _timer;

  Color _getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Future<void> _addPelanggan() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      _showErrorAlert();
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(BaseURL.tambahPelanggan),
        body: {
          "nama_pelanggan": _nameController.text,
          "no_telp_pelanggan": _phoneController.text,
          "alamat_pelanggan": _addressController.text,
        },
      );

      if (response.statusCode == 200) {
        _showSuccessAlert();
        _clearTextFields(); // Clear text fields on success
      } else {
        _showErrorAlert();
      }
    } catch (error) {
      _showErrorAlert();
    }
  }

  void _clearTextFields() {
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Data saved to the database.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save data to the database.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? username;
  _getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mengambil data dengan kunci 'nama'
    // Mengambil data dengan kunci 'username'
    username = prefs.getString('username');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    _fetchDataKeranjang();

    _timer =
        Timer.periodic(Duration(seconds: 5), (timer) => _fetchDataKeranjang());
  }

  Future<List<dynamic>?> _fetchDataKeranjang() async {
    var result = await http.get(Uri.parse(BaseURL.dataKurir));
    var data = json.decode(result.body)['data'];
    if (data != null) {
      streamController!.add(data);
    } else {
      streamController!.add([]);
    }
    return data;
  }

  @override
  void dispose() {
    if (_timer!.isActive) _timer!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Dashboard " + (username ?? 'Guest')),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SedangDikirim();
                      });
                },
                icon: Icon(Icons.auto_graph_sharp))
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Total Uang di Kurir",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<List<dynamic>?>(
              stream: streamController!.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Belum ada pesanan yang di antar.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _randomColor(), // Menggunakan warna acak
                              child: Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              item['nama_kurir'] ?? '',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(item['no_telp_kurir'] ?? ''),
                            trailing: Text(
                              CurrencyFormat.convertToIdr(
                                double.parse(item['total_uang']),
                                0,
                              ),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    height: 800, // Sesuaikan tinggi sesuai kebutuhan
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: const TabBar(
                          unselectedLabelColor: Colors.black,
                          unselectedLabelStyle: TextStyle(color: Colors.black),
                          indicator: BoxDecoration(
                            color: Colors.red, // Ubah warna indikator di sini
                          ),
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                          tabs: [
                            Tab(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 24,
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Sesuaikan jarak antara ikon dan teks
                                  Text("Pelanggan", style: TextStyle()),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_add,
                                    size: 24,
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Sesuaikan jarak antara ikon dan teks
                                  Text("Tambah Pelanggan", style: TextStyle()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TypeAheadFormField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        hintText: 'Search for a customer',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      if (pattern.isEmpty) {
                                        return List<
                                            Pelanggan>.empty(); // Mengembalikan daftar kosong jika teks pencarian kosong
                                      }
                                      List<Pelanggan> suggestions =
                                          await fetchSuggestions(pattern);
                                      return suggestions;
                                    },
                                    itemBuilder:
                                        (context, Pelanggan suggestion) {
                                      return Card(
                                        // margin: EdgeInsets.all(8.0),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(16.0),
                                          leading: CircleAvatar(
                                            backgroundColor: _getRandomColor(),
                                            child: Icon(Icons.person,
                                                color: Colors.white),
                                          ),
                                          title: Text(
                                            suggestion.namaPelanggan,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // SizedBox(height: 8.0),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on,
                                                      size: 14.0),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    suggestion.alamatPelanggan,
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.0),
                                              Row(
                                                children: [
                                                  Icon(Icons.phone, size: 14.0),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    suggestion.noTelpPelanggan,
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    onSuggestionSelected:
                                        (Pelanggan suggestion) {
                                      cart.clearCart();
                                      // Tangani ketika saran dipilih
                                      // print(
                                      //     'Selected suggestion: ${suggestion.namaPelanggan}');
                                      // print(
                                      //     'Alamat pelanggan: ${suggestion.alamatPelanggan}');
                                      // print(
                                      //     'Nomor Telepon pelanggan: ${suggestion.noTelpPelanggan}');
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => HomeProductScreen(
                                          idPelanggan: suggestion.idPelanggan,
                                          namaPelanggan:
                                              suggestion.namaPelanggan,
                                          alamatPelanggan:
                                              suggestion.alamatPelanggan,
                                          noTelponPelanggan:
                                              suggestion.noTelpPelanggan,
                                        ),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      decoration:
                                          InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: _addressController,
                                      decoration:
                                          InputDecoration(labelText: 'Address'),
                                    ),
                                    TextFormField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                          labelText: 'No Whatsapp'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: ElevatedButton(
                                        onPressed: _addPelanggan,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // Background color
                                          minimumSize: Size(double.infinity,
                                              48), // Width and height of the button
                                        ),
                                        child: Text(
                                          "Tambah Pelanggan",
                                          style: TextStyle(
                                              fontSize: 16), // Adjust text size
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      drawer: CustomDrawer(),
    );
  }

  Color _randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
