import 'package:flutter/material.dart';
import 'widgets.dart';
import '../../theme/app_theme.dart';

class ClienteDetalleScreen extends StatelessWidget {
  final Map<String, String> clienteData;

  const ClienteDetalleScreen({
    Key? key,
    required this.clienteData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String nombre = clienteData['nombre'] ?? 'Cliente';
    final String iniciales = clienteData['iniciales'] ?? 'CL';
    final String municipio = clienteData['municipio'] ?? '';
    final String departamento = clienteData['departamento'] ?? '';
    final String puntoVenta = clienteData['puntoVenta'] ?? 'No especificado';
    final String direccion = clienteData['direccion'] ?? 'Dirección no registrada';
    final String telefono = clienteData['telefono'] ?? '+505 8888-8888';

    final String ubicacionCompleta = departamento.isNotEmpty
        ? '$municipio ($departamento)'
        : municipio;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.lavender,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle del Cliente',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del cliente
              ClienteDetalleHeaderCard(
                nombre: nombre,
                iniciales: iniciales,
                puntoVenta: puntoVenta,
              ),

              const SizedBox(height: 20),

              // Sección: Información General
              const Text(
                'Información General',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 10),

              // Contenedor de detalles
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  boxShadow: AppSpacing.cardShadow,
                ),
                child: Column(
                  children: [
                    ClienteDetalleInfoTile(
                      icon: Icons.store_outlined,
                      title: 'Punto de Venta',
                      subtitle: puntoVenta,
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    ClienteDetalleInfoTile(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación',
                      subtitle: ubicacionCompleta,
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    ClienteDetalleInfoTile(
                      icon: Icons.map_outlined,
                      title: 'Dirección Exacta',
                      subtitle: direccion,
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    ClienteDetalleInfoTile(
                      icon: Icons.phone_outlined,
                      title: 'Teléfono de Contacto',
                      subtitle: telefono,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón de Editar Cliente
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegación/Acción para editar cliente
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textOnPrimary),
                  label: const Text(
                    'Editar Cliente',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}