import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AppTabBarItem {
  const AppTabBarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onMorePressed,
  });

  final List<AppTabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++)
            Expanded(
              child: _TabButton(
                item: items[index],
                isActive: index == currentIndex,
                onPressed: () => onTap(index),
              ),
            ),
          Expanded(
            child: _TabButton(
              item: const AppTabBarItem(icon: Icons.menu, label: 'Más'),
              isActive: false,
              onPressed: onMorePressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.isActive,
    required this.onPressed,
  });

  final AppTabBarItem item;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.muted;

    return Semantics(
      selected: isActive,
      button: true,
      label: item.label,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, color: color, size: 22),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
