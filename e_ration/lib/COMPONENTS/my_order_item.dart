import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/MODELS/order_model.dart';
import 'package:e_ration/PAGES/my_order_details.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class MyOrderItem extends StatelessWidget {
  final OrderModel item;
  final void Function()? onPressed;
  const MyOrderItem({
    Key? key,
    required this.item,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = '';
    for (int i = 0; i < item.products!.length && i < 3; ++i) {
      title += (item.products![i].productName);
      if (i != item.products!.length - 1 && i != 2) title += ', ';
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MyOrderDetails(
                item: item,
              ),
            ),
          );
        },
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
                    imageUrl: item.products!.first.thumbUri.toString(),
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
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Scheduled Pick @ ${DateFormat('dd/MMM/yy').format(item.date!)}\nBetween ${item.time}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          DateFormat('dd - MMM - yy, hh:mm ')
                              .format(item.timestamp!),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(FlutterIcons.rupee_sign_faw5s),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${this.item.totalAmount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
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
      ),
    );
  }
}
