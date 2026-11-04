import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/log_model.dart';
import 'package:herrera_system/presentation/providers/logs_provider.dart';
import 'package:herrera_system/presentation/theme/app_theme.dart';
import 'package:herrera_system/presentation/widgets/error_view.dart';
import 'package:herrera_system/presentation/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class LogDetailScreen extends StatefulWidget {
  final String logId;

  const LogDetailScreen({super.key, required this.logId});

  @override
  State<LogDetailScreen> createState() => _LogDetailScreenState();
}

class _LogDetailScreenState extends State<LogDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<LogsProvider>().loadLogDetail(widget.logId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
      ),
      body: switch (provider.detailStatus) {
        ViewStatus.initial ||
        ViewStatus.loading => const LoadingView(message: 'Cargando detalle...'),
        ViewStatus.error => ErrorView(
          errorMessage:
              provider.detailErrorMessage ?? 'No se pudo cargar el detalle.',
          onRetry: () => provider.loadLogDetail(widget.logId),
        ),
        ViewStatus.success =>
          provider.detail == null
              ? const Center(child: Text('No se encontró el evento.'))
              : _LogDetailContent(detail: provider.detail!),
      },
    );
  }
}

class _LogDetailContent extends StatelessWidget {
  final LogDetailModel detail;

  const _LogDetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final log = detail.log;
    final user = log.userName.isEmpty ? log.userId : log.userName;
    final timestamp = log.timestamp.toLocal();
    final formattedDate =
        '${timestamp.day.toString().padLeft(2, '0')}/'
        '${timestamp.month.toString().padLeft(2, '0')}/'
        '${timestamp.year}  '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _DetailSection(
          title: _actionName(log.tipo),
          children: [
            _DetailRow(label: 'Módulo', value: log.modulo),
            _DetailRow(label: 'Usuario', value: user),
            _DetailRow(label: 'Rol', value: log.rol),
            _DetailRow(label: 'Fecha', value: formattedDate),
            _DetailRow(
              label: 'Resultado',
              value: detail.status.isNotEmpty
                  ? '${detail.status} (${log.statusCode})'
                  : (log.success ? 'Exitoso' : 'Fallido'),
            ),
            _DetailRow(
              label: 'Duración',
              value: '${log.elapsedMilliseconds} ms',
            ),
            _DetailRow(label: 'Dirección', value: log.path),
          ],
        ),
        _DetailSection(
          title: 'Información técnica',
          children: [
            _DetailRow(label: 'Identificador', value: log.id),
            _DetailRow(label: 'Código de seguimiento', value: detail.traceId),
            _DetailRow(label: 'Entorno', value: detail.environment),
            _DetailRow(label: 'Dirección de red', value: detail.clientIp),
            _DetailRow(label: 'Dispositivo', value: detail.device),
            _DetailRow(label: 'Parámetros', value: detail.queryString),
            _DetailRow(label: 'Datos enviados', value: detail.payload),
            if (detail.exception.isNotEmpty)
              _DetailRow(label: 'Detalle del error', value: detail.exception),
          ],
        ),
      ],
    );
  }

  String _actionName(String type) {
    switch (type) {
      case 'Creación':
        return 'Crear';
      case 'Edición':
        return 'Actualizar';
      case 'Cambio de estado':
        return 'Cambiar estado';
      case 'Eliminación':
        return 'Eliminar';
      case 'Inicio de sesión':
        return 'Inicio de sesión';
      case 'Consulta':
        return 'Consultar';
      default:
        return type;
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            value,
            style: const TextStyle(color: AppColors.ink, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
