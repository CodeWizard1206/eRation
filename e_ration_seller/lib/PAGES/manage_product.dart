import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:flutter/material.dart';

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
      body: Container(),
    );
  }
}
