// ignore_for_file: must_be_immutable

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:clone_state_management/Screen/landing.dart';
import 'package:clone_state_management/models/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transaksi extends StatefulWidget {
  String? id;
  List? idMakanan = [];
  List? jumlah = [];
  List? catatanMap = [];
  String? total;
  List? title;
  List? price;
  List? subtotal;
  String? namaPelanggan;
  String? noTransaksi;
  String? alamat;

  Transaksi(
      {super.key,
      this.id,
      this.idMakanan,
      this.jumlah,
      this.title,
      this.catatanMap,
      this.price,
      this.total,
      this.noTransaksi,
      this.namaPelanggan,
      this.subtotal,
      this.alamat});

  @override
  State<Transaksi> createState() => _TransaksiState();
}

// Pindahkan fungsi saveConnectedPrinter ke luar dari kelas _TransaksiState
Future<void> saveConnectedPrinter(BluetoothDevice device) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('connectedPrinter', device.address.toString());
}

class _TransaksiState extends State<Transaksi> {
  bool isConnected = false;
  DateTime now = DateTime.now();

  List<BluetoothDevice> device = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevice();
    connectToPrinter();
  }

  void getDevice() async {
    device = await printer.getBondedDevices();
    setState(() {});
  }
// ... (kode sebelumnya)

  Future<void> connectToPrinter() async {
    try {
      // Fetch bonded devices
      List<BluetoothDevice> devices = await printer.getBondedDevices();
      if (devices.isNotEmpty) {
        selectedDevice = devices.first;
        if (selectedDevice != null) {
          await printer.connect(selectedDevice!);

          // Panggil saveConnectedPrinter
          await saveConnectedPrinter(selectedDevice!);

          setState(() {
            isConnected = true;
          });

          // Menampilkan alert bahwa printer berhasil terhubung
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Printer Connected'),
                content: Text('Printer successfully connected.'),
                actions: <Widget>[
                  TextButton(
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
      }
    } catch (e) {
      print('Error connecting to printer: $e');
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> handleDisconnection() async {
    if (isConnected) {
      await printer.disconnect();
      setState(() {
        selectedDevice = null;
        isConnected = false;
      });

      // Menampilkan alert bahwa printer berhasil terputus
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Printer Disconnected'),
            content: Text('Printer successfully disconnected.'),
            actions: <Widget>[
              TextButton(
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
  }

// ... (kode selanjutnya)

  Future<void> printImage(String imagePath) async {
    try {
      await printer.printImage(imagePath);
    } catch (e) {
      print('Error printing image: $e');
    }
  }

  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        DateFormat('E, d MMM yyyy HH:mm.ss').format(DateTime.now());
    return WillPopScope(
      onWillPop: () async {
        await handleDisconnection();
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<BluetoothDevice>(
                onChanged: (device) {
                  // Handle when dropdown value changes
                  setState(() {
                    selectedDevice = device;
                  });
                },
                value: selectedDevice,
                hint: const Text("Selected Printer"),
                items: device.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name.toString()),
                    value: e,
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  printer.connect(selectedDevice!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // Set the background color to white
                ),
                child: Text(
                  "Connect",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  printer.disconnect();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // Set the background color to white
                ),
                child: Text(
                  "Disconnect",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if ((await printer.isConnected)!) {
                    ByteData bytesAsset =
                        await rootBundle.load("assets/icon/logo3.jpg");
                    Uint8List imageBytesFromAsset = bytesAsset.buffer
                        .asUint8List(
                            bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

                    printer.printImageBytes(imageBytesFromAsset);
                    printer.printNewLine();

                    // Header
                    printer.printCustom('Food Delivery', 1, 1);
                    printer.printCustom('Jl. Karang Bayan, Tanjung, KLU', 1, 1);
                    printer.printCustom('082340130110', 1, 1);
                    printer.printCustom(
                        '==========================================', 0, 0);
                    printer.printCustom(
                        formattedDateTime +
                            '     INVOICE #${widget.noTransaksi} ',
                        0,
                        0);

                    printer.printCustom(
                        'Nama   : ${widget.namaPelanggan.toString()}', 0, 0);
                    printer.printCustom(
                        'Alamat : ${widget.alamat.toString()}', 0, 0);
                    printer.printCustom(
                        '==========================================', 0, 0);
                    // Items
                    for (var i = 0; i < widget.title!.length; i++) {
                      printer.printCustom(
                          '${widget.title![i]}  ${widget.catatanMap![i]}  ',
                          0,
                          0);
                      printer.printCustom(
                          CurrencyFormat.convertToIdr(
                                  double.parse('${widget.price![i]}'), 0) +
                              ' x ${widget.jumlah![i]} = ' +
                              "            " +
                              CurrencyFormat.convertToIdr(
                                  double.parse('${widget.subtotal![i]}'), 0),
                          0,
                          2);
                    }
                    printer.printCustom(
                        '==========================================', 0, 0);

                    // Total
                    printer.printCustom(
                        'TOT : ' +
                            CurrencyFormat.convertToIdr(
                                double.parse('${widget.total!}'), 0),
                        2,
                        2);
                    printer.printNewLine();

                    // Footer
                    printer.printCustom('Thank you for your order', 0, 1);
                    printer.printCustom('Gratis ongkir tanjung, gondang', 0, 1);
                    printer.printCustom('pemenang', 0, 1);
                    printer.printNewLine();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // Set the background color to white
                ),
                child: Text(
                  "Print",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        // body: Column(
        //   children: [

        //   ],
        // ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: SizedBox(
              height: 600,
              width: 450,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icon/logo3.png',
                      scale: 7,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Food Delevery",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Jl. Karang Bayan Tanjung, KLU",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "082340130110",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Invoice #${widget.noTransaksi}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${widget.namaPelanggan.toString()}',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Text(
                                        formattedDateTime,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const MySeparator(color: Colors.grey),
                              SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Table header

                                            const SizedBox(height: 10),
                                            // Table rows

                                            SizedBox(height: 10),
                                            for (var i = 0;
                                                i < widget.title!.length;
                                                i++)
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        200, // Adjust the width for 'Nama Menu'
                                                    child: Text(
                                                        ' ${widget.title![i]} ${widget.catatanMap![i]}',
                                                        style: TextStyle(
                                                            fontSize: 17)),
                                                  ),
                                                  SizedBox(width: 20),
                                                  SizedBox(
                                                    width:
                                                        40, // Adjust the width for 'Jumlah'
                                                    child: Text(
                                                        ' x ${widget.jumlah![i]}',
                                                        style: TextStyle(
                                                            fontSize: 17)),
                                                  ),
                                                  SizedBox(width: 50),
                                                  SizedBox(
                                                    width:
                                                        100, // Adjust the width for 'Subtotal'
                                                    child: Text(
                                                        CurrencyFormat.convertToIdr(
                                                            double.parse(
                                                                '${widget.subtotal![i]}'),
                                                            0),
                                                        style: TextStyle(
                                                            fontSize: 17)),
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                  )
                                                ],
                                              ),
                                            SizedBox(height: 20),
                                            Divider(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Total: ",
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    CurrencyFormat.convertToIdr(
                                                        double.parse(
                                                            '${widget.total}'),
                                                        0),
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Text(
                                              "Thank you for your order",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "Gratis ongkir Tanjung, Gondang dan Pemenang",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 0.0,
                left: 0.0,
                bottom: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LandingPage(),
                        ));
                      },
                      child: Icon(Icons.home),
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
