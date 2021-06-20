import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:e_ration/COMPONENTS/app_drawer.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/no_data.dart';
import 'package:e_ration/COMPONENTS/product_card.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:e_ration/PAGES/add_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class ManageProduct extends StatelessWidget {
  final String? category;
  const ManageProduct({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'Products', isBackNeeded: true,),
      ),
      // drawer: AppDrawer(index: 1),
      body: StreamBuilder<List<ProductModel>>(
          stream: this.category != null
              ? DatabaseManager.getInstance
                  .getProductsWhereCategory(this.category!)
              : DatabaseManager.getInstance.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none) {
              if (snapshot.data != null) {
                if (snapshot.data!.length > 0) {
                  var _data = snapshot.data!
                      .where(
                        (element) =>
                            element.sellerArea == Constant.getUser.area,
                      )
                      .toList();
                  return ListView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _data
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
      // floatingActionButton: Builder(
      //   builder: (context) => FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         PageTransition(
      //           type: PageTransitionType.rightToLeft,
      //           child: AddProduct(),
      //         ),
      //       ).then((value) {
      //         if (value != null) {
      //           if (value) {
      //             Fluttertoast.showToast(
      //               msg: "Product Added to Inventory",
      //               toastLength: Toast.LENGTH_SHORT,
      //               timeInSecForIosWeb: 1,
      //               backgroundColor: Colors.white,
      //               textColor: Colors.black54,
      //               fontSize: 16.0,
      //             );
      //           }
      //         }
      //       });
      //     },
      //     child: Icon(FlutterIcons.plus_faw5s),
      //   ),
      // ),
    );
  }
}
