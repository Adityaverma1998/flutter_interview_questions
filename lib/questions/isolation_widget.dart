import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IsolationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Container(
            height: 200,
            child: Image.asset('assets/gifs/bouncing-basketball.gif'),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              log("check double ${count()}");
            },
            child: Text("first")),
        ElevatedButton(
            onPressed: () async {
              final receivePort = ReceivePort();
              await Isolate.spawn(count2, receivePort.sendPort);
              receivePort.listen((total) {
                log('check total value in second task $total');
              });
            },
            child: Text("Second")),
        ElevatedButton(
            onPressed: () async {
              final receivePort = ReceivePort();
              await Isolate.spawn(
                  count3,
                  Data(
                    iteration: 1000000000,
                    sendPort: receivePort.sendPort,
                  ));
              receivePort.listen((total) {
                log('check total value in third task $total');
              });
            },
            child: Text("Third"))
      ],
    );
  }

  double count() {
    double count = 0;
    for (int i = 0; i <= 1000000000; i++) {
      count++;
    }
    return count;
  }
}

count2(SendPort sendPort) {
  double count = 0;
  for (int i = 0; i <= 1000000000; i++) {
    count++;
  }
  sendPort.send(count);
}

count3(Data data) {
  double count = 0;
  for (int i = 0; i <= data.iteration; i++) {
    count++;
  }
  data.sendPort.send(count);
}

class Data {
  final int iteration;
  final SendPort sendPort;

  Data({required this.iteration, required this.sendPort});
}
