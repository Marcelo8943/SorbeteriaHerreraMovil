import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
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
    final esUrl =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    if (esUrl) {
      return Image.network(
        _resolverUrlImagen(uri),
        fit: fit,
        errorBuilder: (_, _, _) => _imagenVacia(),
      );
    }

    if (referencia.startsWith('/')) {
      final baseUri = Uri.tryParse(ApiConstants.instance.baseUrl);
      if (baseUri != null && baseUri.hasAuthority) {
        final origin = baseUri.replace(path: '', query: null, fragment: null);
        return Image.network(
          origin.resolve(referencia).toString(),
          fit: fit,
          errorBuilder: (_, _, _) => _imagenVacia(),
        );
      }
    }

    if (referencia.isEmpty) return _imagenVacia();

    return Image.asset(
      referencia,
      fit: fit,
      errorBuilder: (_, _, _) => _imagenVacia(),
    );
  }

  String _resolverUrlImagen(Uri uri) {
    final host = uri.host.toLowerCase();
    final esHostLocal =
        host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '0.0.0.0' ||
        host == '::1';
    if (!esHostLocal) return uri.toString();

    final baseUri = Uri.tryParse(ApiConstants.instance.baseUrl);
    if (baseUri == null || !baseUri.hasAuthority) return uri.toString();

    return baseUri
        .replace(path: uri.path, query: uri.hasQuery ? uri.query : null)
        .toString();
  }

  Widget _imagenVacia() =>
      Icon(Icons.icecream_outlined, size: iconSize, color: AppColors.primary);
}
