import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
import 'condidat_image.dart';

class DetailsBody extends StatelessWidget {
  final Condidat condidat;

  const DetailsBody({Key? key, required this.condidat}) : super(key: key);
  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
          decoration: const BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CondidatImage(
                    size: size,
                    image: URLpic +
                        (condidat.photo == ''
                            ? 'unknown_profile.png'
                            : condidat.photo!)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                child: Text(
                  condidat.nom! + ' ' + condidat.prenom!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                'Examen : ${condidat.examen!} ',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 1.5,
            vertical: kDefaultPadding / 2,
          ),
          child: Text(
            condidat.num_tel == null ? '' : condidat.num_tel!,
            style: TextStyle(color: Colors.white, fontSize: 19.0),
          ),
        ),
      ],
    );
  }
}
