import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        // 🔻 THIS is the “area” you can change
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/second'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Tap anywhere in this box\nto open Second Page',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
