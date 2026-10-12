import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class ProductoImagen extends StatelessWidget {
  final String referencia;
  final BoxFit fit;
  final double iconSize;

  const ProductoImagen({
    super.key,
    required this.referencia,
    this.fit = BoxFit.contain,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(referencia);
    final esUrl = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    if (esUrl) {
      return Icon(
        Icons.icecream_outlined,
        size: iconSize,
        color: AppColors.primary,
      );
    }

    return Image.asset(
      referencia,
      fit: fit,
      errorBuilder: (_, _, _) => Icon(
        Icons.icecream_outlined,
        size: iconSize,
        color: AppColors.primary,
      ),
    );
  }
}
