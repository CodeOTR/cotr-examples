import 'package:flutter/material.dart';

class Question68423299 extends StatefulWidget {
  const Question68423299({Key? key}) : super(key: key);

  @override
  State<Question68423299> createState() => _Question68423299State();
}

class _Question68423299State extends State<Question68423299> {
  GlobalNotifier globalNotifier = GlobalNotifier();

  @override
  void initState() {
    globalNotifier.counter.addListener(() {
      print('counter changed!');
      print(globalNotifier.counter.value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SO Question: 68423299'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: globalNotifier.counter,
              builder: (context, value, child) {
                return Text('Value: $value');
              },
            ),
            ElevatedButton(
                onPressed: () {
                  globalNotifier.setValue(globalNotifier.counter.value == null ? 0 : globalNotifier.counter.value! + 1);
                },
                child: const Text('Increment'))
          ],
        ),
      ),
    );
  }
}

class GlobalNotifier {
  final counter = ValueNotifier<int?>(null);

  setValue(int value) {
    counter.value = value;
  }
}
