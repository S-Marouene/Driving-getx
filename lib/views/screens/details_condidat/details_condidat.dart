import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';

import 'details_condidat_body.dart';

class DetailsScreen extends StatelessWidget {
  final Condidat condidat;

  const DetailsScreen({Key? key, required this.condidat}) : super(key: key);

  get kPrimaryColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: detailsAppBar(context),
      body: DetailsBody(
        condidat: condidat,
      ),
    );
  }

  AppBar detailsAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      leading: IconButton(
        padding: const EdgeInsets.only(right: kDefaultPadding),
        icon: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.purple,
            size: 30.0,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Liste Condidats',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
