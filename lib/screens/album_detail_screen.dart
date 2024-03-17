import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The details screen
class AlbumDetailScreen extends StatelessWidget {
  /// Constructs a [AlbumDetailScreen]
  const AlbumDetailScreen({super.key});

// -- detail d'un album
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details Screen')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/a'),
              child: const Text('Go back'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/a/artistedetails'),
              child: const Text('Go Artiste Detail'),
            ),
          ],
        )
      ),
    );
  }
}