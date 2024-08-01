import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/cart_screen.dart';
import 'Screen/detail_product.dart';
import 'Screen/landing.dart';
import 'Screen/login/login.dart';
import 'provider/cart.dart';
import 'provider/data_lain.dart';
import 'provider/data_minuman.dart';
import 'provider/data_product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // Check if the user is logged in
      future: checkLoginStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Show loading while checking
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => DataProduct()),
              ChangeNotifierProvider(create: (context) => DataProductMinuman()),
              ChangeNotifierProvider(create: (context) => DataProductLain()),
              ChangeNotifierProvider(create: (context) => Cart()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primaryColor: Colors.red),
              home: snapshot.data! ? LandingPage() : LoginPage(),
              routes: {
                DetailProductScreen.routeName: (context) =>
                    const DetailProductScreen(),
                CartScreen.routeName: (context) {
                  final SharedPreferences prefs =
                      Provider.of<SharedPreferences>(context, listen: false);

                  final String namaPelanggan =
                      prefs.getString('namaPelanggan') ?? 'Nama Pelanggan';
                  final String alamatPelanggan =
                      prefs.getString('alamatPelanggan') ?? 'Alamat Pelanggan';
                  final String noTelponPelanggan =
                      prefs.getString('noTelponPelanggan') ??
                          'No. Telpon Pelanggan';
                  final String idPelanggan =
                      prefs.getString('idPelanggan') ?? 'No id Pelanggan';

                  return CartScreen(
                    namaPelanggan: namaPelanggan,
                    alamatPelanggan: alamatPelanggan,
                    noTelponPelanggan: noTelponPelanggan,
                    idPelanggan: idPelanggan,
                  );
                }
              },
            ),
          );
        }
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') != null;
  }
}
