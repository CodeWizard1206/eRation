import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/circle_picture.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/PAGES/manage_product.dart';
import 'package:e_ration/PAGES/profile_view.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class CustomAppBar extends StatefulWidget {
  final String? title;
  final bool isBackNeeded;
  final Function? moveToCart;
  CustomAppBar({
    Key? key,
    this.title,
    this.moveToCart,
    this.isBackNeeded = false,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: AnimatedContainer(
          width: MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: 500),
          padding: const EdgeInsets.all(8.0),
          child: this._isSearching
              ? SearchBar(
                  controller: _controller,
                  onBackPress: () {
                    setState(() {
                      this._isSearching = false;
                      this._controller.text = '';
                    });
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RawMaterialButton(
                      elevation: 2.0,
                      constraints: BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      onPressed: () {
                        if (this.widget.isBackNeeded)
                          Navigator.pop(context);
                        else
                          setState(() {
                            _isSearching = true;
                            _controller.text = '';
                          });
                      },
                      fillColor: Theme.of(context).primaryColorDark,
                      splashColor: Theme.of(context).primaryColorLight,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: this.widget.isBackNeeded
                            ? const EdgeInsets.all(8.0)
                            : const EdgeInsets.all(12.0),
                        child: Icon(
                          this.widget.isBackNeeded
                              ? FlutterIcons.arrow_left_faw5s
                              : FlutterIcons.search_faw5s,
                          color: Colors.white,
                          size: this.widget.isBackNeeded ? 32 : 24,
                        ),
                      ),
                    ),
                    Text(
                      this.widget.title.toString(),
                      style: TextStyle(
                        fontSize: 42.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 25.0),
                  ],
                ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function? moveToCart;
  final TextEditingController? controller;
  final void Function()? onBackPress;
  const SearchBar({
    Key? key,
    this.onBackPress,
    this.moveToCart,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: this.onBackPress!,
        child: Icon(
          FlutterIcons.arrow_left_faw5s,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              if (controller!.text.isNotEmpty) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ManageProduct(
                      search: controller!.text,
                    ),
                  ),
                ).then((value) => value ? this.moveToCart!() : null);
              }
            },
          ),
        ),
      ),
    ]);
  }
}
