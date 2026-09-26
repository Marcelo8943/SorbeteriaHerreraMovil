import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class QuickAccessItem {
  final IconData icon;
  final String label;
  final AppTone tone;
  final VoidCallback onTap;

  const QuickAccessItem({
    required this.icon,
    required this.label,
    required this.tone,
    required this.onTap,
  });
}

/// Fila de accesos rápidos (Info Prod., Precios, Inventario, Transacc.).
/// Exclusivo del Dashboard.
class QuickAccessRow extends StatelessWidget {
  final List<QuickAccessItem> items;

  const QuickAccessRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final item in items) _QuickAccessButton(item: item),
        ],
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final QuickAccessItem item;

  const _QuickAccessButton({required this.item});

  @override
  Widget build(BuildContext context) {
    final soft = AppToneColors.soft[item.tone]!;
    final intense = AppToneColors.intense[item.tone]!;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: intense, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}
