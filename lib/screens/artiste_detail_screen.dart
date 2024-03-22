import 'package:flutter/material.dart';
import 'package:projet_spotify_gorouter/models/tracks_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/artists_provider.dart';
import '../providers/tracks_provider.dart';
import "../providers/sqflite/sqflite_provider.dart";
import "../models/playlists_model.dart";

class ArtisteDetailScreen extends StatefulWidget {
  final String artistID;

  const ArtisteDetailScreen({super.key, required this.artistID});

  @override
  // ignore: library_private_types_in_public_api
  _ArtisteDetailScreenState createState() => _ArtisteDetailScreenState();
}

class _ArtisteDetailScreenState extends State<ArtisteDetailScreen> {
  late Future<List<Playlist>> futurePlaylists;

  @override
  void initState() {
    super.initState();
    futurePlaylists = fetchPlaylists();
  }

  Future<List<Playlist>> fetchPlaylists() async {
    final databaseHelper = await PlaylistProvider.create();
    return databaseHelper.getPlaylists();
  }

  Future<void> addToPlaylist(Track track, String playlistId) async {
    final databaseHelper = await PlaylistProvider.create();
    await databaseHelper.insertTrack(track, playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          Provider.of<ArtistsProvider>(context, listen: false)
              .fetchArtist(widget.artistID),
          Provider.of<TracksProvider>(context, listen: false)
              .fetchTracks(widget.artistID),
        ]),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading...'),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.error != null) {
              // Error handling
              return const Center(child: Text('An error occurred!'));
            } else {
              return Consumer2<ArtistsProvider, TracksProvider>(
                builder: (ctx, artistsProvider, tracksProvider, _) {
                  final artist = artistsProvider.artist;
                  final tracks = tracksProvider.tracks;
                  return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          artist.name ?? 'Unknown Artist',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  Center(
                                      child: Text(
                                    artist.name ?? 'Unknown Artist',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  const SizedBox(height: 8.0),
                                  if (artist.images != null &&
                                      artist.images!.isNotEmpty)
                                    SizedBox(
                                      width: 200.0,
                                      height: 650.0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: artist.images![0].url ?? '',
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 16.0),
                                  Center(
                                    child: Text(
                                      'Genres: ${artist.genres?.join(', ') ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Center(
                                    child: Text(
                                      'Popularité: ${artist.popularity?.toString() ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Center(
                                    child: Text(
                                      'Followers: ${artist.followers?.total?.toString() ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 16.0),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: tracks.length,
                                itemBuilder: (ctx, index) {
                                  return ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl:
                                          tracks[index].album!.images![0].url!,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    title: Text(tracks[index].name!),
                                    subtitle: Text(tracks[index].album!.name!),
                                    onTap: () {
                                      context.go(
                                          '/a/albumdetails/${tracks[index].album!.id!}');
                                    },
                                    trailing: FutureBuilder<List<Playlist>>(
                                      future: futurePlaylists,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final playlists = snapshot.data!;
                                          return PopupMenuButton<String>(
                                            onSelected: (value) {
                                              final playlist =
                                                  playlists.firstWhere(
                                                (playlist) =>
                                                    playlist.id == value,
                                              );
                                              final track = tracks[index];

                                              final trackName =
                                                  track.name!;

                                              final trackImage = track
                                                  .album!
                                                  .images![0]
                                                  .url!;

                                              final artistName = track
                                                  .artists!
                                                  .map((artist) => artist.name)
                                                  .join(', ');

                                              final previewUrl = track.previewUrl!;

                                              final albumId = track.album!.id!;
                                              final trackToAdd = Track(
                                                id: track.id,
                                                albumId: albumId,
                                                name: trackName,
                                                imageUrl: trackImage,
                                                artist: artistName,
                                                previewUrl: previewUrl,
                                              );
                                              addToPlaylist(
                                                  trackToAdd, playlist.id!);
                                            },
                                            itemBuilder: (context) {
                                              return playlists
                                                  .map((Playlist playlist) {
                                                return PopupMenuItem<String>(
                                                  value: playlist.id,
                                                  child: Text(playlist.name!),
                                                );
                                              }).toList();
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      floatingActionButton: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Go back'),
                      ));
                },
              );
            }
          }
        });
  }
}
