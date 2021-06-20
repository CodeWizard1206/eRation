import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/circle_picture.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/PAGES/profile_view.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool isBackNeeded;
  const CustomAppBar({Key? key, this.title, this.isBackNeeded = false})
      : super(key: key);

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
                  if (this.isBackNeeded)
                    Navigator.pop(context);
                  else
                    Scaffold.of(context).openDrawer();
                },
                fillColor: Theme.of(context).primaryColorDark,
                splashColor: Theme.of(context).primaryColorLight,
                shape: CircleBorder(),
                child: Padding(
                  padding: this.isBackNeeded
                      ? const EdgeInsets.all(8.0)
                      : const EdgeInsets.all(12.0),
                  child: Icon(
                    this.isBackNeeded
                        ? FlutterIcons.arrow_left_faw5s
                        : FlutterIcons.search_faw5s,
                    color: Colors.white,
                    size: this.isBackNeeded ? 32 : 24,
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
                    backgroundImage: (Constant.getUser.profile != null)
                        ? CachedNetworkImageProvider(
                            Constant.getUser.profile.toString(),
                          )
                        : AssetImage('assets/images/user.png') as ImageProvider,
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
