import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:e_ration_seller/COMPONENTS/async_loader.dart';
import 'package:e_ration_seller/COMPONENTS/no_data.dart';
import 'package:e_ration_seller/COMPONENTS/product_card.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/product_model.dart';
import 'package:e_ration_seller/PAGES/add_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'Products'),
      ),
      drawer: AppDrawer(index: 1),
      body: StreamBuilder<List<ProductModel>>(
          stream: DatabaseManager.getInstance.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none) {
              if (snapshot.data != null) {
                if (snapshot.data!.length > 0) {
                  return ListView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: snapshot.data!
                            .map(
                              (e) => ProductCard(
                                productData: e,
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  );
                } else {
                  return NoData(
                    message: 'No product to show!!!',
                    icon: FlutterIcons.store_mall_directory_mdi,
                  );
                }
              }
            }

            return Center(
              child: AsyncLoader(),
            );
          }),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: AddProduct(),
              ),
            ).then((value) {
              if (value != null) {
                if (value) {
                  Fluttertoast.showToast(
                    msg: "Product Added to Inventory",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black54,
                    fontSize: 16.0,
                  );
                }
              }
            });
          },
          child: Icon(FlutterIcons.plus_faw5s),
        ),
      ),
    );
  }
}
