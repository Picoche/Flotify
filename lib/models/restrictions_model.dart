class Restrictions {
  String? reason;

  Restrictions({this.reason});

  Restrictions.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    return data;
  }

  toMap()
  {
    return {
      'reason': reason,
    };
  }
}