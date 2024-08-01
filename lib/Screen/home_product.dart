import 'package:clone_state_management/provider/data_lain.dart';
import 'package:clone_state_management/provider/data_minuman.dart';
import 'package:clone_state_management/provider/data_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/grid_view.dart';
import '../Screen/cart_screen.dart';
import '../provider/cart.dart';

class HomeProductScreen extends StatelessWidget {
  final String idPelanggan;
  final String namaPelanggan;
  final String alamatPelanggan;
  final String noTelponPelanggan;

  const HomeProductScreen({
    required this.idPelanggan,
    required this.namaPelanggan,
    required this.alamatPelanggan,
    required this.noTelponPelanggan,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProduct = Provider.of<DataProduct>(context);
    dataProduct.fetchDataFromAPI();
    final dataMinuman = Provider.of<DataProductMinuman>(context);
    dataMinuman.fetchDataAPI();
    final dataLain = Provider.of<DataProductLain>(context);
    dataLain.fetchDataAPI();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dapur Mamak Arvin'),
        elevation: 0,
        backgroundColor: Colors.red, // Set the background color to red
        actions: [
          Consumer<Cart>(
            builder: (context, value, child) {
              return AnimatedContainer(
                duration:
                    const Duration(milliseconds: 500), // Animation duration
                curve: Curves.easeInOut, // Animation curve
                child: IconButton(
                  iconSize: 32,
                  onPressed: () {
                    // Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: Stack(
                    children: [
                      const Icon(Icons.shopping_cart),
                      Positioned(
                        right: 0.0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .yellow, // Change the badge color to white
                          ),
                          child: Text(
                            value.jumlah.toString(),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize:
                                    16), // Change the badge text color to red
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: GridViewScreen(),
          ),
          Expanded(
            flex: 3,
            child: CartScreen(
                idPelanggan: idPelanggan,
                namaPelanggan: namaPelanggan,
                alamatPelanggan: alamatPelanggan,
                noTelponPelanggan: noTelponPelanggan),
          ),
        ],
      ),
    );
  }
}

// import 'package:clone_state_management/provider/data_lain.dart';
// import 'package:clone_state_management/provider/data_minuman.dart';
// import 'package:clone_state_management/provider/data_product.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widget/grid_view.dart';
// import '../Screen/cart_screen.dart';
// import '../provider/cart.dart';

// class HomeProductScreen extends StatelessWidget {
//   final String idPelanggan;
//   final String namaPelanggan;
//   final String alamatPelanggan;
//   final String noTelponPelanggan;

//   const HomeProductScreen({
//     required this.idPelanggan,
//     required this.namaPelanggan,
//     required this.alamatPelanggan,
//     required this.noTelponPelanggan,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final dataProduct = Provider.of<DataProduct>(context);
//     dataProduct.fetchDataFromAPI();
//     final dataMinuman = Provider.of<DataProductMinuman>(context);
//     dataMinuman.fetchDataAPI();
//     final dataLain = Provider.of<DataProductLain>(context);
//     dataLain.fetcthDataAPI();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dapur Mamak Arvin'),
//         elevation: 0,
//         backgroundColor: Colors.red, // Set the background color to red
//         actions: [
//           Consumer<Cart>(
//             builder: (context, value, child) {
//               return AnimatedContainer(
//                 duration:
//                     const Duration(milliseconds: 500), // Animation duration
//                 curve: Curves.easeInOut, // Animation curve
//                 child: IconButton(
//                   iconSize: 32,
//                   onPressed: () {
//                     // Navigator.of(context).pushNamed(CartScreen.routeName);
//                   },
//                   icon: Stack(
//                     children: [
//                       const Icon(Icons.shopping_cart),
//                       Positioned(
//                         right: 0.0,
//                         child: Container(
//                           padding: const EdgeInsets.all(4.0),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors
//                                 .yellow, // Change the badge color to white
//                           ),
//                           child: Text(
//                             value.jumlah.toString(),
//                             style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize:
//                                     16), // Change the badge text color to red
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: GridViewScreen(),
//           ),
//           // Expanded(
//           //   flex: 3,
//           //   child: CartScreen(
//           //       idPelanggan: idPelanggan,
//           //       namaPelanggan: namaPelanggan,
//           //       alamatPelanggan: alamatPelanggan,
//           //       noTelponPelanggan: noTelponPelanggan),
//           // ),
//         ],
//       ),
//     );
//   }
// }
