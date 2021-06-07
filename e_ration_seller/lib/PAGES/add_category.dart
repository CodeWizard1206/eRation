import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration_seller/COMPONENTS/async_loader.dart';
import 'package:e_ration_seller/COMPONENTS/icon_button.dart';
import 'package:e_ration_seller/COMPONENTS/input_field.dart';
import 'package:e_ration_seller/MODELS/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddCategory extends StatefulWidget {
  AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File? _image;
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();

  Future<File?> _cropImage(String srcPath) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: srcPath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).primaryColorDark,
            activeControlsWidgetColor: Theme.of(context).primaryColorDark,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));

    return croppedFile;
  }

  Future _setImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _image != null
                ? ListTile(
                    leading: Icon(Icons.close),
                    title: Text("Remove Image"),
                    onTap: () {
                      setState(() {
                        _image = null;
                      });
                      Navigator.of(_).pop();
                    },
                  )
                : SizedBox(),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Picture"),
              onTap: () async {
                PickedFile? file =
                    await ImagePicker().getImage(source: ImageSource.camera);
                if (file != null) {
                  Navigator.of(_).pop();
                  File? _temp = await _cropImage(file.path);
                  if (_temp != null) {
                    setState(() {
                      _image = _temp;
                    });
                  }
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
                  File? _temp = await _cropImage(file.path);
                  if (_temp != null) {
                    setState(() {
                      _image = _temp;
                    });
                  }
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
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 0.8,
        progressIndicator: AsyncLoader(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 185,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                _setImage(context);
                              },
                              child: Container(
                                // color: Colors.red,
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                        height: double.maxFinite,
                                      )
                                    : Image.asset('assets/images/user.png'),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Expanded(
                            flex: 5,
                            child: InputField(
                              controller: _controller,
                              title: "Category Name",
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButtonMaterial(
                      onPressed: () async {
                        if (_image != null && _controller.text.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            var _firestore = FirebaseFirestore.instance;

                            var _doc = await _firestore
                                .collection('productCategory')
                                .add({
                              'category': _controller.text,
                              'timestamp': DateTime.now(),
                            });

                            var _store = FirebaseStorage.instance;

                            UploadTask _task = _store
                                .ref('categoryImages/${_doc.id}.jpg')
                                .putFile(_image!);

                            await _task.whenComplete(() => null);

                            String _link = await _store
                                .ref('categoryImages/${_doc.id}.jpg')
                                .getDownloadURL();

                            _firestore
                                .collection('productCategory')
                                .doc(_doc.id)
                                .update({
                              'imageUri': _link,
                            });
                            _controller.text = '';
                            setState(() {
                              _image = null;
                              _isLoading = false;
                            });
                          } catch (e) {
                            print(e.toString());
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      icon: FlutterIcons.plus_faw5s,
                      title: 'Add Category',
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<CategoryModel>>(
                  stream: FirebaseFirestore.instance
                      .collection('productCategory')
                      .snapshots()
                      .map(
                        (event) => event.docs
                            .map((e) => CategoryModel.fromDoc(e))
                            .toList(),
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.none) {
                      if (snapshot.data != null) {
                        if (snapshot.data!.length > 0) {
                          var _data = snapshot.data;

                          return GridView.count(
                            crossAxisCount: 3,
                            semanticChildCount: _data!.length,
                            mainAxisSpacing: 2.0,
                            crossAxisSpacing: 2.0,
                            children: _data
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
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
                                                  "Remove Category",
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  FirebaseStorage.instance
                                                      .ref(
                                                          'categoryImages/${e.uid}.jpg')
                                                      .delete();
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'productCategory')
                                                      .doc(e.uid)
                                                      .delete();
                                                  Navigator.of(_).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: CachedNetworkImage(
                                            imageUrl: e.imageUri!,
                                          ),
                                        ),
                                        Text(
                                          e.category!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        } else
                          return Container();
                      }
                    }
                    return AsyncLoader();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
