class Condidat {
  int? id;
  String? nom;
  String? prenom;
  String? num_tel;
  String? school_name;
  String? school_id;
  String? examen;
  String? photo;
  NbrHeurTotale? nbr_heur_total;
  NbrHeurAffecter? nb_heur_affecter;
  DetailExam? detail_examen;

  Condidat(
      {this.id,
      this.nom,
      this.prenom,
      this.num_tel,
      this.school_name,
      this.school_id,
      this.examen,
      this.photo,
      this.nbr_heur_total,
      this.nb_heur_affecter,
      this.detail_examen});

  factory Condidat.fromJson(Map<String, dynamic> json) {
    List<dynamic> nht = json['nbr_heur_total'];
    List<dynamic> nhaffct = json['nbr_heur_affecter'];
    dynamic detailexam = json['detail_examen'];
    return Condidat(
        id: json['id'],
        nom: json['nom'],
        prenom: json['prenom'],
        num_tel: json['num_tel'],
        school_name: json['school_name'],
        school_id: json['school_id'],
        examen: json['examen'],
        photo: json['photo'],
        nbr_heur_total: NbrHeurTotale(
            condidat_id: nht.isNotEmpty ? nht[0]['condidat_id'] : "",
            nb_heur_total: nht.isNotEmpty ? nht[0]['nb_heur_total'] : "0"),
        nb_heur_affecter: NbrHeurAffecter(
            condidat_id: nhaffct.isNotEmpty ? nhaffct[0]['condidat_id'] : "",
            nb_heur_affecter:
                nhaffct.isNotEmpty ? nhaffct[0]['nb_heur_affecter'] : "0"),
        detail_examen: DetailExam(
            type_examen: detailexam?['type_examen'] != null
                ? detailexam['type_examen']
                : "--",
            date_examen: detailexam?['date_examen'] != null
                ? detailexam['date_examen']
                : "--"));
  }
}

class NbrHeurTotale {
  String? condidat_id;
  String? nb_heur_total;

  NbrHeurTotale({
    this.condidat_id,
    this.nb_heur_total,
  });

  factory NbrHeurTotale.fromJson(Map<String, dynamic> json) {
    return NbrHeurTotale(
      condidat_id: json['condidat_id'],
      nb_heur_total: json['nb_heur_total'],
    );
  }
}

class NbrHeurAffecter {
  String? condidat_id;
  String? nb_heur_affecter;

  NbrHeurAffecter({
    this.condidat_id,
    this.nb_heur_affecter,
  });

  factory NbrHeurAffecter.fromJson(Map<String, dynamic> json) {
    return NbrHeurAffecter(
      condidat_id: json['condidat_id'],
      nb_heur_affecter: json['nb_heur_affecter'],
    );
  }
}

class DetailExam {
  String? type_examen;
  String? date_examen;

  DetailExam({
    this.type_examen,
    this.date_examen,
  });

  factory DetailExam.fromJson(Map<String, dynamic> json) {
    return DetailExam(
      type_examen: json['type_examen'],
      date_examen: json['date_examen'],
    );
  }
}
