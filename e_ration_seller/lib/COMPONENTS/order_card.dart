import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration_seller/MODELS/seller_order_model.dart';
import 'package:e_ration_seller/PAGES/order_detail.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class OrderCard extends StatelessWidget {
  final SellerOrderModel? orderData;
  const OrderCard({
    Key? key,
    this.orderData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CachedNetworkImage(
                  imageUrl: orderData!.product!.thumbUri.toString(),
                  height: double.maxFinite,
                  width: double.maxFinite,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderData!.product!.productName.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${orderData!.name}\n${orderData!.contact}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${DateFormat('dd/MMM/yy').format(orderData!.date!)} -> ${orderData!.time}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Text(
                          DateTime(
                                    orderData!.timestamp!.year,
                                    orderData!.timestamp!.month,
                                    orderData!.timestamp!.day,
                                  ) ==
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  )
                              ? 'Today'
                              : DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                      )
                                          .difference(DateTime(
                                            orderData!.timestamp!.year,
                                            orderData!.timestamp!.month,
                                            orderData!.timestamp!.day,
                                          ))
                                          .inDays ==
                                      1
                                  ? 'Yesterday'
                                  : '${DateFormat('dd/MMM/yy').format(orderData!.timestamp!)}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        RawMaterialButton(
                          constraints: BoxConstraints(
                            minWidth: 55.0,
                            minHeight: 40.0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: OrderDetail(
                                  orderData: orderData,
                                ),
                              ),
                            );
                          },
                          fillColor: Theme.of(context).primaryColorDark,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0),
                            ),
                          ),
                          child: Icon(
                            FlutterIcons.arrow_right_faw5s,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
