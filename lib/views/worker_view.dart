import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkerView extends StatelessWidget {
  const WorkerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Campaign List'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          height: 220,
          width: double.maxFinite,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: const <Widget>[
                                  //loop
                                  Text('Campagna in via di casino 63'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ]),
            ),
          ),
        )
    );
  }
}
