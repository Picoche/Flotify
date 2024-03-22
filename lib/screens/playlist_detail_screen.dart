import "package:cached_network_image/cached_network_image.dart";
import 'package:flutter/material.dart';
import "package:projet_spotify_gorouter/models/playlists_model.dart";
import 'package:audioplayers/audioplayers.dart';

// ignore: library_prefixes
import "../models/tracks_model.dart" as TracksModel;
import "../providers/sqflite/sqflite_provider.dart";

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  // ignore: library_private_types_in_public_api
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late Future<List<TracksModel.Track>> futureTracks;
  late Future<Playlist> playlist;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    futureTracks = fetchTracksFromPlaylist(widget.playlistId);
    playlist = fetchPlaylist(widget.playlistId);
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> _playMusic(String url) async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setSource(UrlSource(url));
      await _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<List<TracksModel.Track>> fetchTracksFromPlaylist(
      String playlistId) async {
    final provider = await PlaylistProvider.create();
    final tracks = await provider.getTracksFromPlaylist(playlistId);
    return tracks;
  }

  Future<Playlist> fetchPlaylist(String playlistId) async {
    final provider = await PlaylistProvider.create();
    final playlist = await provider.getPlaylist(playlistId);
    return playlist!;
  }

  Future<void> deleteTrackFromPlaylist(
      String playlistId, String trackId) async {
    final provider = await PlaylistProvider.create();
    await provider.deleteTrackFromPlaylist(trackId, playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Playlist>(
          future: playlist,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final playlistData = snapshot.data!;
              return Text(playlistData.name!);
            }
          },
        ),
      ),
      body: FutureBuilder<List<TracksModel.Track>>(
        future: futureTracks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final tracks = snapshot.data!;
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(track
                            .imageUrl ??
                        "https://w7.pngwing.com/pngs/991/237/png-transparent-musical-note-music-notes-miscellaneous-monochrome-silhouette-thumbnail.png"),
                    backgroundColor: Colors.blue,
                    radius: 30,
                  ),
                  title: Text(
                    track.name!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    track.artist ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteTrackFromPlaylist(
                          widget.playlistId, track.id!);
                      setState(() {
                        futureTracks =
                            fetchTracksFromPlaylist(widget.playlistId);
                      });
                    },
                  ),
                  onTap: () {
                    _playMusic(track.previewUrl!);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
