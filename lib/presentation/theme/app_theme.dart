import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Marca (--primary / --primary-600 / --primary-700 / --primary-soft)
  static const Color primary = Color(0xFF00B884);
  static const Color primaryDark = Color(0xFF00A377); // hover/pressed
  static const Color primaryDarker = Color(0xFF008A64);
  static const Color primarySoft = Color(0xFFDFF4EC);

  // Base (--ink / --muted / --bg / --card / --lav / --line)
  static const Color ink = Color(0xFF141C2B); // texto principal
  static const Color muted = Color(0xFF69738A); // texto secundario
  static const Color background = Color(0xFFF1F3F9); // fondo de pantallas
  static const Color card = Color(0xFFFFFFFF); // fondo de cards
  static const Color lavender = Color(0xFFECEEF8); // topbar, fondos planos
  static const Color line = Color(0xFFE4E8F2); // bordes/dividers

  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Rojo usado también como color de error/destructivo (--red-i)
  static const Color error = Color(0xFFDD5560);
}

enum AppTone { teal, yellow, red, purple, blue }

class AppToneColors {
  AppToneColors._();

  static const Map<AppTone, Color> soft = {
    AppTone.teal: Color(0xFFDFF4EC),
    AppTone.yellow: Color(0xFFFAF1DA),
    AppTone.red: Color(0xFFFDEAEA),
    AppTone.purple: Color(0xFFF0EAFB),
    AppTone.blue: Color(0xFFE8EFFD),
  };

  static const Map<AppTone, Color> intense = {
    AppTone.teal: Color(0xFF0AA37A),
    AppTone.yellow: Color(0xFFC29218),
    AppTone.red: Color(0xFFDD5560),
    AppTone.purple: Color(0xFF9A6CD8),
    AppTone.blue: Color(0xFF3B76F0),
  };

  /// Tono según tipo de transacción, igual que txMeta() en el prototipo.
  static AppTone forTransactionType(String tipo) {
    switch (tipo) {
      case 'Venta':
        return AppTone.teal;
      case 'Pedido':
        return AppTone.blue;
      default: // Reabastecimiento
        return AppTone.purple;
    }
  }

  /// Tono según tipo de movimiento de inventario, igual que mvMeta().
  static AppTone forMovementType(String tipo) {
    switch (tipo) {
      case 'Transferencia':
        return AppTone.blue;
      case 'Ajuste Positivo':
        return AppTone.teal;
      default: // Ajuste Negativo
        return AppTone.red;
    }
  }

  /// Tono según tipo de evento de log, igual que logMeta().
  static AppTone forLogType(String tipo) {
    switch (tipo) {
      case 'Creación':
        return AppTone.teal;
      case 'Edición':
        return AppTone.yellow;
      case 'Desactivación':
        return AppTone.red;
      default: // ej. inicio de sesión
        return AppTone.blue;
    }
  }
}

/// Radios, espaciados y sombra estándar (--r: 18px, --sh en el prototipo).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// --r del prototipo: radio de cards, stats, sheets.
  static const double cardRadius = 18;
  static const double pillRadius = 999; // badges, tabbar indicator

  /// --sh del prototipo: 0 10px 30px rgba(23,32,63,.10)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A17203F), // rgba(23,32,63,.10)
      offset: Offset(0, 10),
      blurRadius: 30,
    ),
  ];
}

/// Tema global de Material  para toda la app.

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppToneColors.intense[AppTone.blue]!,
      error: AppColors.error,
      surface: AppColors.card,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lavender,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),

      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(fontSize: 15, color: AppColors.ink),
        bodyMedium: TextStyle(fontSize: 13, color: AppColors.muted),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textOnPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lavender,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
      ),

      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF8B93A7),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
