import 'package:e_ration/MODELS/product_model.dart';
import 'package:e_ration/PAGES/product_info.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.productData,
  }) : super(key: key);

  final List<int> _rateStar = [1, 2, 3, 4, 5];
  final ProductModel productData;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _rateStar
                          .map(
                            (star) => Icon(
                              _rateStar.indexOf(star) < (productData.rating!)
                                  ? FlutterIcons.star_faw
                                  : FlutterIcons.star_o_faw,
                              color: Theme.of(context).primaryColorDark,
                              // size: 
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: [
                        
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
                                child: ProductInfo(
                                  product: productData,
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
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(6.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  FlutterIcons.rupee_sign_faw5s,
                                  color: Colors.white,
                                ),
                                Text(productData.price.toString(), style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),),
                                SizedBox(width: 10.0),
                                Icon(
                                  FlutterIcons.arrow_right_faw5s,
                                  color: Colors.white,
                                ),
                              ],
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
