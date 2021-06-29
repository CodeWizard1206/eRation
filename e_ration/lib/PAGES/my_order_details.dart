import 'package:e_ration/COMPONENTS/back_app_bar.dart';
import 'package:e_ration/COMPONENTS/product_card.dart';
import 'package:e_ration/MODELS/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrderDetails extends StatelessWidget {
  final OrderModel? item;
  const MyOrderDetails({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: SafeArea(
          child: BackAppBar(
            title: 'Order Details',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Order ID : ${item!.uid}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Order Placed : ${DateFormat('dd/MMM/yy, hh:mm').format(item!.timestamp!)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'PickUp Schedule :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Date : ${DateFormat('dd/MMM/yy').format(item!.date!)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Time : ${item!.time!}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Total Amount : Rs. ${item!.totalAmount!}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: item!.products!
                  .map(
                    (e) => ProductCard(
                      productData: e,
                      isClickable: false,
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
