import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration_seller/COMPONENTS/async_loader.dart';
import 'package:e_ration_seller/COMPONENTS/back_app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/circle_picture.dart';
import 'package:e_ration_seller/COMPONENTS/drop_down.dart';
import 'package:e_ration_seller/COMPONENTS/icon_button.dart';
import 'package:e_ration_seller/COMPONENTS/input_field.dart';
import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/product_model.dart';
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
  TextEditingController? _name;
  TextEditingController? _desc;
  TextEditingController? _category;
  TextEditingController? _stock;
  TextEditingController? _price;

  List<DropdownMenuItem>? _categoryList;
  List<String>? _images;
  DatabaseManager? _db;

  bool? _isLoading;

  @override
  void initState() {
    _name = TextEditingController();
    _desc = TextEditingController();
    _category = TextEditingController();
    _stock = TextEditingController();
    _price = TextEditingController();

    _name!.text = this.widget.product.productName.toString();
    _desc!.text = this.widget.product.description.toString();
    _category!.text = this.widget.product.category.toString();
    _stock!.text = this.widget.product.stocks.toString();
    _price!.text = this.widget.product.price.toString();
    _images = this.widget.product.images;
    _categoryList = Constant.categoryList;
    _currentFile = _images!.first;

    _db = DatabaseManager.getInstance;

    super.initState();
  }

  void _deleteProduct() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.red,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                FlutterIcons.close_faw,
                size: 30.0,
                color: Colors.white,
              ),
              title: Text(
                "Remove Product",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // controller: _controller,
          children: [
            BackAppBar(title: 'Add Product'),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    controller: _name,
                    title: "Product Name",
                    maxLines: 5,
                    onFieldSubmitted: (value) async {
                      print(value);
                      bool _result = await _db!.updateProductData(
                        uid: this.widget.product.uid.toString(),
                        value: value,
                        fieldName: 'productName',
                      );

                      if (_result)
                        Fluttertoast.showToast(
                          msg: 'Product Name Updated',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                        );
                      else
                        Fluttertoast.showToast(
                          msg: 'Error Occured',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                        );
                    },
                  ),
                  InputField(
                    controller: _desc,
                    title: "Product Description",
                    maxLines: 100,
                    keyboardType: TextInputType.multiline,
                  ),
                  DropDown(
                    label: "Product Category",
                    initialValue: _category!.text,
                    items: _categoryList,
                    onChange: (value) {
                      if (value != 'NONE')
                        _category!.text = value;
                      else {
                        Fluttertoast.showToast(
                          msg: 'Invalid Option Selected',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: _stock,
                          title: "Stock",
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: InputField(
                          controller: _price,
                          title: "Price",
                          iconPlaceholder: true,
                          icon: FlutterIcons.rupee_sign_faw5s,
                        ),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) => IconButtonMaterial(
                      onPressed: this._deleteProduct,
                      icon: FlutterIcons.trash_alt_faw5s,
                      title: 'Delete Product',
                      fillColor: Colors.red,
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