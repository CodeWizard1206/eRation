import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/MODELS/category_model.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/PAGES/manage_product.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatelessWidget {
  final Function? moveToCart;
  const Home({
    Key? key,
    this.moveToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.maxFinite,
            child: Text(
              'Product Categories',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<List<CategoryModel>>(
            stream: FirebaseFirestore.instance
                .collection('productCategory')
                .snapshots()
                .map(
                  (event) =>
                      event.docs.map((e) => CategoryModel.fromDoc(e)).toList(),
                ),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.none) {
                if (snapshot.data != null) {
                  if (snapshot.data!.length > 0) {
                    var _data = snapshot.data;

                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        semanticChildCount: _data!.length,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 6.0,
                        childAspectRatio: 0.8,
                        children: _data
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.5,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: ManageProduct(
                                          category: e.category,
                                        ),
                                      ),
                                    ).then((value) =>
                                        value ? this.moveToCart!() : null);
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
                              ),
                            )
                            .toList(),
                      ),
                    );
                  } else
                    return Container();
                }
              }
              return AsyncLoader();
            },
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.maxFinite,
            child: Text(
              'Seller\'s Near You',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<List<String>>(
            stream: DatabaseManager.getInstance.getNearbySellers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.none) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: snapshot.data!
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 2.0,
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: ManageProduct(
                                          filtered: true,
                                          filterString: e,
                                        ),
                                      ),
                                    ).then((value) =>
                                        value ? this.moveToCart!() : null);
                                  },
                                  leading: Icon(
                                    FlutterIcons.user_faw5s,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  title: Text(e,
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                ),
                              ))
                          .toList(),
                    );
                  }
                }
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
