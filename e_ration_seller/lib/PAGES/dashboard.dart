import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:e_ration_seller/COMPONENTS/data_info_card.dart';
import 'package:e_ration_seller/COMPONENTS/review_card.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class Dashboard extends StatelessWidget {
  final int rating = 3;
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'Dashboard'),
      ),
      drawer: AppDrawer(index: 0),
      body: ListView(
        children: [
          ReviewCard(),
          Row(
            children: [
              DataInfoCard(
                title: 'Prodcuts',
                icon: FlutterIcons.shopping_cart_ent,
                stream: DatabaseManager.getInstance.getProductsCount(),
              ),
              DataInfoCard(
                title: 'Queries',
                icon: FlutterIcons.chat_bubble_mdi,
                stream: DatabaseManager.getInstance.getQueries(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
