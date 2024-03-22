import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import "../providers/sqflite/sqflite_provider.dart";
import "../models/playlists_model.dart";

// The home screen
class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late Future<List<Playlist>> futurePlaylists;
  final playlistNameController = TextEditingController();
  final playlistDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePlaylists = fetchPlaylists();
  }

  Future<List<Playlist>> fetchPlaylists() async {
    final databaseHelper = await PlaylistProvider.create();
    return databaseHelper.getPlaylists();
  }

  Future<void> addPlaylist(Playlist playlist) async {
    final databaseHelper = await PlaylistProvider.create();
    await databaseHelper.insertPlaylist(playlist);
  }

  Future<void> deletePlaylist(String id) async {
    final databaseHelper = await PlaylistProvider.create();
    await databaseHelper.deletePlaylist(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist Screen')),
      body: FutureBuilder<List<Playlist>>(
        future: futurePlaylists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final playlists = snapshot.data;
            return ListView.builder(
              itemCount: playlists?.length,
              itemBuilder: (context, index) {
                final playlist = playlists?[index];
                return ListTile(
                  leading: SizedBox(
                    width: 60.0,
                    child: playlist != null &&
                            playlist.tracks != null &&
                            playlist.tracks!.isNotEmpty &&
                            playlist.tracks![0].imageUrl != null &&
                            Uri.parse(playlist.tracks![0].imageUrl!)
                                .hasAuthority
                        ? Image.network(playlist.tracks![0].imageUrl!)
                        : Image.network(
                            "https://w7.pngwing.com/pngs/991/237/png-transparent-musical-note-music-notes-miscellaneous-monochrome-silhouette-thumbnail.png"),
                  ),
                  title: Text(playlist?.name ?? "",
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  subtitle: Text(playlist?.description ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deletePlaylist(playlist?.id ?? "");
                      setState(() {
                        futurePlaylists = fetchPlaylists();
                      });
                    },
                  ),
                  onTap: () => context.push('/c/playlist/${playlist?.id}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Ajouter une Playlist'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: playlistNameController,
                      decoration:
                          const InputDecoration(hintText: 'Nom de la Playlist'),
                    ),
                    TextField(
                      controller: playlistDescriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Description de la Playlist'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      final playlist = Playlist(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: playlistNameController.text,
                        description: playlistDescriptionController.text,
                        imageUrl: "",
                        tracks: [],
                      );
                      addPlaylist(playlist);
                      setState(() {
                        futurePlaylists = fetchPlaylists();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
