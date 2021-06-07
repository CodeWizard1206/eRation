import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/input_field.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/MODELS/user_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController? _name;
  TextEditingController? _email;
  TextEditingController? _contact;
  TextEditingController? _pass;
  TextEditingController? _dobController;
  TextEditingController? _address;
  TextEditingController? _area;
  TextEditingController? _city;
  TextEditingController? _state;

  TextEditingController? _gender;

  File? _image;
  bool? _isLoading;
  bool? _isEditable;
  String? _profileUri;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _contact = TextEditingController();
    _pass = TextEditingController();
    _dobController = TextEditingController();
    _address = TextEditingController();
    _area = TextEditingController();
    _city = TextEditingController();
    _state = TextEditingController();
    _gender = TextEditingController();

    _name!.text = Constant.getUser.name.toString();
    _contact!.text = Constant.getUser.contact.toString();
    _email!.text = Constant.getUser.email.toString();
    _pass!.text = Constant.getUser.pass.toString();
    _address!.text = Constant.getUser.address.toString();
    _area!.text = Constant.getUser.area.toString();
    _city!.text = Constant.getUser.city.toString();
    _state!.text = Constant.getUser.state.toString();
    _gender!.text = Constant.getUser.gender.toString();
    _dobController!.text =
        DateFormat("dd MMM yy").format(Constant.getUser.dob!);

    _isLoading = false;
    _isEditable = false;
    _profileUri = Constant.getUser.profile;

    super.initState();
  }

  Future<void> _cropImage(String srcPath) async {
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

    if (croppedFile != null) {
      setState(() {
        _isLoading = true;
        _image = croppedFile;
      });
      String _uri =
          await DatabaseManager.getInstance.updateProfileImage(_image!);
      if (_uri != 'none') {
        setState(() {
          _profileUri = _uri;
          Constant.getUser.profile = _uri;
          _image = null;
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
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
            (_profileUri != null)
                ? ListTile(
                    leading: Icon(Icons.close),
                    title: Text("Remove Image"),
                    onTap: () {
                      DatabaseManager.getInstance.deleteProfileImage();
                      setState(() {
                        _profileUri = null;
                        Constant.getUser.profile = null;
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
                  await _cropImage(file.path);
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
                  await _cropImage(file.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeEdits(BuildContext context) async {
    if (_name!.text.isNotEmpty &&
        _email!.text.isNotEmpty &&
        _contact!.text.isNotEmpty &&
        _pass!.text.isNotEmpty &&
        _address!.text.isNotEmpty &&
        _area!.text.isNotEmpty &&
        _city!.text.isNotEmpty &&
        _state!.text.isNotEmpty) {
      if (_name!.text != Constant.getUser.name ||
          _email!.text != Constant.getUser.email ||
          _contact!.text != Constant.getUser.contact ||
          _pass!.text != Constant.getUser.pass ||
          _address!.text != Constant.getUser.address ||
          _area!.text != Constant.getUser.area ||
          _city!.text != Constant.getUser.city ||
          _state!.text != Constant.getUser.state) {
        if (_contact!.text.length == 10) {
          if (_pass!.text.length >= 8) {
            setState(() {
              this._isLoading = true;
            });
            UserModel _user = UserModel(
              uid: Constant.getUser.uid,
              name: _name!.text,
              email: _email!.text,
              contact: _contact!.text,
              pass: _pass!.text,
              gender: Constant.getUser.gender,
              profile: Constant.getUser.profile,
              address: _address!.text,
              city: _city!.text,
              area: _area!.text,
              state: _state!.text,
              dob: Constant.getUser.dob,
            );

            DatabaseManager _db = DatabaseManager.getInstance;
            bool _result = await _db.updateProfile(
                _user,
                _email!.text != Constant.getUser.email,
                _pass!.text != Constant.getUser.pass);

            setState(() {
              this._isLoading = false;
            });
            if (_result) {
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Profile Updated Successfully"),
                ),
              );
            } else {
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error Occured"),
                ),
              );
            }
          } else {
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Password should be atleast 8 Characters Long!!!"),
              ),
            );
          }
        } else {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Mobile Number should be 10 Numeric Digits Long!!!"),
            ),
          );
        }
      }
    } else {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("All Fields are Required!!!"),
        ),
      );
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      fillColor: Theme.of(context).primaryColorDark,
                      splashColor: Theme.of(context).primaryColorLight,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Hero(
                        tag: 'ProfileViewer',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(120),
                            border: Border.all(
                                color: Theme.of(context).primaryColorLight,
                                width: 2),
                          ),
                          padding: const EdgeInsets.all(3.0),
                          child: CircleAvatar(
                            radius: (MediaQuery.of(context).size.width * 0.3),
                            backgroundColor: Colors.transparent,
                            backgroundImage: null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      scale: 1.0,
                                      fit: BoxFit.contain,
                                    )
                                  : _profileUri != null
                                      ? CachedNetworkImage(
                                          imageUrl: _profileUri.toString(),
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          'assets/images/user.png',
                                          scale: 1.0,
                                          fit: BoxFit.contain,
                                        ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          _setImage(context);
                        },
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputField(
                      controller: _name,
                      title: "Name",
                      enabled: _isEditable!,
                    ),
                    InputField(
                      controller: _email,
                      title: "Email",
                      keyboardType: TextInputType.emailAddress,
                      enabled: _isEditable!,
                    ),
                    InputField(
                      controller: _contact,
                      title: "Contact",
                      keyboardType: TextInputType.phone,
                      enabled: _isEditable!,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            controller: _dobController,
                            title: "Date of Birth",
                            enabled: false,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Expanded(
                          child: InputField(
                            controller: _gender,
                            title: "Gender",
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      controller: _address,
                      title: "Address",
                      maxLines: 5,
                      enabled: _isEditable!,
                    ),
                    InputField(
                      controller: _area,
                      title: "Area",
                      textCapitalization: TextCapitalization.characters,
                      enabled: _isEditable!,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            controller: _city,
                            title: "City",
                            textCapitalization: TextCapitalization.characters,
                            enabled: _isEditable!,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Expanded(
                          child: InputField(
                            controller: _state,
                            title: "State",
                            textCapitalization: TextCapitalization.characters,
                            enabled: _isEditable!,
                          ),
                        ),
                      ],
                    ),
                    _isEditable!
                        ? InputField(
                            controller: _pass,
                            title: "Password",
                            obscureText: true,
                            visibilityToggle: true,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            if (_isEditable!) await _makeEdits(context);
            setState(() {
              _isEditable = !_isEditable!;
            });
          },
          child: Icon(
            _isEditable! ? FlutterIcons.check_faw5s : FlutterIcons.edit_faw5s,
          ),
          heroTag: 'button',
        ),
      ),
    );
  }
}
