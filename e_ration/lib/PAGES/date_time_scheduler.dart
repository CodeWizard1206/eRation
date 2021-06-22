import 'package:e_ration/COMPONENTS/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeScheduler extends StatefulWidget {
  DateTimeScheduler({Key? key}) : super(key: key);

  @override
  _DateTimeSchedulerState createState() => _DateTimeSchedulerState();
}

class _DateTimeSchedulerState extends State<DateTimeScheduler> {
  @override
  Widget build(BuildContext context) {
    List<DateTime> _dates = [];
    var date = DateTime.now().add(Duration(days: 2));
    if (date.hour > 17) date = date.add(Duration(hours: 8));

    for (int i = 0; i < 5; ++i) {
      if (date.weekday >= 1 && date.weekday < 7) {
        _dates.add(date);
        print(DateFormat('EEEE').format(date));
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
      body: Container(
        height: double.maxFinite,
        width: MediaQuery.of(context).size.width,
        child: ListView(
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
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
