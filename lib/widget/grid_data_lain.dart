import 'package:clone_state_management/models/currency_format.dart';
import 'package:clone_state_management/models/provider_lain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class GridDataLain extends StatefulWidget {
  const GridDataLain({Key? key});

  @override
  _GridDataLainState createState() => _GridDataLainState();
}

class _GridDataLainState extends State<GridDataLain> {
  @override
  Widget build(BuildContext context) {
    final productLain = Provider.of<ProductLain>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                productLain.title,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
              ),
              subtitle: Text(
                CurrencyFormat.convertToIdr(
                    double.parse('${productLain.price}'), 0),
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
                          '${productLain.title} telah ditambah ke keranjang',
                          style: TextStyle(fontSize: 16),
                        ),
                        // backgroundColor: Colors.green, // Adjust the color as needed
                        duration: Duration(
                            milliseconds: 2), // Adjust the duration as needed
                      ),
                    );

                    cart.addCartItem(
                      productLain.id,
                      productLain.title,
                      productLain.price.toDouble(),
                      productLain.subtotal,
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
                  "https://dapurmamakarvin.online/assets/img/makanan/${productLain.gambarMakanan}",
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
