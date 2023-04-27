import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NuevaNotaView extends StatefulWidget {
  const NuevaNotaView({super.key});

  @override
  State<NuevaNotaView> createState() => _NuevaNotaViewState();
}

class _NuevaNotaViewState extends State<NuevaNotaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva nota'),
      ),
      body: const Text('Escribe tu nota'),
    );
  }
}
