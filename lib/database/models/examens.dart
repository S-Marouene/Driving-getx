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

  Examen(
      {this.id,
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
      this.examinateur});

  factory Examen.fromJson(Map<String, dynamic> json) {
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
        examinateur: json['examinateur']);
  }
}
