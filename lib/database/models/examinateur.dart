class Examinateur {
  int? id;
  String? schoolId;
  String? schoolName;
  String? nom;
  String? prenom;
  String? telephone;
  String? adresse;

  Examinateur({
    this.id,
    this.schoolId,
    this.schoolName,
    this.nom,
    this.prenom,
    this.telephone,
    this.adresse,
  });

  factory Examinateur.fromJson(Map<String, dynamic> json) {
    return Examinateur(
      id: json['id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      adresse: json['adresse'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school_id'] = schoolId;
    data['school_name'] = schoolName;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['telephone'] = telephone;
    data['adresse'] = adresse;
    return data;
  }
}
