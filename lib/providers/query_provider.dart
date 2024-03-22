import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/albums_model.dart';
import '../models/artist_model.dart';
import '../models/tracks_model.dart';

import "../token.dart";

class QueryProvider with ChangeNotifier {
  List<Album> _albums = [];
  List<Artist> _artists = [];
  List<Track> _tracks = [];
  List<Album> get albums => _albums;
  List<Artist> get artists => _artists;
  List<Track> get tracks => _tracks;
  Future<String> token = refreshToken();

  Future<List<dynamic>> fetchQuery(String query, int researchType) async {
    String tokenValue = await token;
    final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=$query&type=album,artist,track'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue'
        });
    switch (researchType) {
      case 0:
        _handleAlbumsResponse(response.body);
        return _albums;
      case 1:
        _handleArtistsResponse(response.body);
        return _artists;
      case 2:
        _handleTracksResponse(response.body);
        return _tracks;
      default:
        _handleAlbumsResponse(response.body);
        return _albums;
    }
  }

  void _handleAlbumsResponse(String response) {
    final List<Album> loadedAlbums = [];
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> albumsData = data['albums']['items'];
    for (var album in albumsData) {
      loadedAlbums.add(Album.fromJson(album));
    }
    _albums = loadedAlbums;
  }

  void _handleArtistsResponse(String response) {
    final List<Artist> loadedArtists = [];
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> artistsData = data['artists']['items'];
    for (var artist in artistsData) {
      loadedArtists.add(Artist.fromJson(artist));
    }
    _artists = loadedArtists;
  }

  void _handleTracksResponse(String response) {
    final List<Track> loadedTracks = [];
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> tracksData = data['tracks']['items'];
    for (var track in tracksData) {
      loadedTracks.add(Track.fromJson(track));
    }
    _tracks = loadedTracks;
  }

}
