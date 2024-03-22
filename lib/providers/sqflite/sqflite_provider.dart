import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../models/playlists_model.dart';
import "../../models/tracks_model.dart";

class PlaylistProvider extends ChangeNotifier {
  static const _databaseName = "playlist.db";
  late Database db;

  PlaylistProvider._();

  static Future<PlaylistProvider> create() async {
    var provider = PlaylistProvider._();
    await provider.open();
    return provider;
  }

  Future open() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final documentsDirectory = await getDatabasesPath();
    final path = documentsDirectory + _databaseName;

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE playlists (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          imageUrl TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE tracks (
          id TEXT PRIMARY KEY,
          albumId TEXT NOT NULL,
          name TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          artist TEXT NOT NULL,
          previewUrl TEXT NOT NULL
        )
      ''');
        await db.execute('''
        CREATE TABLE playlist_tracks (
          playlist_id TEXT,
          track_id TEXT,
          PRIMARY KEY (playlist_id, track_id),
          FOREIGN KEY (playlist_id) REFERENCES playlists (id),
          FOREIGN KEY (track_id) REFERENCES tracks (id)
        )
      ''');
      },
    );
  }

  Future<List<Playlist>> getPlaylists() async {
    await open();
    final List<Map<String, dynamic>> maps = await db.query('playlists');
    return Future.wait(maps.map((map) async {
      notifyListeners();
      return Playlist(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        imageUrl: map['imageUrl'],
        tracks: await getTracksFromPlaylist(map['id']),
      );
    }));
  }

  Future<Playlist?> getPlaylist(String id) async {
    await open();
    final List<Map<String, dynamic>> maps =
        await db.query('playlists', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      notifyListeners();
      return Playlist(
        id: maps[0]['id'],
        name: maps[0]['name'],
        description: maps[0]['description'],
        imageUrl: maps[0]['imageUrl'],
        tracks: await getTracksFromPlaylist(id),
      );
    }
    return null;
  }

  Future<List<Track>> getTracksFromPlaylist(String playlistId) async {
    final result = await db.rawQuery('''
    SELECT tracks.* FROM tracks
    JOIN playlist_tracks ON tracks.id = playlist_tracks.track_id
    WHERE playlist_tracks.playlist_id = ?
  ''', [playlistId]);

    if (result.isNotEmpty) {
      notifyListeners();
      return result.map((item) => Track.fromMap(item)).toList();
    } else {
      return [];
    }
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    await db.insert(
      'playlists',
      playlist.toMapWithoutTracks(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> deletePlaylist(String id) async {
    await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<String> insertTrack(Track track, String playlistId) async {
    await db.insert(
      'tracks',
      track.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await addTrackToPlaylist(playlistId, track.id!);
    notifyListeners();
    return track.id!;
  }

  Future<void> deleteTrackFromPlaylist(String trackId, String playlistId) async {
    await db.delete('playlist_tracks',
        where: 'playlist_id = ? AND track_id = ?', whereArgs: [playlistId, trackId]);
    notifyListeners();
  }

  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    await db.insert(
        'playlist_tracks', {'playlist_id': playlistId, 'track_id': trackId});
        notifyListeners();
  }
}
