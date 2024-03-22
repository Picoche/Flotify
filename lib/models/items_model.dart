import 'artist_model.dart';
import "restrictions_model.dart";
import "linked_from_model.dart";
import "external_urls_model.dart";

class Items {
  List<Artist>? artists;
  List<String>? availableMarkets;
  int? discNumber;
  int? durationMs;
  bool? explicit;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  bool? isPlayable;
  LinkedFrom? linkedFrom;
  Restrictions? restrictions;
  String? name;
  String? previewUrl;
  int? trackNumber;
  String? type;
  String? uri;
  bool? isLocal;

  Items(
      {this.artists,
      this.availableMarkets,
      this.discNumber,
      this.durationMs,
      this.explicit,
      this.externalUrls,
      this.href,
      this.id,
      this.isPlayable,
      this.linkedFrom,
      this.restrictions,
      this.name,
      this.previewUrl,
      this.trackNumber,
      this.type,
      this.uri,
      this.isLocal});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(Artist.fromJson(v));
      });
    }
    availableMarkets = json['available_markets']?.cast<String>();
    discNumber = json['disc_number'];
    durationMs = json['duration_ms'];
    explicit = json['explicit'];
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    isPlayable = json['is_playable'];
    linkedFrom = json['linked_from'] != null
        ? LinkedFrom.fromJson(json['linked_from'])
        : null;
    restrictions = json['restrictions'] != null
        ? Restrictions.fromJson(json['restrictions'])
        : null;
    name = json['name'];
    previewUrl = json['preview_url'];
    trackNumber = json['track_number'];
    type = json['type'];
    uri = json['uri'];
    isLocal = json['is_local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }
    data['available_markets'] = availableMarkets;
    data['disc_number'] = discNumber;
    data['duration_ms'] = durationMs;
    data['explicit'] = explicit;
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['is_playable'] = isPlayable;
    if (linkedFrom != null) {
      data['linked_from'] = linkedFrom!.toJson();
    }
    if (restrictions != null) {
      data['restrictions'] = restrictions!.toJson();
    }
    data['name'] = name;
    data['preview_url'] = previewUrl;
    data['track_number'] = trackNumber;
    data['type'] = type;
    data['uri'] = uri;
    data['is_local'] = isLocal;
    return data;
  }
}