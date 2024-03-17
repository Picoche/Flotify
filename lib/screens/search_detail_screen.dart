import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The details screen
class SearchDetailsScreen extends StatelessWidget {
  /// Constructs a [SearchDetailsScreen]
  const SearchDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/b'),
          child: const Text('Go back to the Search screen'),
        ),
      ),
    );
  }
}