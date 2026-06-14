// =============================================================================
//  SHEET DE TEXTOS Y BOTONES  -  App de referencia en Flutter
//  Estilo inspirado en la imagen (sin el pájaro/búho verde).
//  Un solo archivo: pega esto en lib/main.dart y corre `flutter run`.
//  No usa paquetes externos, solo flutter/material.
// =============================================================================

import 'dart:ui' show ImageFilter; // para el vidrio esmerilado (frosted glass)
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart'; // para el resorte (SpringSimulation)
import 'package:flutter/services.dart'; // para la vibración (HapticFeedback)

void main() => runApp(const SheetApp());

// =============================================================================
//  COLORES DE MARCA (los del sheet)
// =============================================================================
class Brand {
  static const verdeDuo     = Color(0xFF58CC02); // Verde Duo
  static const verdeDuoEdge = Color(0xFF46A302); // borde 3D del verde
  static const verdeClaro   = Color(0xFFD8FF88); // Verde claro
  static const azulDuo      = Color(0xFF1CB0F6); // Azul Duo
  static const azulDuoEdge  = Color(0xFF1899D6); // borde 3D del azul
  static const rosaEnergia  = Color(0xFFFF77CB); // Rosa energía
  static const amarillo     = Color(0xFFFFC800); // Amarillo
  static const rojo         = Color(0xFFFF4B4B); // Destructivo
  static const rojoEdge     = Color(0xFFE03B3B);
  static const grisClaro    = Color(0xFFF1F5F5); // Gris claro
  static const grisMedio    = Color(0xFFCCD1D9); // Gris medio
  static const grisOscuro   = Color(0xFF687287); // Gris oscuro
  static const texto        = Color(0xFF4B4B4B); // Texto (aprox.)
  static const blanco       = Color(0xFFFFFFFF); // Blanco
}

// =============================================================================
//  PALETA SEGÚN MODO (claro / oscuro)
// =============================================================================
class Pal {
  final bool dark;
  const Pal(this.dark);

  Color get bg        => dark ? const Color(0xFF071A24) : const Color(0xFFCBF1FF);
  Color get card      => dark ? const Color(0xCC15303D) : Colors.white.withOpacity(0.55);
  Color get surface   => dark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.40);
  Color get text      => dark ? Brand.blanco            : const Color(0xFF173A4A);
  Color get textMuted => dark ? const Color(0xFFAFC4CE) : const Color(0xFF4A6B79);
  Color get border    => dark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.70);
  Color get optionBg  => dark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.55);
}

// =============================================================================
//  FONDO FRUTIGER AERO: cielo degradado + resplandores + burbujas de cristal
// =============================================================================
class AeroBackground extends StatelessWidget {
  final bool dark;
  final Widget child;
  const AeroBackground({super.key, required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    final gradient = dark
        ? const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0E3A4F), Color(0xFF0A2330), Color(0xFF071A24)],
    )
        : const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF7FD0FF), Color(0xFFBDEEFF), Color(0xFFE6FBE9)],
    );
    return Stack(
      children: [
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: gradient))),
        // resplandores suaves de luz
        Positioned(
            top: -70,
            left: -50,
            child: _glow(240, Colors.white.withOpacity(dark ? 0.06 : 0.40))),
        Positioned(
            top: 160,
            right: -60,
            child: _glow(200, Colors.white.withOpacity(dark ? 0.04 : 0.25))),
        child,
      ],
    );
  }

  Widget _glow(double s, Color c) => Container(
    width: s,
    height: s,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [c, c.withOpacity(0)]),
    ),
  );
}

// =============================================================================
//  RAÍZ DE LA APP  (maneja el estado del tema)
// =============================================================================
class SheetApp extends StatefulWidget {
  const SheetApp({super.key});
  @override
  State<SheetApp> createState() => _SheetAppState();
}

class _SheetAppState extends State<SheetApp> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    final pal = Pal(dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sheet de Textos y Botones',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pal.bg,
        fontFamily: 'Roboto',
      ),
      home: HomePage(
        dark: dark,
        onToggle: () => setState(() => dark = !dark),
      ),
    );
  }
}

// =============================================================================
//  HOME: pestañas "Sheet" y "Pantallas" + switch de modo
// =============================================================================
class HomePage extends StatelessWidget {
  final bool dark;
  final VoidCallback onToggle;
  const HomePage({super.key, required this.dark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final pal = Pal(dark);
    return AeroBackground(
      dark: dark,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor:
            dark ? const Color(0x5512323F) : Colors.white.withOpacity(0.30),
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Sheet de Textos y Botones',
              style: TextStyle(
                color: pal.text,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            actions: [
              Row(
                children: [
                  Icon(dark ? Icons.dark_mode : Icons.light_mode,
                      color: dark ? Brand.amarillo : Brand.azulDuo, size: 20),
                  Switch(
                    value: dark,
                    activeColor: Brand.verdeDuo,
                    onChanged: (_) => onToggle(),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              labelColor: Brand.verdeDuo,
              unselectedLabelColor: pal.textMuted,
              indicatorColor: Brand.verdeDuo,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800),
              tabs: const [
                Tab(text: 'SHEET'),
                Tab(text: 'PANTALLAS'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SheetTab(pal: pal),
              ScreensTab(pal: pal),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  WIDGETS REUTILIZABLES
// =============================================================================

/// Título de sección dentro del sheet
class SectionTitle extends StatelessWidget {
  final String text;
  final Pal pal;
  const SectionTitle(this.text, {super.key, required this.pal});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: pal.textMuted,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Tarjeta contenedora del sheet
class SheetCard extends StatelessWidget {
  final Widget child;
  final Pal pal;
  const SheetCard({super.key, required this.child, required this.pal});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: pal.dark
                    ? [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.03),
                ]
                    : [
                  Colors.white.withOpacity(0.65),
                  Colors.white.withOpacity(0.32),
                ],
              ),
              border: Border.all(
                  color: Colors.white.withOpacity(pal.dark ? 0.18 : 0.7), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(pal.dark ? 0.25 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Botón estilo Duo con efecto 3D y animación de "hundido" al presionar
class DuoButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color edge;
  final Color textColor;
  final bool enabled;
  final VoidCallback? onTap;
  const DuoButton({
    super.key,
    required this.label,
    required this.color,
    required this.edge,
    this.textColor = Brand.blanco,
    this.enabled = true,
    this.onTap,
  });
  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: 1,
  );

  // Resorte para el regreso: un solo movimiento continuo, con rebotecito natural.
  static const SpringDescription _spring =
  SpringDescription(mass: 1, stiffness: 480, damping: 18);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _down() {
    if (!widget.enabled) return;
    // baja con velocidad (no se frena en seco)
    _c.animateTo(1.0,
        duration: const Duration(milliseconds: 90), curve: Curves.easeOut);
  }

  void _up() {
    if (!widget.enabled) return;
    // regresa con un resorte que conserva la velocidad actual: así, aunque el
    // toque sea rapidísimo, se ve un solo gesto fluido (baja y rebota arriba).
    _c.animateWith(SpringSimulation(_spring, _c.value, 0.0, _c.velocity));
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final base = w.enabled ? w.color : const Color(0xFFD9DEE0);
    // brillo suave
    final topGloss =
    w.enabled ? Color.lerp(w.color, Colors.white, 0.32)! : const Color(0xFFEBEEF0);
    final bottomEdge = w.enabled ? w.edge : const Color(0xFFB9C0C4);

    // contenido fijo (no se reconstruye en cada frame)
    final content = Stack(
      children: [
        // brillo especular superior (más sutil)
        Positioned(
          top: 3,
          left: 6,
          right: 6,
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.32),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              w.label.toUpperCase(),
              style: TextStyle(
                color: w.enabled ? w.textColor : const Color(0xFFAFAFAF),
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTapDown: (_) => _down(),
      onTapCancel: _up,
      onTapUp: (_) => _up(),
      onTap: w.enabled
          ? () {
        HapticFeedback.lightImpact(); // vibración suave al presionar
        w.onTap?.call();
      }
          : null,
      child: AnimatedBuilder(
        animation: _c,
        child: content,
        builder: (context, child) {
          final v = _c.value.clamp(0.0, 1.0); // 0 (arriba) .. 1 (hundido)
          return Transform.translate(
            offset: Offset(0, 4 * v), // se hunde hacia abajo
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [topGloss, base],
                ),
                // el borde 3D inferior se reduce a 0 al hundirse
                border: Border(
                  bottom: BorderSide(color: bottomEdge, width: 4 * (1 - v)),
                ),
                boxShadow: (w.enabled && v < 0.6)
                    ? [
                  BoxShadow(
                    color: base.withOpacity(0.4 * (1 - v)),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : null,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// Contador de energía (batería rosa + número)
class EnergyCounter extends StatelessWidget {
  final int value;
  const EnergyCounter(this.value, {super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Brand.rosaEnergia,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.bolt, color: Brand.blanco, size: 16),
        ),
        const SizedBox(width: 5),
        Text(
          '$value',
          style: const TextStyle(
            color: Brand.rosaEnergia,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

/// Chip de contador con icono (fuego / gema)
class CounterChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  const CounterChip(
      {super.key, required this.icon, required this.color, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ],
    );
  }
}

/// Barra de progreso con badge "5 IN A ROW"
class ProgressPill extends StatelessWidget {
  final double progress; // 0..1
  final String? badge;
  const ProgressPill({super.key, required this.progress, this.badge});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 16,
            backgroundColor: const Color(0xFFE5E5E5),
            valueColor: const AlwaysStoppedAnimation(Brand.verdeDuo),
          ),
        ),
        if (badge != null)
          Positioned(
            top: -10,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Brand.verdeDuo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Brand.blanco,
                  fontWeight: FontWeight.w800,
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Tarjeta de sección verde
class SectionCard extends StatelessWidget {
  final String top;
  final String title;
  const SectionCard({super.key, required this.top, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Brand.verdeDuo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  top.toUpperCase(),
                  style: TextStyle(
                    color: Brand.blanco.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Brand.blanco,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.menu_book_rounded, color: Brand.blanco, size: 26),
        ],
      ),
    );
  }
}

/// Burbuja de batería de energía (grande, para pantallas/popup)
class EnergyBattery extends StatelessWidget {
  final double size;
  const EnergyBattery({super.key, this.size = 90});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.62,
      decoration: BoxDecoration(
        color: Brand.rosaEnergia,
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(color: Brand.blanco, width: 4),
        boxShadow: [
          BoxShadow(
            color: Brand.rosaEnergia.withOpacity(0.5),
            blurRadius: 18,
          ),
        ],
      ),
      child: Icon(Icons.bolt, color: Brand.blanco, size: size * 0.4),
    );
  }
}

// =============================================================================
//  PESTAÑA 1: EL SHEET (sistema de diseño)
// =============================================================================
class SheetTab extends StatelessWidget {
  final Pal pal;
  const SheetTab({super.key, required this.pal});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ---------------- TIPOGRAFÍA ----------------
        SectionTitle('Tipografía', pal: pal),
        SheetCard(
          pal: pal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _typeRow('H1 Título', '22px / Bold', 22, FontWeight.bold, pal.text),
              _div(pal),
              _typeRow('H2 Subtítulo', '18px / Bold', 18, FontWeight.bold, pal.text),
              _div(pal),
              _typeRow('Cuerpo grande', '16px / Semibold', 16, FontWeight.w600, pal.text),
              _div(pal),
              _typeRow('Cuerpo', '14px / Regular', 14, FontWeight.w400, pal.text),
              _div(pal),
              _typeRow('Secundario / Ayuda', '12px / Regular', 12, FontWeight.w400,
                  pal.textMuted),
              _div(pal),
              _typeRow('Enlace', '12px / Semibold', 12, FontWeight.w600, Brand.azulDuo),
            ],
          ),
        ),

        // ---------------- BOTONES ----------------
        SectionTitle('Botones', pal: pal),
        SheetCard(
          pal: pal,
          child: Column(
            children: [
              _btnLabel('Primario', pal),
              const DuoButton(
                  label: 'Continuar', color: Brand.verdeDuo, edge: Brand.verdeDuoEdge),
              const SizedBox(height: 16),
              _btnLabel('Secundario', pal),
              const DuoButton(
                  label: 'Explicar mi respuesta',
                  color: Brand.azulDuo,
                  edge: Brand.azulDuoEdge),
              const SizedBox(height: 16),
              _btnLabel('Terciario (Enlace)', pal),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'AHORA NO',
                  style: TextStyle(
                    color: Brand.azulDuo,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _btnLabel('Destructivo', pal),
              const DuoButton(
                  label: 'Salir', color: Brand.rojo, edge: Brand.rojoEdge),
              const SizedBox(height: 16),
              _btnLabel('Deshabilitado', pal),
              const DuoButton(
                  label: 'Continuar',
                  color: Brand.grisMedio,
                  edge: Brand.grisMedio,
                  enabled: false),
            ],
          ),
        ),

        // ---------------- COMPONENTES ----------------
        SectionTitle('Componentes', pal: pal),
        SheetCard(
          pal: pal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _compLabel('Barra de progreso', pal),
              const Padding(
                padding: EdgeInsets.only(top: 12, bottom: 4),
                child: ProgressPill(progress: 0.45, badge: '5 IN A ROW'),
              ),
              _div(pal),
              _compLabel('Contador de energía', pal),
              const SizedBox(height: 8),
              const EnergyCounter(21),
              _div(pal),
              _compLabel('Moneda y gemas', pal),
              const SizedBox(height: 8),
              Row(
                children: const [
                  CounterChip(
                      icon: Icons.local_fire_department,
                      color: Brand.amarillo,
                      value: '12'),
                  SizedBox(width: 20),
                  CounterChip(icon: Icons.diamond, color: Brand.azulDuo, value: '500'),
                ],
              ),
              _div(pal),
              _compLabel('Tarjeta de sección', pal),
              const SizedBox(height: 10),
              const SectionCard(
                top: 'Sección 4, Unidad 4',
                title: 'Usa frases básicas y saluda a la gente',
              ),
              _div(pal),
              _compLabel('Popup / Modal (ejemplo)', pal),
              const SizedBox(height: 12),
              _miniModal(pal),
            ],
          ),
        ),

        // ---------------- ICONOS Y ELEMENTOS ----------------
        SectionTitle('Iconos y elementos', pal: pal),
        SheetCard(
          pal: pal,
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              _icon(Icons.public, Brand.verdeDuo, pal),
              _icon(Icons.volume_up, Brand.azulDuo, pal),
              _icon(Icons.check_circle, Brand.verdeDuo, pal),
              _icon(Icons.cancel, Brand.rojo, pal),
              _icon(Icons.favorite, Brand.rojo, pal),
              _icon(Icons.star_border, Brand.grisOscuro, pal),
              _icon(Icons.ios_share, Brand.grisOscuro, pal),
              _icon(Icons.outlined_flag, Brand.verdeDuo, pal),
              _icon(Icons.bolt, Brand.rosaEnergia, pal),
              _icon(Icons.local_fire_department, Brand.amarillo, pal),
              _icon(Icons.diamond, Brand.azulDuo, pal),
              _icon(Icons.water_drop, Brand.azulDuo, pal),
              _icon(Icons.eco, Brand.verdeDuo, pal),
              _icon(Icons.auto_awesome, const Color(0xFF9B6BFF), pal),
            ],
          ),
        ),

        // ---------------- COLORES ----------------
        SectionTitle('Colores', pal: pal),
        SheetCard(
          pal: pal,
          child: Wrap(
            spacing: 12,
            runSpacing: 14,
            children: [
              _swatch('Verde Duo', '#58CC02', Brand.verdeDuo, pal),
              _swatch('Verde claro', '#D8FF88', Brand.verdeClaro, pal),
              _swatch('Azul Duo', '#1CB0F6', Brand.azulDuo, pal),
              _swatch('Rosa energía', '#FF77CB', Brand.rosaEnergia, pal),
              _swatch('Amarillo', '#FFC800', Brand.amarillo, pal),
              _swatch('Gris claro', '#F1F5F5', Brand.grisClaro, pal),
              _swatch('Gris medio', '#CCD1D9', Brand.grisMedio, pal),
              _swatch('Gris oscuro', '#687287', Brand.grisOscuro, pal),
              _swatch('Texto', '#4B4B4B', Brand.texto, pal),
              _swatch('Blanco', '#FFFFFF', Brand.blanco, pal),
            ],
          ),
        ),

        // ---------------- ESTILO VISUAL ----------------
        SectionTitle('Estilo visual', pal: pal),
        SheetCard(
          pal: pal,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _styleTag('Bordes redondeados', pal),
              _styleTag('Sombras suaves', pal),
              _styleTag('Gradientes sutiles', pal),
              _styleTag('Textura iOS (Aqua)', pal),
              _styleTag('Colores amigables y vibrantes', pal),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ---- helpers de SheetTab ----
  Widget _div(Pal pal) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(color: pal.border, height: 1));

  Widget _typeRow(String name, String spec, double size, FontWeight w, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: size, fontWeight: w, color: color)),
        const SizedBox(height: 2),
        Text(spec, style: const TextStyle(fontSize: 11, color: Brand.grisOscuro)),
      ],
    );
  }

  Widget _btnLabel(String t, Pal pal) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(t,
          style: TextStyle(
              color: pal.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
    ),
  );

  Widget _compLabel(String t, Pal pal) => Text(t,
      style: TextStyle(color: pal.textMuted, fontSize: 12, fontWeight: FontWeight.w600));

  Widget _icon(IconData i, Color c, Pal pal) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: pal.surface,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(i, color: c, size: 24),
  );

  Widget _swatch(String name, String hex, Color color, Pal pal) {
    final w = (pal.dark ? 0.0 : 0.0); // placeholder noop to keep const-free
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: pal.border),
            ),
          ),
          const SizedBox(height: 6),
          Text(name,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: pal.text)),
          Text(hex, style: const TextStyle(fontSize: 10, color: Brand.grisOscuro)),
          SizedBox(height: w),
        ],
      ),
    );
  }

  Widget _styleTag(String t, Pal pal) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: pal.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: pal.border),
    ),
    child: Text(t,
        style: TextStyle(
            fontSize: 12, color: pal.text, fontWeight: FontWeight.w600)),
  );

  Widget _miniModal(Pal pal) => Container(
    width: 220,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: pal.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: pal.border),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(pal.dark ? 0.3 : 0.08),
            blurRadius: 12)
      ],
    ),
    child: Column(
      children: [
        const EnergyBattery(size: 64),
        const SizedBox(height: 12),
        Text('Tu energía está llena.',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: pal.text)),
        const SizedBox(height: 12),
        const DuoButton(
            label: 'Aceptar', color: Brand.azulDuo, edge: Brand.azulDuoEdge),
      ],
    ),
  );
}

// =============================================================================
//  PESTAÑA 2: PANTALLAS DE EJEMPLO (sin el pájaro)
// =============================================================================
class ScreensTab extends StatelessWidget {
  final Pal pal;
  const ScreensTab({super.key, required this.pal});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PhoneFrame(pal: pal, child: _screenTranslateOptions(pal)),
        const SizedBox(height: 24),
        PhoneFrame(pal: pal, child: _screenSection(pal)),
        const SizedBox(height: 24),
        PhoneFrame(pal: pal, child: _screenTranslateText(pal)),
        const SizedBox(height: 24),
        PhoneFrame(pal: pal, child: _screenReward(pal)),
        const SizedBox(height: 24),
      ],
    );
  }

  // ---- Pantalla 1: selecciona la traducción ----
  Widget _screenTranslateOptions(Pal pal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topBar(pal, energy: 21, progress: 0.45, badge: '5 IN A ROW', showX: true),
        const SizedBox(height: 16),
        Text('Selecciona la traducción correcta',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: pal.text, height: 1.2)),
        const SizedBox(height: 20),
        // personaje (placeholder) + burbuja "milk"
        Row(
          children: [
            _avatar(pal),
            const SizedBox(width: 10),
            _speechBubble('milk', pal),
          ],
        ),
        const SizedBox(height: 24),
        _option('leche', pal, selected: true),
        const SizedBox(height: 10),
        _option('niña', pal),
        const SizedBox(height: 10),
        _option('manzana', pal),
        const SizedBox(height: 16),
        _correctBanner('¡Correcto!', pal),
        const SizedBox(height: 12),
        const DuoButton(
            label: 'Continuar', color: Brand.verdeDuo, edge: Brand.verdeDuoEdge),
      ],
    );
  }

  // ---- Pantalla 2: sección / notificaciones (pájaro eliminado) ----
  Widget _screenSection(Pal pal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CounterChip(
                icon: Icons.local_fire_department, color: Brand.amarillo, value: '12'),
            CounterChip(icon: Icons.diamond, color: Brand.azulDuo, value: '500'),
            EnergyCounter(25),
          ],
        ),
        const SizedBox(height: 16),
        const SectionCard(
          top: 'Sección 4, Unidad 4',
          title: 'Usa frases básicas y saluda a la gente',
        ),
        const SizedBox(height: 28),
        // (Aquí iba el pájaro verde — eliminado)
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Brand.rosaEnergia,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('+3',
                style: TextStyle(
                    color: Brand.blanco, fontWeight: FontWeight.w800, fontSize: 26)),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Tu energía está llena.\nLa próxima vez, se usará la segunda carga.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: pal.text, height: 1.3),
          ),
        ),
        const SizedBox(height: 20),
        const DuoButton(
            label: 'Activar notificaciones',
            color: Brand.azulDuo,
            edge: Brand.azulDuoEdge),
        const SizedBox(height: 12),
        const Center(
          child: Text('AHORA NO',
              style: TextStyle(
                  color: Brand.azulDuo,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5)),
        ),
      ],
    );
  }

  // ---- Pantalla 3: traduce esta oración ----
  Widget _screenTranslateText(Pal pal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topBar(pal, energy: 15, progress: 0.6, showX: true),
        const SizedBox(height: 16),
        Text('Traduce esta oración',
            style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: pal.text)),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Brand.azulDuo, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.volume_up, color: Brand.blanco, size: 18),
            ),
            const SizedBox(width: 10),
            Text('Soy una niña.',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: pal.text)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 110,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: pal.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: pal.border),
          ),
          child: Text('I am a girl',
              style: TextStyle(fontSize: 15, color: pal.text)),
        ),
        const SizedBox(height: 16),
        _correctBanner('¡Genial!', pal),
        const SizedBox(height: 12),
        const DuoButton(
            label: 'Continuar', color: Brand.verdeDuo, edge: Brand.verdeDuoEdge),
      ],
    );
  }

  // ---- Pantalla 4: recompensa de energía (fondo gradiente azul) ----
  Widget _screenReward(Pal pal) {
    return Container(
      margin: const EdgeInsets.all(-16), // ocupa todo el marco
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7FD0F7), Color(0xFF1CB0F6)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          _topBar(Pal(true), energy: 15, progress: 0.6, showX: false, transparent: true),
          const SizedBox(height: 30),
          const EnergyBattery(size: 110),
          const SizedBox(height: 30),
          const Text(
            '¡Ganaste +15 de energía\npor agregar a un amigo!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Brand.blanco, fontWeight: FontWeight.w800, fontSize: 18, height: 1.3),
          ),
          const SizedBox(height: 24),
          DuoButton(
            label: 'Volver a la lección',
            color: Brand.blanco,
            edge: const Color(0xFFD7E9F0),
            textColor: Brand.azulDuo,
          ),
        ],
      ),
    );
  }

  // ---- helpers de ScreensTab ----
  Widget _topBar(Pal pal,
      {required int energy,
        required double progress,
        String? badge,
        bool showX = true,
        bool transparent = false}) {
    final fg = transparent ? Brand.blanco : pal.text;
    return Row(
      children: [
        if (showX)
          Icon(Icons.close, color: transparent ? Brand.blanco : pal.textMuted, size: 24),
        if (showX) const SizedBox(width: 12),
        Expanded(child: ProgressPill(progress: progress, badge: badge)),
        const SizedBox(width: 12),
        EnergyCounter(energy),
      ],
    );
  }

  Widget _avatar(Pal pal) => Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      color: Brand.rosaEnergia.withOpacity(0.25),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.person, color: Brand.rosaEnergia, size: 36),
  );

  Widget _speechBubble(String text, Pal pal) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    decoration: BoxDecoration(
      color: pal.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: pal.border),
    ),
    child: Text(text,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: pal.text)),
  );

  Widget _option(String text, Pal pal, {bool selected = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: selected ? Brand.verdeClaro : pal.optionBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? Brand.verdeDuo : pal.border,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(selected ? Icons.star : Icons.star_border,
              color: selected ? Brand.verdeDuo : pal.textMuted, size: 20),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? const Color(0xFF3F7D00) : pal.text)),
        ],
      ),
    );
  }

  Widget _correctBanner(String text, Pal pal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Brand.verdeClaro.withOpacity(pal.dark ? 0.18 : 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Brand.verdeDuo, size: 22),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  color: Brand.verdeDuo, fontWeight: FontWeight.w800, fontSize: 16)),
          const Spacer(),
          const Icon(Icons.ios_share, color: Brand.verdeDuo, size: 20),
          const SizedBox(width: 12),
          const Icon(Icons.outlined_flag, color: Brand.verdeDuo, size: 20),
        ],
      ),
    );
  }
}

/// Marco de teléfono que envuelve cada pantalla de ejemplo
class PhoneFrame extends StatelessWidget {
  final Widget child;
  final Pal pal;
  const PhoneFrame({super.key, required this.child, required this.pal});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: pal.dark
                    ? [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.03),
                ]
                    : [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.30),
                ],
              ),
              border: Border.all(
                  color: Colors.white.withOpacity(pal.dark ? 0.18 : 0.75), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(pal.dark ? 0.35 : 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // barra de estado simulada
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('9:41 AM',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: pal.textMuted)),
                      Row(
                        children: [
                          Icon(Icons.signal_cellular_alt, size: 14, color: pal.textMuted),
                          const SizedBox(width: 4),
                          Icon(Icons.wifi, size: 14, color: pal.textMuted),
                          const SizedBox(width: 4),
                          Icon(Icons.battery_full, size: 14, color: pal.textMuted),
                        ],
                      ),
                    ],
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}