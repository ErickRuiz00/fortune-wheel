import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Ruleta(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Ruleta extends StatefulWidget {
  const Ruleta({super.key});

  @override
  State<Ruleta> createState() => _RuletaState();
}

class _RuletaState extends State<Ruleta> {
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    super.dispose();
    selected.close();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      "Donitas",
      "Waffles",
      "Hot Cakes",
      "Crepa",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Iker y sus dulzuras"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Flexible(
            flex: 1,
            child: SizedBox(),
          ),
          Flexible(
            flex: 2,
            child: FortuneWheel(
              alignment: Alignment.bottomCenter,
              selected: selected.stream,
              items: [
                ...items.map((e) => FortuneItem(
                      child: Text(e.toUpperCase()),
                    ))
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: TextButton(
                onPressed: () => setState(() {
                      selected.add(Fortune.randomInt(0, items.length));
                    }),
                child: const Text("Prueba tu suerte")),
          ),
        ],
      ),
    );
  }
}
