import 'package:e_ration/COMPONENTS/cart_item.dart';
import 'package:e_ration/COMPONENTS/no_data.dart';
import 'package:e_ration/MODELS/cart_model.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyCart extends StatefulWidget {
  MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    int sum = 0;
    for (CartModel i in Constant.cartItems) {
      sum += (i.product.price! * i.qty);
    }
    return Container(
      height: double.maxFinite,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Constant.cartItems.length > 0
              ? ListView(
                  children: [
                    Column(
                      children: Constant.cartItems
                          .map(
                            (item) => CartItem(
                              item: item,
                              onPressed: () {
                                setState(() {
                                  Constant.cartItems.remove(item);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    Container(
                      height: 80,
                      color: Colors.transparent,
                    ),
                  ],
                )
              : NoData(
                  message: 'No item in cart!',
                  icon: FlutterIcons.shopping_cart_faw,
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            padding: const EdgeInsets.all(10.0),
            child: RawMaterialButton(
              onPressed: () {},
              fillColor: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                width: double.maxFinite,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total:   ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      FlutterIcons.rupee_sign_faw5s,
                      size: 28,
                      color: Colors.white,
                    ),
                    Text(
                      '$sum',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
