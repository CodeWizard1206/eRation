import 'package:flutter/material.dart';

class DataInfoCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Stream<int>? stream;
  const DataInfoCard({
    Key? key,
    this.title,
    this.icon,
    this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
            stream: this.stream,
            builder: (context, snapshot) {
              int _count = 401;

              if (snapshot.connectionState != ConnectionState.none) {
                if (snapshot.data != null) {
                  _count = snapshot.data as int;
                }
              }
              return Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            this.icon,
                          ),
                          SizedBox(width: 3.0),
                          Text(
                            this.title.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        _count.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 55.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
