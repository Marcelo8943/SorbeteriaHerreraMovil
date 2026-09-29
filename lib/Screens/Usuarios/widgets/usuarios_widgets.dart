import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/app_models.dart';

class UsuarioCardItem extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback? onTap;

  const UsuarioCardItem({super.key, required this.usuario, this.onTap});

  String get _iniciales {
    final partes = usuario.nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return partes.isNotEmpty && partes[0].isNotEmpty
        ? partes[0][0].toUpperCase()
        : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final bool esAdmin = usuario.rol == 'Administrador';
    final Color badgeBg = esAdmin
        ? AppToneColors.soft[AppTone.teal]!
        : AppToneColors.soft[AppTone.purple]!;
    final Color badgeText = esAdmin
        ? AppToneColors.intense[AppTone.teal]!
        : AppToneColors.intense[AppTone.purple]!;
    final Color avatarBg = esAdmin
        ? AppColors.primary
        : AppToneColors.intense[AppTone.purple]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                // Avatar con iniciales
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: avatarBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _iniciales,
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Nombre y handle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.nombre,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '@ ${usuario.usuario}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge de Rol
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    usuario.rol.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeText,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Control de Paginación idéntico al diseño de Clientes
class UsuarioPaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const UsuarioPaginationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = currentPage > 1;
    final bool canGoNext = currentPage < totalPages && totalPages > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: canGoBack ? onPrevious : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: canGoBack ? AppColors.primary : AppColors.line,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 12,
                  color: canGoBack ? AppColors.primary : AppColors.muted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Anterior',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: canGoBack ? AppColors.primary : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            totalPages > 0
                ? 'Página $currentPage de $totalPages'
                : 'Página 1 de 1',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          OutlinedButton(
            onPressed: canGoNext ? onNext : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: canGoNext ? AppColors.primary : AppColors.line,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Siguiente',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: canGoNext ? AppColors.primary : AppColors.muted,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: canGoNext ? AppColors.primary : AppColors.muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
