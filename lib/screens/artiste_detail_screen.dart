import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// -- detail d'un artiste
class ArtisteDetailScreen extends StatelessWidget {
  /// Constructs a [ArtisteDetailScreen]
  const ArtisteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artiste Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/a/albumdetails'),
          child: const Text('Go back'),
        ),
      ),
    );
  }
}