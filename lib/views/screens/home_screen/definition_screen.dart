import 'package:flutter/material.dart';

class DefinitionScreen extends StatefulWidget {
  final String word;
  const DefinitionScreen({super.key, required this.word});

  @override
  State<DefinitionScreen> createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Hero(tag: 'wordOfTheDay', child: Material(color: Colors.transparent)));
  }
}
