import 'dart:io';
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
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? _currentFile;
  TextEditingController? _name;
  TextEditingController? _desc;
  TextEditingController? _category;
  TextEditingController? _stock;
  TextEditingController? _price;

  List<DropdownMenuItem>? _categoryList;
  List<File> _images = [];

  bool? _isLoading;

  @override
  void initState() {
    _name = TextEditingController();
    _desc = TextEditingController();
    _category = TextEditingController();
    _stock = TextEditingController();
    _price = TextEditingController();

    _categoryList = Constant.categoryList;

    _category!.text = "NONE";
    _stock!.text = "1";
    _price!.text = "10";

    _isLoading = false;
    super.initState();
  }

  Future<void> addProductImage(String srcPath) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: srcPath,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).primaryColorDark,
          activeControlsWidgetColor: Theme.of(context).primaryColorDark,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    if (croppedFile != null)
      setState(() {
        _currentFile = croppedFile;
        _images.add(_currentFile!);
      });
  }

  void _selectImage(BuildContext context) {
    if (_images.length < 3) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take Picture"),
                onTap: () async {
                  PickedFile? file =
                      await ImagePicker().getImage(source: ImageSource.camera);
                  if (file != null) {
                    Navigator.of(_).pop();
                    await addProductImage(file.path);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Upload from Gallery"),
                onTap: () async {
                  PickedFile? file =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  if (file != null) {
                    Navigator.of(_).pop();
                    await addProductImage(file.path);
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Only 3 product images are allowed!!!"),
        ),
      );
    }
  }

  void onLongPress(BuildContext context, File? image) {
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
                "Remove Image",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                if (_images.length == 1) {
                  setState(() {
                    _images.remove(image);
                    _currentFile = null;
                  });
                } else {
                  setState(() {
                    _images.remove(image);
                    _currentFile = _images[0];
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> addProduct(BuildContext context) async {
    if (_currentFile != null) {
      if (_name!.text.isNotEmpty &&
          _category!.text.isNotEmpty &&
          _desc!.text.isNotEmpty &&
          _stock!.text.isNotEmpty &&
          _price!.text.isNotEmpty) {
        int stock = int.parse(_stock!.text);
        int price = int.parse(_price!.text);
        if (stock > 0 && price > 0) {
          setState(() {
            this._isLoading = true;
          });
          ProductModel _product = ProductModel(
            sellerId: Constant.getUser.uid,
            sellerName: Constant.getUser.shopName,
            sellerArea: Constant.getUser.area,
            sellerCity: Constant.getUser.city,
            productName: _name!.text,
            category: _category!.text,
            description: _desc!.text,
            stocks: stock,
            price: price,
            timestamp: DateTime.now(),
          );

          bool _result = await DatabaseManager.getInstance
              .addProductToDB(_product, _images);

          setState(() {
            this._isLoading = false;
          });
          if (_result) {
            return _result;
          } else {
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Error adding product!!!"),
              ),
            );
            return false;
          }
        } else {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Stock and Price can't be 0!!!"),
            ),
          );
          return false;
        }
      } else {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("All fields are required!!!"),
          ),
        );
        return false;
      }
    } else {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("At least 1 image is requred!!!"),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: this._isLoading,
        opacity: 0.8,
        progressIndicator: AsyncLoader(),
        child: SafeArea(
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
                  child: _currentFile != null
                      ? Column(
                          children: [
                            Expanded(
                              child: Image.file(
                                _currentFile!,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _images
                                      .map((image) => GestureDetector(
                                            onLongPress: () =>
                                                onLongPress(context, image),
                                            onTap: () {
                                              setState(() {
                                                _currentFile = image;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: CirclePicture(
                                                backgroundImage:
                                                    FileImage(image),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                FloatingActionButton(
                                  elevation: 0.0,
                                  onPressed: () => this._selectImage(context),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : FloatingActionButton(
                          onPressed: () => this._selectImage(context),
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
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
                    ),
                    InputField(
                      controller: _desc,
                      title: "Product Description",
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                    ),
                    DropDown(
                      label: "Product Category",
                      initialValue: _category!.text,
                      items: _categoryList,
                      onChange: (value) {
                        _category!.text = value;
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
                        onPressed: () async {
                          bool _result = await addProduct(context);
                          if (_result) {
                            Navigator.pop(context, _result);
                          }
                        },
                        icon: FlutterIcons.plus_faw5s,
                        title: 'Add Product',
                      ),
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
