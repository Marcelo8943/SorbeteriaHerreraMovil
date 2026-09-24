import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import 'widgets/acerca_de_widgets.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

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
                AboutAppBar(onBack: () => Navigator.of(context).maybePop()),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xl,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: AboutInformationCard(),
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
