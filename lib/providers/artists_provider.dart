import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/artist_model.dart';
import "../token.dart";

class ArtistsProvider with ChangeNotifier {
  Artist _artist = Artist();
  Future<String> token = refreshToken();


  Future<void> fetchArtist(String id) async {
    String tokenValue = await token;
    final response = await http.get(Uri.parse('https://api.spotify.com/v1/artists/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenValue'});
    final Map<String, dynamic> data = json.decode(response.body);
    _artist = Artist.fromJson(data);
    notifyListeners();
  }

  Artist get artist {
    return _artist;
  }
}
