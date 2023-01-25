import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';

class CondidatImage extends StatelessWidget {
  const CondidatImage({
    Key? key,
    required this.size,
    required this.image,
  }) : super(key: key);

  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      height: size.width * 0.8,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: size.width * 0.7,
            width: size.width * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
              image,
            ),
            radius: 150,
          ),
        ],
      ),
    );
  }
}
