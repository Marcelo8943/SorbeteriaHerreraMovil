import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AppDrawerItem {
  const AppDrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.adminOnly = false,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool adminOnly;
  final bool destructive;
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userInitials,
    required this.isAdmin,
    required this.onProfileTap,
    required this.items,
  });

  final String userName;
  final String userRole;
  final String userInitials;
  final bool isAdmin;
  final VoidCallback onProfileTap;
  final List<AppDrawerItem> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.where((item) => isAdmin || !item.adminOnly);

    final bottomGestureInset = MediaQuery.of(
      context,
    ).systemGestureInsets.bottom;

    return Drawer(
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
      ),
      child: SafeArea(
        right: false,
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 116,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C48F), Color(0xFF007A58)],
                ),
                borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -32),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Material(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  child: InkWell(
                    onTap: onProfileTap,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            child: Text(
                              userInitials,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(userRole),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.muted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  0,
                  AppSpacing.sm,
                  AppSpacing.md + bottomGestureInset,
                ),
                children: [
                  for (final item in visibleItems)
                    ListTile(
                      leading: Icon(
                        item.icon,
                        color: item.destructive
                            ? AppColors.error
                            : AppColors.ink,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: item.destructive
                              ? AppColors.error
                              : AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: item.onTap,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
