import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// -- les derniers albums (news)
class AlbumNewsScreen extends StatelessWidget {
  /// Constructs a [AlbumNewsScreen]
  const AlbumNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album News Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/a/albumdetails'),
          child: const Text('Go to the Details screen'),
        ),
      ),
    );
  }
}