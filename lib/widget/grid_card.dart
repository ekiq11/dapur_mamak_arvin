import 'package:clone_state_management/models/currency_format.dart';
import 'package:clone_state_management/models/provider_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class GridCard extends StatefulWidget {
  const GridCard({Key? key});

  @override
  _GridCardState createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductMakanan>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                productData.title!,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
              ),
              subtitle: Text(
                CurrencyFormat.convertToIdr(
                    double.parse('${productData.price}'), 0),
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
                          '${productData.title} telah ditambah ke keranjang',
                          style: TextStyle(fontSize: 16),
                        ),
                        // backgroundColor:
                        //     Colors.green, // Adjust the color as needed
                        duration: Duration(
                            milliseconds: 2), // Adjust the duration as needed
                      ),
                    );

                    cart.addCartItem(
                      productData.id!,
                      productData.title!,
                      productData.price!.toDouble(),
                      productData.subtotal!.toDouble(),
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
                  "https://dapurmamakarvin.online/assets/img/makanan/${productData.gambarMakanan!}",
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
