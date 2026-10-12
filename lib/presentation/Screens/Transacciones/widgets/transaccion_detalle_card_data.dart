import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

class TransaccionDetalleCardData extends StatefulWidget {
  final Transaccion transaccion;

  const TransaccionDetalleCardData({super.key, required this.transaccion});

  @override
  State<TransaccionDetalleCardData> createState() =>
      _TransaccionDetalleCardDataState();
}

class _TransaccionDetalleCardDataState
    extends State<TransaccionDetalleCardData> {
  int _selectedTabIndex = 0; // 0: General, 1: Detalle

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    title: 'General',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    title: 'Detalle',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_selectedTabIndex == 0)
            _buildGeneralTab()
          else
            _buildDetalleTab(),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'Consulta de solo lectura · gestionado en el sistema web.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    final t = widget.transaccion;
    final isReabastecimiento = t.tipo == 'Reabastecimiento';

    if (isReabastecimiento) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TwoColumnsRow(
            label1: 'FOLIO',
            value1: t.folio,
            label2: 'FECHA',
            value2: t.fecha,
          ),
          const _CustomDivider(),
          _TwoColumnsRow(
            label1: 'LOTES GENERADOS',
            value1: t.items.length.toString(),
            label2: 'UNIDADES TOTALES',
            value2: '${t.cantidadTotal} und',
          ),
          const _CustomDivider(),
          _IconDetailRow(
            icon: Icons.inventory_2_outlined,
            tone: AppTone.purple,
            label: 'PRODUCTO(S)',
            value: t.relacionado,
          ),
          const _CustomDivider(),
          _IconDetailRow(
            icon: Icons.person_outline,
            tone: AppTone.teal,
            label: 'REGISTRADO POR',
            value: '${t.realizadoPor} · ${t.rol}',
          ),
        ],
      );
    }

    // Para Ventas y Pedidos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconDetailRow(
          icon: Icons.person_outline,
          tone: AppTone.blue,
          label: 'RELACIONADO',
          value: t.relacionado,
        ),
        const _CustomDivider(),
        _IconDetailRow(
          icon: Icons.info_outline,
          tone: AppTone.purple,
          label: 'DETALLE',
          value: t.detalle,
        ),
        const _CustomDivider(),
        _TwoColumnsRow(
          label1: 'FOLIO',
          value1: t.folio,
          label2: 'FECHA',
          value2: t.fecha,
        ),
        const SizedBox(height: 14),
        _TwoColumnsRow(
          label1: 'CANTIDAD',
          value1: '${t.cantidadTotal} und',
          label2: 'MONTO',
          value2: _formatMonto(t.monto),
        ),
        const SizedBox(height: 14),
        _TwoColumnsRow(
          label1: 'TIPO DE VENTA',
          value1: t.tipoVenta ?? '—',
          label2: 'ESTADO',
          value2: t.estado,
        ),
        const _CustomDivider(),
        _IconDetailRow(
          icon: Icons.person_outline,
          tone: AppTone.teal,
          label: 'REGISTRADO POR',
          value: '${t.realizadoPor} · ${t.rol}',
        ),
      ],
    );
  }

  Widget _buildDetalleTab() {
    final t = widget.transaccion;
    final isReabastecimiento = t.tipo == 'Reabastecimiento';

    if (isReabastecimiento) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lotes generados',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          ...t.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == t.items.length - 1;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.producto,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Lote L-26-08${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.cantidad} und',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                if (!isLast) const _CustomDivider(),
              ],
            );
          }),
        ],
      );
    }

    // Para Ventas y Pedidos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ítems de la transacción',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 12),
        ...t.items.asMap().entries.map((entry) {
          final item = entry.value;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.producto,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.cantidad} und × ${_formatMonto(item.precio)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatMonto(item.subtotal),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const _CustomDivider(),
            ],
          );
        }),
        // Fila de Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            Text(
              _formatMonto(t.monto),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatMonto(double monto) {
    final entero = monto.toInt();
    final decimales = ((monto - entero) * 100).toInt().toString().padLeft(
      2,
      '0',
    );
    if (entero >= 1000) {
      final miles = entero ~/ 1000;
      final resto = (entero % 1000).toString().padLeft(3, '0');
      return 'C\$$miles,$resto.$decimales';
    }
    return 'C\$$entero.$decimales';
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? AppSpacing.cardShadow : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _TwoColumnsRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const _TwoColumnsRow({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value2,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Fila con ícono lateral y etiqueta (Relacionado / Detalle / Registrado por) ─
class _IconDetailRow extends StatelessWidget {
  final IconData icon;
  final AppTone tone;
  final String label;
  final String value;

  const _IconDetailRow({
    required this.icon,
    required this.tone,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppToneColors.soft[tone],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 19, color: AppToneColors.intense[tone]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, thickness: 1, color: AppColors.line),
    );
  }
}
