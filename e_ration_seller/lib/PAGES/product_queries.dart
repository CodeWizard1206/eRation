import 'package:e_ration_seller/COMPONENTS/async_loader.dart';
import 'package:e_ration_seller/COMPONENTS/back_app_bar.dart';
import 'package:e_ration_seller/COMPONENTS/query_box.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/MODELS/query_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductQueries extends StatefulWidget {
  final String? uid;
  ProductQueries({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  _ProductQueriesState createState() => _ProductQueriesState();
}

class _ProductQueriesState extends State<ProductQueries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: SafeArea(child: BackAppBar(title: 'Queries')),
      ),
      body: StreamBuilder<List<QueryModel>>(
        stream: DatabaseManager.getInstance.getQuery(widget.uid!),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (_, i) => InkWell(
                  onTap: () {
                    if (snapshot.data![i].answer == null) {
                      TextEditingController _controller =
                          TextEditingController();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Answer Query...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: TextFormField(
                            autofocus: true,
                            controller: _controller,
                            cursorColor: Theme.of(context).primaryColorLight,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.7,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(_).pop();
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (_controller.text.isNotEmpty) {
                                  bool _result = await DatabaseManager
                                      .getInstance
                                      .answerQuery(
                                          widget.uid!,
                                          snapshot.data![i].uid!,
                                          _controller.text);

                                  if (_result) {
                                    Navigator.of(_).pop();
                                    Fluttertoast.showToast(
                                      msg: 'Query Answered',
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black87,
                                    );
                                  } else
                                    Fluttertoast.showToast(
                                      msg: 'Error Occured',
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black87,
                                    );
                                }
                              },
                              child: Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: QueryBox(
                    query: snapshot.data![i],
                  ),
                ),
                separatorBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 1.0,
                  ),
                ),
                itemCount: snapshot.data!.length,
              );
            }
          }
          return Center(
            child: AsyncLoader(),
          );
        },
      ),
    );
  }
}
