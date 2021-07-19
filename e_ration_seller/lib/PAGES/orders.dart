import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:e_ration_seller/COMPONENTS/no_data.dart';
import 'package:e_ration_seller/COMPONENTS/order_card.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/seller_order_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
                  if (snapshot.data!.length > 0) {
                    List<SellerOrderModel> _picked = snapshot.data!
                        .where((element) => element.status == 'Picked')
                        .toList();
                    List<SellerOrderModel> _notpicked = snapshot.data!
                        .where((element) => element.status == 'Not Picked')
                        .toList();
                    return Column(
                      children: [
                        TabBar(
                          labelColor: Theme.of(context).primaryColorLight,
                          unselectedLabelColor: Colors.blueGrey[700],
                          indicator: MaterialIndicator(
                            horizontalPadding: 35.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Not Picked',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Picked',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView(
                                children: _notpicked
                                    .map((e) => OrderCard(orderData: e))
                                    .toList(),
                              ),
                              ListView(
                                children: _picked
                                    .map((e) => OrderCard(orderData: e))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
              }
              return NoData(
                message: 'No orders to show!!!',
                icon: FlutterIcons.shopping_bag_ent,
              );
            }),
      ),
    );
  }
}
