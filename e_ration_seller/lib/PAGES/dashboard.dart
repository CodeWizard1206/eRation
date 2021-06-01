import 'package:e_ration_seller/COMPONENTS/app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/app_drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'Dashboard'),
      ),
      drawer: AppDrawer(index: 0),
      body: Container(),
    );
  }
}
