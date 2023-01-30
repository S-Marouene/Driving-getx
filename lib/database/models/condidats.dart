class Condidat {
  int? id;
  String? nom;
  String? prenom;
  String? num_tel;
  String? school_name;
  String? examen;
  String? photo;
  NbrHeurTotale? nbr_heur_total;
  NbrHeurAffecter? nb_heur_affecter;

  Condidat(
      {this.id,
      this.nom,
      this.prenom,
      this.num_tel,
      this.school_name,
      this.examen,
      this.photo,
      this.nbr_heur_total,
      this.nb_heur_affecter});

  factory Condidat.fromJson(Map<String, dynamic> json) {
    List<dynamic> nht = json['nbr_heur_total'];
    return Condidat(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      num_tel: json['num_tel'],
      school_name: json['school_name'],
      examen: json['examen'],
      photo: json['photo'],
      nbr_heur_total: NbrHeurTotale(
          condidat_id: nht.isNotEmpty ? nht[0]['condidat_id'] : "",
          nb_heur_total: nht.isNotEmpty ? nht[0]['nb_heur_total'] : ""),
      nb_heur_affecter: NbrHeurAffecter(
          condidat_id: nht.isNotEmpty ? nht[0]['condidat_id'] : "",
          nb_heur_affecter: nht.isNotEmpty ? nht[0]['nb_heur_total'] : ""),
    );
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
