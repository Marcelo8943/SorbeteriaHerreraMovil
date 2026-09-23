import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: _hintFor(label),
            hintStyle: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(icon, color: AppColors.muted, size: 20),
          ),
        ),
      ],
    );
  }

  String? _hintFor(String field) {
    switch (field) {
      case 'Nombre completo':
        return 'Ej. Roberto Argüello';
      case 'Teléfono':
        return 'Ej. 8777-6543';
      case 'Punto de venta':
        return 'Ej. Heladería & Snacks Masaya';
      default:
        return null;
    }
  }
}

class CustomFormDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomFormDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.muted, size: 20),
          ),
          hint: const Text(
            'Selecciona...',
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class FormSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FormSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check, color: Colors.white, size: 21),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
