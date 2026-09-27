import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'widgets/sistema_widgets.dart';

class PreferenciasSistemaScreen extends StatelessWidget {
  const PreferenciasSistemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                SistemaAppBar(onBack: () => Navigator.of(context).maybePop()),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        GlobalMonitoringCard(),
                        SizedBox(height: AppSpacing.lg),
                        ProductThresholdCard(),
                      ],
                    ),
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
