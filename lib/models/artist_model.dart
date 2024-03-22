import "external_urls_model.dart";
import "followers_model.dart";
import "images_model.dart";


class Artist {
  ExternalUrls? externalUrls;
  Followers? followers;
  List<String>? genres;
  String? href;
  String? id;
  List<Images>? images;
  String? name;
  int? popularity;
  String? type;
  String? uri;

  Artist(
      {this.externalUrls,
      this.followers,
      this.genres,
      this.href,
      this.id,
      this.images,
      this.name,
      this.popularity,
      this.type,
      this.uri});

  Artist.fromJson(Map<String, dynamic> json) {
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    followers = json['followers'] != null
        ? Followers.fromJson(json['followers'])
        : null;
    genres = json['genres']?.cast<String>();
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    name = json['name'];
    popularity = json['popularity'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    if (followers != null) {
      data['followers'] = followers!.toJson();
    }
    data['genres'] = genres;
    data['href'] = href;
    data['id'] = id;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['popularity'] = popularity;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }

  toMap()
  {
    return {
      'external_urls': externalUrls!.toMap(),
      'followers': followers!.toMap(),
      'genres': genres,
      'href': href,
      'id': id,
      'images': images!.map((v) => v.toMap()).toList(),
      'name': name,
      'popularity': popularity,
      'type': type,
      'uri': uri,
    };
  }
}