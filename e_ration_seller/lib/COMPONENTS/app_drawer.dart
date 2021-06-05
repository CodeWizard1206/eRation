import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/drawer_item_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

List<DrawerItemModel> listItems = [
  DrawerItemModel(
    icon: FlutterIcons.google_analytics_mco,
    title: 'Dashboard',
    route: '/dashboard',
  ),
  DrawerItemModel(
    icon: FlutterIcons.store_mall_directory_mdi,
    title: 'Products',
    route: '/manage',
  ),
  DrawerItemModel(
    icon: FlutterIcons.shopping_cart_faw5s,
    title: 'Orders',
    route: '/orders',
  ),
  DrawerItemModel(
    icon: FlutterIcons.chat_mco,
    title: 'Queries',
    route: '/queries',
  ),
];

class AppDrawer extends StatelessWidget {
  final int? index;
  const AppDrawer({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: (MediaQuery.of(context).size.width * 0.8),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset('assets/images/app_logo.png'),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'eRation',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 55.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: ListView(
                children: listItems
                    .map(
                      (item) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: listItems.indexOf(item) == index
                              ? Border.all(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 2.0,
                                )
                              : null,
                        ),
                        child: ListTile(
                          leading: Icon(item.icon, color: Colors.black87),
                          title: Text(
                            item.title.toString(),
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(
                              context,
                              item.route.toString(),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: RawMaterialButton(
                onPressed: () {
                  DatabaseManager.getInstance.logoutUser();
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/');
                },
                fillColor: Theme.of(context).primaryColorDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: double.maxFinite,
                  child: Text(
                    'Log Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
