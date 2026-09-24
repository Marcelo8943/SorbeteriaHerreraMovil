import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

/// Encabezado verde con la imagen, nombre y estado
class HeaderSeccion extends StatelessWidget {
  final Producto producto;

  const HeaderSeccion({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 64),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Image.asset(
              producto.imgUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.icecream_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            producto.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${producto.linea} · ${producto.sabor}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
            ),
            child: Text(
              producto.estado,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta blanca con la cuadrícula de información
class TarjetaInformacion extends StatelessWidget {
  final Producto producto;

  const TarjetaInformacion({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila de Tags/Chips
          Row(
            children: [
              TagChip(texto: producto.linea, tone: AppTone.yellow),
              const SizedBox(width: 8),
              TagChip(texto: producto.presentacion, tone: AppTone.blue),
              const SizedBox(width: 8),
              TagChip(texto: producto.sabor, tone: AppTone.red),
            ],
          ),
          const SizedBox(height: 28),

          // Fila de Precios
          Row(
            children: [
              Expanded(
                child: DatoCelda(
                  label: 'PRECIO DETALLE',
                  valor: 'C\$${producto.precioDetalle.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: DatoCelda(
                  label: 'PRECIO MAYOREO',
                  valor: 'C\$${producto.precioMayoreo.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Fila de Línea y Presentación
          Row(
            children: [
              Expanded(
                child: DatoCelda(
                  label: 'LÍNEA',
                  valor: producto.linea,
                ),
              ),
              Expanded(
                child: DatoCelda(
                  label: 'PRESENTACIÓN',
                  valor: producto.presentacion,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 20),

          // Fila del Sabor Destacado
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppToneColors.soft[AppTone.red],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.icecream_outlined,
                  color: AppToneColors.intense[AppTone.red],
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SABOR',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.sabor,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Celda auxiliar de texto (Label + Valor)
class DatoCelda extends StatelessWidget {
  final String label;
  final String valor;

  const DatoCelda({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Badge/Chip de etiqueta
class TagChip extends StatelessWidget {
  final String texto;
  final AppTone tone;

  const TagChip({
    super.key,
    required this.texto,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppToneColors.soft[tone],
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: AppToneColors.intense[tone],
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}