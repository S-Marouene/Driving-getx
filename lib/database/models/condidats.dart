class Condidat {
  int? id;
  String? nom;
  String? prenom;
  String? num_tel;
  String? school_name;
  String? examen;
  String? photo;

  Condidat(
      {this.id,
      this.nom,
      this.prenom,
      this.num_tel,
      this.school_name,
      this.examen,
      this.photo});

  factory Condidat.fromJson(Map<String, dynamic> json) {
    return Condidat(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      num_tel: json['num_tel'],
      school_name: json['school_name'],
      examen: json['examen'],
      photo: json['photo'],
    );
  }
}
