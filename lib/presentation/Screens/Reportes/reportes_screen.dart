import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/presentation/providers/dashboard_provider.dart';
import 'package:herrera_system/presentation/theme/app_theme.dart';
import 'package:herrera_system/presentation/widgets/error_view.dart';
import 'package:herrera_system/presentation/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import '../Dashboard/widgets/dashboard_stats_cards.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DashboardProvider>();
      if (mounted && provider.status == ViewStatus.initial) {
        provider.loadStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final stats = provider.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.ink,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Reportes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().loadStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (provider.status == ViewStatus.initial ||
                  (provider.status == ViewStatus.loading && stats == null))
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingView(message: 'Cargando estadísticas...'),
                )
              else if (provider.status == ViewStatus.error && stats == null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xl),
                  child: ErrorView(
                    errorMessage:
                        provider.errorMessage ?? 'No se pudieron cargar los reportes.',
                    onRetry: () => provider.loadStats(),
                  ),
                )
              else if (stats != null)
                DashboardStatsCards(stats: stats),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
