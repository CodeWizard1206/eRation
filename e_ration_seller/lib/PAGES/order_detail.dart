import 'package:e_ration_seller/COMPONENTS/back_app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/drop_down.dart';
import 'package:e_ration_seller/COMPONENTS/order_product_card.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/seller_order_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  TextEditingController? _controller;
  List<DropdownMenuItem>? _status;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller!.text = widget.orderData!.status!;
    _status = [
      DropdownMenuItem(
        value: "Not Picked",
        child: Text('Not Picked'),
      ),
      DropdownMenuItem(
        value: "Picked",
        child: Text('Picked'),
      ),
    ];
    super.initState();
  }

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
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Order ID : ${widget.orderData!.orderId}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Order Placed : ${DateFormat('dd/MMM/yy, hh:mm').format(widget.orderData!.timestamp!)}',
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
                'Date : ${DateFormat('dd/MMM/yy').format(widget.orderData!.date!)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Time : ${widget.orderData!.time!}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            DropDown(
              label: "Order Status",
              initialValue: _controller!.text,
              items: _status,
              onChange: (value) async {
                _controller!.text = value;

                bool _result = await DatabaseManager.getInstance
                    .updateOrderStatus(
                        widget.orderData!.uid!, _controller!.text);

                if (_result)
                  Fluttertoast.showToast(
                    msg: 'Order Status Updated',
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                  );
                else
                  Fluttertoast.showToast(
                    msg: 'Error Occured',
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                  );
              },
            ),
            SizedBox(height: 15.0),
            OrderProductCard(
              productData: widget.orderData!.product!,
              // isClickable: false,
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
