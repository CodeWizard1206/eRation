import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/MODELS/category_model.dart';
import 'package:e_ration/PAGES/manage_product.dart';
import 'package:flutter/material.dart';
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
      child: Column(
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

                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
          ),
        ],
      ),
    );
  }
}
