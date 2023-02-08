class Bureau {
  int? id;
  String? schoolId;
  String? schoolName;
  String? nom;
  String? sequence;
  String? mat_fiscal;
  String? adresse;
  String? nom_comercial;

  Bureau({
    this.id,
    this.schoolId,
    this.schoolName,
    this.nom,
    this.sequence,
    this.mat_fiscal,
    this.adresse,
    this.nom_comercial,
  });

  factory Bureau.fromJson(Map<String, dynamic> json) {
    return Bureau(
      id: json['id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      nom: json['nom'],
      sequence: json['sequence'],
      mat_fiscal: json['mat_fiscal'],
      adresse: json['adresse'],
      nom_comercial: json['nom_comercial'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school_id'] = schoolId;
    data['school_name'] = schoolName;
    data['nom'] = nom;
    data['sequence'] = sequence;
    data['mat_fiscal'] = mat_fiscal;
    data['adresse'] = adresse;
    data['nom_comercial'] = nom_comercial;
    return data;
  }
}
