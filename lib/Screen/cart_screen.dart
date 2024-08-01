import 'dart:convert';
import 'package:clone_state_management/Screen/transaksi.dart';
import 'package:clone_state_management/api/api.dart';
import 'package:clone_state_management/models/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final String idPelanggan;
  final String namaPelanggan;
  final String alamatPelanggan;
  final String noTelponPelanggan;

  const CartScreen({
    required this.idPelanggan,
    required this.namaPelanggan,
    required this.alamatPelanggan,
    required this.noTelponPelanggan,
    Key? key,
  }) : super(key: key);

  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _catatanController = TextEditingController();
  late List<String> catatanMap;
  bool _isSendingData = false;

  @override
  void initState() {
    super.initState();
    final cartData = Provider.of<Cart>(context, listen: false);

    // Ensure that catatanMap is initialized with the correct length
    catatanMap = List<String>.filled(cartData.items.length, '');
    // Alternatively, you can use List.generate:
    // catatanMap = List<String>.generate(cartData.items.length, (index) => '');
  }

  void _tambahCatatan(int index, String catatan) {
    setState(() {
      catatanMap[index] = catatan;
    });
  }

  Future<void> _showDialog(int index) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tambah Catatan',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _catatanController,
                decoration: InputDecoration(
                  hintText: 'Masukkan catatan',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                String catatan = _catatanController.text;
                if (catatan.isNotEmpty) {
                  _tambahCatatan(index, catatan); // Use the correct index here
                  _catatanController.clear();
                }
                Navigator.pop(context, catatan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      final cartData = Provider.of<Cart>(context, listen: false);

      // Pastikan panjang catatanMap sesuai dengan panjang cartData.items
      if (catatanMap.length != cartData.items.length) {
        setState(() {
          catatanMap = List<String>.filled(cartData.items.length, '');
        });
      }

      if (index >= 0 && index < cartData.items.length) {
        _tambahCatatan(index, result);
      } else {
        print('Invalid index: $index');
      }
      print('CatatanList: $catatanMap');
    } else {
      print('Dialog dibatalkan atau catatan kosong.');
    }
  }

  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: false);
    if (catatanMap.length != cartData.items.length) {
      setState(() {
        catatanMap = List<String>.filled(cartData.items.length, '');
      });
    }
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'List Pesanan - ${widget.namaPelanggan} - ${widget.noTelponPelanggan}',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.black54,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cartData.items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final cartItem = cartData.items.values.toList()[index];
                    String catatan =
                        catatanMap[index]; // Get catatan for this item

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 10,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                          title: Text(
                            '${cartItem.title}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: catatan.isNotEmpty
                              ? Text(
                                  'Quantity: ${cartItem.qty} x ' +
                                      CurrencyFormat.convertToIdr(
                                          double.parse('${cartItem.price}'),
                                          0) +
                                      " \n( " +
                                      CurrencyFormat.convertToIdr(
                                          double.parse('${cartItem.price}'),
                                          0) +
                                      " ) "
                                          '- $catatan',
                                )
                              : Text('Quantity: ${cartItem.qty} x ' +
                                  CurrencyFormat.convertToIdr(
                                      double.parse('${cartItem.price}'), 0) +
                                  " \n(" +
                                  CurrencyFormat.convertToIdr(
                                      double.parse('${cartItem.subtotal}'), 0) +
                                  " ) "),
                        ),
                        SizedBox(width: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 37)),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                cartData.removeSingleItem(cartItem.id!);
                              },
                            ),
                            Text('${cartItem.qty}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cartData.addCartItem(
                                    cartItem.id!,
                                    cartItem.title!,
                                    cartItem.price!,
                                    cartItem.subtotal!);
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                _showDialog(
                                    index); // Pass the index to the dialog
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Stack(
                                children: [
                                  Icon(Icons.comment, color: Colors.grey),
                                  if (catatan.isNotEmpty)
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red, // Badge color
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _isSendingData
                      ? null
                      : () async {
                          setState(() {
                            _isSendingData = true;
                          });

                          final response = await http.post(
                            Uri.parse(BaseURL.simpanTrx),
                            body: {
                              "id_pelanggan": widget.idPelanggan,
                              "id_makanan": cartData.items.keys.join(','),
                              "jumlah": cartData.items.values
                                  .map((item) => item.qty)
                                  .toList()
                                  .join(','),
                              "catatan": catatanMap.join(','),
                            },
                          );

                          setState(() {
                            _isSendingData = false;
                          });

                          if (response.statusCode == 200) {
                            final responseData =
                                json.decode(response.body)['no_transaksi'];
                            print(responseData);
                            print('CatatanList: $catatanMap');
                            print('Data saved to the database.');

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Data saved to the database.'),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Transaksi(
                                id: widget.idPelanggan,
                                idMakanan: cartData.items.keys.toList(),
                                jumlah: cartData.items.values
                                    .map((item) => item.qty)
                                    .toList(),
                                catatanMap: catatanMap,
                                total: cartData.totalAmount.toString(),
                                title: cartData.items.values
                                    .map((item) => item.title)
                                    .toList(),
                                price: cartData.items.values
                                    .map((item) => item.price)
                                    .toList(),
                                subtotal: cartData.items.values
                                    .map((item) => item.subtotal)
                                    .toList(),
                                namaPelanggan: widget.namaPelanggan,
                                noTransaksi: responseData.toString(),
                                alamat: widget.alamatPelanggan,
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to save data to the database. Error: ${response.statusCode}',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            print(
                                'Failed to save data to the database. Error: ${response.statusCode}');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isSendingData
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            CurrencyFormat.convertToIdr(
                                double.parse('${cartData.totalAmount}'), 0),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
