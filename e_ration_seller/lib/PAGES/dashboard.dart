import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:e_ration_seller/COMPONENTS/review_card.dart';
import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
