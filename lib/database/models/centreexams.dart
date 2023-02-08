class CentreExam {
  int? id;
  String? schoolId;
  String? schoolName;
  String? libelle;
  String? type;

  CentreExam({
    this.id,
    this.schoolId,
    this.schoolName,
    this.libelle,
    this.type,
  });

  factory CentreExam.fromJson(Map<String, dynamic> json) {
    return CentreExam(
      id: json['id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      libelle: json['libelle'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school_id'] = schoolId;
    data['school_name'] = schoolName;
    data['libelle'] = libelle;
    data['type'] = type;
    return data;
  }
}
