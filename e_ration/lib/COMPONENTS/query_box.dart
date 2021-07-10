import 'package:e_ration/MODELS/query_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QueryBox extends StatelessWidget {
  final QueryModel? query;
  const QueryBox({
    Key? key,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Asked by : ${query!.askedBy}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('dd/MMM/yy - hh:mm').format(query!.timestamp!),
                // style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            width: double.maxFinite,
            child: Text(
              'Ques. ${query!.question!}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            width: double.maxFinite,
            child: Text(
              'Ans. ${query!.answer == null ? 'Unanswered' : query!.answer}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
