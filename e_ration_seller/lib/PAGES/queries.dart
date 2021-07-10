import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:e_ration_seller/COMPONENTS/no_data.dart';
import 'package:e_ration_seller/COMPONENTS/product_query_box.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/product_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class Queries extends StatelessWidget {
  const Queries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'Queries'),
      ),
      drawer: AppDrawer(index: 3),
      body: StreamBuilder<List<ProductModel>>(
          stream: DatabaseManager.getInstance.getQueryProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!
                      .map((e) => ProductQueryBox(
                            product: e,
                          ))
                      .toList(),
                );
              }
            }
            return NoData(
              message: 'No queries to show!!!',
              icon: FlutterIcons.chat_bubble_mdi,
            );
          }),
    );
  }
}
