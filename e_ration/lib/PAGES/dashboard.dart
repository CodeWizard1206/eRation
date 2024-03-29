import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_ration/COMPONENTS/circle_picture.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/PAGES/home.dart';
import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:e_ration/PAGES/my_cart.dart';
import 'package:e_ration/PAGES/my_orders.dart';
import 'package:e_ration/PAGES/profile_view.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  List<Widget>? _widgetList;

  @override
  void initState() {
    _widgetList = [
      Home(
        moveToCart: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      MyCart(),
      MyOrders(),
      ProfileView(),
    ];
    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(
          title: 'eRation',
          moveToCart: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: _widgetList!.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        elevation: 50.0,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: BottomNavigationBar(
            onTap: (index) => _onItemTap(index),
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'My Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'My Orders',
              ),
              BottomNavigationBarItem(
                icon: CirclePicture(
                  isProfile: true,
                  backgroundImage: (Constant.getUser.profile != null)
                      ? CachedNetworkImageProvider(
                          Constant.getUser.profile.toString(),
                        )
                      : AssetImage('assets/images/user.png') as ImageProvider,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
