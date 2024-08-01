import 'package:clone_state_management/provider/data_lain.dart';
import 'package:clone_state_management/provider/data_minuman.dart';
import 'package:clone_state_management/widget/grid_data_lain.dart';
import 'package:clone_state_management/widget/grid_minuman.dart';
import 'package:flutter/material.dart';
import 'package:clone_state_management/provider/data_product.dart';
import '../widget/grid_card.dart';
import 'package:provider/provider.dart';

class GridViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<DataProduct>(context);
    //print("ini dari" + "$productData");
    final allProduct = productData.dataProduct;
    // print(allProduct);
    final productMinuman = Provider.of<DataProductMinuman>(context);
    // print(productMinuman);
    final allMinuman = productMinuman.dataMinuman;
    //print("ini data minuman" + "$allMinuman");
    final productLain = Provider.of<DataProductLain>(context);
    // print(productMinuman);
    final dataProdukLain = productLain.dataLain;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0), // Set the desired height here
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.red,
            // Rest of your AppBar code
            bottom: TabBar(
              indicator: BoxDecoration(
                color: Colors.redAccent, // Change the indicator color here
              ),
              labelStyle: TextStyle(fontSize: 16.0),
              tabs: [
                Tab(text: 'Makanan'),
                Tab(text: 'Minuman'),
                Tab(text: 'Mie Ayam'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1 content (GridMakanan)
            ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: allProduct.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: allProduct[index],
                child: const GridCard(),
              ),
            ),
            // Tab 2 content (GridMinuman)
            ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: allMinuman.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: allMinuman[index],
                child: const GridDataMinuman(),
              ),
            ),
            // Tab 3 content (GridDataLain)
            ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: dataProdukLain.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: dataProdukLain[index],
                child: const GridDataLain(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
