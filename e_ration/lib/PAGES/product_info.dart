import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/back_app_bar.dart';
import 'package:e_ration/COMPONENTS/circle_picture.dart';
import 'package:e_ration/COMPONENTS/input_field.dart';
import 'package:e_ration/MODELS/cart_model.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: import_of_legacy_library_into_null_safe

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
  CartModel? _cart;
  final List<int> _rateStar = [1, 2, 3, 4, 5];
  final List<int> _qtyList = [1, 2, 3];

  @override
  void initState() {
    _desc = TextEditingController();

    _desc!.text = widget.product.description!;
    _images = this.widget.product.images;
    _currentFile = _images!.first;

    var cart = Constant.cartItems
        .where((element) => element.product == widget.product)
        .toList();

    if (cart.length > 0) {
      _cart = cart.first;
    } else {
      _cart = CartModel(
        product: widget.product,
        qty: 1,
      );
    }

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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _rateStar
                              .map(
                                (star) => Icon(
                                  _rateStar.indexOf(star) <
                                          (widget.product.rating!)
                                      ? FlutterIcons.star_faw
                                      : FlutterIcons.star_o_faw,
                                  color: Theme.of(context).primaryColorDark,
                                  // size:
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Text(
                          widget.product.category!,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      InputField(
                        controller: _desc,
                        title: "Product Description",
                        maxLines: 100,
                        enabled: false,
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Quantity',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _qtyList
                              .map(
                                (i) => Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  elevation: 5.0,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        width: i == _cart!.qty ? 2 : 0.0,
                                        color: i == _cart!.qty
                                            ? Theme.of(context)
                                                .primaryColorLight
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        setState(() => _cart!.qty = i);
                                      },
                                      splashColor: Colors.transparent,
                                      child: Text(
                                        i.toString(),
                                        style: TextStyle(
                                          fontWeight: i == _cart!.qty
                                              ? FontWeight.bold
                                              : null,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 100.0),
                    ],
                  ),
                ),
              ],
            ),
            Material(
              elevation: 25.0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
              ),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _cart!.added
                        ? SizedBox()
                        : Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _cart!.added = true;
                                  Constant.cartItems.add(_cart!);
                                });
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                      ),
                      color: Theme.of(context).primaryColorDark,
                      child: InkWell(
                        onTap: () {
                          if (_cart!.added) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          height: 60.0,
                          width: _cart!.added
                              ? MediaQuery.of(context).size.width
                              : null,
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(width: 15),
                              _cart!.added
                                  ? SizedBox()
                                  : Icon(
                                      FlutterIcons.rupee_sign_faw5s,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.bounceInOut,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                  color: Colors.white,
                                ),
                                child: Text(
                                  _cart!.added
                                      ? 'Move to cart'
                                      : widget.product.price.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Icon(
                                FlutterIcons.shopping_cart_faw5s,
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
