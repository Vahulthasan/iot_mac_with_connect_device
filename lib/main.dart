import 'package:flutter/material.dart';
import 'second_page.dart'; // import the second page

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named‑Route Demo',
      // 🔑 declare the routes once
      routes: {
        '/':        (context) => const HomePage(),   // initial
        '/second':  (context) => const SecondPage(), // target
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(  // 👈 navigate to second page
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child: Text('Go to Second Page'),
        ),
      ),
    );
  }
}

// For example, make an entire ListTile open the page:
ListTile(
leading: const Icon(Icons.settings),
title: const Text('Settings'),
onTap: () => Navigator.pushNamed(context, '/second'),
),

// …or an image
GestureDetector(
onTap: () => Navigator.pushNamed(context, '/second'),
child: Image.asset('assets/banner.png'),
),
