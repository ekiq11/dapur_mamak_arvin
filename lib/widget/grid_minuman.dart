import 'package:clone_state_management/models/currency_format.dart';
import 'package:clone_state_management/models/provider_minuman.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class GridDataMinuman extends StatefulWidget {
  const GridDataMinuman({Key? key});

  @override
  State<GridDataMinuman> createState() => _GridDataMinumanState();
}

class _GridDataMinumanState extends State<GridDataMinuman> {
  @override
  Widget build(BuildContext context) {
    final productMinuman = Provider.of<ProductMinuman>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                productMinuman.title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
              ),
              subtitle: Text(
                CurrencyFormat.convertToIdr(
                    double.parse('${productMinuman.price}'), 0),
              ),
              trailing: Ink(
                decoration: ShapeDecoration(
                  color: Colors.red, // Warna latar belakang merah
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${productMinuman.title} telah ditambah ke keranjang',
                          style: TextStyle(fontSize: 16),
                        ),
                        //backgroundColor: Colors.green, // Adjust the color as needed
                        duration: Duration(
                            milliseconds: 2), // Adjust the duration as needed
                      ),
                    );

                    cart.addCartItem(
                      productMinuman.id,
                      productMinuman.title,
                      productMinuman.price.toDouble(),
                      productMinuman.subtotal.toDouble(),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://dapurmamakarvin.online/assets/img/makanan/${productMinuman.gambarMakanan}",
                ),
                radius: 30, // Adjust the radius as needed
              ),
            )),
        Divider(
          height: 3,
        ),
      ],
    );
  }
}
