import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/business_profile_model.dart';
import 'package:herrera_system/presentation/providers/business_profile_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import 'widgets/acerca_de_widgets.dart';

class AcercaDeScreen extends StatefulWidget {
  const AcercaDeScreen({super.key});

  @override
  State<AcercaDeScreen> createState() => _AcercaDeScreenState();
}

class _AcercaDeScreenState extends State<AcercaDeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BusinessProfileProvider>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessProfile = context.watch<BusinessProfileProvider>();
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xl,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: _AboutContent(
                      isLoading: businessProfile.isLoading,
                      errorMessage: businessProfile.errorMessage,
                      onRetry: businessProfile.loadProfile,
                      profile: businessProfile.profile,
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

class _AboutContent extends StatelessWidget {
  const _AboutContent({
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.profile,
  });

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final BusinessProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    final currentProfile = profile;

    if (isLoading && currentProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (currentProfile == null) {
      return Column(
        children: [
          Text(
            errorMessage ?? 'No se pudo obtener la información del negocio.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      );
    }

    return AboutInformationCard(profile: currentProfile);
  }
}
