import 'package:flutter/material.dart';

import 'derivation_tests.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TextSpan> result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing rust VS Dart implementation"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        reverse: true,
        children: <Widget>[
          RichText(
              text: TextSpan(
                  children: result,
                  style: const TextStyle(
                    color: Colors.black,
                  )))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              result = [];
            });
            runDerivationTest((value) {
              setState(() {
                final splits = value.split(":");
                result += [
                  const TextSpan(
                    text: "\n",
                  ),
                  TextSpan(
                      text: splits[0],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (splits.length > 1)
                    const TextSpan(
                        text: ": ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  if (splits.length > 1) TextSpan(text: splits[1])
                ];
              });
            });
          },
          child: const Icon(Icons.run_circle)),
    );
  }
}
