import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.height,
    required this.textScale,
    required this.roleName,
    required this.imageUrl,
    this.imageSize = 0.2,
    this.onTap,
  });

  final double height;
  final double textScale;
  final String roleName;
  final String imageUrl;
  final double imageSize;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height * 0.3,
        width: height * 0.3,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(height: height * imageSize, imageUrl),
              Text(
                textScaleFactor: textScale,
                roleName,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: textScale * 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
