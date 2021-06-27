import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/drop_down.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DateTimeScheduler extends StatefulWidget {
  DateTimeScheduler({Key? key}) : super(key: key);

  @override
  _DateTimeSchedulerState createState() => _DateTimeSchedulerState();
}

class _DateTimeSchedulerState extends State<DateTimeScheduler> {
  List<DropdownMenuItem<String>>? _times;
  List<TextEditingController>? _controllers;
  bool isLoading = false;

  @override
  void initState() {
    _times = [
      DropdownMenuItem(
        child: Text('Select a option'),
        value: '',
      ),
      DropdownMenuItem(
        child: Text('10 - 12'),
        value: '10 - 12',
      ),
      DropdownMenuItem(
        child: Text('12 - 02'),
        value: '12 - 02',
      ),
      DropdownMenuItem(
        child: Text('02 - 04'),
        value: '02 - 04',
      ),
      DropdownMenuItem(
        child: Text('04 - 06'),
        value: '04 - 06',
      ),
    ];

    _controllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];

    _controllers![0].text = '';
    _controllers![1].text = '';
    _controllers![2].text = '';
    _controllers![3].text = '';
    _controllers![4].text = '';
    _controllers![5].text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> _dates = [];
    var date = DateTime.now();
    if (date.hour > 17) date = date.add(Duration(hours: 8));

    for (int i = 0; i < 6; ++i) {
      if (date.weekday >= 1 && date.weekday < 7) {
        _dates.add(date);
        date = date.add(
          Duration(days: 1),
        );
      } else {
        date = date.add(
          Duration(days: 1),
        );
        --i;
      }
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(
          title: 'Select Slot',
          isBackNeeded: true,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: this.isLoading,
        progressIndicator: AsyncLoader(),
        child: Container(
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: _dates
                    .map(
                      (date) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${DateFormat('EEEE').format(date)} - ${DateFormat('dd/MMM/yy').format(date)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: DropDown(
                                items: _times,
                                label: 'Time Slot',
                                initialValue:
                                    _controllers![_dates.indexOf(date)].text,
                                onChange: (value) {
                                  setState(() {
                                    _controllers![_dates.indexOf(date)].text =
                                        value;
                                  });
                                  Constant.cartItems.forEach((element) {
                                    element.date = date;
                                    element.time = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              Builder(
                builder: (context) => Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10.0),
                  child: RawMaterialButton(
                    onPressed: () async {
                      if (Constant.cartItems.length > 0) {
                        if (Constant.cartItems.first.time != '') {
                          setState(() => this.isLoading = true);
                          bool _result =
                              await DatabaseManager.getInstance.placeOrder();
                          if (_result) {
                            setState(() => this.isLoading = false);
                            Navigator.pop(context, true);
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text('OrderPlaced'),
                            // ));
                          } else {
                            setState(() => this.isLoading = false);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Error Occured!'),
                            ));
                          }
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('No schedule is selected!'),
                          ));
                        }
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.rightToLeft,
                        //     child: DateTimeScheduler(),
                        //   ),
                        // );
                      }
                    },
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
                            'Checkout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            FlutterIcons.log_out_fea,
                            size: 28,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
