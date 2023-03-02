class Examen {
  int? id;
  String? schoolId;
  String? schoolName;
  String? condidatId;
  String? numListe;
  String? numConvocation;
  String? dateExamen;
  String? centreExamen;
  String? typeExamen;
  String? prestation;
  String? bureau;
  String? resultat;
  String? examinateur;
  Detailcondidat? condidat;

  Examen({
    this.id,
    this.schoolId,
    this.schoolName,
    this.condidatId,
    this.numListe,
    this.numConvocation,
    this.dateExamen,
    this.centreExamen,
    this.typeExamen,
    this.prestation,
    this.bureau,
    this.resultat,
    this.examinateur,
    this.condidat,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    dynamic detailcond = json['condidat'];
    return Examen(
      id: json['id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      condidatId: json['condidat_id'],
      numListe: json['num_liste'],
      numConvocation: json['num_convocation'],
      dateExamen: json['date_examen'],
      centreExamen: json['centre_examen'],
      typeExamen: json['type_examen'],
      prestation: json['prestation'],
      bureau: json['bureau'],
      resultat: json['resultat'],
      examinateur: json['examinateur'],
      condidat: Detailcondidat(
          nom: detailcond != null ? detailcond['nom'] : "",
          prenom: detailcond != null ? detailcond['prenom'] : "",
          photo: detailcond != null ? detailcond['photo'] : ""),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school_id'] = schoolId;
    data['school_name'] = schoolName;
    data['condidat_id'] = condidatId;
    data['num_liste'] = numListe;
    data['num_convocation'] = numConvocation;
    data['date_examen'] = dateExamen;
    data['centre_examen'] = centreExamen;
    data['type_examen'] = typeExamen;
    data['prestation'] = prestation;
    data['bureau'] = bureau;
    return data;
  }
}

class Detailcondidat {
  String? nom;
  String? prenom;
  String? photo;

  Detailcondidat({
    this.nom,
    this.prenom,
    this.photo,
  });

  factory Detailcondidat.fromJson(Map<String, dynamic> json) {
    return Detailcondidat(
      nom: json['nom'],
      prenom: json['prenom'],
      photo: json['photo'],
    );
  }
}
