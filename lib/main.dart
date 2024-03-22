import 'package:flutter/material.dart';
import 'package:projet_spotify_gorouter/router/router_config.dart';
import 'package:provider/provider.dart';

import 'providers/albums_provider.dart';
import 'providers/artists_provider.dart';
import 'providers/tracks_provider.dart';
import 'providers/query_provider.dart';
/// Exemple d'application avec double navigation
///  - une avec une bottom navigation bar (3 branches)
///  - une navigation entre les pages de chaque branche

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AlbumsProvider()),
        ChangeNotifierProvider(create: (context) => ArtistsProvider()),
        ChangeNotifierProvider(create: (context) => TracksProvider()),
        ChangeNotifierProvider(create: (context) => QueryProvider()),],
      child: const MyApp(),
    ),
  );
}

/// The main app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // -- le point d'entrée du main est le router
  //    (pas de scafflod à ce niveau)
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      )
    );
  }
}


