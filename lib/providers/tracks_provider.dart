import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/tracks_model.dart';
import "../token.dart";

class TracksProvider with ChangeNotifier {
  List<Track> _tracks = [];
  Track _track = Track();
  List<Track> get tracks => _tracks;
  Future<String> token = refreshToken();

  Future<void> fetchTracks(String id) async {
    String tokenValue = await token;
    final response = await http.get(Uri.parse('https://api.spotify.com/v1/artists/$id/top-tracks'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenValue'});
    final List<Track> loadedTracks = [];
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> tracksData = data['tracks'];
    for (var track in tracksData) {
      loadedTracks.add(Track.fromJson(track));
    }
    _tracks = loadedTracks;
    notifyListeners();
  }

  Future<void> fetchTrack(String id) async {
    String tokenValue = await token;
    final response = await http.get(Uri.parse('https://api.spotify.com/v1/tracks/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenValue'});
    final Map<String, dynamic> data = json.decode(response.body);
    _track = Track.fromJson(data);
    notifyListeners();
  }

  Track get track {
    return _track;
  }
}