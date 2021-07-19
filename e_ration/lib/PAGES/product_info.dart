import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/back_app_bar.dart';
import 'package:e_ration/COMPONENTS/circle_picture.dart';
import 'package:e_ration/COMPONENTS/input_field.dart';
import 'package:e_ration/COMPONENTS/query_box.dart';
import 'package:e_ration/MODELS/cart_model.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:e_ration/MODELS/query_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  TextEditingController? _qty;
  final List<int> _rateStar = [1, 2, 3, 4, 5];

  @override
  void initState() {
    _desc = TextEditingController();
    _qty = TextEditingController();

    _desc!.text = widget.product.description!;
    _qty!.text = '0';
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
                      StreamBuilder<int>(
                          stream: DatabaseManager.getInstance
                              .getStockUpdate(widget.product.uid!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.none) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: InputField(
                                        controller: _qty,
                                        title: "Quatity (in KGs)",
                                        maxLines: 1,
                                        enabled: true,
                                        keyboardType: TextInputType.number,
                                        onChange: (value) {
                                          if (int.parse(value) <=
                                              snapshot.data!) {
                                            this.widget.product.qty =
                                                int.parse(value);
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: 'Invalid Value Entered!!!',
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black87,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      '/ ${snapshot.data} KG\'s',
                                      style: TextStyle(
                                        fontSize: 28.0,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InputField(
                                    controller: _qty,
                                    title: "Quatity (in KGs)",
                                    maxLines: 1,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  '/ 0 KG\'s',
                                  style: TextStyle(
                                    fontSize: 28.0,
                                  ),
                                ),
                              ],
                            );
                          }),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'Customer Queries',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: RawMaterialButton(
                          onPressed: () {
                            TextEditingController _controller =
                                TextEditingController();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: Text(
                                  'Ask Query...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: TextFormField(
                                  autofocus: true,
                                  controller: _controller,
                                  cursorColor:
                                      Theme.of(context).primaryColorLight,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.7,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.5,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(_).pop();
                                    },
                                    child: Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (_controller.text.isNotEmpty) {
                                        QueryModel query = QueryModel(
                                          question: _controller.text,
                                          askedBy: Constant.getUser.name,
                                          timestamp: DateTime.now(),
                                        );

                                        bool _result = await DatabaseManager
                                            .getInstance
                                            .askQuery(
                                                widget.product.uid!, query);

                                        if (_result) {
                                          Navigator.of(_).pop();
                                          Fluttertoast.showToast(
                                            msg: 'Query Asked',
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black87,
                                          );
                                        } else
                                          Fluttertoast.showToast(
                                            msg: 'Error Occured',
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black87,
                                          );
                                      }
                                    },
                                    child: Text(
                                      'Ask',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          splashColor: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Ask Query',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      FutureBuilder<List<QueryModel>>(
                        future: DatabaseManager.getInstance
                            .getQueries(widget.product.uid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: snapshot.data!
                                    .map((query) => QueryBox(
                                          query: query,
                                        ))
                                    .toList(),
                              );
                            }
                          }

                          return SizedBox();
                        },
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
