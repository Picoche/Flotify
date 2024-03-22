import 'artist_model.dart';
import 'tracks_model.dart';
import 'restrictions_model.dart';
import 'external_ids_model.dart';
import 'copyrights_model.dart';
import 'external_urls_model.dart';
import 'images_model.dart';

class Album {
  String? albumType;
  int? totalTracks;
  List<String>? availableMarkets;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  List<Images>? images;
  String? name;
  String? releaseDate;
  String? releaseDatePrecision;
  Restrictions? restrictions;
  String? type;
  String? uri;
  List<Artist>? artists;
  Track? tracks;
  List<Copyrights>? copyrights;
  ExternalIds? externalIds;
  List<String>? genres;
  String? label;
  int? popularity;

  Album(
      {this.albumType,
      this.totalTracks,
      this.availableMarkets,
      this.externalUrls,
      this.href,
      this.id,
      this.images,
      this.name,
      this.releaseDate,
      this.releaseDatePrecision,
      this.restrictions,
      this.type,
      this.uri,
      this.artists,
      this.tracks,
      this.copyrights,
      this.externalIds,
      this.genres,
      this.label,
      this.popularity});

  Album.fromJson(Map<String, dynamic> json) {
    albumType = json['album_type'];
    totalTracks = json['total_tracks'];
    availableMarkets = json['available_markets']?.cast<String>();
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    name = json['name'];
    releaseDate = json['release_date'];
    releaseDatePrecision = json['release_date_precision'];
    restrictions = json['restrictions'] != null
        ? Restrictions.fromJson(json['restrictions'])
        : null;
    type = json['type'];
    uri = json['uri'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(Artist.fromJson(v));
      });
    }
    tracks =
        json['tracks'] != null ? Track.fromJson(json['tracks']) : null;
    if (json['copyrights'] != null) {
      copyrights = <Copyrights>[];
      json['copyrights'].forEach((v) {
        copyrights!.add(Copyrights.fromJson(v));
      });
    }
    externalIds = json['external_ids'] != null
        ? ExternalIds.fromJson(json['external_ids'])
        : null;
    genres = json['genres']?.cast<String>();
    label = json['label'];
    popularity = json['popularity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['album_type'] = albumType;
    data['total_tracks'] = totalTracks;
    data['available_markets'] = availableMarkets;
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['release_date'] = releaseDate;
    data['release_date_precision'] = releaseDatePrecision;
    if (restrictions != null) {
      data['restrictions'] = restrictions!.toJson();
    }
    data['type'] = type;
    data['uri'] = uri;
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }
    if (tracks != null) {
      data['tracks'] = tracks!.toJson();
    }
    if (copyrights != null) {
      data['copyrights'] = copyrights!.map((v) => v.toJson()).toList();
    }
    if (externalIds != null) {
      data['external_ids'] = externalIds!.toJson();
    }
    data['genres'] = genres;
    data['label'] = label;
    data['popularity'] = popularity;
    return data;
  }
}