import 'package:flutter/material.dart';

class SingleCat extends StatelessWidget {
  final String image;
  const SingleCat({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Container(
          width: 180,
          height: 180,
          padding: const EdgeInsets.all(10),
          child: Image.network(
            image,
            fit: BoxFit.fitHeight,
            width: 180,
          ),
        ),
      ),
    );
  }
}
