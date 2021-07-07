import 'package:e_ration_seller/COMPONENTS/back_app_bar.dart';
import 'package:e_ration_seller/MODELS/seller_order_model.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  final SellerOrderModel? orderData;
  OrderDetail({
    Key? key,
    this.orderData,
  }) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: SafeArea(child: BackAppBar(title: 'Order Details')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
        ),
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}
