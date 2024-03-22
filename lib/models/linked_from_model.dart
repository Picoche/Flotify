import "external_urls_model.dart";

class LinkedFrom {
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  String? type;
  String? uri;

  LinkedFrom({this.externalUrls, this.href, this.id, this.type, this.uri});

  LinkedFrom.fromJson(Map<String, dynamic> json) {
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}