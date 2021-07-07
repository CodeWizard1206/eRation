import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:e_ration_seller/COMPONENTS/no_data.dart';
import 'package:e_ration_seller/COMPONENTS/order_card.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/seller_order_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'Orders'),
      ),
      drawer: AppDrawer(index: 2),
      body: StreamBuilder<List<SellerOrderModel>>(
          stream: DatabaseManager.getInstance.getOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none) {
              if (snapshot.hasData) {
                List<SellerOrderModel> _data = snapshot.data!;

                if (_data.length > 0) {
                  return ListView(
                    children:
                        _data.map((e) => OrderCard(orderData: e)).toList(),
                  );
                }
              }
            }

            return NoData(
              message: 'No queries to show!!!',
              icon: FlutterIcons.shopping_bag_ent,
            );
          }),
    );
  }
}
