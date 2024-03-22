import "tracks_model.dart";

class Playlist {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final List<Track>? tracks;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tracks,
  });

  List<Playlist> get playlists => [];

  Playlist? getPlaylistById(String id) {
    return playlists.firstWhere((playlist) => playlist.id == id,
        orElse: () => Playlist(
            id: '', name: '', description: '', imageUrl: '', tracks: []));
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      tracks: json['tracks'],
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'tracks': tracks,
    };
  }

  toMap()
  {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'tracks': tracks,
    };
  }

  toMapWithoutTracks()
  {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
