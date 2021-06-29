import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/my_order_item.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/MODELS/order_model.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: StreamBuilder<List<OrderModel>>(
          stream: DatabaseManager.getInstance.getMyOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return ListView(
                    children: snapshot.data!
                        .map((e) => MyOrderItem(item: e))
                        .toList(),
                  );
                }

                return Container();
              }
            }
            return Center(child: AsyncLoader());
          }),
    );
  }
}
