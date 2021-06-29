import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/MODELS/cart_model.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class CartItem extends StatelessWidget {
  final CartModel item;
  final void Function()? onPressed;
  const CartItem({
    Key? key,
    required this.item,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductModel productData = item.product;
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
                  imageUrl: productData.thumbUri.toString(),
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
                      productData.productName.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      productData.description.toString(),
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
                      child: SizedBox(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Price: ${this.item.qty * this.item.product.price!}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          constraints: BoxConstraints(
                            minWidth: 55.0,
                            minHeight: 40.0,
                          ),
                          onPressed: this.onPressed,
                          fillColor: Colors.red[500],
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(6.0),
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(6.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FlutterIcons.trash_faw5s,
                              color: Colors.white,
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
    );
  }
}
