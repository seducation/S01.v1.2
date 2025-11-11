import 'package:flutter/material.dart';

class LensScreen extends StatelessWidget {
  const LensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: const Text('Lens'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Handle reload button press
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Lens Screen Content'),
      ),
    );
  }
}
