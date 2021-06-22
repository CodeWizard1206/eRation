import 'package:e_ration/PAGES/home.dart';
import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:e_ration/COMPONENTS/app_drawer.dart';
import 'package:flutter/material.dart';

import 'my_cart.dart';

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
      Text('My Orders'),
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
            ],
          ),
        ),
      ),
    );
  }
}
