import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:e_ration/COMPONENTS/app_drawer.dart';
import 'package:e_ration/COMPONENTS/no_data.dart';
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
      body: NoData(
        message: 'No queries to show!!!',
        icon: FlutterIcons.chat_bubble_mdi,
      ),
    );
  }
}
