class Conduite {
  int? id;
  String? school_name;
  String? school_id;
  String? condidat_id;
  String? date_deb;
  String? date_fin;
  String? nbr_heure;
  String? moniteur;
  String? vehicule;
  String? couleur;
  Detailcondidat? condidat;
  String? detail_examen;
  String? nbr_heur_affecter;
  String? nbr_heur_total;
  String? nbr_exam;

  Conduite({
    this.id,
    this.condidat_id,
    this.date_deb,
    this.date_fin,
    this.school_name,
    this.school_id,
    this.nbr_heure,
    this.moniteur,
    this.nbr_heur_total,
    this.vehicule,
    this.detail_examen,
    this.nbr_heur_affecter,
    this.nbr_exam,
    this.condidat,
  });

  factory Conduite.fromJson(Map<String, dynamic> json) {
    dynamic detailcond = json['condidat'];
    return Conduite(
      id: json['id'],
      condidat_id: json['condidat_id'],
      date_deb: json['date_deb'],
      date_fin: json['date_fin'],
      school_name: json['school_name'],
      school_id: json['school_id'],
      nbr_heure: json['nbr_heure'],
      moniteur: json['moniteur'],
      nbr_heur_total: json['nbr_heur_total'],
      vehicule: json['vehicule'],
      detail_examen: json['detail_examen'],
      nbr_heur_affecter: json['nbr_heur_affecter'],
      nbr_exam: json['nbr_exam'],
      condidat: Detailcondidat(
          nom: detailcond != null ? detailcond['nom'] : "",
          prenom: detailcond != null ? detailcond['prenom'] : "",
          photo: detailcond != null ? detailcond['photo'] : ""),
    );
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
