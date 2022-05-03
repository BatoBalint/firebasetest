import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: Size.infinite.width,
          color: Colors.blue[800],
          child: Column(
            children: [
              TextField(
                controller: inputController,
                decoration: const InputDecoration(
                  hintText: 'ingridient name',
                ),
              ),
              ElevatedButton(
                onPressed: sendData,
                child: Text('Send'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendData() async {
    String name = inputController.text.trim();
    Map<String, dynamic> map = {'name': name};
    await FirebaseFirestore.instance.collection('ingridient').add(map);
    inputController.clear();
  }
}
