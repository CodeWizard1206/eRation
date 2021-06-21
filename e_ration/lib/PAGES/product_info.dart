import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/back_app_bar.dart';
import 'package:e_ration/COMPONENTS/circle_picture.dart';
import 'package:e_ration/COMPONENTS/drop_down.dart';
import 'package:e_ration/COMPONENTS/icon_button.dart';
import 'package:e_ration/COMPONENTS/input_field.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductInfo extends StatefulWidget {
  final ProductModel product;
  ProductInfo({Key? key, required this.product}) : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  String? _currentFile;
  List<String>? _images;
  TextEditingController? _desc;
  final List<int> _rateStar = [1, 2, 3, 4, 5];

  @override
  void initState() {
    _desc = TextEditingController();

    _desc!.text = widget.product.description!;
    _images = this.widget.product.images;
    _currentFile = _images!.first;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                BackAppBar(title: ''),
                Builder(
                  builder: (context) => AnimatedContainer(
                    duration: Duration(
                      seconds: 1,
                    ),
                    height: _currentFile != null ? 400 : 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: _currentFile!,
                            height: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: _images!
                              .map((image) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentFile = image;
                                  });
                                },
                                                              child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CirclePicture(
                                    backgroundImage:
                                        CachedNetworkImageProvider(image),
                                  ),
                                ),
                              ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _rateStar
                            .map(
                              (star) => Icon(
                                _rateStar.indexOf(star) < (widget.product.rating!)
                                    ? FlutterIcons.star_faw
                                    : FlutterIcons.star_o_faw,
                                color: Theme.of(context).primaryColorDark,
                                // size: 
                              ),
                            )
                            .toList(),
                    ),
                      ),
                    SizedBox(height: 5.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Text(
                          widget.product.productName!,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:14.0),
                        child: Text(
                          widget.product.category!,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height:15.0),
                      InputField(
                        controller: _desc,
                        title: "Product Description",
                        maxLines: 100,
                        enabled: false,
                      ),
                      SizedBox(height:80.0),
                    ],
                  ),
                ),
              ],
            ),
            Material(
              elevation: 25.0,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Constant.cartItems.contains(widget.product) ? SizedBox() : Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Constant.cartItems.add(widget.product);
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15.0,),
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),),
                      color: Theme.of(context).primaryColorDark,
                      child: InkWell(
                        onTap: () {
                          if (Constant.cartItems.contains(widget.product)) {
                            setState(() {
                              Constant.cartItems.remove(widget.product);
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          height: 60.0,
                          width: Constant.cartItems.contains(widget.product) ? MediaQuery.of(context).size.width : null,
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 15),
                                Constant.cartItems.contains(widget.product)
                                  ? SizedBox()
                                  :Icon(FlutterIcons.rupee_sign_faw5s, color: Colors.white, size: 28,),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.bounceInOut,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    Constant.cartItems.contains(widget.product) ? 'Move to cart' : widget.product.price.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 15.0),
                                Icon(FlutterIcons.shopping_cart_faw5s,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
