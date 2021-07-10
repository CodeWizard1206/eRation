import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/product_model.dart';
import 'package:e_ration_seller/MODELS/query_model.dart';
import 'package:e_ration_seller/PAGES/product_queries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductQueryBox extends StatefulWidget {
  final ProductModel? product;
  ProductQueryBox({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  _ProductQueryBoxState createState() => _ProductQueryBoxState();
}

class _ProductQueryBoxState extends State<ProductQueryBox> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryModel>>(
      stream: DatabaseManager.getInstance.getQuery(widget.product!.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.none) {
          if (snapshot.hasData) {
            List<QueryModel> _list = snapshot.data!;

            if (_list.length > 0) {
              bool _isNew = false;

              _list.forEach((element) {
                if (element.answer == null) {
                  _isNew = true;
                }
              });

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductQueries(uid: widget.product!.uid),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.product!.thumbUri!),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              width: double.maxFinite,
                              child: Text(
                                widget.product!.productName!,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              width: double.maxFinite,
                              child: Text(
                                _list.first.question!,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: _isNew
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              width: double.maxFinite,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('dd/MMM/yy - hh:mm')
                                        .format(_list.first.timestamp!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        }
        return SizedBox();
      },
    );
  }
}
