// ignore: file_names
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/albums_model.dart';
import "../token.dart";

class AlbumsProvider with ChangeNotifier {
  List<Album> _albums = [];
  Album _album = Album();
  List<Album> get albums => _albums;
  Future<String> token = refreshToken();

  final _fetchAlbumsController = StreamController<void>();

  Stream<void> get fetchAlbumsStream => _fetchAlbumsController.stream;

  Future<void> fetchAlbums(int page) async {
  String tokenValue = await token;
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/browse/new-releases?offset=${(page - 1) * 20}'), 
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenValue'
    }
  );
  final List<Album> loadedAlbums = [];
  final Map<String, dynamic> data = json.decode(response.body);
  final List<dynamic> albumsData = data['albums']['items'];
  for (var album in albumsData) {
    loadedAlbums.add(Album.fromJson(album));
  }
  _albums = loadedAlbums;

  _fetchAlbumsController.add(null);

  notifyListeners();
}

  Future<void> fetchAlbum(String id) async {
    String tokenValue = await token;
    final response = await http.get(Uri.parse('https://api.spotify.com/v1/albums/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenValue'});
    final Map<String, dynamic> data = json.decode(response.body);
    _album = Album.fromJson(data);
    notifyListeners();
  }

  Future<void> queryAlbums(String query) async {
    String tokenValue = await token;
    final response = await http.get(Uri.parse('https://api.spotify.com/v1/search?q=$query&type=album'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenValue'});
    final List<Album> loadedAlbums = [];
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> albumsData = data['albums']['items'];
    for (var album in albumsData) {
      loadedAlbums.add(Album.fromJson(album));
    }
    _albums = loadedAlbums;

    _fetchAlbumsController.add(null);

    notifyListeners();
  }

  @override
  void dispose() {
    _fetchAlbumsController.close();
    super.dispose();
  }

  Album get album {
    return _album;
  }
}