import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// The home screen
class SearchScreen extends StatelessWidget {
  /// Constructs a [SearchScreen]
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Screen')),
      body: Center(
        child: 
          ElevatedButton(
            onPressed: () => context.go('/b/searchdetails'),
            child: const Text('Go to the search Details screen'),
          ),

      ),
    );
  }
}