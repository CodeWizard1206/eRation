import 'package:e_ration/MODELS/database_model.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class ReviewCard extends StatefulWidget {
  ReviewCard({Key? key}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  List<int> _rateStar = [1, 2, 3, 4, 5];
  int rating = 3;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      // child: StreamBuilder<List<int>>(
      //     stream: DatabaseManager.getInstance.getReviewDataStream(),
      //     builder: (context, snapshot) {
      //       int rating = 0;
      //       if (snapshot.connectionState != ConnectionState.none) {
      //         if (snapshot.data != null) {
      //           if (snapshot.data!.length > 0) {
      //             int _totalReviews = snapshot.data!.length;
      //             int _reviews = 0;

      //             for (int i in snapshot.data!) {
      //               _reviews += i;
      //             }

      //             rating = (_reviews / _totalReviews) as int;
      //           }
      //         }
      //       }
      //       return Material(
      //         elevation: 8.0,
      //         borderRadius: BorderRadius.circular(15.0),
      //         child: Padding(
      //           padding: const EdgeInsets.all(10.0),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Text(
      //                 rating <= 2
      //                     ? 'Just keep going'
      //                     : rating == 3
      //                         ? 'Great Work, Seller'
      //                         : 'Hi, Super Seller',
      //                 style: TextStyle(
      //                   fontSize: 20.0,
      //                 ),
      //               ),
      //               SizedBox(height: 8.0),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: _rateStar
      //                     .map(
      //                       (star) => Icon(
      //                         _rateStar.indexOf(star) <= (rating - 1)
      //                             ? FlutterIcons.star_faw
      //                             : FlutterIcons.star_o_faw,
      //                         color: Theme.of(context).primaryColorDark,
      //                         size: _rateStar.indexOf(star) == (rating - 1)
      //                             ? 45
      //                             : 35.0,
      //                       ),
      //                     )
      //                     .toList(),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },),
    );
  }
}
