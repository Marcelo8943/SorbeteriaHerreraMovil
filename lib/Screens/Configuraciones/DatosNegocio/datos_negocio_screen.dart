import 'package:flutter/material.dart';

import '../../../models/mocks/mock_negocio.dart';
import '../../../theme/app_theme.dart';
import 'widgets/datos_negocio_widgets.dart';

class DatosNegocioScreen extends StatelessWidget {
  const DatosNegocioScreen({super.key});

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
                BusinessAppBar(
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: BusinessInformationCard(negocio: negocioActual),
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
