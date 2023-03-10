// ignore_for_file: camel_case_types

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
  Detailexam? detail_examen;
  Nbr_hr_affec? nbr_heur_affecter;
  Nbr_heur_total? nbr_heur_total;
  Nbr_ex? nbr_exam;

  Conduite({
    this.id,
    this.condidat_id,
    this.date_deb,
    this.date_fin,
    this.school_name,
    this.school_id,
    this.nbr_heure,
    this.couleur,
    this.moniteur,
    this.nbr_heur_total,
    this.vehicule,
    this.detail_examen,
    this.nbr_heur_affecter,
    this.condidat,
    this.nbr_exam,
  });

  factory Conduite.fromJson(Map<String, dynamic> json) {
    dynamic detailcond = json['condidat'];
    dynamic detailexam = json['detail_examen'];
    List<dynamic> nht = json['nbr_heur_total'];
    List<dynamic> nhaff = json['nbr_heur_affecter'];
    List<dynamic> nnn = json['nbr_exam'];

    return Conduite(
      id: json['id'],
      condidat_id: json['condidat_id'],
      date_deb: json['date_deb'],
      date_fin: json['date_fin'],
      school_name: json['school_name'],
      school_id: json['school_id'],
      nbr_heure: json['nbr_heure'],
      moniteur: json['moniteur'],
      couleur: json['couleur'],
      nbr_heur_total: Nbr_heur_total(
        nb_heur_total: nht[0]['nb_heur_total'] ?? "0",
      ),
      vehicule: json['vehicule'],
      detail_examen: Detailexam(
        date_examen: detailexam?['date_examen'] != null ? detailexam['date_examen'] : "--",
        type_examen: detailexam?['type_examen'] != null ? detailexam['type_examen'] : "--",
      ),
      nbr_heur_affecter: Nbr_hr_affec(
        nb_heur_affecter: nhaff[0]['nb_heur_affecter'] ?? "0",
      ),
      condidat: Detailcondidat(
          nom: detailcond['nom'] ?? "",
          prenom: detailcond['prenom'] ?? "",
          photo: detailcond['photo'] ?? "",
          num_tel: detailcond['num_tel'] ?? ""),
      nbr_exam: Nbr_ex(
        nb_exam: "nbr ghalet",
      ),
    );
  }
}

class Detailcondidat {
  String? nom;
  String? prenom;
  String? photo;
  String? num_tel;

  Detailcondidat({
    this.nom,
    this.prenom,
    this.photo,
    this.num_tel,
  });

  factory Detailcondidat.fromJson(Map<String, dynamic> json) {
    return Detailcondidat(
      nom: json['nom'],
      prenom: json['prenom'],
      photo: json['photo'],
      num_tel: json['num_tel'],
    );
  }
}

class Detailexam {
  String? date_examen;
  String? type_examen;

  Detailexam({
    this.date_examen,
    this.type_examen,
  });

  factory Detailexam.fromJson(Map<String, dynamic> json) {
    return Detailexam(
      date_examen: json['date_examen'],
      type_examen: json['type_examen'],
    );
  }
}

class Nbr_hr_affec {
  String? nb_heur_affecter;

  Nbr_hr_affec({
    this.nb_heur_affecter,
  });

  factory Nbr_hr_affec.fromJson(Map<String, dynamic> json) {
    return Nbr_hr_affec(
      nb_heur_affecter: json['nb_heur_affecter'],
    );
  }
}

class Nbr_heur_total {
  String? nb_heur_total;

  Nbr_heur_total({
    this.nb_heur_total,
  });

  factory Nbr_heur_total.fromJson(Map<String, dynamic> json) {
    return Nbr_heur_total(
      nb_heur_total: json['nb_heur_total'],
    );
  }
}

/***a terminer next  week */
class Nbr_ex {
  String? nb_exam;

  Nbr_ex({
    this.nb_exam,
  });

  factory Nbr_ex.fromJson(Map<String, dynamic> json) {
    print(json['nb_exam']);
    return Nbr_ex(
      nb_exam: json['nb_exam'],
    );
  }
}
