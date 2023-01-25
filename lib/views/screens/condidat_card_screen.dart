import 'package:driving_getx/database/models/condidats.dart';
import 'package:flutter/material.dart';

class CondidatCard extends StatelessWidget {
  const CondidatCard({
    Key? key,
    required this.itemIndex,
    required this.condidat,
    required this.press,
  }) : super(key: key);

  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';
  final int itemIndex;
  final Condidat condidat;
  final dynamic press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 1.0,
      ),
      height: 120.0,
      child: InkWell(
        onTap: press,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  const BoxShadow(
                      offset: Offset(0, 15),
                      blurRadius: 25,
                      color: Color.fromARGB(31, 206, 21, 21)),
                ],
              ),
            ),
            Positioned(
              top: 22.0,
              left: 0.0,
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 100.0,
                width: 110.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(URLpic +
                      (condidat.photo == ''
                          ? 'unknown_profile.png'
                          : condidat.photo!)),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: SizedBox(
                height: 110.0,
                // Because oure image is 200 width, then: width - 200
                width: size.width - 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        condidat.nom! + ' ' + condidat.prenom!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Tel : ${condidat.num_tel}',
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * 1.5, // 30 px padding
                          vertical: 8 / 5, // 5 px padding
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 216, 114, 114),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text('Examen : ${condidat.examen}'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
