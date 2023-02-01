class Payement {
  int? id;
  String? schoolId;
  String? schoolName;
  String? condidatId;
  String? caisse;
  String? type;
  String? montant;
  String? mode_paiement;
  String? date_paiement;

  Payement({
    this.id,
    this.schoolId,
    this.schoolName,
    this.condidatId,
    this.caisse,
    this.type,
    this.montant,
    this.mode_paiement,
    this.date_paiement,
  });

  factory Payement.fromJson(Map<String, dynamic> json) {
    return Payement(
      id: json['id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      condidatId: json['condidat_id'],
      caisse: json['caisse'],
      type: json['type'],
      montant: json['montant'],
      mode_paiement: json['mode_paiement'],
      date_paiement: json['date_paiement'],
    );
  }
}
