import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration_seller/COMPONENTS/circle_picture.dart';
import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/PAGES/profile_view.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  const CustomAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RawMaterialButton(
                elevation: 2.0,
                constraints: BoxConstraints(
                  minHeight: 0,
                  minWidth: 0,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                fillColor: Theme.of(context).primaryColorDark,
                splashColor: Theme.of(context).primaryColorLight,
                shape: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FlutterIcons.menu_open_mco,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              Text(
                this.title.toString(),
                style: TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProfileView(),
                    ),
                  );
                },
                child: Hero(
                  tag: 'ProfileViewer',
                  child: CirclePicture(
                    backgroundImage: CachedNetworkImageProvider(
                      Constant.getUser.profile.toString(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
