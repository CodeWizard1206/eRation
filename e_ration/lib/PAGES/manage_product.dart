import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/no_data.dart';
import 'package:e_ration/COMPONENTS/product_card.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class ManageProduct extends StatefulWidget {
  final String? category;
  final String? search;
  ManageProduct({
    Key? key,
    this.category,
    this.search,
  }) : super(key: key);

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  Set<String> _storeList = {};
  bool _filtered = false;
  String? _filteredString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(
          title: this.widget.category != null
              ? this.widget.category
              : 'Search Results',
          isBackNeeded: true,
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
          stream: this.widget.category != null
              ? DatabaseManager.getInstance
                  .getProductsWhereCategory(this.widget.category!)
              : DatabaseManager.getInstance.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none) {
              if (snapshot.data != null) {
                List<ProductModel> _data;
                if (this.widget.category != null) {
                  _data = snapshot.data!
                      .where(
                        (element) =>
                            element.sellerArea == Constant.getUser.area &&
                            element.stocks! > 0,
                      )
                      .toList();
                } else {
                  _data = snapshot.data!
                      .where(
                        (element) => (element.sellerArea ==
                                Constant.getUser.area &&
                            element.stocks! > 0 &&
                            (element.productName!.toLowerCase().contains(
                                    this.widget.search!.toLowerCase()) ||
                                element.category!.toLowerCase().contains(
                                    this.widget.search!.toLowerCase()) ||
                                element.description!.toLowerCase().contains(
                                    this.widget.search!.toLowerCase()))),
                      )
                      .toList();
                }

                _storeList.clear();
                _storeList = {'Select None'};
                _data.forEach((element) {
                  _storeList.add(element.sellerName!);
                });

                if (_filtered) {
                  _data = _data
                      .where((element) => element.sellerName == _filteredString)
                      .toList();

                  print(_filtered);
                }
                if (_data.length > 0) {
                  return ListView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _data
                            .map(
                              (e) => ProductCard(
                                productData: e,
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  );
                } else {
                  return NoData(
                    message: 'No product to show!!!',
                    icon: FlutterIcons.store_mall_directory_mdi,
                  );
                }
              }
            }

            return Center(
              child: AsyncLoader(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blueGrey[100],
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: SizedBox(),
                  height: 5.0,
                  width: 30.0,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select a Store',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: _storeList
                        .map(
                          (e) => ListTile(
                            onTap: () {
                              if (e == 'Select None') {
                                setState(() {
                                  _filtered = false;
                                });
                              } else {
                                setState(() {
                                  _filteredString = e;
                                  _filtered = true;
                                });
                              }
                              Navigator.of(_).pop();
                            },
                            title: Text(
                              e,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
        child: Icon(
          FlutterIcons.filter_faw5s,
          color: Colors.white,
        ),
      ),
    );
  }
}
