import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StreamWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream Widget"),
      ),
      body: _buildStreamWidget(),
    );
  }

  Stream<int> _nNatualNumber(int n) async* {
    for (int i = 1; i <= n; i++) {
            await Future.delayed(const Duration(seconds: 1)); // Simulate delay

      yield i;
    }
  }

  Widget _buildStreamWidget() {
    return Column(
      children: [
       
        Expanded(
            child: StreamBuilder<int>(
          stream: _nNatualNumber(10),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No data"));
            }
            return Center(
              child: Text(
                "Current Number: ${snapshot.data}",
                style: const TextStyle(fontSize: 32),
              ),
            );
          },
        ))
      ],
    );
  }
}
