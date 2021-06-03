import 'dart:io';

import 'package:e_ration_seller/COMPONENTS/back_app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/drop_down.dart';
import 'package:e_ration_seller/COMPONENTS/icon_button.dart';
import 'package:e_ration_seller/COMPONENTS/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? currentFile;
  TextEditingController? _name;
  TextEditingController? _desc;
  TextEditingController? _category;

  List<DropdownMenuItem>? _categoryList;

  @override
  void initState() {
    _name = TextEditingController();
    _desc = TextEditingController();
    _category = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // controller: _controller,
          children: [
            BackAppBar(title: 'Add Product'),
            AnimatedContainer(
              duration: Duration(
                seconds: 1,
              ),
              height: currentFile != null ? 400 : 75,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
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
