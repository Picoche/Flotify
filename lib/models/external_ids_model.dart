class ExternalIds {
  String? isrc;
  String? ean;
  String? upc;

  ExternalIds({this.isrc, this.ean, this.upc});

  ExternalIds.fromJson(Map<String, dynamic> json) {
    isrc = json['isrc'];
    ean = json['ean'];
    upc = json['upc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isrc'] = isrc;
    data['ean'] = ean;
    data['upc'] = upc;
    return data;
  }

  toMap()
  {
    return {
      'isrc': isrc,
      'ean': ean,
      'upc': upc,
  };
  }
}