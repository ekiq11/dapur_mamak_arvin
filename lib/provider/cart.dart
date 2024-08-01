// import 'package:flutter/material.dart';

// import '../models/cart_item.dart';

// class Cart with ChangeNotifier {
//   late Map<String, CartItem> _items = {};

//   Map<String, CartItem> get items => _items;

//   int get jumlah {
//     return _items.length;
//   }

//   double get totalAmount {
//     var total = 0.0;
//     _items.forEach((key, CartItem) {
//       total += CartItem.qty * CartItem.price;
//     });
//     return total;
//   }

//   void addCart(String productId, String title, double price) {
//     if (_items.containsKey(productId)) {
//       // ketika id sudah berisi (menambah qyt)
//       _items.update(
//           productId,
//           (value) => CartItem(
//                 id: value.id,
//                 title: value.title,
//                 price: value.price,
//                 qty: value.qty + 1,
//               ));
//     } else {
//       // ketika id masih kosong
//       _items.putIfAbsent(
//           productId,
//           () => CartItem(
//                 id: DateTime.now().toString(),
//                 title: title,
//                 price: price,
//                 qty: 1,
//               ));
//     }
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get jumlah {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.qty! * cartItem.price!;
    });
    return total;
  }

  void addCartItem(
      String productId, String title, double price, double subtotal) {
    if (_items.containsKey(productId)) {
      // Product is already in the cart, increase its quantity
      _items.update(
        productId,
        (existingCartItem) {
          return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            qty: existingCartItem.qty! + 1,
            subtotal: (existingCartItem.qty! + 1) * existingCartItem.price!,
          );
        },
      );
    } else {
      // Product is not in the cart, add it as a new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          price: price,
          subtotal: price,
          qty: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return; // Item not in the cart, do nothing
    }

    if (_items[productId]!.qty! > 1) {
      // If quantity is more than 1, decrement the quantity and update subtotal
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          subtotal: (existingCartItem.qty! - 1) * existingCartItem.price!,
          qty: existingCartItem.qty! - 1,
        ),
      );
    } else {
      // If quantity is 1, remove the item from the cart
      _items.remove(productId);
    }
    notifyListeners(); // Notify listeners of the change
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId) && newQuantity > 0) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          subtotal: existingCartItem.subtotal,
          qty: newQuantity,
        ),
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
