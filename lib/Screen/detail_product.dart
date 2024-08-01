import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './cart_screen.dart';
import '../provider/data_product.dart';
import '../provider/cart.dart';
import 'package:badges/badges.dart' as badges;

class DetailProductScreen extends StatelessWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<DataProduct>(context).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        elevation: 0,
        actions: [
          Consumer<Cart>(
            builder: (context, value, child) {
              return badges.Badge(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      Text(value.jumlah.toString()),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              product.gambarMakanan!,
            ),
            // "https://dapurmamakarvin.online/assets/img/makanan/" +
            //     '${product.gambarMakanan}'),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  '${product.title}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                (product.isFavorite)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_border_rounded),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '\$ ${product.price}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '${product.idJenisMakanan}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Center(
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add to Cart'),
                    duration: Duration(seconds: 1),
                  ),
                );
                cart.addCartItem(
                  product.id!,
                  product.title!,
                  product.price!.toDouble(),
                  product.subtotal!.toDouble(),
                );
              },
              child: const Text('Add to Cart'),
            ),
          )
        ],
      ),
    );
  }
}
