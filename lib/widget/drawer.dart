import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:clone_state_management/Screen/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:clone_state_management/api/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('username');

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}

class SedangDikirim extends StatefulWidget {
  const SedangDikirim({super.key});

  @override
  State<SedangDikirim> createState() => _SedangDikirimState();
}

class _SedangDikirimState extends State<SedangDikirim> {
  final StreamController<List>? streamController = StreamController();
  // final StreamController<List>? streamctrl = StreamController();
  // final StreamController<List>? streamer = StreamController();

  @override
  void initState() {
    _belumdikirim();
    _sedangdikirim();

    super.initState();
  }

  Future<List<dynamic>?> _belumdikirim() async {
    var result = await http.get(Uri.parse(BaseURL.belumDikirim));
    var data = json.decode(result.body)['data'];

    return data;
  }

  Future<List<dynamic>?> _sedangdikirim() async {
    var result = await http.get(Uri.parse(BaseURL.sedangDikirim));
    var data = json.decode(result.body)['data'];

    return data;
  }

  Future<List<dynamic>?> _selesai() async {
    var result = await http.get(Uri.parse(BaseURL.selesai));
    var data = json.decode(result.body)['data'];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 800, // Sesuaikan tinggi sesuai kebutuhan
        child: DefaultTabController(
          length: 3,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.backpack,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.done,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "Pesanan yang belum dikirim",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FutureBuilder<List<dynamic>?>(
                        future: _belumdikirim(), // Call _statusSedang here
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available.'));
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
                                        backgroundColor: _randomColor(),
                                        child: Icon(
                                          Icons.person,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        item['nama_pelanggan'] +
                                            " #" +
                                            item['id_pesanan'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle:
                                          Text(item['tanggal_pesanan'] ?? ''),
                                      trailing:
                                          Text(item['alamat_pelanggan'] ?? ''),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "Pesanan yang sedang dikirim",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FutureBuilder<List<dynamic>?>(
                        future: _sedangdikirim(), // Call _statusSedang here
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available.'));
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
                                        backgroundColor: _randomColor(),
                                        child: Icon(
                                          Icons.person,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        item['nama_pelanggan'] +
                                            " #" +
                                            item['id_pesanan'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle:
                                          Text(item['tanggal_pesanan'] ?? ''),
                                      trailing:
                                          Text(item['alamat_pelanggan'] ?? ''),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "Pesanan yang selesai dikirim",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FutureBuilder<List<dynamic>?>(
                        future: _selesai(), // Call _statusSedang here
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available.'));
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
                                        backgroundColor: _randomColor(),
                                        child: Icon(
                                          Icons.person,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        item['nama_pelanggan'] +
                                            " #" +
                                            item['id_pesanan'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle:
                                          Text(item['tanggal_pesanan'] ?? ''),
                                      trailing:
                                          Text(item['alamat_pelanggan'] ?? ''),
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
              ],
            ),
          ),
        ),
      ),
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
