class Caisse {
  int? id;
  String? schoolId;
  String? schoolName;
  String? caisse;

  Caisse({
    this.id,
    this.schoolId,
    this.schoolName,
    this.caisse,
  });

  factory Caisse.fromJson(Map<String, dynamic> json) {
    return Caisse(
      id: json['id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      caisse: json['caisse'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school_id'] = schoolId;
    data['school_name'] = schoolName;
    data['caisse'] = caisse;
    return data;
  }
}
