import "albums_model.dart";
import "artist_model.dart";
import "external_ids_model.dart";
import "external_urls_model.dart";

class Track {
  Album? album;
  String? albumId;
  List<Artist>? artists;
  String? artist;
  String? imageUrl;
  String? previewUrl;
  int? discNumber;
  int? durationMs;
  bool? explicit;
  ExternalIds? externalIds;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  bool? isLocal;
  String? name;
  int? popularity;
  int? trackNumber;
  String? type;
  String? uri;

  Track(
      {this.album,
      this.albumId,
      this.artists,
      this.artist,
      this.imageUrl,
      this.previewUrl,
      this.discNumber,
      this.durationMs,
      this.explicit,
      this.externalIds,
      this.externalUrls,
      this.href,
      this.id,
      this.isLocal,
      this.name,
      this.popularity,
      this.trackNumber,
      this.type,
      this.uri});

  Track.fromJson(Map<String, dynamic> json) {
    album = json['album'] != null ? Album.fromJson(json['album']) : null;
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(Artist.fromJson(v));
      });
    }
    albumId = json['album_id'];
    discNumber = json['disc_number'];
    durationMs = json['duration_ms'];
    previewUrl = json['preview_url'];
    explicit = json['explicit'];
    externalIds = json['external_ids'] != null
        ? ExternalIds.fromJson(json['external_ids'])
        : null;
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    isLocal = json['is_local'];
    name = json['name'];
    popularity = json['popularity'];
    trackNumber = json['track_number'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (album != null) {
      data['album'] = album!.toJson();
    }
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }
    data['album_id'] = albumId;
    data['disc_number'] = discNumber;
    data['duration_ms'] = durationMs;
    data['preview_url'] = previewUrl;
    data['explicit'] = explicit;
    if (externalIds != null) {
      data['external_ids'] = externalIds!.toJson();
    }
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['is_local'] = isLocal;
    data['name'] = name;
    data['popularity'] = popularity;
    data['track_number'] = trackNumber;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }

  static Track fromMap(Map<String, Object?> item) {
    return Track(
      id: item['id'] as String?,
      albumId: item['albumId'] as String?,
      name: item['name'] as String?,
      imageUrl: item['imageUrl'] as String?,
      artist: item['artist'] as String?,
      previewUrl: item['previewUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'albumId': albumId,
      'name': name,
      'imageUrl': imageUrl,
      'artist': artist,
      'previewUrl': previewUrl,
    };
  }
}
