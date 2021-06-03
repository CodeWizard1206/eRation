import 'dart:io';
import 'package:e_ration_seller/COMPONENTS/back_app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/circle_picture.dart';
import 'package:e_ration_seller/COMPONENTS/drop_down.dart';
import 'package:e_ration_seller/COMPONENTS/icon_button.dart';
import 'package:e_ration_seller/COMPONENTS/input_field.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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

  List<DropdownMenuItem>? _categoryList;
  List<File>? _images;

  @override
  void initState() {
    _name = TextEditingController();
    _desc = TextEditingController();
    _category = TextEditingController();

    _images = [];
    _categoryList = [
      DropdownMenuItem(
        value: "NONE",
        child: Text('SELECT A CATEGORY'),
      ),
      DropdownMenuItem(
        value: "RICE",
        child: Text('RICE'),
      ),
    ];

    _category!.text = "NONE";
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

    setState(() {
      _currentFile = croppedFile;
      _images!.add(croppedFile!);
    });
  }

  void _selectImage(BuildContext context) {
    if (_images!.length < 3) {
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
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        // padding: const EdgeInsets.all(8.0),
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
                if (_images!.length == 1) {
                  setState(() {
                    _images!.remove(image);
                    _currentFile = null;
                  });
                } else {
                  setState(() {
                    _images!.remove(image);
                    _currentFile = _images![0];
                  });
                }
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
                                children: _images!
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
                                              backgroundImage: FileImage(image),
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
                          controller: _desc,
                          title: "Stock",
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: InputField(
                          controller: _desc,
                          title: "Price",
                        ),
                      ),
                    ],
                  ),
                  IconButtonMaterial(
                    onPressed: () {},
                    icon: FlutterIcons.plus_faw5s,
                    title: 'Add Product',
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
