import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:herrera_system/presentation/providers/dashboard_provider.dart';
import 'package:herrera_system/presentation/theme/app_theme.dart';
import 'package:herrera_system/presentation/widgets/app_top_bar.dart';
import 'package:herrera_system/presentation/widgets/error_view.dart';
import 'package:herrera_system/presentation/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import 'widgets/dashboard_stats_cards.dart';
import 'widgets/greeting_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DashboardProvider>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final provider = context.watch<DashboardProvider>();
    final stats = provider.stats;
    final initials = user?.initials.isNotEmpty == true ? user!.initials : 'U';

    return RefreshIndicator(
      onRefresh: () => context.read<DashboardProvider>().loadStats(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(subtitle: 'Hecho en familia', userInitials: initials),
            const SizedBox(height: AppSpacing.md),
            GreetingBanner(
              userName: user?.firstName ?? 'Usuario',
              userRole: user?.roleName ?? 'Usuario',
            ),
            const SizedBox(height: AppSpacing.md),
            if (provider.status == ViewStatus.initial ||
                (provider.status == ViewStatus.loading && stats == null))
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: LoadingView(message: 'Cargando estadísticas...'),
              )
            else if (provider.status == ViewStatus.error && stats == null)
              ErrorView(
                errorMessage:
                    provider.errorMessage ?? 'No se pudieron cargar las estadísticas.',
                onRetry: () => provider.loadStats(),
              )
            else if (stats != null)
              DashboardStatsCards(stats: stats, compact: true),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
